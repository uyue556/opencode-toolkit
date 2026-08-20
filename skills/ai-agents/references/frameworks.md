# Agent Frameworks: LangGraph & PydanticAI

Production-grade stateful agents. LangGraph gives explicit graph structure (visible, debuggable flows); PydanticAI gives type-safe tool use and structured outputs in Python. Both are consolidated from their source skills.

## Table of contents

1. [LangGraph](#langgraph)
2. [PydanticAI](#pydanticai)

---

# LangGraph

Graph-based state machine for stateful, multi-actor agents. Used in production at LinkedIn, Uber, and 400+ companies; LangChain's recommended agent approach. Covers state management with reducers, conditional routing, checkpointers, human-in-the-loop, and parallel map-reduce.

## Basic ReAct agent

```python
from typing import Annotated, TypedDict
from langgraph.graph import StateGraph, START, END
from langgraph.graph.message import add_messages
from langgraph.prebuilt import ToolNode
from langchain_openai import ChatOpenAI
from langchain_core.tools import tool

class AgentState(TypedDict):
    messages: Annotated[list, add_messages]   # appends, doesn't overwrite

@tool
def search(query: str) -> str:
    """Search the web for information."""
    return f"Results for: {query}"

tools = [search]
llm = ChatOpenAI(model="gpt-4o").bind_tools(tools)

def agent(state: AgentState) -> dict:
    return {"messages": [llm.invoke(state["messages"])]}

def should_continue(state: AgentState) -> str:
    return "tools" if state["messages"][-1].tool_calls else END

graph = StateGraph(AgentState)
graph.add_node("agent", agent)
graph.add_node("tools", ToolNode(tools))
graph.add_edge(START, "agent")
graph.add_conditional_edges("agent", should_continue, ["tools", END])
graph.add_edge("tools", "agent")  # loop back
app = graph.compile()

result = app.invoke({"messages": [("user", "What is 25 * 4?")]})
```

## State with reducers

Reducers merge/append instead of overwrite. Nodes return partial state updates.

```python
from operator import add
from typing import Annotated, TypedDict

def merge_dicts(left: dict, right: dict) -> dict:
    return {**left, **right}

class ResearchState(TypedDict):
    messages: Annotated[list, add_messages]   # append
    findings: Annotated[dict, merge_dicts]    # merge
    sources: Annotated[list[str], add]        # accumulate
    current_step: str                          # overwrite (no reducer)
    errors: Annotated[int, lambda a, b: a + b]

def researcher(state: ResearchState) -> dict:
    # Return only the fields being updated
    return {"findings": {"topic_a": "New finding"}, "sources": ["source1.com"], "current_step": "researching"}
```

## Conditional branching

Route to different paths based on state via `add_conditional_edges("node", router_fn, {"coding": "coding", "search": "search", ...})`. The router returns the destination node name.

## Persistence with checkpointers

```python
from langgraph.checkpoint.sqlite import SqliteSaver
from langgraph.checkpoint.postgres import PostgresSaver

memory = SqliteSaver.from_conn_string("agent_state.db")   # SQLite dev
app = graph.compile(checkpointer=memory)

config = {"configurable": {"thread_id": "user-123-session-1"}}
result1 = app.invoke({"messages": [("user", "My name is Alice")]}, config=config)
result2 = app.invoke({"messages": [("user", "What's my name?")]}, config=config)
# -> agent remembers; also app.get_state(config), app.get_state_history(config)
```

## Human-in-the-loop (interrupt_before)

```python
app = graph.compile(checkpointer=memory, interrupt_before=["execute"])

result = app.invoke({"messages": [("user", "Send report")]}, config)   # pauses
state = app.get_state(config)               # human reviews pending_action
app.update_state(config, {"approved": True})
result = app.invoke(None, config)           # resume
```

Use for sensitive operations — pause before the side-effecting node and let a human approve.

## Parallel execution (map-reduce via Send)

```python
from langgraph.constants import Send

def fanout_topics(state) -> list[Send]:
    return [Send("research", {"topic": t}) for t in state["topics"]]

graph.add_conditional_edges(START, fanout_topics, ["research"])
graph.add_edge("research", "summarize")   # results accumulate via add reducer
graph.add_edge("summarize", END)
```

## LangGraph guidance

- Design state carefully; use reducers for anything multiple nodes update.
- Always consider persistence for production; cycles need explicit loop-break conditions.
- Combine with structured outputs for tool responses and observability (e.g., Langfuse/LangSmith).
- Use subgraphs for multi-agent (supervisor) systems and `Send` for parallelism.

---

# PydanticAI

Typed, production-ready agents in Python from the Pydantic team: type-safe tool use, structured outputs validated with Pydantic models, dependency injection for testability, streaming, and multi-turn conversations across OpenAI, Anthropic, Gemini, Groq, Mistral, Ollama.

## Install and minimal agent

```bash
pip install 'pydantic-ai[openai,anthropic,gemini]'
```

```python
from pydantic_ai import Agent

agent = Agent('anthropic:claude-sonnet-4-6', system_prompt='Be concise.')
result = agent.run_sync('What is the capital of Japan?')
print(result.data)          # "Tokyo"
print(result.usage())       # token usage
```

## Structured output

```python
from pydantic import BaseModel
from pydantic_ai import Agent

class MovieReview(BaseModel):
    title: str
    year: int
    rating: float
    summary: str
    recommended: bool

agent = Agent('openai:gpt-4o', result_type=MovieReview, system_prompt='Return structured reviews.')
review = agent.run_sync('Review Inception (2010)').data   # typed MovieReview
```

## Tool use

```python
from pydantic_ai import Agent, RunContext

@agent.tool
async def get_temperature(ctx: RunContext, city: str) -> dict:
    """Fetch the current temperature for a city from the weather API."""
    ...
```

The tool's docstring is what the LLM sees as its description — write clear, specific docstrings or the tool is never called.

## Dependency injection (testability)

```python
from dataclasses import dataclass
from pydantic_ai import Agent, RunContext

@dataclass
class Deps:
    db: Database
    user_id: str

agent = Agent('openai:gpt-4o-mini', deps_type=Deps, result_type=SupportResponse)
@agent.tool
async def get_order_history(ctx: RunContext[Deps]) -> list[dict]:
    return await ctx.deps.db.get_orders(ctx.deps.user_id, limit=5)

result = await agent.run(message, deps=Deps(db=get_db(), user_id=uid))
```

## Testing without a real LLM

```python
from pydantic_ai.models.test import TestModel
from pydantic_ai.models.function import FunctionModel, ModelResponse
from pydantic_ai.messages import TextPart

with agent.override(model=TestModel()):
    result = agent.run_sync('cancel my account', deps=FakeDeps())
    assert isinstance(result.data, SupportResponse)
```

`TestModel` returns a minimal valid response matching `result_type`; `FunctionModel(fn)` returns deterministic responses. Use these in CI — never hit a real LLM.

## Retry logic

```python
from pydantic_ai import Agent, ModelRetry

@agent.result_validator
async def validate(ctx, result: StrictJson) -> StrictJson:
    if result.value > 1000:
        raise ModelRetry('Value must be under 1000. Try again.')
    return result
```

## PydanticAI guidance

- Always define `result_type` with a Pydantic model in production; avoid raw strings.
- Use `deps_type` dataclass for DI; `TestModel` for unit tests.
- Use `run_stream` for long outputs; pass `message_history` for multi-turn.
- If structured output never validates, simplify the schema (Optional + defaults).
- If `RunContext` is None in a tool, you forgot to pass `deps=` on `run()`.
- Don't wrap `await agent.run()` in `asyncio.run()` inside FastAPI — await directly.
- Validate tool inputs, require confirmation for mutating tools, log `result.all_messages()` for audit, and set `retries=` to prevent runaway loops.

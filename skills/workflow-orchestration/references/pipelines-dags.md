# Pipelines & DAGs (Airflow, MLOps)

Batch/data pipelines defined as DAGs. Read `../SKILL.md` first.

## Airflow DAG patterns

### Design principles

| Principle | Description |
|-----------|-------------|
| **Idempotent** | Running twice produces the same result |
| **Atomic** | Tasks succeed or fail completely |
| **Incremental** | Process only new/changed data |
| **Observable** | Logs, metrics, alerts at every step |

### Task dependencies

```python
task1 >> task2 >> task3                    # linear
task1 >> [task2, task3, task4]             # fan-out
[task1, task2, task3] >> task4             # fan-in
task1 >> task2 >> task4 ; task1 >> task3 >> task4   # complex
```

### Default args (production baseline)

```python
default_args = {
    'owner': 'data-team',
    'depends_on_past': False,
    'email_on_failure': True,
    'email_on_retry': False,
    'retries': 3,
    'retry_delay': timedelta(minutes=5),
    'retry_exponential_backoff': True,
    'max_retry_delay': timedelta(hours=1),
}
```

Set `schedule` (e.g., `'0 6 * * *'`), `catchup=False`, `max_active_runs=1`,
`tags`, and a `start_date`. Prefer the **TaskFlow API** (`@dag` + `@task`
decorators) for cleaner code and automatic XCom.

### Sensors and external dependencies

- `S3KeySensor`, `FileSensor`, `ExternalTaskSensor` wait for upstream
  conditions.
- `@task.sensor` decorator for custom pokes.
- Set `timeout` and `poke_interval`; use `mode='reschedule'` to free worker
  slots while waiting.

### Branching & conditional logic

- `BranchPythonOperator` picks a downstream path based on XCom.
- Join point: `EmptyOperator` with `trigger_rule=TriggerRule.NONE_FAILED_MIN_ONE_SUCCESS`.

### Error handling & alerts

- `on_failure_callback` on task or DAG: send Slack/PagerDuty with DAG id, task
  id, execution date, error, and log URL.
- `cleanup` task uses `TriggerRule.ALL_DONE` (runs even if upstream failed).
- `notify_success` uses `TriggerRule.ALL_SUCCESS`.

### Dynamic DAG generation

Factory function over `PIPELINE_CONFIGS` (name/schedule/source) generates many
similar DAGs — keeps pipelines DRY.

### Testing DAGs

```python
@pytest.fixture
def dagbag():
    return DagBag(dag_folder='dags/', include_examples=False)

def test_dag_loaded(dagbag):
    assert len(dagbag.import_errors) == 0

def test_dag_integrity(dagbag):
    for dag_id, dag in dagbag.dags.items():
        assert dag.test_cycle() is None, f"Cycle detected in {dag_id}"
```

Also unit-test individual task callables and assert task dependencies
(`dag.get_task('extract').downstream_list`).

### Airflow Do's / Don'ts

Do:
- Use TaskFlow API; set timeouts; use `mode='reschedule'` sensors; test DAGs;
  keep tasks idempotent; import heavy logic from modules.

Don't:
- Use `depends_on_past=True` (bottlenecks); hardcode dates (use `{{ ds }}`
  macros); use global state (tasks should be stateless); skip catchup blindly;
  put heavy logic in the DAG file.

## ML / MLOps pipeline orchestration

End-to-end stages: **data ingestion → preparation → training → validation →
deployment → monitoring**.

### Stage design

1. **Data preparation**: data quality checks (Great Expectations, TFX), feature
   engineering, data versioning/lineage (DVC), train/validation/test splits.
2. **Training**: training-job orchestration, hyperparameter management,
   experiment tracking (MLflow, W&B, TensorBoard), distributed training.
3. **Validation**: validation frameworks and metrics, A/B test infra, performance
   regression detection, model comparison.
4. **Deployment**: serving patterns, canary, blue-green, shadow deployment,
   rollback mechanisms; model registries (MLflow/W&B); monitor drift; automated
   rollback triggers.

### Pipeline best practices

- **Modularity**: each stage independently testable.
- **Idempotency**: re-running stages is safe.
- **Observability**: log metrics at every stage.
- **Versioning**: track data, code, and model versions.
- **Failure handling**: retry logic + alerting.
- Separate training and serving infrastructure; implement gradual rollouts.

### Orchestration tools

- **Apache Airflow**: DAG-based orchestration.
- **Dagster**: asset-based orchestration.
- **Kubeflow Pipelines**: Kubernetes-native ML workflows.
- **Prefect**: modern dataflow automation.

### Progressive disclosure

1. Level 1: simple linear pipeline (data → train → deploy).
2. Level 2: add validation and monitoring stages.
3. Level 3: hyperparameter tuning.
4. Level 4: A/B testing and gradual rollouts.
5. Level 5: multi-model pipelines with ensemble strategies.

### Debugging pipeline failures

1. Check per-stage logs.
2. Validate input/output data at stage boundaries.
3. Test components in isolation.
4. Review experiment-tracking metrics.
5. Inspect model artifacts and metadata.

## Workflow-bundle pattern (phase-based automation playbook)

The `workflow-bundle` / `granular-workflow-bundle` sources encode a reusable
meta-pattern for orchestrating multi-skill delivery:

```
Overview → When to Use → Workflow Phases
  Phase N:
    Skills to Invoke   (which specialized skill for this step)
    Actions            (concrete steps in this phase)
    Copy-Paste Prompts (ready-made invocation prompts)
```

Apply this shape when you need to orchestrate several capabilities into one
guided end-to-end playbook (e.g., design → implement → test → deploy). Each
phase should have explicit completion criteria before advancing.

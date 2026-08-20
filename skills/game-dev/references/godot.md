# Godot 4 Development (GDScript patterns + 3.x -> 4 migration)

> Godot 4.x game development with GDScript: architecture, signals, scenes, state
> machines, and optimization — plus a migration guide for Godot 3.x projects.
> Full runnable code patterns live in `godot-gdscript-playbook.md`.

## When to use

- Building games with Godot 4; implementing game systems in GDScript.
- Designing scene architecture; managing game state; optimizing GDScript.
- Porting a Godot 3.x project to Godot 4 / fixing post-upgrade syntax errors.

## Godot architecture

```
Node:      Base building block
├── Scene: Reusable node tree (saved as .tscn)
├── Resource: Data container (saved as .tres)
├── Signal: Event communication
└── Group:  Node categorization
```

## Key patterns (details + code in playbook)

1. **State machine** — generic `StateMachine` node that registers `State` children, enables/disables their `process_mode`, and routes `_process` / `_physics_process` / `_unhandled_input` to the current state.
2. **Autoload singletons** — `game_manager.gd`, `event_bus.gd` (global signal bus) for truly global systems; use sparingly.
3. **Resource-based data** — `WeaponData`, `CharacterStats` as `Resource` subclasses; duplicate for runtime to avoid mutating the shared asset.
4. **Object pooling** — generic `ObjectPool` with `get_instance()` / return-to-pool signals; process_mode disabled while idle.
5. **Component system** — `HealthComponent` / `HitboxComponent` / `HurtboxComponent` decoupled via signals.
6. **Scene management** — autoload `SceneManager` using `ResourceLoader.load_threaded_request` for async loads with transitions.
7. **Save system** — encrypted JSON via `FileAccess.open_encrypted_with_pass`, plus a `Saveable` component pattern.

## Godot 3 -> 4 migration (GDScript 2.0)

**1. Annotations (`@`):**
```
export var x  -> @export var x
onready var y -> @onready var y
tool          -> @tool (top of file)
```

**2. Setters/getters inline:**
```gdscript
# Godot 3: var health setget set_health, get_health
# Godot 4:
var health: int:
    set(value):
        health = value
        emit_signal("health_changed", health)
    get:
        return health
```

**3. Tween system** — the `Tween` node is deprecated; use `create_tween()`:
```gdscript
var tween = create_tween()
tween.tween_property($Sprite, "position", Vector2(100, 100), 1.0)
tween.parallel().tween_property($Sprite, "modulate:a", 0.0, 1.0)
```

**4. Signal connections use callables, not strings:**
```gdscript
# Godot 3: connect("pressed", self, "_on_pressed")
pressed.connect(_on_pressed)
```

**5. Typed arrays** — `var enemies: Array[Node] = []` for performance + type safety.

**6. `yield` -> `await`:**
```gdscript
# Godot 3: yield(get_tree().create_timer(1.0), "timeout")
await get_tree().create_timer(1.0).timeout
```

**7. Parent calls** — use `super()` instead of `.function_name()`.

**Troubleshooting:** "Identifier 'Tween' is not a valid type" — `Tween` is now returned by `create_tween()`; rarely type it explicitly.

## Performance tips

- Cache node references (`@onready var sprite := $Sprite2D`), never `get_node()` in loops.
- Object pooling for frequent spawning.
- Avoid allocations in hot paths — reuse arrays.
- Static typing everywhere (`func calculate(value: float) -> float`).
- Disable processing when not needed (`set_process(false)`).

## Do & Don't

| Don't | Do |
|-------|-----|
| `get_node()` in loops | Cache references |
| Tightly couple scenes | Use signals |
| Put logic in resources | Keep resources data-only |
| Use string names for signals | Use signal objects / callables |
| Ignore the Profiler | Monitor performance |
| Fight the scene tree | Work with Godot's design |

## Learning resources

- Godot Docs: https://docs.godotengine.org/en/stable/
- GDQuest: https://www.gdquest.com/
- Godot Recipes: https://kidscancode.org/godot_recipes/

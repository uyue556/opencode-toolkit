# Unit Testing

Framework patterns for writing, generating, and covering unit tests. Merged from:
`pytest-skill`, `testing-patterns` (Jest), `unit-testing-test-generate`,
`bats-testing-patterns`, and the framework-specific material in `test-guard`.

## Test structure

- Organize by component/feature with `describe` blocks; one behavior per test.
- AAA pattern: arrange → act → assert.
- Descriptive names: `should_X_when_Y` (Jest) / `test_<scenario>_<expected>` (pytest).
- Clear mocks between tests (`jest.clearAllMocks()`, fresh fixtures).
- Use `beforeEach`/fixtures for shared setup, not `__init__`/class state.

```typescript
describe('LoginForm', () => {
  beforeEach(() => jest.clearAllMocks());

  describe('Rendering', () => {
    it('renders loading state while loading', () => {});
  });
  describe('User interactions', () => {
    it('calls onSubmit when the form is submitted', async () => {});
  });
});
```

## Factory pattern (data builders)

Create `getMockX(overrides?: Partial<X>)` functions with sensible defaults so tests
stay DRY and consistent — avoids copy-paste test data that drifts out of sync.

```typescript
const getMockUser = (overrides?: Partial<User>): User => ({
  id: '123',
  name: 'John Doe',
  email: 'john@example.com',
  role: 'user',
  ...overrides,
});

it('shows admin badge for admins', () => {
  const user = getMockUser({ role: 'admin' });
  // ...
});
```

In Python, prefer a fixture that builds a **real** object (or `factory_boy` if it
has many fields) rather than `MagicMock()` — real construction catches field typos
and validation errors.

## pytest patterns

### Fixtures

```python
@pytest.fixture
def calculator():
    return Calculator()

@pytest.fixture
def db_connection():
    conn = Database.connect("test_db")
    yield conn          # teardown after yield
    conn.rollback()
    conn.close()

@pytest.fixture(scope="module")
def api_client():
    client = APIClient(base_url="http://localhost:8000")
    yield client
    client.logout()
```

- `conftest.py` holds shared fixtures; `autouse=True` for reset/cleanup fixtures.
- Scope: function (default) / module / session. Use `tmp_path` for file I/O.

### Parametrize (data-driven)

```python
@pytest.mark.parametrize("input,expected", [
    ("hello", 5), ("", 0), ("pytest", 6),
])
def test_string_length(input, expected):
    assert len(input) == expected
```

### Markers

```python
@pytest.mark.slow
@pytest.mark.skip(reason="Not implemented")
@pytest.mark.skipif(sys.platform == "win32", reason="Unix only")
@pytest.mark.xfail(reason="Known bug #123")
```

### Mocking

Mock only at boundaries: HTTP clients (`requests`/`httpx`), LLM SDKs, DB sessions
(when not the subject), `time`/`datetime`/`random` (or use `freezegun`). Prefer
`respx`/`responses` over raw HTTP mocks.

```python
def test_send_email(mocker):
    mock_smtp = mocker.patch("myapp.email.smtplib.SMTP")
    send_welcome_email("user@test.com")
    mock_smtp.return_value.sendmail.assert_called_once()
```

Anti-patterns: mocking internal utilities, mocking `json.loads`, `@patch` stacked
3+ deep, `MagicMock()` standing in for a Pydantic model/dataclass.

### Assertions

```python
assert x == y
assert x in collection
assert isinstance(obj, MyClass)
assert 0.1 + 0.2 == pytest.approx(0.3)

with pytest.raises(ValueError) as exc_info:
    raise ValueError("bad")
assert "bad" in str(exc_info.value)
```

Use plain `assert` (pytest rewrites give better output), not `self.assertEqual`.

### pyproject.toml

```toml
[tool.pytest.ini_options]
testpaths = ["tests"]
markers = ["slow: slow tests", "integration: integration tests"]
addopts = "-v --tb=short"
```

### Quick reference

| Task | Command |
|------|---------|
| Run all | `pytest` |
| Run one file / node | `pytest tests/test_login.py::test_login_success` |
| By marker / keyword | `pytest -m slow` / `pytest -k "login and not invalid"` |
| Stop first fail / last failed | `pytest -x` / `pytest --lf` |
| Coverage | `pytest --cov=myapp --cov-report=html` |
| Parallel | `pytest -n auto` (pytest-xdist) |

## Jest / Vitest patterns

### Mocking modules

```typescript
jest.mock('utils/analytics', () => ({
  Analytics: { logEvent: jest.fn() },
}));
const mockLogEvent = jest.requireMock('utils/analytics').Analytics.logEvent;
```

In JS/TS prefer `msw` (Mock Service Worker) for network mocking — it mocks at the
true HTTP boundary instead of your own fetch wrapper.

### Query & interaction patterns (Testing Library)

```typescript
expect(screen.getByText('Hello')).toBeTruthy();      // must exist
expect(screen.queryByText('Goodbye')).toBeNull();      // must not exist
await waitFor(() => expect(screen.findByText('Loaded')).toBeTruthy());

fireEvent.changeText(screen.getByLabelText('Email'), 'user@example.com');
fireEvent.press(screen.getByTestId('login-button'));
await waitFor(() => expect(onSubmit).toHaveBeenCalled());
```

### Data-driven with `test.each`

```typescript
test.each([
  ['Hello World', 'hello-world'],
  ['  padded  ', 'padded'],
])('slugify(%s) → %s', (raw, expected) => {
  expect(slugify(raw)).toBe(expected);
});
```

### Snapshot discipline

Snapshots are implementation tests in disguise unless the snapshot *is* the
contract (public JSON output, CLI help text). Avoid full component trees and large
unreviewed objects. Prefer targeted assertions:
`expect(screen.getByRole('button')).toHaveTextContent('Save')`.

## Anti-patterns (both ecosystems)

- Testing the mock instead of behavior (`expect(mockFetchData).toHaveBeenCalled()`
  instead of asserting the rendered result).
- Duplicated test data without factories.
- Testing framework guarantees (that the validator validates, the ORM commits).
- Asserting `mock.call_count` on internal functions.

## Generating unit tests from code

Analyze the source to find functions/classes, then generate happy-path, empty-input,
and error-handling tests per unit. Skip private members; keep one class per unit
under test; provide fixtures for external dependencies. Then run coverage to find
gaps (`files_below_threshold`, `missing_lines`) and generate targeted tests for
uncovered lines. Generated tests must still be reviewed against the rules in
`test-quality-review.md` — agents over-generate.

## Coverage

- `npm run test:coverage` / `pytest --cov=...`.
- Aim ≥80% line coverage; prioritize critical paths.
- Coverage is a floor: fix gaps in untested branches, error paths, and boundary
  conditions, but don't game percentages with trivial tests (rule: "what bug does
  this catch?").

## Bash (Bats)

For shell scripts use Bats (Bash Automated Testing System): set up helper/fixture
structure, assert on exit codes, output, and side effects, add setup/teardown, and
run in CI. Confirm shell dialect compatibility (bash/dash/ksh/POSIX) first.

## Production-grade checklist

- Fixtures scoped correctly with teardown
- Parametrize instead of copy-paste
- Mocks only at system boundaries
- Async tests (pytest-asyncio) handled
- Real test DB for persistence logic (rule 9)
- CI runs tests in matrix with coverage gate

# Spreadsheets — xlsx & Google Sheets

Synthesized from: `xlsx-official`, `google-sheets-automation`, `googlesheets-automation`.

## ToC

1. [Excel/xlsx workflows](#excelxlsx-workflows)
2. [Excel output standards](#excel-output-standards)
3. [Formula verification & recalc](#formula-verification--recalc)
4. [Google Sheets (standalone OAuth)](#google-sheets-standalone-oauth)
5. [Google Sheets (Rube MCP)](#google-sheets-rube-mcp)

## Excel/xlsx workflows

- Read/analyze with **pandas** (`pd.read_excel`, `pd.to_excel`); create/edit formulas + formatting with
  **openpyxl**.
- CRITICAL: use Excel **formulas**, not values computed in Python (`sheet['B10'] = '=SUM(B2:B9)'`, not
  `sheet['B10'] = 5000`). Spreadsheet must recalculate when source data changes.
- Create: openpyxl `Workbook` → add data/formulas → styles → `wb.save()`.
- Edit: `load_workbook('existing.xlsx')` preserves formulas/formatting; `data_only=True` reads cached
  values but saving then destroys formulas — never save a `data_only` workbook.
- Deliver zero formula errors (`#REF!`, `#DIV/0!`, `#VALUE!`, `#N/A`, `#NAME?`).
- Preserve existing template conventions — never impose formatting on files with established patterns.
- Watch 1-based indexing (Excel row 1 = DataFrame row 0), column letters vs numbers, NaN/null handling.

## Excel output standards

Financial-model conventions (unless user/template says otherwise):

- Color coding: blue = hardcoded inputs, black = formulas, green = same-workbook links, red = external
  links, yellow background = key assumptions to update.
- Number formats: years as text; `$#,##0` for currency with units in headers; zeros display `-`;
  percentages 0.0%; multiples 0.0x; negatives in parentheses.
- Put all assumptions in separate cells and reference them (`=B5*(1+$B$6)`), never inline constants.
- Document hardcoded sources ("Source: Company 10-K, FY2024, Page 45 ...").

## Formula verification & recalc

- openpyxl writes formulas as strings without cached values → recalculate with LibreOffice
  (`python recalc.py output.xlsx [timeout]`), which auto-configures LibreOffice, recalculates all
  sheets, and scans for Excel errors returning JSON (`status`, `total_errors`, `error_summary` with
  locations per error type). Fix and re-run until `status: success`.
- Checklist: test 2–3 sample references first; verify column mapping; confirm row offsets; check
  denominators (division by zero), cross-sheet refs (`Sheet1!A1`), and edge cases (zero/negative/large).

## Google Sheets (standalone OAuth)

Lightweight integration, no MCP server, requires a Google Workspace account:

- Auth: `python scripts/auth.py login|status|logout`; tokens stored in the OS keyring
  (service: `google-sheets-skill-oauth`), auto-refresh.
- Read: `get-text ID [--format csv|json]`, `get-range ID "Sheet1!A1:D10"`, `find "query"`, `get-metadata`.
- Write: `update-range ID "Sheet1!A1:B2" '[[...]]' [--raw]`, `append-rows`, `clear-range`,
  `batch-update` (formatting/merging).
- Spreadsheet ID or full URL both work. Value modes: USER_ENTERED (parses formulas/dates) vs RAW
  (literal text). A1 notation: `Sheet1!A1:B10`, `Sheet1!A:A`, `Sheet1!1:1`.

## Google Sheets (Rube MCP)

MCP-based automation (Composio/Rube): read/write data, create/manage spreadsheets, search & filter
rows, upsert rows by key, format cells. Same discipline as any MCP automation: confirm the target
spreadsheet, handle rate limits, validate before bulk writes. Prefer the standalone script when you
want zero external dependencies.

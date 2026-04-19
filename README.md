# pgtools

Repository of convenience PostgreSQL functions and stored procedures.

## Included utilities

The SQL module at `sql/pgtools.sql` installs:

- `pgtools.null_if_blank(text)` — returns `NULL` when a string is empty.
- `pgtools.trim_to_null(text)` — trims surrounding whitespace and returns `NULL` if empty.
- `pgtools.touch_row(regclass, text, text, text default 'updated_at')` — updates `updated_at` (or another timestamp column) for all rows matching `key_column::text = key_value` (multiple rows may be affected if the key column is not unique).

`touch_row` intentionally compares by `key_column::text`, so non-text key types are matched by their text output. If no rows match, the procedure exits without error.

## Usage

Load the utilities:

```sql
-- Replace /path/to/pgtools with your local checkout path.
\i /path/to/pgtools/sql/pgtools.sql
```

Examples:

```sql
select pgtools.null_if_blank('');
select pgtools.trim_to_null('  hello  ');
call pgtools.touch_row('public.accounts', 'id', '42');
```

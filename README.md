# pgtools

Repository of convenience PostgreSQL functions and stored procedures.

## Included utilities

The SQL module at `/home/runner/work/pgtools/pgtools/sql/pgtools.sql` installs:

- `pgtools.null_if_blank(text)` — returns `NULL` when a string is empty.
- `pgtools.trim_to_null(text)` — trims surrounding whitespace and returns `NULL` if empty.
- `pgtools.touch_row(regclass, text, text, text default 'updated_at')` — updates a row's timestamp column to `clock_timestamp()` by key.

## Usage

Load the utilities:

```sql
\i /path/to/pgtools/sql/pgtools.sql
```

Examples:

```sql
select pgtools.null_if_blank('   ');
select pgtools.trim_to_null('  hello  ');
call pgtools.touch_row('public.accounts', 'id', '42');
```

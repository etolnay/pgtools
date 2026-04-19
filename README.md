# Zeke's pgtools library
Convenience PostgreSQL functions, stored procedures, types, and collations.
Some of the functions are Supabase-specific.

## Overview
All objects are created in a series of aptly-named schemas:
* __utils__: Functions and procedures that assist with development, maintenance, set-up, etc.
* __private__: Data and supporting code that should only be accessible by administrators, or security definer functions and procedures owned by administrators.
* __public__: Types and utility functions to be included in common views, constraints, indices, or RLS rules.

## Included utilities

The SQL module at `sql/pgtools.sql` installs general tools:

- creates utils and private schemas
- `pgtools.null_if_blank(text)` — returns `NULL` when a string is empty.
- `pgtools.trim_to_null(text)` — trims surrounding whitespace and returns `NULL` if empty.
- `pgtools.touch_row(regclass, text, text, text default 'updated_at')` — updates `updated_at` (or another timestamp column) for all rows matching `key_column::text = key_value` (multiple rows may be affected if the key column is not unique).

`touch_row` intentionally compares by `key_column::text`, so non-text key types are matched by their text output. If no rows match, the procedure exits without error.

The `sql` folder contains an assortment of files with functions and stored procedures for specific requirements.

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

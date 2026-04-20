# Zeke's pgtools library
Convenience PostgreSQL functions, stored procedures, types, and collations.
Some of the functions are Supabase-specific.

If you would like to contribute, please make any changes you want on your own fork, and create pull requests for any bugs you've fixed, or code you'd like to contribute to this repo. Thanks in advance!

## Overview
All objects are created in a series of aptly-named schemas:
* __utils__: Functions and procedures that assist with development, maintenance, set-up, etc.
* __private__: Data and supporting code that should only be accessible by administrators, or security definer functions and procedures owned by administrators.
* __public__: Types and utility functions to be included in common views, constraints, indices, or RLS rules.

## Included utilities

The SQL module at `sql/pgtools.sql` installs general tools:

- creates utils and private schemas if not already present, and revokes access from public for these.
- `public.nullif_blank(text)` — returns `NULL` when a string is empty.
- `public.trim_to_null(text)` — trims surrounding whitespace and returns `NULL` if empty.
- `public.tf_set_updated_at()` — trigger function that updates `updated_at` to now().

The SQL module at `sql/clone_schema.sql` installs general tools:
- `utils.clone_schema(from_schema text, to_schema text)` - creates a new schema named as `to_schema`, cloning the schema named `from_schema` (DDL only).

The `sql` folder also contains an assortment of files with functions and other objects for specific requirements.

## Usage

Load the utilities:

```sql
psql -f sql/pgtools.sql
```

Examples:

```sql
SELECT public.nullif_blank('');
SELECT public.trim_to_null('  hello  ');
CREATE OR REPLACE TRIGGER set_updated_at BEFORE UPDATE ON your_table FOR EACH ROW EXECUTE FUNCTION public.tf_set_updated_at();
```

create schema if not exists pgtools;

create or replace function pgtools.null_if_blank(value text)
returns text
language sql
immutable
parallel safe
as $$
    select nullif(value, '');
$$;

comment on function pgtools.null_if_blank(text)
is 'Converts an empty string to NULL.';

create or replace function pgtools.trim_to_null(value text)
returns text
language sql
immutable
parallel safe
as $$
    select nullif(btrim(value), '');
$$;

comment on function pgtools.trim_to_null(text)
is 'Trims leading and trailing whitespace and converts empty results to NULL.';

create or replace procedure pgtools.touch_row(
    target_table regclass,
    key_column text,
    key_value text,
    updated_column text default 'updated_at'
)
language plpgsql
as $$
declare
    table_schema text;
    table_name text;
    statement text;
begin
    select n.nspname, c.relname
    into table_schema, table_name
    from pg_class as c
    join pg_namespace as n on n.oid = c.relnamespace
    where c.oid = target_table;

    if not exists (
        select 1
        from pg_attribute
        where attrelid = target_table
          and attname = key_column
          and not attisdropped
          and attnum > 0
    ) then
        raise exception 'Column "%" does not exist on table %', key_column, target_table;
    end if;

    if not exists (
        select 1
        from pg_attribute
        where attrelid = target_table
          and attname = updated_column
          and not attisdropped
          and attnum > 0
    ) then
        raise exception 'Column "%" does not exist on table %', updated_column, target_table;
    end if;

    -- Use %I for identifier interpolation; key_value is passed as a bound value.
    statement := format(
        'update %I.%I set %I = clock_timestamp() where %I::text = $1',
        table_schema,
        table_name,
        updated_column,
        key_column
    );

    execute statement using key_value;
end;
$$;

comment on procedure pgtools.touch_row(regclass, text, text, text)
is 'Sets the timestamp column (default updated_at) to clock_timestamp() for all rows where key_column::text = key_value. Matching uses text output rules for the key column. Non-text types are compared by their text representation, and multiple rows may be updated when key_column is not unique. Raises an error if specified columns do not exist. If no rows match, the procedure exits without error.';

create schema if not exists pgtools;

create or replace function pgtools.null_if_blank(value text)
returns text
language sql
immutable
parallel safe
as $$
    select nullif(value, '');
$$;

create or replace function pgtools.trim_to_null(value text)
returns text
language sql
immutable
parallel safe
as $$
    select nullif(btrim(value), '');
$$;

create or replace procedure pgtools.touch_row(
    target_table regclass,
    key_column text,
    key_value text,
    updated_column text default 'updated_at'
)
language plpgsql
as $$
declare
    statement text;
begin
    statement := format(
        'update %s set %I = clock_timestamp() where %I::text = $1',
        target_table,
        updated_column,
        key_column
    );

    execute statement using key_value;
end;
$$;

/*
Library of convenience utility functions for PostgreSQL and Supabase.
This library includes functions that are used elsewhere in this project, and that are commonly used in most projects.

This library installs the following schemas:
  * private: handles security-sensitive data, should only be accessed by administrators and trusted users,
             and be accessible only by security definer functions and stored procedures.
  * utils:   for utility functions and procedures that assist with development and maintenance,
             typically only accessible by administrators, developers, cron jobs, and other trusted users.

Naming conventions for this and all other files in this project:
  * All objects, columns, variables, and arguments should have descriptive names and be named using snake_case.
  * Functions should have descriptive parameter names, and use `#variable_conflict use_variable` to avoid naming conflicts with variables in the calling context.
  * Variable names should be prefixed with an underscore.
  * Trigger functions should be prefixed with `tf_`. Triggers calling these should ideally be named the same but without the `tf_` prefix.
  * Functions that are intended for use in SQL queries and by application code should be created in the public schema,
    and have descriptive names that clearly indicate their purpose and behavior.
  * Functions that are intended for internal use only or security-sensitive operations, such as helper functions for other functions,
    should be created in the private schema.
  * Functions that are intended for development and maintenance tasks, such as data cleanup or performance monitoring,
    should be created in the utils schema.
  * Functions that modify data should be marked as VOLATILE, and those that do not should be marked as IMMUTABLE or STABLE as appropriate.

Developed by Ezequiel Tolnay. Licensed under the GNU General Public License v3.0. See LICENSE file for details.
*/

CREATE SCHEMA IF NOT EXISTS private, utils;
REVOKE ALL ON SCHEMA private, utils FROM public;

CREATE OR REPLACE FUNCTION public.nullif_blank(value text) RETURNS text STRICT IMMUTABLE PARALLEL SAFE SET SEARCH_PATH TO public, pg_temp
    RETURN NULLIF($1, '');

COMMENT ON FUNCTION public.nullif_blank(text) IS 'Converts an empty string to NULL.';

CREATE OR REPLACE FUNCTION public.trim_to_null(value text) RETURNS text STRICT IMMUTABLE PARALLEL SAFE SET SEARCH_PATH TO public, pg_temp
    RETURN NULLIF(btrim($1), '');

COMMENT ON FUNCTION public.trim_to_null(text) IS 'Trims leading and trailing whitespace and converts empty results to NULL.';

CREATE OR REPLACE FUNCTION public.tf_set_updated_at() RETURNS trigger AS
$BODY$
BEGIN
    NEW.updated_at := now();
    RETURN NEW;
END;
$BODY$ LANGUAGE plpgsql SET SEARCH_PATH TO public, pg_temp;

COMMENT ON FUNCTION public.tf_set_updated_at() IS 'Trigger function that sets the updated_at column to the current timestamp for the row being updated.
Invoke from a trigger like: CREATE TRIGGER set_updated_at BEFORE UPDATE ON your_table FOR EACH ROW EXECUTE FUNCTION public.tf_set_updated_at();';

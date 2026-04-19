# Zeke's pgtools library
Convenience PostgreSQL functions, stored procedures, types, and collations.
Some of the functions are Supabase-specific.

## Overview
All objects are created in a series of aptly-named schemas:
* __utils__: Functions and procedures that assist with development, maintenance, set-up, etc.
* __private__: Data and supporting code that should only be accessible by administrators, or security definer functions and procedures owned by administrators.
* __public__: Types and utility functions to be included in common views, constraints, indices, or RLS rules.
-- Clarity v0.19 patient backend migration
-- Run once in Supabase SQL Editor before using the updated Patients page.
-- Stores existing v0.19 patient fields not represented by the normalized columns.
alter table public.patients
  add column if not exists details jsonb not null default '{}'::jsonb;

-- Ensure authenticated users can use the existing owner-scoped policies.
-- This migration intentionally does not weaken or replace existing RLS policies.

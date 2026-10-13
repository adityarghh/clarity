-- Clarity: assessments, alert decisions, audit log, feedback. Run once in Supabase SQL Editor.
create table if not exists public.assessments(id uuid primary key default gen_random_uuid(),owner_id uuid not null default auth.uid() references auth.users(id),patient_code text,meds jsonb,findings jsonb,used_kb boolean,summary text,created_at timestamptz default now());
create table if not exists public.alert_decisions(id uuid primary key default gen_random_uuid(),owner_id uuid not null default auth.uid() references auth.users(id),patient_code text,finding_id text,level text,decision text check(decision in('acknowledged','overridden')),reason text,role text,created_at timestamptz default now());
create table if not exists public.audit_log(id uuid primary key default gen_random_uuid(),owner_id uuid not null default auth.uid() references auth.users(id),role text,action text,detail text,prev_hash text,hash text,created_at timestamptz default now());
create table if not exists public.feedback(id uuid primary key default gen_random_uuid(),owner_id uuid not null default auth.uid() references auth.users(id),kind text check(kind in('rating','accuracy')),value int,created_at timestamptz default now());
do $$ declare t text; begin foreach t in array array['assessments','alert_decisions','audit_log','feedback'] loop
 execute format('alter table public.%I enable row level security',t);
 execute format('drop policy if exists "%s_select" on public.%I',t,t);execute format('drop policy if exists "%s_insert" on public.%I',t,t);
 execute format('create policy "%s_select" on public.%I for select to authenticated using (owner_id=auth.uid())',t,t);
 execute format('create policy "%s_insert" on public.%I for insert to authenticated with check (owner_id=auth.uid())',t,t);
end loop; end $$;
-- Audit log is append-only: no update/delete policies exist, and privileges are revoked.
revoke update,delete on public.audit_log from authenticated,anon;

-- Hardening (safe to re-run): server-side critical count and database-enforced audit chain.
alter table public.assessments add column if not exists critical_count int not null default 0;
create extension if not exists pgcrypto with schema extensions;
create or replace function public.audit_log_guard() returns trigger language plpgsql security definer set search_path=public,extensions as $$
begin
 if tg_op='INSERT' then
  select a.hash into new.prev_hash from public.audit_log a where a.owner_id=new.owner_id order by a.created_at desc,a.id desc limit 1;
  new.prev_hash:=coalesce(new.prev_hash,'0'); new.created_at:=now();
  new.hash:=encode(extensions.digest(new.prev_hash||new.owner_id::text||coalesce(new.role,'')||new.action||coalesce(new.detail,'')||new.created_at::text,'sha256'),'hex');
  return new;
 end if;
 raise exception 'audit_log is append-only';
end $$;
drop trigger if exists audit_log_ins on public.audit_log;
create trigger audit_log_ins before insert on public.audit_log for each row execute function public.audit_log_guard();
drop trigger if exists audit_log_nomod on public.audit_log;
create trigger audit_log_nomod before update or delete on public.audit_log for each row execute function public.audit_log_guard();
drop trigger if exists audit_log_notrunc on public.audit_log;
create trigger audit_log_notrunc before truncate on public.audit_log for each statement execute function public.audit_log_guard();

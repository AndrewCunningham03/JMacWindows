-- Run this in Supabase SQL Editor to add new fields
-- (It's safe to run even if some columns already exist)

alter table customers add column if not exists whatsapp text default '';
alter table customers add column if not exists windows_count int default 0;
alter table customers add column if not exists gate_code text default '';
alter table customers add column if not exists directions text default '';
alter table customers add column if not exists stripe_link text default '';
alter table customers add column if not exists revolut_link text default '';
alter table customers add column if not exists lat float;
alter table customers add column if not exists lng float;
alter table customers add column if not exists route_order int default 999;

alter table cleaning_history add column if not exists visit_notes text default '';
alter table cleaning_history add column if not exists done_by text default '';

create table if not exists scheduled_jobs (
  id bigserial primary key,
  customer_id bigint references customers(id) on delete cascade,
  scheduled_date date not null,
  notes text default '',
  done boolean default false,
  created_at timestamptz default now()
);
alter table scheduled_jobs enable row level security;
create policy "authenticated_schedule" on scheduled_jobs
  for all to authenticated using (true) with check (true);

-- Run this in Supabase SQL Editor to enable the "Owing list" feature.
-- When admin starts a "Next round" on a route, anyone still unpaid gets
-- recorded here so you can come back later and chase them for payment.
-- Safe to run multiple times.

create table if not exists unpaid_carryovers (
  id bigserial primary key,
  customer_id bigint references customers(id) on delete cascade,
  route text,
  miss_count int default 1,
  amount_owed numeric,
  created_at timestamptz default now(),
  resolved boolean default false
);

alter table unpaid_carryovers enable row level security;

drop policy if exists "carryovers_all" on unpaid_carryovers;
create policy "carryovers_all" on unpaid_carryovers
  for all to authenticated using (true) with check (true);

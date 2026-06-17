-- Window Rounds — run this in Supabase SQL Editor (Database > SQL Editor > New Query)

create table customers (
  id bigserial primary key,
  name text not null,
  addr text default '',
  phone text default '',
  route text not null,
  freq text default 'monthly',
  price numeric(10,2) default 20,
  paid boolean default false,
  last_cleaned text default '',
  notes text default '',
  created_at timestamptz default now()
);

create table cleaning_history (
  id bigserial primary key,
  customer_id bigint references customers(id) on delete cascade,
  cleaned_date date not null default current_date,
  price numeric(10,2),
  paid boolean default false,
  created_at timestamptz default now()
);

alter table customers enable row level security;
alter table cleaning_history enable row level security;

create policy "authenticated_customers" on customers
  for all to authenticated using (true) with check (true);

create policy "authenticated_history" on cleaning_history
  for all to authenticated using (true) with check (true);

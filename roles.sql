-- Run this in Supabase SQL Editor to add role-based access
-- Safe to run multiple times

create table if not exists profiles (
  id uuid references auth.users(id) on delete cascade primary key,
  email text,
  name text default '',
  role text default 'employee',
  created_at timestamptz default now()
);

alter table profiles enable row level security;

-- Everyone can read all profiles (so admin can see employee list)
create policy "profiles_read" on profiles
  for select to authenticated using (true);

-- Users can only update their own profile
create policy "profiles_update_own" on profiles
  for update to authenticated using (auth.uid() = id);

-- Users can insert their own profile on first login
create policy "profiles_insert_own" on profiles
  for insert to authenticated with check (auth.uid() = id);

-- Make yourself admin — replace with your actual email
update profiles set role = 'admin' where email = 'andrewcunningham9911@gmail.com';

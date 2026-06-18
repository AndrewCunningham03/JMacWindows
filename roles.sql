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
drop policy if exists "profiles_insert_own" on profiles;
create policy "profiles_insert_own" on profiles
  for insert to authenticated with check (auth.uid() = id);

-- Helper: is the current logged-in user an admin?
-- SECURITY DEFINER avoids infinite recursion (a profiles policy querying profiles)
create or replace function public.is_admin() returns boolean
  language sql security definer stable set search_path = public as $$
    select exists(select 1 from profiles where id = auth.uid() and role = 'admin');
  $$;

-- Admins can update ANY profile (this is what makes the "Make admin" button work)
drop policy if exists "profiles_update_admin" on profiles;
create policy "profiles_update_admin" on profiles
  for update to authenticated using (public.is_admin()) with check (public.is_admin());

-- Make yourself admin — replace with YOUR actual login email
update profiles set role = 'admin' where email = 'andrewcunningham9911@hotmail.com';

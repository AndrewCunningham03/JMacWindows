-- Run this AFTER deleting the test users from Authentication → Users in the
-- Supabase dashboard. This just cleans up their leftover row in `profiles`
-- (deleting the auth user does not automatically remove it).

delete from profiles where email in ('test@gmail.com', 'testemployee@gmail.com');

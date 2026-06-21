# JMac Windows — JMac Window Cleaning

A simple phone app for running window cleaning rounds: customers, weekly routes,
marking jobs done, tracking who's paid, and sending WhatsApp messages.

**Live app:** https://andrewcunningham03.github.io/JMacWindows/

Open that link on your phone, then use your browser menu → **"Add to Home Screen"**
so it sits on your phone like a normal app. Always use this link — never open the
files from a Downloads folder (it won't work).

---

## Day-to-day use

Everything you need is on the **Today** tab. There's an **ⓘ How this works**
button there that explains it in plain English. In short:

- **Today** — pick this week's route, tap **Done** as you clean each house.
  After tapping Done you can send a WhatsApp text (thank-you if they paid, or a
  pay-link reminder if they didn't).
- **Tap the price/"Tap if paid" badge** anywhere to mark someone paid or unpaid.
- **Customers** — search everyone, add/edit, send "Tomorrow" / "All done" texts.
- **Map** — see the route on a map and open it in Google Maps to navigate.
- **Routes** — the running order for each route; admin can start the **Next round**.
- **Money** (admin only) — who owes you, and full history of every job done.
- **Admin** (admin only) — team, the **Owing list**, and start next rounds.

### Roles
- **Admin** sees everything including prices and money.
- **Employee** sees customers, routes, the map and can mark jobs done — but
  **never sees any prices or money figures**.

A new person who logs in starts as an **employee**. To make them an admin, an
existing admin taps **Make admin** next to their name in the Admin → Team list.

---

## Adding a new staff member
1. They open the live link and sign in with their own email + a password
   (create their user in the Supabase dashboard → Authentication → Users, or
   send them an invite from there).
2. They log in once — they'll appear in Admin → Team as an Employee.
3. Tap **Make admin** if they should have full access.

## Forgot password
There's no self-service reset (not worth it for a small team). If someone forgets,
the owner resets it in Supabase → Authentication → Users → that person →
"Send password reset" (or set a new password directly).

---

## ⚠️ If the app gets stuck on a loading/spinning screen and won't open

This is the single most important troubleshooting step. It usually happens after
the app has been updated, or randomly on iPhone after the app has been fully
closed (swiped away) for a while.

**Fix it like this, on the phone that's stuck:**
1. **Delete the app icon** from the home screen (long-press it → Remove from Home Screen)
2. Go to **Settings app → Safari → Advanced → Website Data**
3. Search for **"github.io"**, swipe left on it → **Delete**
4. Open **Safari**, go to the live link (https://andrewcunningham03.github.io/JMacWindows/)
5. **Log in again** (clearing website data also clears the saved login — this is expected, just log back in once)
6. **Share → Add to Home Screen** again

This clears out any stuck cached version of the app and fixes it for good. If
it ever happens again to anyone on the team, this is the fix — no need to
re-diagnose it from scratch.

---

## Behind the scenes (for whoever maintains it)

- **Frontend:** one file, `index.html` (plain HTML/JS, no build step). Deployed
  free via GitHub Pages from the `AndrewCunningham03/JMacWindows` repo.
- **Backend:** Supabase (Postgres + auth). The project URL and public key are in
  the CONFIG section near the top of `index.html`. The public key is safe to be
  public — the database is protected by row-level security.
- **Tables:** `customers`, `cleaning_history`, `profiles`, `unpaid_carryovers`.

### SQL files (already applied to the live database — only needed for a fresh setup)
Run in this order in Supabase → SQL Editor:
1. `setup.sql` — creates the core tables
2. `update.sql` — adds extra columns the app needs
3. `roles.sql` — adds the admin/employee system (edit the last line to set the
   first admin's email)
4. `owing_list.sql` — adds the Owing list feature

⚠️ **`full_reset.sql` deletes ALL customers and history** and reloads from scratch.
Do not run it on the live database unless you really mean to wipe everything.
The other `fix_*.sql` / `update_phones.sql` files were one-off jobs and can be ignored.

### Costs
Free at this scale. Supabase free tier and GitHub Pages cover ~170 customers with
daily use comfortably. (Supabase pauses a project after 7 days of *no* activity —
not a concern with daily use.)

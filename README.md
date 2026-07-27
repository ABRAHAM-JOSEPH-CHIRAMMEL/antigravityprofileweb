# Portfolio + admin login — setup guide

Three pages:
- `index.html` — the public site (safe to publish even before Supabase is set up; it falls back to the content already written into the HTML).
- `admin-login.html` — email/password sign-in, gated to you only.
- `admin-dashboard.html` — edit the hero line, about paragraph, and stats; changes save live to the public site.

## 1. Create a Supabase project

1. Go to [supabase.com](https://supabase.com) → New project. Free tier is enough.
2. Once it's created, go to **Project Settings → API**. Copy:
   - **Project URL**
   - **anon public key**

## 2. Create the database table

1. In Supabase, open **SQL Editor**.
2. Paste the contents of `supabase-schema.sql` (included alongside this file) and run it.
   This creates the `site_content` table, seeds it with your current copy, and locks it down so anyone can *read* it but only a signed-in user can *write* to it.

## 3. Create your admin login

1. In Supabase, go to **Authentication → Users → Add user**.
2. Add yourself with an email and password. Use **"Auto Confirm User"** so you don't need to click an email link.
3. This is the only account that will be able to log in — there's no public sign-up form on purpose.

## 4. Wire up the three HTML files

Open `index.html`, `admin-login.html`, and `admin-dashboard.html`. In each, find:

```js
const SUPABASE_URL = "YOUR_SUPABASE_URL";
const SUPABASE_ANON_KEY = "YOUR_SUPABASE_ANON_KEY";
```

Replace both values with what you copied in step 1. Same two values in all three files.

## 5. Deploy

Push all files to your `abraham-joseph-chirammel.github.io` repo (or whichever repo powers your GitHub Pages) and it works as-is — GitHub Pages just serves static files, and Supabase handles the backend.

- Visit `yoursite.com/admin-login.html`, sign in, and edit content.
- Visit `yoursite.com/` — your changes to the hero line, about paragraph, and stats appear automatically, no redeploy needed.

## What's editable live vs. not yet

Wired up to Supabase and editable from the dashboard right now:
- Hero role line
- The four hero stats (number + label)
- About section lead paragraph

**Projects and Experience** are drafted as JSON in the dashboard for convenience, but the public page still reads those sections directly from `index.html`. If you want them fully live-editable too, that's a bigger change (an admin repeater UI for each project/job) — happy to build that next if it'd help; for now, edit the JSON draft in the dashboard, then send it back to Claude to apply to the page directly.

## Security notes

- The anon key is meant to be public — it's safe to leave in the HTML. Row Level Security (the policies in `supabase-schema.sql`) is what actually protects the data: anyone can read, only a signed-in user can write.
- There's no public sign-up page, so the only way to get an account is you creating it manually in the Supabase dashboard.
- If you ever need to revoke access, delete the user in **Authentication → Users**.

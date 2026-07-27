-- Run this in Supabase → SQL Editor (one time setup)

create table if not exists site_content (
  id text primary key default 'main',
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz default now()
);

-- Seed the single content row the site reads from.
insert into site_content (id, data)
values ('main', '{
  "heroSub": "Final-year <strong>ECE</strong> engineer building machines for the real world — from KiCad schematic to deployed firmware.",
  "aboutLead": "I''m a final-year B.Tech Electronics & Communication Engineering student at Christ College of Engineering (KTU). My depth is in <strong>embedded systems</strong> — schematic capture and PCB layout in KiCad, tight C++ firmware for ESP32, Raspberry Pi Pico W, and TIVA C, and full IoT pipeline design from sensor node to cloud endpoint.",
  "stats": [
    {"num":"7+","label":"Institutions Trained"},
    {"num":"100+","label":"Students / Session"},
    {"num":"3","label":"Hackathon Wins"},
    {"num":"4","label":"Internships Shipped"}
  ]
}'::jsonb)
on conflict (id) do nothing;

alter table site_content enable row level security;

-- Anyone (including anonymous visitors) can read the content — needed for the public site to render it.
create policy "Public can read site content"
  on site_content for select
  using (true);

-- Only a signed-in user can update it — this is what the admin dashboard uses.
create policy "Authenticated users can update site content"
  on site_content for update
  using (auth.role() = 'authenticated');

-- Only a signed-in user can insert (covers the dashboard's upsert on first save).
create policy "Authenticated users can insert site content"
  on site_content for insert
  with check (auth.role() = 'authenticated');

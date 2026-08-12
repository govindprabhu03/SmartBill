-- SmartBill schema. Run in Supabase SQL editor.
create table if not exists public.expenses (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  store text,
  purchased_on date not null default current_date,
  items jsonb default '[]'::jsonb,
  amount numeric(12,2) not null default 0,
  tax numeric(12,2) default 0,
  category text default 'Other',
  raw_text text,
  created_at timestamptz default now()
);

alter table public.expenses enable row level security;

create policy "own rows - select" on public.expenses
  for select using (auth.uid() = user_id);
create policy "own rows - insert" on public.expenses
  for insert with check (auth.uid() = user_id);
create policy "own rows - update" on public.expenses
  for update using (auth.uid() = user_id);
create policy "own rows - delete" on public.expenses
  for delete using (auth.uid() = user_id);

create index if not exists expenses_user_date_idx
  on public.expenses (user_id, purchased_on desc);

-- 专属工作台 · Supabase 云端同步表结构
-- 在 Supabase 控制台的 SQL Editor 中执行本文件即可创建所需数据表。
-- 说明：本应用用「同步口令(owner)」区分不同用户的数据；为简化个人使用，
--       下面直接关闭了行级安全(RLS)。这意味着任何拿到 URL+AnonKey+口令 的人
--       都能读写对应数据——请使用足够随机的口令，且数据仅限个人非敏感内容。
--       若需更严格隔离，可改为开启 RLS 并编写按 owner 过滤的策略。

create extension if not exists "pgcrypto";

create table if not exists todos (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  due_date date,
  priority text default 'normal',
  status text default 'open',
  created_at timestamptz default now(),
  done_at timestamptz,
  owner text not null
);

create table if not exists books (
  id uuid primary key default gen_random_uuid(),
  type text not null,
  category text,
  amount numeric not null,
  note text,
  date date,
  created_at timestamptz default now(),
  owner text not null
);

create table if not exists edu_records (
  id uuid primary key default gen_random_uuid(),
  kind text default 'study',
  content text not null,
  minutes integer,
  date date,
  created_at timestamptz default now(),
  owner text not null
);

create table if not exists edu_progress (
  id integer primary key default 1,
  level integer default 0,
  chars integer default 0,
  owner text not null
);

create table if not exists watchlist (
  id uuid primary key default gen_random_uuid(),
  list_type text not null,
  code text not null,
  market integer,
  name text,
  cost numeric,
  note text,
  owner text not null
);

create table if not exists etf_advice (
  id uuid primary key default gen_random_uuid(),
  content text not null,
  advice_date date,
  owner text not null
);

create table if not exists used_keys (
  id uuid primary key default gen_random_uuid(),
  k text not null,
  owner text not null
);

create table if not exists habits (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  emoji text,
  color text,
  created_at timestamptz default now(),
  owner text not null
);

create table if not exists habit_logs (
  id uuid primary key default gen_random_uuid(),
  habit_id uuid,
  date date,
  created_at timestamptz default now(),
  owner text not null
);

-- 索引
create index if not exists idx_todos_owner on todos(owner);
create index if not exists idx_books_owner on books(owner);
create index if not exists idx_edu_owner on edu_records(owner);
create index if not exists idx_watchlist_owner on watchlist(owner);
create index if not exists idx_etf_advice_owner on etf_advice(owner);
create index if not exists idx_used_keys_owner on used_keys(owner);
create index if not exists idx_habits_owner on habits(owner);
create index if not exists idx_habit_logs_owner on habit_logs(owner);

-- 个人使用：关闭 RLS（如需更安全请改为开启并编写 owner 策略）
alter table todos disable row level security;
alter table books disable row level security;
alter table edu_records disable row level security;
alter table edu_progress disable row level security;
alter table watchlist disable row level security;
alter table etf_advice disable row level security;
alter table used_keys disable row level security;
alter table habits disable row level security;
alter table habit_logs disable row level security;

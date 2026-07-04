-- W杯2026 トーナメント＆ベッティング用テーブル
create table if not exists wc26_state (
  id text primary key default 'main',
  bracket jsonb not null,
  bets jsonb not null default '[]'::jsonb,
  updated_at timestamptz not null default now()
);

-- 匿名キーで読み書きできるようにする（3人の友達だけが使うURLなので、
-- パスワードはアプリ側の簡易ロックで対応します）
alter table wc26_state enable row level security;

create policy "anon can read wc26_state"
  on wc26_state for select
  to anon
  using (true);

create policy "anon can upsert wc26_state"
  on wc26_state for insert
  to anon
  with check (true);

create policy "anon can update wc26_state"
  on wc26_state for update
  to anon
  using (true);

-- 初期データを1行だけ入れておく
insert into wc26_state (id, bracket, bets)
values ('main', '{}'::jsonb, '[]'::jsonb)
on conflict (id) do nothing;

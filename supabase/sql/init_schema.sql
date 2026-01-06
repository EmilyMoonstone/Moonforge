-- ============================================================
-- 001_schema.sql — D&D 5e 2024 Campaign Manager (Supabase)
-- New database schema (Postgres / Supabase)
-- Safe to re-run: CREATE IF NOT EXISTS, OR REPLACE, DROP TRIGGER IF EXISTS
-- ============================================================

-- Extensions
create extension if not exists pgcrypto;

-- ============================================================
-- Timestamps helper
-- ============================================================
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end $$;

-- Prevent changing immutable created_by on campaigns
create or replace function public.prevent_campaign_created_by_change()
returns trigger
language plpgsql
as $$
begin
  if (tg_op = 'UPDATE') and (new.created_by is distinct from old.created_by) then
    raise exception 'created_by is immutable';
  end if;
  return new;
end $$;

-- ============================================================
-- Core hierarchy: campaigns -> chapters -> adventures -> scenes
-- ============================================================
create table if not exists public.campaigns (
  id uuid primary key default gen_random_uuid(),
  created_by uuid not null references auth.users(id) on delete cascade,

  title text not null,
  description text,
  icon text,
  title_image text,
  content jsonb not null default '{}'::jsonb,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

drop trigger if exists set_campaigns_updated_at on public.campaigns;
create trigger set_campaigns_updated_at
before update on public.campaigns
for each row execute function public.set_updated_at();

drop trigger if exists prevent_campaign_created_by_change_trigger on public.campaigns;
create trigger prevent_campaign_created_by_change_trigger
before update of created_by on public.campaigns
for each row execute function public.prevent_campaign_created_by_change();


create table if not exists public.chapters (
  id uuid primary key default gen_random_uuid(),
  campaign_id uuid not null references public.campaigns(id) on delete cascade,

  title text not null,
  description text,
  content jsonb not null default '{}'::jsonb,

  -- e.g. "1"
  order_number int not null,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists chapters_campaign_id_idx on public.chapters(campaign_id);

drop trigger if exists set_chapters_updated_at on public.chapters;
create trigger set_chapters_updated_at
before update on public.chapters
for each row execute function public.set_updated_at();


create table if not exists public.adventures (
  id uuid primary key default gen_random_uuid(),
  chapter_id uuid not null references public.chapters(id) on delete cascade,

  -- denormalized for PowerSync / RLS simplicity
  campaign_id uuid not null references public.campaigns(id) on delete cascade,

  title text not null,
  description text,
  content jsonb not null default '{}'::jsonb,

  -- e.g. "1.1"
  order_number int not null,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists adventures_chapter_id_idx on public.adventures(chapter_id);
create index if not exists adventures_campaign_id_idx on public.adventures(campaign_id);

drop trigger if exists set_adventures_updated_at on public.adventures;
create trigger set_adventures_updated_at
before update on public.adventures
for each row execute function public.set_updated_at();


create table if not exists public.scenes (
  id uuid primary key default gen_random_uuid(),
  adventure_id uuid not null references public.adventures(id) on delete cascade,

  -- denormalized for PowerSync / RLS simplicity
  campaign_id uuid not null references public.campaigns(id) on delete cascade,

  title text not null,
  description text,
  content jsonb not null default '{}'::jsonb,

  -- e.g. "1.1.1"
  order_number int not null,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists scenes_adventure_id_idx on public.scenes(adventure_id);
create index if not exists scenes_campaign_id_idx on public.scenes(campaign_id);

drop trigger if exists set_scenes_updated_at on public.scenes;
create trigger set_scenes_updated_at
before update on public.scenes
for each row execute function public.set_updated_at();

-- ============================================================
-- Content scopes (campaign/chapter/adventure/scene) for attaching entities
-- ============================================================
create table if not exists public.content_scopes (
  id uuid primary key default gen_random_uuid(),

  scope_type text not null check (scope_type in ('campaign','chapter','adventure','scene')),

  -- denormalized for PowerSync / RLS simplicity
  campaign_id uuid not null references public.campaigns(id) on delete cascade,

  chapter_id uuid references public.chapters(id) on delete cascade,
  adventure_id uuid references public.adventures(id) on delete cascade,
  scene_id uuid references public.scenes(id) on delete cascade,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  -- ensure “exactly one target id” matches scope_type
  constraint content_scopes_one_target check (
    (scope_type = 'campaign'  and chapter_id is null and adventure_id is null and scene_id is null)
    or
    (scope_type = 'chapter'   and chapter_id is not null and adventure_id is null and scene_id is null)
    or
    (scope_type = 'adventure' and chapter_id is null and adventure_id is not null and scene_id is null)
    or
    (scope_type = 'scene'     and chapter_id is null and adventure_id is null and scene_id is not null)
  )
);

-- one scope row per node
create unique index if not exists content_scopes_unique_campaign_scope
  on public.content_scopes(campaign_id)
  where scope_type = 'campaign';

create unique index if not exists content_scopes_unique_chapter_scope
  on public.content_scopes(chapter_id)
  where scope_type = 'chapter';

create unique index if not exists content_scopes_unique_adventure_scope
  on public.content_scopes(adventure_id)
  where scope_type = 'adventure';

create unique index if not exists content_scopes_unique_scene_scope
  on public.content_scopes(scene_id)
  where scope_type = 'scene';

create index if not exists content_scopes_campaign_id_idx on public.content_scopes(campaign_id);

drop trigger if exists set_content_scopes_updated_at on public.content_scopes;
create trigger set_content_scopes_updated_at
before update on public.content_scopes
for each row execute function public.set_updated_at();

-- ============================================================
-- Maps (campaign 1-n map)
-- ============================================================
create table if not exists public.maps (
  id uuid primary key default gen_random_uuid(),
  campaign_id uuid not null references public.campaigns(id) on delete cascade,

  title text not null,
  description text,
  image text,

  -- store anything: url, storage path, pins, layer config, etc.
  data jsonb not null default '{}'::jsonb,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists maps_campaign_id_idx on public.maps(campaign_id);

drop trigger if exists set_maps_updated_at on public.maps;
create trigger set_maps_updated_at
before update on public.maps
for each row execute function public.set_updated_at();

-- ============================================================
-- organizations, locations, items, creatures, encounters
-- Each belongs to a scope (scope_id) and has denormalized campaign_id
-- ============================================================
create table if not exists public.organizations (
  id uuid primary key default gen_random_uuid(),
  scope_id uuid not null references public.content_scopes(id) on delete cascade,
  campaign_id uuid not null references public.campaigns(id) on delete cascade,

  name text not null,
  avatar text,
  type text not null, -- e.g. faction/family/guild/cult/...
  description text,
  content jsonb not null default '{}'::jsonb,

  -- organization 1-1 location (HQ)
  hq_location_id uuid unique,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists organizations_scope_id_idx on public.organizations(scope_id);
create index if not exists organizations_campaign_id_idx on public.organizations(campaign_id);

drop trigger if exists set_organizations_updated_at on public.organizations;
create trigger set_organizations_updated_at
before update on public.organizations
for each row execute function public.set_updated_at();


create table if not exists public.locations (
  id uuid primary key default gen_random_uuid(),
  scope_id uuid not null references public.content_scopes(id) on delete cascade,
  campaign_id uuid not null references public.campaigns(id) on delete cascade,

  name text not null,
  description text,
  content jsonb not null default '{}'::jsonb,

  -- arbitrary: coordinates, tags, parent-child structure, etc.
  data jsonb not null default '{}'::jsonb,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists locations_scope_id_idx on public.locations(scope_id);
create index if not exists locations_campaign_id_idx on public.locations(campaign_id);

drop trigger if exists set_locations_updated_at on public.locations;
create trigger set_locations_updated_at
before update on public.locations
for each row execute function public.set_updated_at();


-- add FK after both tables exist (org.hq_location_id -> locations.id)
do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'organizations_hq_location_fk'
  ) then
    alter table public.organizations
      add constraint organizations_hq_location_fk
      foreign key (hq_location_id) references public.locations(id) on delete set null;
  end if;
end $$;


create table if not exists public.items (
  id uuid primary key default gen_random_uuid(),
  scope_id uuid not null references public.content_scopes(id) on delete cascade,
  campaign_id uuid not null references public.campaigns(id) on delete cascade,

  name text not null,
  type text,            -- weapon/armor/consumable/treasure/quest/...
  rarity text,          -- common/uncommon/rare/...
  attunement boolean not null default false,

  description text,
  image text,
  content jsonb not null default '{}'::jsonb,

  -- store DDB / homebrew item structure here
  data jsonb not null default '{}'::jsonb,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists items_scope_id_idx on public.items(scope_id);
create index if not exists items_campaign_id_idx on public.items(campaign_id);

drop trigger if exists set_items_updated_at on public.items;
create trigger set_items_updated_at
before update on public.items
for each row execute function public.set_updated_at();


create table if not exists public.creatures (
  id uuid primary key default gen_random_uuid(),
  scope_id uuid not null references public.content_scopes(id) on delete cascade,
  campaign_id uuid not null references public.campaigns(id) on delete cascade,

  -- organization 1-n creature
  organization_id uuid references public.organizations(id) on delete set null,

  name text not null,

  -- npc/creature
  kind text not null check (kind in ('npc','creature')),

  -- common SRD / DDB-ish fields
  source text,
  size text,
  creature_type text,
  subtype text,
  alignment text,

  challenge_rating int,
  experience_points int,

  armor_class int,
  hit_points int,
  hit_dice text,

  speed jsonb not null default '{}'::jsonb,
  ability_scores jsonb not null default '{}'::jsonb,
  saving_throws jsonb not null default '{}'::jsonb,
  skills jsonb not null default '{}'::jsonb,
  senses jsonb not null default '{}'::jsonb,
  languages jsonb not null default '{}'::jsonb,
  damage_resistances jsonb not null default '[]'::jsonb,
  damage_immunities jsonb not null default '[]'::jsonb,
  condition_immunities jsonb not null default '[]'::jsonb,

  traits jsonb not null default '[]'::jsonb,
  actions jsonb not null default '[]'::jsonb,
  reactions jsonb not null default '[]'::jsonb,
  legendary_actions jsonb not null default '[]'::jsonb,
  spellcasting jsonb not null default '{}'::jsonb,

  description text,
  content jsonb not null default '{}'::jsonb,

  -- keep the original JSON as-is (e.g. from DDB / 5e.tools / other SRD sources)
  raw jsonb not null default '{}'::jsonb,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists creatures_scope_id_idx on public.creatures(scope_id);
create index if not exists creatures_campaign_id_idx on public.creatures(campaign_id);
create index if not exists creatures_organization_id_idx on public.creatures(organization_id);

drop trigger if exists set_creatures_updated_at on public.creatures;
create trigger set_creatures_updated_at
before update on public.creatures
for each row execute function public.set_updated_at();

-- drop dependent views before altering columns (recreate via init_views.sql)
drop view if exists public.v_encounter_expanded_with_path;
drop view if exists public.v_encounter_with_path;
drop view if exists public.v_creature_with_path;
drop view if exists public.v_item_with_path;
drop view if exists public.v_location_with_path;
drop view if exists public.v_organization_with_path;
drop view if exists public.v_campaign_encounters;
drop view if exists public.v_campaign_creatures;
drop view if exists public.v_campaign_items;
drop view if exists public.v_campaign_locations;
drop view if exists public.v_campaign_organizations;
drop view if exists public.v_campaign_outline;
drop view if exists public.v_scope_campaign;
drop view if exists public.v_scope_path;
drop view if exists public.v_group_dashboard;
drop view if exists public.v_character_quick;

-- add image path columns if missing
alter table public.campaigns
  add column if not exists icon text,
  add column if not exists title_image text;

alter table public.maps
  add column if not exists image text;

alter table public.organizations
  add column if not exists avatar text;

alter table public.items
  add column if not exists image text;

alter table public.creatures
  add column if not exists avatar text;

alter table public.characters
  add column if not exists avatar text;

alter table public.characters
  drop column if exists avatar_url;

-- migrate order_number columns if tables already exist
do $$
begin
  if exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'chapters'
      and column_name = 'order_number'
      and data_type <> 'integer'
  ) then
    alter table public.chapters
      alter column order_number type int
      using nullif(regexp_replace(order_number, '^.*\\.', ''), '')::int;
  end if;

  if exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'adventures'
      and column_name = 'order_number'
      and data_type <> 'integer'
  ) then
    alter table public.adventures
      alter column order_number type int
      using nullif(regexp_replace(order_number, '^.*\\.', ''), '')::int;
  end if;

  if exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'scenes'
      and column_name = 'order_number'
      and data_type <> 'integer'
  ) then
    alter table public.scenes
      alter column order_number type int
      using nullif(regexp_replace(order_number, '^.*\\.', ''), '')::int;
  end if;
end $$;

-- migrate challenge_rating columns if creatures already exists
do $$
begin
  if exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'creatures'
      and column_name = 'challenge_rating_decimal'
  ) and not exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'creatures'
      and column_name = 'challenge_rating'
  ) then
    alter table public.creatures
      rename column challenge_rating_decimal to challenge_rating;
  end if;

  if exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'creatures'
      and column_name = 'challenge_rating_text'
  ) then
    alter table public.creatures
      drop column challenge_rating_text;
  end if;

  if exists (
    select 1
    from information_schema.columns
    where table_schema = 'public'
      and table_name = 'creatures'
      and column_name = 'challenge_rating'
      and data_type <> 'integer'
  ) then
    alter table public.creatures
      alter column challenge_rating type int
      using round(challenge_rating);
  end if;
end $$;


create table if not exists public.encounters (
  id uuid primary key default gen_random_uuid(),
  scope_id uuid not null references public.content_scopes(id) on delete cascade,
  campaign_id uuid not null references public.campaigns(id) on delete cascade,

  title text not null,
  description text,
  content jsonb not null default '{}'::jsonb,

  -- initiative order, terrain, xp budget, etc.
  data jsonb not null default '{}'::jsonb,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists encounters_scope_id_idx on public.encounters(scope_id);
create index if not exists encounters_campaign_id_idx on public.encounters(campaign_id);

drop trigger if exists set_encounters_updated_at on public.encounters;
create trigger set_encounters_updated_at
before update on public.encounters
for each row execute function public.set_updated_at();


-- join table: encounter 1-n creature instances
-- (surrogate id makes PowerSync/client-side easier)
create table if not exists public.encounter_creatures (
  id uuid primary key default gen_random_uuid(),

  encounter_id uuid not null references public.encounters(id) on delete cascade,
  creature_id uuid not null references public.creatures(id) on delete restrict,

  campaign_id uuid not null references public.campaigns(id) on delete cascade,

  quantity int not null default 1,
  initiative int,
  notes text,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  unique (encounter_id, creature_id)
);

create index if not exists encounter_creatures_encounter_id_idx on public.encounter_creatures(encounter_id);
create index if not exists encounter_creatures_creature_id_idx on public.encounter_creatures(creature_id);
create index if not exists encounter_creatures_campaign_id_idx on public.encounter_creatures(campaign_id);

drop trigger if exists set_encounter_creatures_updated_at on public.encounter_creatures;
create trigger set_encounter_creatures_updated_at
before update on public.encounter_creatures
for each row execute function public.set_updated_at();

-- ============================================================
-- Groups, characters, session logs
-- ============================================================
create table if not exists public.groups (
  id uuid primary key default gen_random_uuid(),

  name text not null,
  description text,

  -- group 1-1 dungeonMaster (a user)
  dungeon_master_user_id uuid not null references auth.users(id) on delete restrict,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists groups_dm_user_id_idx on public.groups(dungeon_master_user_id);

drop trigger if exists set_groups_updated_at on public.groups;
create trigger set_groups_updated_at
before update on public.groups
for each row execute function public.set_updated_at();


-- group membership table (kept in sync via triggers)
create table if not exists public.group_members (
  id uuid primary key default gen_random_uuid(),
  group_id uuid not null references public.groups(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  role text not null check (role in ('dm','player')),

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  unique (group_id, user_id)
);

create index if not exists group_members_user_id_idx on public.group_members(user_id);
create index if not exists group_members_group_id_idx on public.group_members(group_id);

drop trigger if exists set_group_members_updated_at on public.group_members;
create trigger set_group_members_updated_at
before update on public.group_members
for each row execute function public.set_updated_at();


-- group 1-1 playingCampaign
create table if not exists public.playing_campaigns (
  group_id uuid primary key references public.groups(id) on delete cascade,
  campaign_id uuid not null references public.campaigns(id) on delete cascade,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists playing_campaigns_campaign_id_idx on public.playing_campaigns(campaign_id);

drop trigger if exists set_playing_campaigns_updated_at on public.playing_campaigns;
create trigger set_playing_campaigns_updated_at
before update on public.playing_campaigns
for each row execute function public.set_updated_at();


-- character 1-1 user; group 1-n character
create table if not exists public.characters (
  id uuid primary key default gen_random_uuid(),

  group_id uuid not null references public.groups(id) on delete cascade,
  user_id uuid not null unique references auth.users(id) on delete cascade,

  dndbeyond_character_id bigint,

  name text not null,
  avatar text,

  level int,
  armor_class int,
  hit_points int,

  race text,
  background text,
  classes jsonb not null default '[]'::jsonb,

  abilities jsonb not null default '{}'::jsonb, -- STR/DEX/CON/INT/WIS/CHA
  data jsonb not null default '{}'::jsonb,      -- anything else (skills, prof, inventory, etc.)
  content jsonb not null default '{}'::jsonb,   -- rich text notes

  dndbeyond_raw jsonb not null default '{}'::jsonb,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists characters_group_id_idx on public.characters(group_id);
create index if not exists characters_user_id_idx on public.characters(user_id);

drop trigger if exists set_characters_updated_at on public.characters;
create trigger set_characters_updated_at
before update on public.characters
for each row execute function public.set_updated_at();


create table if not exists public.session_logs (
  id uuid primary key default gen_random_uuid(),
  group_id uuid not null references public.groups(id) on delete cascade,

  session_number int,
  session_date date,
  title text,
  content jsonb not null default '{}'::jsonb,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists session_logs_group_id_idx on public.session_logs(group_id);

drop trigger if exists set_session_logs_updated_at on public.session_logs;
create trigger set_session_logs_updated_at
before update on public.session_logs
for each row execute function public.set_updated_at();

-- ============================================================
-- Campaign access (for PowerSync buckets + RLS mirroring)
-- ============================================================
create table if not exists public.campaign_access (
  id uuid primary key default gen_random_uuid(),

  campaign_id uuid not null references public.campaigns(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,

  -- owner/dm/player/viewer (owner usually implied by campaigns.created_by)
  role text not null check (role in ('owner','dm','player','viewer')),

  -- who granted this (handy for auto maintenance via groups)
  source_group_id uuid references public.groups(id) on delete cascade,

  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),

  unique (campaign_id, user_id)
);

create index if not exists campaign_access_user_id_idx on public.campaign_access(user_id);
create index if not exists campaign_access_campaign_id_idx on public.campaign_access(campaign_id);
create index if not exists campaign_access_source_group_id_idx on public.campaign_access(source_group_id);

drop trigger if exists set_campaign_access_updated_at on public.campaign_access;
create trigger set_campaign_access_updated_at
before update on public.campaign_access
for each row execute function public.set_updated_at();

-- ============================================================
-- Denormalization triggers (campaign_id propagation)
-- ============================================================
create or replace function public.trg_set_adventures_campaign_id()
returns trigger
language plpgsql
as $$
begin
  select ch.campaign_id into new.campaign_id
  from public.chapters ch
  where ch.id = new.chapter_id;

  if new.campaign_id is null then
    raise exception 'Cannot resolve campaign_id for adventure (chapter_id=%)', new.chapter_id;
  end if;

  return new;
end $$;

drop trigger if exists set_adventures_campaign_id on public.adventures;
create trigger set_adventures_campaign_id
before insert or update of chapter_id
on public.adventures
for each row execute function public.trg_set_adventures_campaign_id();


create or replace function public.trg_set_scenes_campaign_id()
returns trigger
language plpgsql
as $$
begin
  select a.campaign_id into new.campaign_id
  from public.adventures a
  where a.id = new.adventure_id;

  if new.campaign_id is null then
    raise exception 'Cannot resolve campaign_id for scene (adventure_id=%)', new.adventure_id;
  end if;

  return new;
end $$;

drop trigger if exists set_scenes_campaign_id on public.scenes;
create trigger set_scenes_campaign_id
before insert or update of adventure_id
on public.scenes
for each row execute function public.trg_set_scenes_campaign_id();


create or replace function public.trg_set_content_scopes_campaign_id()
returns trigger
language plpgsql
as $$
begin
  if new.scope_type = 'campaign' then
    -- campaign_id already provided
    return new;
  elsif new.scope_type = 'chapter' then
    select ch.campaign_id into new.campaign_id
    from public.chapters ch where ch.id = new.chapter_id;
  elsif new.scope_type = 'adventure' then
    select a.campaign_id into new.campaign_id
    from public.adventures a where a.id = new.adventure_id;
  elsif new.scope_type = 'scene' then
    select s.campaign_id into new.campaign_id
    from public.scenes s where s.id = new.scene_id;
  end if;

  if new.campaign_id is null then
    raise exception 'Cannot resolve campaign_id for content_scope (type=%)', new.scope_type;
  end if;

  return new;
end $$;

drop trigger if exists set_content_scopes_campaign_id on public.content_scopes;
create trigger set_content_scopes_campaign_id
before insert or update of scope_type, campaign_id, chapter_id, adventure_id, scene_id
on public.content_scopes
for each row execute function public.trg_set_content_scopes_campaign_id();


create or replace function public.trg_set_scoped_entity_campaign_id()
returns trigger
language plpgsql
as $$
begin
  select cs.campaign_id into new.campaign_id
  from public.content_scopes cs
  where cs.id = new.scope_id;

  if new.campaign_id is null then
    raise exception 'Cannot resolve campaign_id for scoped entity (scope_id=%)', new.scope_id;
  end if;

  return new;
end $$;

drop trigger if exists set_organizations_campaign_id on public.organizations;
create trigger set_organizations_campaign_id
before insert or update of scope_id
on public.organizations
for each row execute function public.trg_set_scoped_entity_campaign_id();

drop trigger if exists set_locations_campaign_id on public.locations;
create trigger set_locations_campaign_id
before insert or update of scope_id
on public.locations
for each row execute function public.trg_set_scoped_entity_campaign_id();

drop trigger if exists set_items_campaign_id on public.items;
create trigger set_items_campaign_id
before insert or update of scope_id
on public.items
for each row execute function public.trg_set_scoped_entity_campaign_id();

drop trigger if exists set_creatures_campaign_id on public.creatures;
create trigger set_creatures_campaign_id
before insert or update of scope_id
on public.creatures
for each row execute function public.trg_set_scoped_entity_campaign_id();

drop trigger if exists set_encounters_campaign_id on public.encounters;
create trigger set_encounters_campaign_id
before insert or update of scope_id
on public.encounters
for each row execute function public.trg_set_scoped_entity_campaign_id();


create or replace function public.trg_set_encounter_creatures_campaign_id()
returns trigger
language plpgsql
as $$
begin
  select e.campaign_id into new.campaign_id
  from public.encounters e
  where e.id = new.encounter_id;

  if new.campaign_id is null then
    raise exception 'Cannot resolve campaign_id for encounter_creatures (encounter_id=%)', new.encounter_id;
  end if;

  return new;
end $$;

drop trigger if exists set_encounter_creatures_campaign_id on public.encounter_creatures;
create trigger set_encounter_creatures_campaign_id
before insert or update of encounter_id
on public.encounter_creatures
for each row execute function public.trg_set_encounter_creatures_campaign_id();

-- ============================================================
-- Auto-create content scopes for hierarchy nodes
-- ============================================================
create or replace function public.ensure_campaign_scope()
returns trigger
language plpgsql
as $$
begin
  insert into public.content_scopes (scope_type, campaign_id)
  values ('campaign', new.id)
  on conflict do nothing;
  return new;
end $$;

drop trigger if exists ensure_campaign_scope_trigger on public.campaigns;
create trigger ensure_campaign_scope_trigger
after insert on public.campaigns
for each row execute function public.ensure_campaign_scope();


create or replace function public.ensure_chapter_scope()
returns trigger
language plpgsql
as $$
begin
  insert into public.content_scopes (scope_type, campaign_id, chapter_id)
  values ('chapter', new.campaign_id, new.id)
  on conflict do nothing;
  return new;
end $$;

drop trigger if exists ensure_chapter_scope_trigger on public.chapters;
create trigger ensure_chapter_scope_trigger
after insert on public.chapters
for each row execute function public.ensure_chapter_scope();


create or replace function public.ensure_adventure_scope()
returns trigger
language plpgsql
as $$
begin
  insert into public.content_scopes (scope_type, campaign_id, adventure_id)
  values ('adventure', new.campaign_id, new.id)
  on conflict do nothing;
  return new;
end $$;

drop trigger if exists ensure_adventure_scope_trigger on public.adventures;
create trigger ensure_adventure_scope_trigger
after insert on public.adventures
for each row execute function public.ensure_adventure_scope();


create or replace function public.ensure_scene_scope()
returns trigger
language plpgsql
as $$
begin
  insert into public.content_scopes (scope_type, campaign_id, scene_id)
  values ('scene', new.campaign_id, new.id)
  on conflict do nothing;
  return new;
end $$;

drop trigger if exists ensure_scene_scope_trigger on public.scenes;
create trigger ensure_scene_scope_trigger
after insert on public.scenes
for each row execute function public.ensure_scene_scope();

-- ============================================================
-- Group membership maintenance (group_members)
-- ============================================================
create or replace function public.ensure_group_dm_membership()
returns trigger
language plpgsql
as $$
begin
  -- ensure DM membership row exists
  insert into public.group_members (group_id, user_id, role)
  values (new.id, new.dungeon_master_user_id, 'dm')
  on conflict (group_id, user_id)
  do update set role='dm', updated_at=now();

  return new;
end $$;

drop trigger if exists ensure_group_dm_membership_trigger on public.groups;
create trigger ensure_group_dm_membership_trigger
after insert on public.groups
for each row execute function public.ensure_group_dm_membership();


create or replace function public.sync_group_dm_membership_on_update()
returns trigger
language plpgsql
as $$
begin
  if new.dungeon_master_user_id is distinct from old.dungeon_master_user_id then
    -- remove old DM role row (keep if they are also a player row elsewhere)
    delete from public.group_members
    where group_id = new.id and user_id = old.dungeon_master_user_id and role = 'dm';

    -- ensure new DM row
    insert into public.group_members (group_id, user_id, role)
    values (new.id, new.dungeon_master_user_id, 'dm')
    on conflict (group_id, user_id)
    do update set role='dm', updated_at=now();
  end if;

  return new;
end $$;

drop trigger if exists sync_group_dm_membership_on_update_trigger on public.groups;
create trigger sync_group_dm_membership_on_update_trigger
after update of dungeon_master_user_id on public.groups
for each row execute function public.sync_group_dm_membership_on_update();


create or replace function public.sync_group_membership_from_character()
returns trigger
language plpgsql
as $$
begin
  if (tg_op = 'INSERT') then
    insert into public.group_members (group_id, user_id, role)
    values (new.group_id, new.user_id, 'player')
    on conflict (group_id, user_id)
    do update set role = greatest(excluded.role, public.group_members.role), updated_at=now();
    return new;
  elsif (tg_op = 'UPDATE') then
    if (new.group_id is distinct from old.group_id) or (new.user_id is distinct from old.user_id) then
      delete from public.group_members
      where group_id = old.group_id and user_id = old.user_id and role = 'player';

      insert into public.group_members (group_id, user_id, role)
      values (new.group_id, new.user_id, 'player')
      on conflict (group_id, user_id)
      do update set role = greatest(excluded.role, public.group_members.role), updated_at=now();
    end if;
    return new;
  elsif (tg_op = 'DELETE') then
    delete from public.group_members
    where group_id = old.group_id and user_id = old.user_id and role = 'player';
    return old;
  end if;

  return null;
end $$;

drop trigger if exists sync_group_membership_from_character_trigger on public.characters;
create trigger sync_group_membership_from_character_trigger
after insert or update of group_id, user_id or delete
on public.characters
for each row execute function public.sync_group_membership_from_character();

-- ============================================================
-- Campaign access auto-refresh for groups that play a campaign
-- (keeps campaign_access in sync with group_members + playing_campaigns)
-- ============================================================
create or replace function public.refresh_campaign_access_for_group(p_group_id uuid)
returns void
language plpgsql
as $$
declare
  cid uuid;
begin
  select campaign_id into cid
  from public.playing_campaigns
  where group_id = p_group_id;

  if cid is null then
    return;
  end if;

  -- rebuild "source_group_id = group" access for this campaign
  delete from public.campaign_access
  where source_group_id = p_group_id
    and campaign_id = cid;

  insert into public.campaign_access (campaign_id, user_id, role, source_group_id)
  select
    cid,
    gm.user_id,
    case when gm.role = 'dm' then 'dm' else 'player' end,
    p_group_id
  from public.group_members gm
  where gm.group_id = p_group_id
  on conflict (campaign_id, user_id) do update
    set role = excluded.role,
        source_group_id = excluded.source_group_id,
        updated_at = now();
end $$;

create or replace function public.trg_refresh_campaign_access_on_group_members_change()
returns trigger
language plpgsql
as $$
declare
  gid uuid;
begin
  gid := coalesce(new.group_id, old.group_id);
  perform public.refresh_campaign_access_for_group(gid);
  return coalesce(new, old);
end $$;

drop trigger if exists refresh_campaign_access_on_group_members_change_trigger on public.group_members;
create trigger refresh_campaign_access_on_group_members_change_trigger
after insert or update or delete
on public.group_members
for each row execute function public.trg_refresh_campaign_access_on_group_members_change();


create or replace function public.trg_refresh_campaign_access_on_playing_campaign_change()
returns trigger
language plpgsql
as $$
begin
  if tg_op = 'INSERT' then
    perform public.refresh_campaign_access_for_group(new.group_id);
    return new;
  elsif tg_op = 'UPDATE' then
    if new.campaign_id is distinct from old.campaign_id then
      delete from public.campaign_access
      where source_group_id = new.group_id
        and campaign_id = old.campaign_id;
    end if;
    perform public.refresh_campaign_access_for_group(new.group_id);
    return new;
  elsif tg_op = 'DELETE' then
    delete from public.campaign_access
    where source_group_id = old.group_id
      and campaign_id = old.campaign_id;
    return old;
  end if;

  return null;
end $$;

drop trigger if exists refresh_campaign_access_on_playing_campaign_change_trigger on public.playing_campaigns;
create trigger refresh_campaign_access_on_playing_campaign_change_trigger
after insert or update or delete
on public.playing_campaigns
for each row execute function public.trg_refresh_campaign_access_on_playing_campaign_change();

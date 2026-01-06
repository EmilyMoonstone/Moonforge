-- ============================================================
-- 003_rls.sql — Row Level Security + view grants
-- Run after 001_schema.sql and 002_views.sql
-- ============================================================

-- Enable + FORCE RLS on all app tables
do $$
declare t text;
begin
  foreach t in array array[
    'campaigns','chapters','adventures','scenes',
    'content_scopes','maps',
    'organizations','locations','items','creatures',
    'encounters','encounter_creatures',
    'groups','group_members','playing_campaigns','characters','session_logs',
    'campaign_access'
  ]
  loop
    if exists (
      select 1
      from information_schema.tables
      where table_schema='public' and table_name=t
    ) then
      execute format('alter table public.%I enable row level security;', t);
      execute format('alter table public.%I force row level security;', t);
    end if;
  end loop;
end $$;

-- ============================================================
-- Storage buckets (profile_pictures, images)
-- ============================================================

-- profile_pictures: public read, authenticated create, owner edit
drop policy if exists "profile_pictures_select_public" on storage.objects;
create policy "profile_pictures_select_public"
on storage.objects
for select
to public
using (bucket_id = 'profile_pictures');

drop policy if exists "profile_pictures_insert_authenticated" on storage.objects;
create policy "profile_pictures_insert_authenticated"
on storage.objects
for insert
to authenticated
with check (bucket_id = 'profile_pictures');

drop policy if exists "profile_pictures_update_owner" on storage.objects;
create policy "profile_pictures_update_owner"
on storage.objects
for update
to authenticated
using (bucket_id = 'profile_pictures' and owner_id = auth.uid()::text)
with check (bucket_id = 'profile_pictures' and owner_id = auth.uid()::text);

drop policy if exists "profile_pictures_delete_owner" on storage.objects;
create policy "profile_pictures_delete_owner"
on storage.objects
for delete
to authenticated
using (bucket_id = 'profile_pictures' and owner_id = auth.uid()::text);

-- images: campaign-scoped access (campaign_id/<type>/...)
drop policy if exists "images_select_campaign_access" on storage.objects;
create policy "images_select_campaign_access"
on storage.objects
for select
to authenticated
using (
  bucket_id = 'images'
  and (storage.foldername(name))[1] is not null
  and (storage.foldername(name))[2] in ('campaign_icons','campaign_images','campaign_maps')
  and (
    exists (
      select 1 from public.campaigns c
      where c.id::text = (storage.foldername(name))[1]
        and c.created_by = auth.uid()
    )
    or exists (
      select 1 from public.campaign_access ca
      where ca.campaign_id::text = (storage.foldername(name))[1]
        and ca.user_id = auth.uid()
    )
  )
);

drop policy if exists "images_insert_owner_or_dm" on storage.objects;
create policy "images_insert_owner_or_dm"
on storage.objects
for insert
to authenticated
with check (
  bucket_id = 'images'
  and (storage.foldername(name))[1] is not null
  and (storage.foldername(name))[2] in ('campaign_icons','campaign_images','campaign_maps')
  and (
    exists (
      select 1 from public.campaigns c
      where c.id::text = (storage.foldername(name))[1]
        and c.created_by = auth.uid()
    )
    or exists (
      select 1 from public.campaign_access ca
      where ca.campaign_id::text = (storage.foldername(name))[1]
        and ca.user_id = auth.uid()
        and ca.role in ('owner','dm')
    )
  )
);

drop policy if exists "images_update_owner_or_dm" on storage.objects;
create policy "images_update_owner_or_dm"
on storage.objects
for update
to authenticated
using (
  bucket_id = 'images'
  and (storage.foldername(name))[1] is not null
  and (storage.foldername(name))[2] in ('campaign_icons','campaign_images','campaign_maps')
  and (
    exists (
      select 1 from public.campaigns c
      where c.id::text = (storage.foldername(name))[1]
        and c.created_by = auth.uid()
    )
    or exists (
      select 1 from public.campaign_access ca
      where ca.campaign_id::text = (storage.foldername(name))[1]
        and ca.user_id = auth.uid()
        and ca.role in ('owner','dm')
    )
  )
)
with check (
  bucket_id = 'images'
  and (storage.foldername(name))[1] is not null
  and (storage.foldername(name))[2] in ('campaign_icons','campaign_images','campaign_maps')
  and (
    exists (
      select 1 from public.campaigns c
      where c.id::text = (storage.foldername(name))[1]
        and c.created_by = auth.uid()
    )
    or exists (
      select 1 from public.campaign_access ca
      where ca.campaign_id::text = (storage.foldername(name))[1]
        and ca.user_id = auth.uid()
        and ca.role in ('owner','dm')
    )
  )
);

drop policy if exists "images_delete_owner_or_dm" on storage.objects;
create policy "images_delete_owner_or_dm"
on storage.objects
for delete
to authenticated
using (
  bucket_id = 'images'
  and (storage.foldername(name))[1] is not null
  and (storage.foldername(name))[2] in ('campaign_icons','campaign_images','campaign_maps')
  and (
    exists (
      select 1 from public.campaigns c
      where c.id::text = (storage.foldername(name))[1]
        and c.created_by = auth.uid()
    )
    or exists (
      select 1 from public.campaign_access ca
      where ca.campaign_id::text = (storage.foldername(name))[1]
        and ca.user_id = auth.uid()
        and ca.role in ('owner','dm')
    )
  )
);

-- ============================================================
-- Helper: campaign access predicates (INLINE-SAFE, no recursion)
-- ============================================================

-- ------------------------------------------------------------
-- GROUPS
-- ------------------------------------------------------------
drop policy if exists "groups_select_member_or_dm" on public.groups;
create policy "groups_select_member_or_dm"
on public.groups
for select
to authenticated
using (
  dungeon_master_user_id = auth.uid()
  or exists (
    select 1 from public.group_members gm
    where gm.group_id = groups.id
      and gm.user_id = auth.uid()
  )
);

drop policy if exists "groups_insert_self_dm" on public.groups;
create policy "groups_insert_self_dm"
on public.groups
for insert
to authenticated
with check (dungeon_master_user_id = auth.uid());

drop policy if exists "groups_update_dm" on public.groups;
create policy "groups_update_dm"
on public.groups
for update
to authenticated
using (dungeon_master_user_id = auth.uid())
with check (true);

drop policy if exists "groups_delete_dm" on public.groups;
create policy "groups_delete_dm"
on public.groups
for delete
to authenticated
using (dungeon_master_user_id = auth.uid());

-- ------------------------------------------------------------
-- GROUP_MEMBERS (each user sees only their membership rows)
-- (DM can see the group row itself; party lists should come from characters)
-- ------------------------------------------------------------
drop policy if exists "group_members_select_own" on public.group_members;
create policy "group_members_select_own"
on public.group_members
for select
to authenticated
using (user_id = auth.uid());

drop policy if exists "group_members_no_write_from_clients" on public.group_members;
create policy "group_members_no_write_from_clients"
on public.group_members
for all
to authenticated
using (false)
with check (false);

-- ------------------------------------------------------------
-- PLAYING_CAMPAIGNS
-- ------------------------------------------------------------
drop policy if exists "playing_campaigns_select_member_or_dm" on public.playing_campaigns;
create policy "playing_campaigns_select_member_or_dm"
on public.playing_campaigns
for select
to authenticated
using (
  exists (
    select 1 from public.groups g
    where g.id = playing_campaigns.group_id
      and g.dungeon_master_user_id = auth.uid()
  )
  or exists (
    select 1 from public.group_members gm
    where gm.group_id = playing_campaigns.group_id
      and gm.user_id = auth.uid()
  )
);

drop policy if exists "playing_campaigns_write_dm" on public.playing_campaigns;
create policy "playing_campaigns_write_dm"
on public.playing_campaigns
for all
to authenticated
using (
  exists (
    select 1 from public.groups g
    where g.id = playing_campaigns.group_id
      and g.dungeon_master_user_id = auth.uid()
  )
)
with check (
  exists (
    select 1 from public.groups g
    where g.id = playing_campaigns.group_id
      and g.dungeon_master_user_id = auth.uid()
  )
);

-- ------------------------------------------------------------
-- CHARACTERS
-- ------------------------------------------------------------
drop policy if exists "characters_select_own_or_dm" on public.characters;
create policy "characters_select_own_or_dm"
on public.characters
for select
to authenticated
using (
  user_id = auth.uid()
  or exists (
    select 1 from public.groups g
    where g.id = characters.group_id
      and g.dungeon_master_user_id = auth.uid()
  )
);

drop policy if exists "characters_insert_dm" on public.characters;
create policy "characters_insert_dm"
on public.characters
for insert
to authenticated
with check (
  exists (
    select 1 from public.groups g
    where g.id = characters.group_id
      and g.dungeon_master_user_id = auth.uid()
  )
);

drop policy if exists "characters_update_owner_or_dm" on public.characters;
create policy "characters_update_owner_or_dm"
on public.characters
for update
to authenticated
using (
  user_id = auth.uid()
  or exists (
    select 1 from public.groups g
    where g.id = characters.group_id
      and g.dungeon_master_user_id = auth.uid()
  )
)
with check (
  user_id = auth.uid()
  or exists (
    select 1 from public.groups g
    where g.id = characters.group_id
      and g.dungeon_master_user_id = auth.uid()
  )
);

drop policy if exists "characters_delete_dm" on public.characters;
create policy "characters_delete_dm"
on public.characters
for delete
to authenticated
using (
  exists (
    select 1 from public.groups g
    where g.id = characters.group_id
      and g.dungeon_master_user_id = auth.uid()
  )
);

-- ------------------------------------------------------------
-- SESSION LOGS
-- ------------------------------------------------------------
drop policy if exists "session_logs_select_member_or_dm" on public.session_logs;
create policy "session_logs_select_member_or_dm"
on public.session_logs
for select
to authenticated
using (
  exists (
    select 1 from public.groups g
    where g.id = session_logs.group_id
      and g.dungeon_master_user_id = auth.uid()
  )
  or exists (
    select 1 from public.group_members gm
    where gm.group_id = session_logs.group_id
      and gm.user_id = auth.uid()
  )
);

drop policy if exists "session_logs_write_dm" on public.session_logs;
create policy "session_logs_write_dm"
on public.session_logs
for all
to authenticated
using (
  exists (
    select 1 from public.groups g
    where g.id = session_logs.group_id
      and g.dungeon_master_user_id = auth.uid()
  )
)
with check (
  exists (
    select 1 from public.groups g
    where g.id = session_logs.group_id
      and g.dungeon_master_user_id = auth.uid()
  )
);

-- ============================================================
-- CAMPAIGNS + CAMPAIGN_ACCESS
-- ============================================================

-- Campaigns: owner or shared via campaign_access
drop policy if exists "campaigns_select_owner_or_shared" on public.campaigns;
create policy "campaigns_select_owner_or_shared"
on public.campaigns
for select
to authenticated
using (
  created_by = auth.uid()
  or exists (
    select 1
    from public.campaign_access ca
    where ca.campaign_id = campaigns.id
      and ca.user_id = auth.uid()
  )
);

drop policy if exists "campaigns_insert_owner" on public.campaigns;
create policy "campaigns_insert_owner"
on public.campaigns
for insert
to authenticated
with check (created_by = auth.uid());

-- Update: owner or (dm/owner) in campaign_access
drop policy if exists "campaigns_update_owner_or_dm" on public.campaigns;
create policy "campaigns_update_owner_or_dm"
on public.campaigns
for update
to authenticated
using (
  created_by = auth.uid()
  or exists (
    select 1 from public.campaign_access ca
    where ca.campaign_id = campaigns.id
      and ca.user_id = auth.uid()
      and ca.role in ('owner','dm')
  )
)
with check (
  created_by = auth.uid()
  or exists (
    select 1 from public.campaign_access ca
    where ca.campaign_id = campaigns.id
      and ca.user_id = auth.uid()
      and ca.role in ('owner','dm')
  )
);

drop policy if exists "campaigns_delete_owner" on public.campaigns;
create policy "campaigns_delete_owner"
on public.campaigns
for delete
to authenticated
using (created_by = auth.uid());

-- campaign_access: clients can only read their own rows; writes via service role / backend
drop policy if exists "campaign_access_select_own" on public.campaign_access;
create policy "campaign_access_select_own"
on public.campaign_access
for select
to authenticated
using (user_id = auth.uid());

drop policy if exists "campaign_access_no_write_from_clients" on public.campaign_access;
create policy "campaign_access_no_write_from_clients"
on public.campaign_access
for all
to authenticated
using (false)
with check (false);

-- ============================================================
-- Campaign-scoped tables (chapters/adventures/scenes/scopes/maps/entities)
-- Access: owner OR campaign_access row exists
-- Edit: owner OR campaign_access.role in ('owner','dm')
-- ============================================================

-- CHAPTERS
drop policy if exists "chapters_select" on public.chapters;
create policy "chapters_select"
on public.chapters
for select
to authenticated
using (
  exists (select 1 from public.campaigns c where c.id = chapters.campaign_id and c.created_by = auth.uid())
  or exists (select 1 from public.campaign_access ca where ca.campaign_id = chapters.campaign_id and ca.user_id = auth.uid())
);

drop policy if exists "chapters_write" on public.chapters;
create policy "chapters_write"
on public.chapters
for all
to authenticated
using (
  exists (select 1 from public.campaigns c where c.id = chapters.campaign_id and c.created_by = auth.uid())
  or exists (select 1 from public.campaign_access ca where ca.campaign_id = chapters.campaign_id and ca.user_id = auth.uid() and ca.role in ('owner','dm'))
)
with check (
  exists (select 1 from public.campaigns c where c.id = chapters.campaign_id and c.created_by = auth.uid())
  or exists (select 1 from public.campaign_access ca where ca.campaign_id = chapters.campaign_id and ca.user_id = auth.uid() and ca.role in ('owner','dm'))
);

-- ADVENTURES
drop policy if exists "adventures_select" on public.adventures;
create policy "adventures_select"
on public.adventures
for select
to authenticated
using (
  exists (select 1 from public.campaigns c where c.id = adventures.campaign_id and c.created_by = auth.uid())
  or exists (select 1 from public.campaign_access ca where ca.campaign_id = adventures.campaign_id and ca.user_id = auth.uid())
);

drop policy if exists "adventures_write" on public.adventures;
create policy "adventures_write"
on public.adventures
for all
to authenticated
using (
  exists (select 1 from public.campaigns c where c.id = adventures.campaign_id and c.created_by = auth.uid())
  or exists (select 1 from public.campaign_access ca where ca.campaign_id = adventures.campaign_id and ca.user_id = auth.uid() and ca.role in ('owner','dm'))
)
with check (
  exists (select 1 from public.campaigns c where c.id = adventures.campaign_id and c.created_by = auth.uid())
  or exists (select 1 from public.campaign_access ca where ca.campaign_id = adventures.campaign_id and ca.user_id = auth.uid() and ca.role in ('owner','dm'))
);

-- SCENES
drop policy if exists "scenes_select" on public.scenes;
create policy "scenes_select"
on public.scenes
for select
to authenticated
using (
  exists (select 1 from public.campaigns c where c.id = scenes.campaign_id and c.created_by = auth.uid())
  or exists (select 1 from public.campaign_access ca where ca.campaign_id = scenes.campaign_id and ca.user_id = auth.uid())
);

drop policy if exists "scenes_write" on public.scenes;
create policy "scenes_write"
on public.scenes
for all
to authenticated
using (
  exists (select 1 from public.campaigns c where c.id = scenes.campaign_id and c.created_by = auth.uid())
  or exists (select 1 from public.campaign_access ca where ca.campaign_id = scenes.campaign_id and ca.user_id = auth.uid() and ca.role in ('owner','dm'))
)
with check (
  exists (select 1 from public.campaigns c where c.id = scenes.campaign_id and c.created_by = auth.uid())
  or exists (select 1 from public.campaign_access ca where ca.campaign_id = scenes.campaign_id and ca.user_id = auth.uid() and ca.role in ('owner','dm'))
);

-- CONTENT_SCOPES
drop policy if exists "content_scopes_select" on public.content_scopes;
create policy "content_scopes_select"
on public.content_scopes
for select
to authenticated
using (
  exists (select 1 from public.campaigns c where c.id = content_scopes.campaign_id and c.created_by = auth.uid())
  or exists (select 1 from public.campaign_access ca where ca.campaign_id = content_scopes.campaign_id and ca.user_id = auth.uid())
);

drop policy if exists "content_scopes_write" on public.content_scopes;
create policy "content_scopes_write"
on public.content_scopes
for all
to authenticated
using (
  exists (select 1 from public.campaigns c where c.id = content_scopes.campaign_id and c.created_by = auth.uid())
  or exists (select 1 from public.campaign_access ca where ca.campaign_id = content_scopes.campaign_id and ca.user_id = auth.uid() and ca.role in ('owner','dm'))
)
with check (
  exists (select 1 from public.campaigns c where c.id = content_scopes.campaign_id and c.created_by = auth.uid())
  or exists (select 1 from public.campaign_access ca where ca.campaign_id = content_scopes.campaign_id and ca.user_id = auth.uid() and ca.role in ('owner','dm'))
);

-- MAPS
drop policy if exists "maps_select" on public.maps;
create policy "maps_select"
on public.maps
for select
to authenticated
using (
  exists (select 1 from public.campaigns c where c.id = maps.campaign_id and c.created_by = auth.uid())
  or exists (select 1 from public.campaign_access ca where ca.campaign_id = maps.campaign_id and ca.user_id = auth.uid())
);

drop policy if exists "maps_write" on public.maps;
create policy "maps_write"
on public.maps
for all
to authenticated
using (
  exists (select 1 from public.campaigns c where c.id = maps.campaign_id and c.created_by = auth.uid())
  or exists (select 1 from public.campaign_access ca where ca.campaign_id = maps.campaign_id and ca.user_id = auth.uid() and ca.role in ('owner','dm'))
)
with check (
  exists (select 1 from public.campaigns c where c.id = maps.campaign_id and c.created_by = auth.uid())
  or exists (select 1 from public.campaign_access ca where ca.campaign_id = maps.campaign_id and ca.user_id = auth.uid() and ca.role in ('owner','dm'))
);

-- ORGS / LOCATIONS / ITEMS / CREATURES / ENCOUNTERS / ENCOUNTER_CREATURES
do $$
declare tbl text;
begin
  foreach tbl in array array['organizations','locations','items','creatures','encounters','encounter_creatures']
  loop
    execute format('drop policy if exists "%1$s_select" on public.%1$I;', tbl);
    execute format($pol$
      create policy "%1$s_select"
      on public.%1$I
      for select
      to authenticated
      using (
        exists (select 1 from public.campaigns c where c.id = %1$I.campaign_id and c.created_by = auth.uid())
        or exists (select 1 from public.campaign_access ca where ca.campaign_id = %1$I.campaign_id and ca.user_id = auth.uid())
      );
    $pol$, tbl);

    execute format('drop policy if exists "%1$s_write" on public.%1$I;', tbl);
    execute format($pol$
      create policy "%1$s_write"
      on public.%1$I
      for all
      to authenticated
      using (
        exists (select 1 from public.campaigns c where c.id = %1$I.campaign_id and c.created_by = auth.uid())
        or exists (select 1 from public.campaign_access ca where ca.campaign_id = %1$I.campaign_id and ca.user_id = auth.uid() and ca.role in ('owner','dm'))
      )
      with check (
        exists (select 1 from public.campaigns c where c.id = %1$I.campaign_id and c.created_by = auth.uid())
        or exists (select 1 from public.campaign_access ca where ca.campaign_id = %1$I.campaign_id and ca.user_id = auth.uid() and ca.role in ('owner','dm'))
      );
    $pol$, tbl);
  end loop;
end $$;

-- ============================================================
-- View privileges
-- (Views inherit underlying table RLS; this just grants SELECT)
-- ============================================================
do $$
declare v text;
begin
  foreach v in array array[
    'v_scope_path',
    'v_scope_campaign',
    'v_campaign_outline',
    'v_campaign_creatures',
    'v_campaign_items',
    'v_campaign_locations',
    'v_campaign_organizations',
    'v_campaign_encounters',
    'v_creature_with_path',
    'v_item_with_path',
    'v_location_with_path',
    'v_organization_with_path',
    'v_encounter_with_path',
    'v_encounter_expanded_with_path',
    'v_group_dashboard',
    'v_character_quick'
  ]
  loop
    if exists (
      select 1
      from information_schema.views
      where table_schema='public' and table_name=v
    ) then
      execute format('revoke all on public.%I from anon;', v);
      execute format('grant select on public.%I to authenticated;', v);
      begin
        execute format('alter view public.%I set (security_invoker = true);', v);
      exception when others then
        null;
      end;
    end if;
  end loop;
end $$;

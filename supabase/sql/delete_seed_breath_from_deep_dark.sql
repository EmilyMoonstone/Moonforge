-- ============================================================
-- 004_delete_seed_breath_from_deep_dark.sql — Remove seed data
-- Run anytime after the seed script if you want to remove it.
-- ============================================================

begin;

with
seed_user as (
  select 'be4b8621-b222-4a9c-8a4b-d8eac240bd4f'::uuid as user_id
),
campaigns_to_delete as (
  select c.id
  from public.campaigns c
  join seed_user su on su.user_id = c.created_by
  where c.title in (
    'Breath from the Deep Dark'
  )
),
groups_to_delete as (
  select distinct g.id
  from public.groups g
  join public.playing_campaigns pc on pc.group_id = g.id
  join campaigns_to_delete ctd on ctd.id = pc.campaign_id
),
delete_encounter_creatures as (
  delete from public.encounter_creatures
  where campaign_id in (select id from campaigns_to_delete)
  returning id
),
delete_encounters as (
  delete from public.encounters
  where campaign_id in (select id from campaigns_to_delete)
  returning id
),
delete_creatures as (
  delete from public.creatures
  where campaign_id in (select id from campaigns_to_delete)
  returning id
),
delete_items as (
  delete from public.items
  where campaign_id in (select id from campaigns_to_delete)
  returning id
),
delete_organisations as (
  delete from public.organisations
  where campaign_id in (select id from campaigns_to_delete)
  returning id
),
delete_locations as (
  delete from public.locations
  where campaign_id in (select id from campaigns_to_delete)
  returning id
),
delete_maps as (
  delete from public.maps
  where campaign_id in (select id from campaigns_to_delete)
  returning id
),
delete_content_scopes as (
  delete from public.content_scopes
  where campaign_id in (select id from campaigns_to_delete)
  returning id
),
delete_scenes as (
  delete from public.scenes
  where campaign_id in (select id from campaigns_to_delete)
  returning id
),
delete_adventures as (
  delete from public.adventures
  where campaign_id in (select id from campaigns_to_delete)
  returning id
),
delete_chapters as (
  delete from public.chapters
  where campaign_id in (select id from campaigns_to_delete)
  returning id
),
delete_campaign_access as (
  delete from public.campaign_access
  where campaign_id in (select id from campaigns_to_delete)
  returning id
),
delete_group_members as (
  delete from public.group_members
  where group_id in (select id from groups_to_delete)
  returning id
),
delete_characters as (
  delete from public.characters
  where group_id in (select id from groups_to_delete)
  returning id
),
delete_session_logs as (
  delete from public.session_logs
  where group_id in (select id from groups_to_delete)
  returning id
),
delete_playing_campaigns as (
  delete from public.playing_campaigns
  where campaign_id in (select id from campaigns_to_delete)
     or group_id in (select id from groups_to_delete)
  returning group_id
),
delete_groups as (
  delete from public.groups
  where id in (select id from groups_to_delete)
  returning id
),
delete_campaigns as (
  delete from public.campaigns
  where id in (select id from campaigns_to_delete)
  returning id
)
select
  (select count(*) from delete_campaigns) as campaigns_deleted,
  (select count(*) from delete_chapters) as chapters_deleted,
  (select count(*) from delete_adventures) as adventures_deleted,
  (select count(*) from delete_scenes) as scenes_deleted,
  (select count(*) from delete_maps) as maps_deleted,
  (select count(*) from delete_content_scopes) as content_scopes_deleted,
  (select count(*) from delete_locations) as locations_deleted,
  (select count(*) from delete_organisations) as organisations_deleted,
  (select count(*) from delete_items) as items_deleted,
  (select count(*) from delete_creatures) as creatures_deleted,
  (select count(*) from delete_encounters) as encounters_deleted,
  (select count(*) from delete_encounter_creatures) as encounter_creatures_deleted,
  (select count(*) from delete_campaign_access) as campaign_access_deleted,
  (select count(*) from delete_groups) as groups_deleted,
  (select count(*) from delete_group_members) as group_members_deleted,
  (select count(*) from delete_playing_campaigns) as playing_campaigns_deleted,
  (select count(*) from delete_characters) as characters_deleted,
  (select count(*) from delete_session_logs) as session_logs_deleted;

commit;

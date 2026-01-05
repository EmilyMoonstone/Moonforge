-- ============================================================
-- 002_views.sql — Views
-- Run after 001_schema.sql
-- ============================================================

create or replace view public.v_scope_path as
select
  cs.id as scope_id,
  cs.scope_type,
  cs.campaign_id,

  ca.title as campaign_title,

  -- resolve chapter/adventure/scene for path display
  coalesce(ch_direct.id, ch_from_adv.id, ch_from_scene.id) as chapter_id,
  coalesce(ch_direct.order_number, ch_from_adv.order_number, ch_from_scene.order_number) as chapter_order_number,
  coalesce(ch_direct.title, ch_from_adv.title, ch_from_scene.title) as chapter_title,

  coalesce(adv_direct.id, adv_from_scene.id) as adventure_id,
  coalesce(adv_direct.order_number, adv_from_scene.order_number) as adventure_order_number,
  coalesce(adv_direct.title, adv_from_scene.title) as adventure_title,

  sc_direct.id as scene_id,
  sc_direct.order_number as scene_order_number,
  sc_direct.title as scene_title,

  concat_ws(' / ',
    coalesce(ch_direct.order_number, ch_from_adv.order_number, ch_from_scene.order_number),
    coalesce(adv_direct.order_number, adv_from_scene.order_number),
    sc_direct.order_number
  ) as path_order,

  concat_ws(' › ',
    coalesce(ch_direct.title, ch_from_adv.title, ch_from_scene.title),
    coalesce(adv_direct.title, adv_from_scene.title),
    sc_direct.title
  ) as path_titles

from public.content_scopes cs
join public.campaigns ca on ca.id = cs.campaign_id

left join public.chapters ch_direct on ch_direct.id = cs.chapter_id
left join public.adventures adv_direct on adv_direct.id = cs.adventure_id
left join public.scenes sc_direct on sc_direct.id = cs.scene_id

left join public.chapters ch_from_adv on ch_from_adv.id = adv_direct.chapter_id
left join public.adventures adv_from_scene on adv_from_scene.id = sc_direct.adventure_id
left join public.chapters ch_from_scene on ch_from_scene.id = adv_from_scene.chapter_id;

create or replace view public.v_scope_campaign as
select scope_id, scope_type, campaign_id
from public.v_scope_path;

create or replace view public.v_campaign_outline as
select
  ca.id as campaign_id,
  ca.title as campaign_title,

  ch.id as chapter_id,
  ch.order_number as chapter_order_number,
  ch.title as chapter_title,

  adv.id as adventure_id,
  adv.order_number as adventure_order_number,
  adv.title as adventure_title,

  sc.id as scene_id,
  sc.order_number as scene_order_number,
  sc.title as scene_title
from public.campaigns ca
left join public.chapters ch on ch.campaign_id = ca.id
left join public.adventures adv on adv.chapter_id = ch.id
left join public.scenes sc on sc.adventure_id = adv.id;

-- Campaign-wide entity lists (fast filtering)
create or replace view public.v_campaign_creatures as
select c.* from public.creatures c;

create or replace view public.v_campaign_items as
select i.* from public.items i;

create or replace view public.v_campaign_locations as
select l.* from public.locations l;

create or replace view public.v_campaign_organisations as
select o.* from public.organisations o;

create or replace view public.v_campaign_encounters as
select e.* from public.encounters e;

-- With path (requested)
create or replace view public.v_creature_with_path as
select
  c.*,
  sp.campaign_title,
  sp.chapter_id, sp.chapter_order_number, sp.chapter_title,
  sp.adventure_id, sp.adventure_order_number, sp.adventure_title,
  sp.scene_id, sp.scene_order_number, sp.scene_title,
  sp.path_order, sp.path_titles
from public.creatures c
join public.v_scope_path sp on sp.scope_id = c.scope_id;

create or replace view public.v_item_with_path as
select
  i.*,
  sp.campaign_title,
  sp.chapter_id, sp.chapter_order_number, sp.chapter_title,
  sp.adventure_id, sp.adventure_order_number, sp.adventure_title,
  sp.scene_id, sp.scene_order_number, sp.scene_title,
  sp.path_order, sp.path_titles
from public.items i
join public.v_scope_path sp on sp.scope_id = i.scope_id;

create or replace view public.v_location_with_path as
select
  l.*,
  sp.campaign_title,
  sp.chapter_id, sp.chapter_order_number, sp.chapter_title,
  sp.adventure_id, sp.adventure_order_number, sp.adventure_title,
  sp.scene_id, sp.scene_order_number, sp.scene_title,
  sp.path_order, sp.path_titles
from public.locations l
join public.v_scope_path sp on sp.scope_id = l.scope_id;

create or replace view public.v_organisation_with_path as
select
  o.*,
  sp.campaign_title,
  sp.chapter_id, sp.chapter_order_number, sp.chapter_title,
  sp.adventure_id, sp.adventure_order_number, sp.adventure_title,
  sp.scene_id, sp.scene_order_number, sp.scene_title,
  sp.path_order, sp.path_titles
from public.organisations o
join public.v_scope_path sp on sp.scope_id = o.scope_id;

create or replace view public.v_encounter_with_path as
select
  e.*,
  sp.campaign_title,
  sp.chapter_id, sp.chapter_order_number, sp.chapter_title,
  sp.adventure_id, sp.adventure_order_number, sp.adventure_title,
  sp.scene_id, sp.scene_order_number, sp.scene_title,
  sp.path_order, sp.path_titles
from public.encounters e
join public.v_scope_path sp on sp.scope_id = e.scope_id;

create or replace view public.v_encounter_expanded_with_path as
select
  ewp.id as encounter_id,
  ewp.scope_id,
  ewp.campaign_id,
  ewp.title,
  ewp.description,
  ewp.content,
  ewp.data,
  ewp.created_at,
  ewp.updated_at,

  ewp.campaign_title,
  ewp.chapter_id, ewp.chapter_order_number, ewp.chapter_title,
  ewp.adventure_id, ewp.adventure_order_number, ewp.adventure_title,
  ewp.scene_id, ewp.scene_order_number, ewp.scene_title,
  ewp.path_order, ewp.path_titles,

  ec.id as encounter_creature_id,
  ec.creature_id,
  ec.quantity,
  ec.initiative,
  ec.notes,

  cr.name as creature_name,
  cr.kind as creature_kind,
  cr.challenge_rating as creature_cr,
  cr.armor_class as creature_ac,
  cr.hit_points as creature_hp
from public.v_encounter_with_path ewp
left join public.encounter_creatures ec on ec.encounter_id = ewp.id
left join public.creatures cr on cr.id = ec.creature_id;

create or replace view public.v_group_dashboard as
select
  g.id as group_id,
  g.name as group_name,
  g.dungeon_master_user_id,
  pc.campaign_id as playing_campaign_id,
  (select count(*) from public.characters c where c.group_id = g.id) as character_count,
  (select count(*) from public.session_logs sl where sl.group_id = g.id) as session_log_count
from public.groups g
left join public.playing_campaigns pc on pc.group_id = g.id;

create or replace view public.v_character_quick as
select
  c.id,
  c.group_id,
  c.user_id,
  c.name,
  c.avatar_url,
  c.level,
  c.armor_class,
  c.hit_points,
  c.abilities,
  c.race,
  c.classes,
  c.dndbeyond_character_id,
  c.updated_at
from public.characters c;

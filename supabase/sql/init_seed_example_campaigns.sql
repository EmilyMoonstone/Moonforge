-- ============================================================
-- 004_seed_example_campaigns.sql — Example data for one user
-- Run after 001_schema.sql (and optionally 002_views.sql / 003_rls.sql)
-- ============================================================

begin;

with
seed_user as (
  select 'be4b8621-b222-4a9c-8a4b-d8eac240bd4f'::uuid as user_id
),
campaigns as (
  insert into public.campaigns (id, created_by, title, description, content)
  select gen_random_uuid(), seed_user.user_id, v.title, v.description, v.content
  from seed_user
  cross join (values
    ('Echoes of the Astral Sea', 'A spelljammer style voyage between shattered worlds.', jsonb_build_object('tone','cosmic','theme','exploration')),
    ('Ember Crown Rebellion', 'A city-state uprising with shifting alliances.', jsonb_build_object('tone','political','theme','intrigue')),
    ('Winter of the Hollow Sun', 'A doomed frontier during the long winter.', jsonb_build_object('tone','survival','theme','mystery'))
  ) v(title, description, content)
  returning id, title
),
chapters as (
  insert into public.chapters (id, campaign_id, title, description, content, order_number)
  select gen_random_uuid(), c.id, v.title, v.description, v.content, v.order_number::int
  from campaigns c
  join (values
    ('Echoes of the Astral Sea', '1', 'Stormwake Port', 'Smugglers and starlanes.', '{}'::jsonb),
    ('Echoes of the Astral Sea', '2', 'The Shattered Ring', 'The broken asteroid fields.', '{}'::jsonb),
    ('Ember Crown Rebellion', '1', 'Ashmarket', 'Workers and guild tensions.', '{}'::jsonb),
    ('Ember Crown Rebellion', '2', 'The Red Citadel', 'Seat of the regent.', '{}'::jsonb),
    ('Winter of the Hollow Sun', '1', 'Frostmarch', 'Border fort in the snow.', '{}'::jsonb),
    ('Winter of the Hollow Sun', '2', 'The Drowned Vale', 'Frozen lake of secrets.', '{}'::jsonb)
  ) v(campaign_title, order_number, title, description, content)
  on v.campaign_title = c.title
  returning id, campaign_id, title, order_number
),
adventures as (
  insert into public.adventures (id, chapter_id, campaign_id, title, description, content, order_number)
  select gen_random_uuid(), ch.id, ch.campaign_id, v.title, v.description, v.content, v.order_number::int
  from chapters ch
  join campaigns c on c.id = ch.campaign_id
  join (values
    ('Echoes of the Astral Sea', 'Stormwake Port', '1', 'The Siren Ledger', 'A cargo log hides a route.', '{}'::jsonb),
    ('Echoes of the Astral Sea', 'The Shattered Ring', '1', 'Gravemarsh Ambush', 'Raiders among the rocks.', '{}'::jsonb),
    ('Ember Crown Rebellion', 'Ashmarket', '1', 'Spark in the Mill', 'A strike turns violent.', '{}'::jsonb),
    ('Ember Crown Rebellion', 'The Red Citadel', '1', 'Masks at Court', 'A gala of knives.', '{}'::jsonb),
    ('Winter of the Hollow Sun', 'Frostmarch', '1', 'The Lost Patrol', 'A vanished scout team.', '{}'::jsonb),
    ('Winter of the Hollow Sun', 'The Drowned Vale', '1', 'Icebound Choir', 'Voices under the ice.', '{}'::jsonb)
  ) v(campaign_title, chapter_title, order_number, title, description, content)
  on v.campaign_title = c.title and v.chapter_title = ch.title
  returning id, campaign_id, chapter_id, title, order_number
),
scenes as (
  insert into public.scenes (id, adventure_id, campaign_id, title, description, content, order_number)
  select gen_random_uuid(), adv.id, adv.campaign_id, v.title, v.description, v.content, v.order_number::int
  from adventures adv
  join campaigns c on c.id = adv.campaign_id
  join (values
    ('Echoes of the Astral Sea', 'The Siren Ledger', '1', 'Dockside Interrogation', 'A tense chat at the piers.', '{}'::jsonb),
    ('Echoes of the Astral Sea', 'Gravemarsh Ambush', '1', 'Rockfall Run', 'A chase through drifting boulders.', '{}'::jsonb),
    ('Ember Crown Rebellion', 'Spark in the Mill', '1', 'Boiler Room', 'Steam and sabotage.', '{}'::jsonb),
    ('Ember Crown Rebellion', 'Masks at Court', '1', 'Moonlit Balcony', 'A whispered bargain.', '{}'::jsonb),
    ('Winter of the Hollow Sun', 'The Lost Patrol', '1', 'Frostline Trail', 'Tracks vanish in a blizzard.', '{}'::jsonb),
    ('Winter of the Hollow Sun', 'Icebound Choir', '1', 'Under the Ice', 'Echoes beneath the lake.', '{}'::jsonb)
  ) v(campaign_title, adventure_title, order_number, title, description, content)
  on v.campaign_title = c.title and v.adventure_title = adv.title
  returning id, campaign_id, adventure_id, title, order_number
),
maps as (
  insert into public.maps (id, campaign_id, title, description, data)
  select gen_random_uuid(), c.id, v.title, v.description, v.data
  from campaigns c
  join (values
    ('Echoes of the Astral Sea', 'Astral Chart', 'Trade lanes and void currents.', jsonb_build_object('type','starfield','scale','sector')),
    ('Ember Crown Rebellion', 'City Ward Map', 'Districts and checkpoints.', jsonb_build_object('type','city','scale','ward')),
    ('Winter of the Hollow Sun', 'Frontier Map', 'Frozen passes and watchtowers.', jsonb_build_object('type','frontier','scale','region'))
  ) v(campaign_title, title, description, data)
  on v.campaign_title = c.title
  returning id, campaign_id, title
),
ensure_campaign_scopes as (
  insert into public.content_scopes (scope_type, campaign_id)
  select 'campaign', c.id
  from campaigns c
  on conflict (campaign_id) where scope_type = 'campaign'
  do update set campaign_id = excluded.campaign_id
  returning id as scope_id, campaign_id
),
ensure_chapter_scopes as (
  insert into public.content_scopes (scope_type, campaign_id, chapter_id)
  select 'chapter', ch.campaign_id, ch.id
  from chapters ch
  on conflict (chapter_id) where scope_type = 'chapter'
  do update set campaign_id = excluded.campaign_id
  returning id as scope_id, campaign_id, chapter_id
),
ensure_adventure_scopes as (
  insert into public.content_scopes (
    scope_type,
    campaign_id,
    chapter_id,
    adventure_id
  )
  select 'adventure', adv.campaign_id, adv.chapter_id, adv.id
  from adventures adv
  on conflict (adventure_id) where scope_type = 'adventure'
  do update set
    campaign_id = excluded.campaign_id,
    chapter_id = excluded.chapter_id
  returning id as scope_id, campaign_id, chapter_id, adventure_id
),
ensure_scene_scopes as (
  insert into public.content_scopes (
    scope_type,
    campaign_id,
    chapter_id,
    adventure_id,
    scene_id
  )
  select 'scene', sc.campaign_id, adv.chapter_id, sc.adventure_id, sc.id
  from scenes sc
  join adventures adv on adv.id = sc.adventure_id
  on conflict (scene_id) where scope_type = 'scene'
  do update set
    campaign_id = excluded.campaign_id,
    chapter_id = excluded.chapter_id,
    adventure_id = excluded.adventure_id
  returning id as scope_id, campaign_id, chapter_id, adventure_id, scene_id
),
campaign_map as (
  select c.id as campaign_id, lower(trim(c.title)) as campaign_key
  from campaigns c
),
chapter_map as (
  select ch.id as chapter_id, ch.campaign_id, lower(trim(ch.title)) as chapter_key
  from chapters ch
),
adventure_map as (
  select
    adv.id as adventure_id,
    adv.campaign_id,
    adv.chapter_id,
    lower(trim(adv.title)) as adventure_key
  from adventures adv
),
scene_map as (
  select
    sc.id as scene_id,
    sc.campaign_id,
    sc.adventure_id,
    adv.chapter_id,
    lower(trim(sc.title)) as scene_key
  from scenes sc
  join adventures adv on adv.id = sc.adventure_id
),
campaign_scopes as (
  select scope_id, campaign_id
  from ensure_campaign_scopes
),
chapter_scopes as (
  select scope_id, campaign_id, chapter_id
  from ensure_chapter_scopes
),
adventure_scopes as (
  select scope_id, campaign_id, adventure_id
  from ensure_adventure_scopes
),
scene_scopes as (
  select scope_id, campaign_id, scene_id
  from ensure_scene_scopes
),
locations as (
  insert into public.locations (id, scope_id, campaign_id, name, description, content, data)
  select gen_random_uuid(), cs.scope_id, cs.campaign_id, v.name, v.description, v.content, v.data
  from (values
    ('Echoes of the Astral Sea', 'Stormwake Market', 'Orbital bazaar of salvage.', '{}'::jsonb, jsonb_build_object('tags', jsonb_build_array('market','orbital'))),
    ('Ember Crown Rebellion', 'Ashmarket Plaza', 'The rallying square.', '{}'::jsonb, jsonb_build_object('tags', jsonb_build_array('plaza','riot'))),
    ('Winter of the Hollow Sun', 'Frostmarch Keep', 'Wind-scarred fortress walls.', '{}'::jsonb, jsonb_build_object('tags', jsonb_build_array('fort','snow')))
  ) v(campaign_title, name, description, content, data)
  join campaign_map cm
    on cm.campaign_key = lower(trim(v.campaign_title))
  join campaign_scopes cs
    on cs.campaign_id = cm.campaign_id
  union all
  select gen_random_uuid(), cs.scope_id, cs.campaign_id, v.name, v.description, v.content, v.data
  from (values
    ('Echoes of the Astral Sea', 'Stormwake Port', 'Stormwake Docks', 'Dockside warehouses and skiffs.', '{}'::jsonb, jsonb_build_object('tags', jsonb_build_array('docks','cargo'))),
    ('Echoes of the Astral Sea', 'The Shattered Ring', 'Ring Salvage Yard', 'Magnetic cranes and scrap.', '{}'::jsonb, jsonb_build_object('tags', jsonb_build_array('salvage','ring'))),
    ('Ember Crown Rebellion', 'Ashmarket', 'Ashmarket Foundry', 'Sooty forges and union banners.', '{}'::jsonb, jsonb_build_object('tags', jsonb_build_array('foundry','union'))),
    ('Ember Crown Rebellion', 'The Red Citadel', 'Citadel Archives', 'Cold halls of records.', '{}'::jsonb, jsonb_build_object('tags', jsonb_build_array('archives','citadel'))),
    ('Winter of the Hollow Sun', 'Frostmarch', 'Frostmarch Storehouse', 'Cold stores for supplies.', '{}'::jsonb, jsonb_build_object('tags', jsonb_build_array('supply','ice'))),
    ('Winter of the Hollow Sun', 'The Drowned Vale', 'Drowned Vale Shore', 'Ice-crusted shoreline.', '{}'::jsonb, jsonb_build_object('tags', jsonb_build_array('shore','mist')))
  ) v(campaign_title, chapter_title, name, description, content, data)
  join campaign_map cm
    on cm.campaign_key = lower(trim(v.campaign_title))
  join chapter_map chm
    on chm.campaign_id = cm.campaign_id
    and chm.chapter_key = lower(trim(v.chapter_title))
  join chapter_scopes cs
    on cs.chapter_id = chm.chapter_id
  union all
  select gen_random_uuid(), cs.scope_id, cs.campaign_id, v.name, v.description, v.content, v.data
  from (values
    ('Echoes of the Astral Sea', 'The Siren Ledger', 'Ledger Vault', 'Hidden cache beneath the port.', '{}'::jsonb, jsonb_build_object('tags', jsonb_build_array('vault','smugglers'))),
    ('Echoes of the Astral Sea', 'Gravemarsh Ambush', 'Gravemarsh Ridge', 'Loose rock and void winds.', '{}'::jsonb, jsonb_build_object('tags', jsonb_build_array('ridge','ambush'))),
    ('Ember Crown Rebellion', 'Spark in the Mill', 'Mill Gearworks', 'Grinding gears and sabotage.', '{}'::jsonb, jsonb_build_object('tags', jsonb_build_array('mill','machinery'))),
    ('Ember Crown Rebellion', 'Masks at Court', 'Gala Atrium', 'Marble floors and whispers.', '{}'::jsonb, jsonb_build_object('tags', jsonb_build_array('gala','court'))),
    ('Winter of the Hollow Sun', 'The Lost Patrol', 'Patrol Camp', 'Abandoned camp in the snow.', '{}'::jsonb, jsonb_build_object('tags', jsonb_build_array('camp','snow'))),
    ('Winter of the Hollow Sun', 'Icebound Choir', 'Frozen Choir Hall', 'A chamber of echoing ice.', '{}'::jsonb, jsonb_build_object('tags', jsonb_build_array('hall','echo')))
  ) v(campaign_title, adventure_title, name, description, content, data)
  join campaign_map cm
    on cm.campaign_key = lower(trim(v.campaign_title))
  join adventure_map am
    on am.campaign_id = cm.campaign_id
    and am.adventure_key = lower(trim(v.adventure_title))
  join adventure_scopes cs
    on cs.adventure_id = am.adventure_id
  union all
  select gen_random_uuid(), cs.scope_id, cs.campaign_id, v.name, v.description, v.content, v.data
  from (values
    ('Echoes of the Astral Sea', 'Dockside Interrogation', 'Pier 7', 'A narrow pier with watchful eyes.', '{}'::jsonb, jsonb_build_object('tags', jsonb_build_array('pier','smugglers'))),
    ('Echoes of the Astral Sea', 'Rockfall Run', 'Driftway Tunnel', 'A tunnel carved into rubble.', '{}'::jsonb, jsonb_build_object('tags', jsonb_build_array('tunnel','chase'))),
    ('Ember Crown Rebellion', 'Boiler Room', 'Boiler Catwalks', 'Hot metal walkways.', '{}'::jsonb, jsonb_build_object('tags', jsonb_build_array('catwalks','steam'))),
    ('Ember Crown Rebellion', 'Moonlit Balcony', 'Balcony Garden', 'Hedged alcoves and shadows.', '{}'::jsonb, jsonb_build_object('tags', jsonb_build_array('garden','balcony'))),
    ('Winter of the Hollow Sun', 'Frostline Trail', 'Frostline Waypost', 'A ruined waypost.', '{}'::jsonb, jsonb_build_object('tags', jsonb_build_array('waypost','blizzard'))),
    ('Winter of the Hollow Sun', 'Under the Ice', 'Ice Cavern', 'Cracked ice revealing darkness.', '{}'::jsonb, jsonb_build_object('tags', jsonb_build_array('ice','cavern')))
  ) v(campaign_title, scene_title, name, description, content, data)
  join campaign_map cm
    on cm.campaign_key = lower(trim(v.campaign_title))
  join scene_map sm
    on sm.campaign_id = cm.campaign_id
    and sm.scene_key = lower(trim(v.scene_title))
  join scene_scopes cs
    on cs.scene_id = sm.scene_id
  returning id, campaign_id, name
),
location_map as (
  select l.id as location_id, l.campaign_id, lower(trim(l.name)) as location_key
  from locations l
),
organizations as (
  insert into public.organizations (id, scope_id, campaign_id, name, type, description, content, hq_location_id)
  select gen_random_uuid(), cs.scope_id, cs.campaign_id, v.name, v.type, v.description, v.content, lm.location_id
  from (values
    ('Echoes of the Astral Sea', 'The Silver Compass', 'guild', 'Navigators who map the void.', '{}'::jsonb, 'Stormwake Market'),
    ('Ember Crown Rebellion', 'Ashmarket Union', 'faction', 'Workers pushing for reform.', '{}'::jsonb, 'Ashmarket Plaza'),
    ('Winter of the Hollow Sun', 'The Hollow Watch', 'order', 'Rangers guarding the frontier.', '{}'::jsonb, 'Frostmarch Keep')
  ) v(campaign_title, name, type, description, content, hq_location_name)
  join campaign_map cm
    on cm.campaign_key = lower(trim(v.campaign_title))
  join campaign_scopes cs
    on cs.campaign_id = cm.campaign_id
  left join location_map lm
    on lm.campaign_id = cm.campaign_id
    and lm.location_key = lower(trim(v.hq_location_name))
  union all
  select gen_random_uuid(), cs.scope_id, cs.campaign_id, v.name, v.type, v.description, v.content, lm.location_id
  from (values
    ('Echoes of the Astral Sea', 'Stormwake Port', 'Stormwake Dockers', 'guild', 'Dockworkers who control cargo.', '{}'::jsonb, 'Stormwake Docks'),
    ('Echoes of the Astral Sea', 'The Shattered Ring', 'Ring Salvagers', 'crew', 'Scavengers of the ring.', '{}'::jsonb, 'Ring Salvage Yard'),
    ('Ember Crown Rebellion', 'Ashmarket', 'Ashmarket Foremen', 'faction', 'Local bosses enforcing quotas.', '{}'::jsonb, 'Ashmarket Foundry'),
    ('Ember Crown Rebellion', 'The Red Citadel', 'Citadel Scribes', 'order', 'Keepers of the regent records.', '{}'::jsonb, 'Citadel Archives'),
    ('Winter of the Hollow Sun', 'Frostmarch', 'Frostmarch Quartermasters', 'guild', 'Supply officers and logisticians.', '{}'::jsonb, 'Frostmarch Storehouse'),
    ('Winter of the Hollow Sun', 'The Drowned Vale', 'Vale Wardens', 'order', 'Hunters of the misty shore.', '{}'::jsonb, 'Drowned Vale Shore')
  ) v(campaign_title, chapter_title, name, type, description, content, hq_location_name)
  join campaign_map cm
    on cm.campaign_key = lower(trim(v.campaign_title))
  join chapter_map chm
    on chm.campaign_id = cm.campaign_id
    and chm.chapter_key = lower(trim(v.chapter_title))
  join chapter_scopes cs
    on cs.chapter_id = chm.chapter_id
  left join location_map lm
    on lm.campaign_id = cm.campaign_id
    and lm.location_key = lower(trim(v.hq_location_name))
  union all
  select gen_random_uuid(), cs.scope_id, cs.campaign_id, v.name, v.type, v.description, v.content, lm.location_id
  from (values
    ('Echoes of the Astral Sea', 'The Siren Ledger', 'Ledger Smugglers', 'gang', 'Smugglers tied to the ledger.', '{}'::jsonb, 'Ledger Vault'),
    ('Echoes of the Astral Sea', 'Gravemarsh Ambush', 'Gravemarsh Raiders', 'raiders', 'Ambushers among the rocks.', '{}'::jsonb, 'Gravemarsh Ridge'),
    ('Ember Crown Rebellion', 'Spark in the Mill', 'Mill Saboteurs', 'cell', 'Saboteurs hiding in the mill.', '{}'::jsonb, 'Mill Gearworks'),
    ('Ember Crown Rebellion', 'Masks at Court', 'Velvet Masks', 'circle', 'Courtiers trading favors.', '{}'::jsonb, 'Gala Atrium'),
    ('Winter of the Hollow Sun', 'The Lost Patrol', 'Patrol Seekers', 'band', 'Searchers for the lost patrol.', '{}'::jsonb, 'Patrol Camp'),
    ('Winter of the Hollow Sun', 'Icebound Choir', 'Icebound Choir', 'cult', 'Voices in the ice.', '{}'::jsonb, 'Frozen Choir Hall')
  ) v(campaign_title, adventure_title, name, type, description, content, hq_location_name)
  join campaign_map cm
    on cm.campaign_key = lower(trim(v.campaign_title))
  join adventure_map am
    on am.campaign_id = cm.campaign_id
    and am.adventure_key = lower(trim(v.adventure_title))
  join adventure_scopes cs
    on cs.adventure_id = am.adventure_id
  left join location_map lm
    on lm.campaign_id = cm.campaign_id
    and lm.location_key = lower(trim(v.hq_location_name))
  union all
  select gen_random_uuid(), cs.scope_id, cs.campaign_id, v.name, v.type, v.description, v.content, lm.location_id
  from (values
    ('Echoes of the Astral Sea', 'Dockside Interrogation', 'Pier 7 Crew', 'crew', 'Dockhands loyal to the Compass.', '{}'::jsonb, 'Pier 7'),
    ('Echoes of the Astral Sea', 'Rockfall Run', 'Driftway Trackers', 'crew', 'Guides who know the rubble.', '{}'::jsonb, 'Driftway Tunnel'),
    ('Ember Crown Rebellion', 'Boiler Room', 'Boiler Room Cell', 'cell', 'Hot-headed rebels.', '{}'::jsonb, 'Boiler Catwalks'),
    ('Ember Crown Rebellion', 'Moonlit Balcony', 'Balcony Court', 'circle', 'Whisper network on the balcony.', '{}'::jsonb, 'Balcony Garden'),
    ('Winter of the Hollow Sun', 'Frostline Trail', 'Frostline Scouts', 'band', 'Scouts watching the trail.', '{}'::jsonb, 'Frostline Waypost'),
    ('Winter of the Hollow Sun', 'Under the Ice', 'Choir of the Deep', 'cult', 'Voices beneath the ice.', '{}'::jsonb, 'Ice Cavern')
  ) v(campaign_title, scene_title, name, type, description, content, hq_location_name)
  join campaign_map cm
    on cm.campaign_key = lower(trim(v.campaign_title))
  join scene_map sm
    on sm.campaign_id = cm.campaign_id
    and sm.scene_key = lower(trim(v.scene_title))
  join scene_scopes cs
    on cs.scene_id = sm.scene_id
  left join location_map lm
    on lm.campaign_id = cm.campaign_id
    and lm.location_key = lower(trim(v.hq_location_name))
  returning id, campaign_id, name
),
organization_map as (
  select o.id as organization_id, o.campaign_id, lower(trim(o.name)) as organization_key
  from organizations o
),
items as (
  insert into public.items (id, scope_id, campaign_id, name, type, rarity, attunement, description, content, data)
  select gen_random_uuid(), cs.scope_id, cs.campaign_id, v.name, v.type, v.rarity, v.attunement, v.description, v.content, v.data
  from (values
    ('Echoes of the Astral Sea', 'Gravestone Compass', 'wondrous', 'rare', true, 'Points to the nearest starwell.', '{}'::jsonb, jsonb_build_object('charges', 3)),
    ('Ember Crown Rebellion', 'Cinderbrand Pike', 'weapon', 'uncommon', false, 'A spear that smolders at dawn.', '{}'::jsonb, jsonb_build_object('damage','1d8 piercing')),
    ('Winter of the Hollow Sun', 'Lantern of Thaw', 'wondrous', 'uncommon', false, 'Warms a small area against frost.', '{}'::jsonb, jsonb_build_object('radius','10ft'))
  ) v(campaign_title, name, type, rarity, attunement, description, content, data)
  join campaign_map cm
    on cm.campaign_key = lower(trim(v.campaign_title))
  join campaign_scopes cs
    on cs.campaign_id = cm.campaign_id
  union all
  select gen_random_uuid(), cs.scope_id, cs.campaign_id, v.name, v.type, v.rarity, v.attunement, v.description, v.content, v.data
  from (values
    ('Echoes of the Astral Sea', 'Stormwake Port', 'Dockmaster Seal', 'gear', 'common', false, 'Stamped pass for port access.', '{}'::jsonb, jsonb_build_object('faction','port')),
    ('Echoes of the Astral Sea', 'The Shattered Ring', 'Salvage Tag', 'gear', 'common', false, 'Marked tag for salvage claims.', '{}'::jsonb, jsonb_build_object('value','5 sp')),
    ('Ember Crown Rebellion', 'Ashmarket', 'Union Armband', 'gear', 'common', false, 'Worn by union organizers.', '{}'::jsonb, jsonb_build_object('symbol','ember')),
    ('Ember Crown Rebellion', 'The Red Citadel', 'Citadel Pass', 'gear', 'uncommon', false, 'Seal granting access to the inner ward.', '{}'::jsonb, jsonb_build_object('access','inner ward')),
    ('Winter of the Hollow Sun', 'Frostmarch', 'Frostmarch Ration Kit', 'consumable', 'common', false, 'Travel rations for cold marches.', '{}'::jsonb, jsonb_build_object('uses', 3)),
    ('Winter of the Hollow Sun', 'The Drowned Vale', 'Vale Compass', 'tool', 'uncommon', false, 'Points toward the drowned shore.', '{}'::jsonb, jsonb_build_object('effect','avoid getting lost'))
  ) v(campaign_title, chapter_title, name, type, rarity, attunement, description, content, data)
  join campaign_map cm
    on cm.campaign_key = lower(trim(v.campaign_title))
  join chapter_map chm
    on chm.campaign_id = cm.campaign_id
    and chm.chapter_key = lower(trim(v.chapter_title))
  join chapter_scopes cs
    on cs.chapter_id = chm.chapter_id
  union all
  select gen_random_uuid(), cs.scope_id, cs.campaign_id, v.name, v.type, v.rarity, v.attunement, v.description, v.content, v.data
  from (values
    ('Echoes of the Astral Sea', 'The Siren Ledger', 'Siren Ledger Fragment', 'quest', 'rare', false, 'A torn page of star routes.', '{}'::jsonb, jsonb_build_object('page', 2)),
    ('Echoes of the Astral Sea', 'Gravemarsh Ambush', 'Ring Fragment', 'treasure', 'uncommon', false, 'Shimmering rock from the ring.', '{}'::jsonb, jsonb_build_object('value','25 gp')),
    ('Ember Crown Rebellion', 'Spark in the Mill', 'Mill Shift Key', 'tool', 'common', false, 'Key to the mill floor.', '{}'::jsonb, jsonb_build_object('access','mill')),
    ('Ember Crown Rebellion', 'Masks at Court', 'Gala Mask', 'wondrous', 'uncommon', false, 'Disguises the wearer at court.', '{}'::jsonb, jsonb_build_object('bonus','advantage on disguise')),
    ('Winter of the Hollow Sun', 'The Lost Patrol', 'Patrol Signal Horn', 'tool', 'uncommon', false, 'Echoes across the snow fields.', '{}'::jsonb, jsonb_build_object('range','2 miles')),
    ('Winter of the Hollow Sun', 'Icebound Choir', 'Choir Chime', 'wondrous', 'rare', false, 'Rings with a hollow frost tone.', '{}'::jsonb, jsonb_build_object('charges', 1))
  ) v(campaign_title, adventure_title, name, type, rarity, attunement, description, content, data)
  join campaign_map cm
    on cm.campaign_key = lower(trim(v.campaign_title))
  join adventure_map am
    on am.campaign_id = cm.campaign_id
    and am.adventure_key = lower(trim(v.adventure_title))
  join adventure_scopes cs
    on cs.adventure_id = am.adventure_id
  union all
  select gen_random_uuid(), cs.scope_id, cs.campaign_id, v.name, v.type, v.rarity, v.attunement, v.description, v.content, v.data
  from (values
    ('Echoes of the Astral Sea', 'Dockside Interrogation', 'Pier 7 Coinpurse', 'treasure', 'common', false, 'A heavy purse of dock coins.', '{}'::jsonb, jsonb_build_object('value','12 sp')),
    ('Echoes of the Astral Sea', 'Rockfall Run', 'Rockfall Chalk', 'gear', 'common', false, 'Marks safe paths through rubble.', '{}'::jsonb, jsonb_build_object('uses', 5)),
    ('Ember Crown Rebellion', 'Boiler Room', 'Boiler Valve Key', 'tool', 'common', false, 'Key to shut down a boiler.', '{}'::jsonb, jsonb_build_object('area','boiler room')),
    ('Ember Crown Rebellion', 'Moonlit Balcony', 'Balcony Signet', 'jewelry', 'uncommon', false, 'Signet ring for court access.', '{}'::jsonb, jsonb_build_object('symbol','crescent')),
    ('Winter of the Hollow Sun', 'Frostline Trail', 'Frostline Map', 'gear', 'common', false, 'Map with safe trail marks.', '{}'::jsonb, jsonb_build_object('area','trail')),
    ('Winter of the Hollow Sun', 'Under the Ice', 'Frozen Locket', 'treasure', 'uncommon', false, 'A locket sealed in ice.', '{}'::jsonb, jsonb_build_object('inscription','Liora'))
  ) v(campaign_title, scene_title, name, type, rarity, attunement, description, content, data)
  join campaign_map cm
    on cm.campaign_key = lower(trim(v.campaign_title))
  join scene_map sm
    on sm.campaign_id = cm.campaign_id
    and sm.scene_key = lower(trim(v.scene_title))
  join scene_scopes cs
    on cs.scene_id = sm.scene_id
  returning id, campaign_id, name
),
creatures as (
  insert into public.creatures (
    id, scope_id, campaign_id, organization_id, name, kind, source, size, creature_type, subtype, alignment,
    challenge_rating, experience_points, armor_class, hit_points, hit_dice,
    speed, ability_scores, saving_throws, skills, senses, languages,
    damage_resistances, damage_immunities, condition_immunities,
    traits, actions, reactions, legendary_actions, spellcasting,
    description, content, raw
  )
  select
    gen_random_uuid(),
    cs.scope_id,
    cs.campaign_id,
    om.organization_id,
    v.name,
    v.kind,
    v.source,
    v.size,
    v.creature_type,
    v.subtype,
    v.alignment,
    v.cr_decimal,
    v.xp,
    v.ac,
    v.hp,
    v.hit_dice,
    v.speed,
    v.ability_scores,
    v.saving_throws,
    v.skills,
    v.senses,
    v.languages,
    v.damage_resistances,
    v.damage_immunities,
    v.condition_immunities,
    v.traits,
    v.actions,
    v.reactions,
    v.legendary_actions,
    v.spellcasting,
    v.description,
    v.content,
    v.raw
  from (values
    ('Echoes of the Astral Sea', 'Dockside Interrogation', 'The Silver Compass', 'Silver Compass Corsair', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'chaotic neutral',
     2.000, '2', 450, 15, 27, '5d8+5',
     jsonb_build_object('walk','30 ft','fly','30 ft'), jsonb_build_object('str',12,'dex',16,'con',12,'int',13,'wis',10,'cha',14),
     '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb,
     '[]'::jsonb, '[]'::jsonb, '[]'::jsonb,
     jsonb_build_array(jsonb_build_object('name','Void Step','text','Teleport 10 ft as a bonus action.')),
     jsonb_build_array(jsonb_build_object('name','Cutlass','text','Melee Weapon Attack.')),
     '[]'::jsonb, '[]'::jsonb, '{}'::jsonb,
     'A privateer loyal to the Compass.', '{}'::jsonb, '{}'::jsonb),
    ('Echoes of the Astral Sea', 'Dockside Interrogation', 'Stormwake Dockers', 'Dockmaster Elen', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'neutral',
     1.000, '1', 200, 12, 18, '4d8',
     jsonb_build_object('walk','30 ft'), jsonb_build_object('str',10,'dex',12,'con',11,'int',12,'wis',11,'cha',12),
     '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb,
     '[]'::jsonb, '[]'::jsonb, '[]'::jsonb,
     jsonb_build_array(jsonb_build_object('name','Harbor Eyes','text','Advantage on Perception checks in the port.')),
     jsonb_build_array(jsonb_build_object('name','Sap','text','Melee Weapon Attack.')),
     '[]'::jsonb, '[]'::jsonb, '{}'::jsonb,
     'A strict dockmaster who runs Pier 7.', '{}'::jsonb, '{}'::jsonb),
    ('Ember Crown Rebellion', 'Boiler Room', 'Ashmarket Union', 'Cinderbrand Enforcer', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'lawful evil',
     3.000, '3', 700, 16, 33, '6d8+6',
     jsonb_build_object('walk','30 ft'), jsonb_build_object('str',16,'dex',12,'con',14,'int',10,'wis',11,'cha',10),
     '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb,
     '[]'::jsonb, '[]'::jsonb, '[]'::jsonb,
     jsonb_build_array(jsonb_build_object('name','Intimidating Presence','text','Targets have disadvantage on checks.')),
     jsonb_build_array(jsonb_build_object('name','Pike','text','Melee Weapon Attack.')),
     '[]'::jsonb, '[]'::jsonb, '{}'::jsonb,
     'City guard turned enforcer.', '{}'::jsonb, '{}'::jsonb),
    ('Ember Crown Rebellion', 'Boiler Room', null, 'Steam Mephit', 'creature', 'homebrew', 'small', 'monster', null, 'neutral evil',
     2.000, '2', 450, 13, 21, '6d6',
     jsonb_build_object('fly','30 ft'), jsonb_build_object('str',6,'dex',14,'con',10,'int',11,'wis',10,'cha',12),
     '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb,
     jsonb_build_array('fire'), '[]'::jsonb, '[]'::jsonb,
     jsonb_build_array(jsonb_build_object('name','Steam Form','text','Can pass through narrow gaps.')),
     jsonb_build_array(jsonb_build_object('name','Scald','text','Ranged Spell Attack.')),
     '[]'::jsonb, '[]'::jsonb, '{}'::jsonb,
     'A mischievous creature of hot steam.', '{}'::jsonb, '{}'::jsonb),
    ('Winter of the Hollow Sun', 'Under the Ice', null, 'Hollow Lake Wraith', 'creature', 'homebrew', 'medium', 'monster', null, 'neutral evil',
     4.000, '4', 1100, 15, 45, '6d8+18',
     jsonb_build_object('fly','40 ft','swim','40 ft'), jsonb_build_object('str',8,'dex',14,'con',16,'int',11,'wis',12,'cha',15),
     '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb,
     jsonb_build_array('cold'), '[]'::jsonb, '[]'::jsonb,
     jsonb_build_array(jsonb_build_object('name','Chilling Aura','text','Creatures within 10 ft take cold damage.')),
     jsonb_build_array(jsonb_build_object('name','Soul Drain','text','Melee Spell Attack.')),
     '[]'::jsonb, '[]'::jsonb, '{}'::jsonb,
     'A spirit bound beneath the ice.', '{}'::jsonb, '{}'::jsonb),
    ('Winter of the Hollow Sun', 'Under the Ice', 'Choir of the Deep', 'Icebound Devourer', 'creature', 'homebrew', 'large', 'monster', null, 'neutral evil',
     5.000, '5', 1800, 14, 68, '8d10+24',
     jsonb_build_object('walk','20 ft','swim','30 ft'), jsonb_build_object('str',18,'dex',10,'con',16,'int',6,'wis',12,'cha',8),
     '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb,
     jsonb_build_array('cold'), '[]'::jsonb, '[]'::jsonb,
     jsonb_build_array(jsonb_build_object('name','Ice Armor','text','Gains resistance to nonmagical attacks.')),
     jsonb_build_array(jsonb_build_object('name','Crush','text','Melee Weapon Attack.')),
     '[]'::jsonb, '[]'::jsonb, '{}'::jsonb,
     'A hulking beast that hunts beneath the lake.', '{}'::jsonb, '{}'::jsonb)
  ) v(
    campaign_title, scene_title, organization_name, name, kind, source, size, creature_type, subtype, alignment,
    cr_decimal, cr_text, xp, ac, hp, hit_dice,
    speed, ability_scores, saving_throws, skills, senses, languages,
    damage_resistances, damage_immunities, condition_immunities,
    traits, actions, reactions, legendary_actions, spellcasting,
    description, content, raw
  )
  join campaign_map cm
    on cm.campaign_key = lower(trim(v.campaign_title))
  join scene_map sm
    on sm.campaign_id = cm.campaign_id
    and sm.scene_key = lower(trim(v.scene_title))
  join scene_scopes cs
    on cs.scene_id = sm.scene_id
  left join organization_map om
    on om.campaign_id = cm.campaign_id
    and om.organization_key = lower(trim(v.organization_name))
  union all
  select
    gen_random_uuid(),
    cs.scope_id,
    cs.campaign_id,
    om.organization_id,
    v.name,
    v.kind,
    v.source,
    v.size,
    v.creature_type,
    v.subtype,
    v.alignment,
    v.cr_decimal,
    v.xp,
    v.ac,
    v.hp,
    v.hit_dice,
    v.speed,
    v.ability_scores,
    v.saving_throws,
    v.skills,
    v.senses,
    v.languages,
    v.damage_resistances,
    v.damage_immunities,
    v.condition_immunities,
    v.traits,
    v.actions,
    v.reactions,
    v.legendary_actions,
    v.spellcasting,
    v.description,
    v.content,
    v.raw
  from (values
    ('Echoes of the Astral Sea', 'The Siren Ledger', null, 'Void Maw Larva', 'creature', 'homebrew', 'small', 'monster', null, 'unaligned',
     1.000, '1', 200, 12, 18, '4d6',
     jsonb_build_object('walk','20 ft','climb','20 ft'), jsonb_build_object('str',8,'dex',14,'con',10,'int',3,'wis',10,'cha',5),
     '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb,
     '[]'::jsonb, '[]'::jsonb, '[]'::jsonb,
     jsonb_build_array(jsonb_build_object('name','Void Scent','text','Tracks creatures by scent.')),
     jsonb_build_array(jsonb_build_object('name','Bite','text','Melee Weapon Attack.')),
     '[]'::jsonb, '[]'::jsonb, '{}'::jsonb,
     'A larval predator from the void.', '{}'::jsonb, '{}'::jsonb),
    ('Echoes of the Astral Sea', 'Gravemarsh Ambush', 'Gravemarsh Raiders', 'Gravemarsh Ravager', 'creature', 'homebrew', 'medium', 'monster', null, 'chaotic evil',
     3.000, '3', 700, 14, 36, '8d8',
     jsonb_build_object('walk','30 ft','climb','20 ft'), jsonb_build_object('str',15,'dex',14,'con',12,'int',8,'wis',11,'cha',9),
     '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb,
     '[]'::jsonb, '[]'::jsonb, '[]'::jsonb,
     jsonb_build_array(jsonb_build_object('name','Scrap Armor','text','Temporary HP at start of combat.')),
     jsonb_build_array(jsonb_build_object('name','Hooked Blade','text','Melee Weapon Attack.')),
     '[]'::jsonb, '[]'::jsonb, '{}'::jsonb,
     'A scavenger turned raider.', '{}'::jsonb, '{}'::jsonb),
    ('Ember Crown Rebellion', 'Spark in the Mill', 'Mill Saboteurs', 'Mill Foreman Rusk', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'neutral evil',
     2.000, '2', 450, 14, 26, '5d8+5',
     jsonb_build_object('walk','30 ft'), jsonb_build_object('str',13,'dex',12,'con',12,'int',11,'wis',10,'cha',11),
     '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb,
     '[]'::jsonb, '[]'::jsonb, '[]'::jsonb,
     jsonb_build_array(jsonb_build_object('name','Overseer','text','Workers gain +1 to attack.')),
     jsonb_build_array(jsonb_build_object('name','Hammer','text','Melee Weapon Attack.')),
     '[]'::jsonb, '[]'::jsonb, '{}'::jsonb,
     'A ruthless foreman in the mill.', '{}'::jsonb, '{}'::jsonb),
    ('Ember Crown Rebellion', 'Masks at Court', 'Velvet Masks', 'Court Whisperer', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'neutral',
     1.000, '1', 200, 12, 16, '4d8',
     jsonb_build_object('walk','30 ft'), jsonb_build_object('str',9,'dex',12,'con',10,'int',14,'wis',11,'cha',14),
     '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb,
     '[]'::jsonb, '[]'::jsonb, '[]'::jsonb,
     jsonb_build_array(jsonb_build_object('name','Silver Tongue','text','Advantage on Persuasion checks.')),
     jsonb_build_array(jsonb_build_object('name','Dagger','text','Melee Weapon Attack.')),
     '[]'::jsonb, '[]'::jsonb, '{}'::jsonb,
     'A broker of secrets at court.', '{}'::jsonb, '{}'::jsonb),
    ('Winter of the Hollow Sun', 'The Lost Patrol', null, 'Snow Stalker', 'creature', 'homebrew', 'large', 'monster', null, 'neutral evil',
     4.000, '4', 1100, 13, 52, '7d10+14',
     jsonb_build_object('walk','40 ft'), jsonb_build_object('str',16,'dex',12,'con',14,'int',5,'wis',12,'cha',6),
     '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb,
     jsonb_build_array('cold'), '[]'::jsonb, '[]'::jsonb,
     jsonb_build_array(jsonb_build_object('name','Snow Camouflage','text','Advantage on Stealth checks in snow.')),
     jsonb_build_array(jsonb_build_object('name','Maul','text','Melee Weapon Attack.')),
     '[]'::jsonb, '[]'::jsonb, '{}'::jsonb,
     'A predator stalking the frozen trail.', '{}'::jsonb, '{}'::jsonb),
    ('Winter of the Hollow Sun', 'Icebound Choir', 'Icebound Choir', 'Icebound Acolyte', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'neutral evil',
     2.000, '2', 450, 12, 24, '5d8+2',
     jsonb_build_object('walk','30 ft'), jsonb_build_object('str',9,'dex',12,'con',11,'int',12,'wis',14,'cha',10),
     '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb,
     jsonb_build_array('cold'), '[]'::jsonb, '[]'::jsonb,
     jsonb_build_array(jsonb_build_object('name','Frozen Hymn','text','Allies gain temporary HP.')),
     jsonb_build_array(jsonb_build_object('name','Ice Dart','text','Ranged Spell Attack.')),
     '[]'::jsonb, '[]'::jsonb, '{}'::jsonb,
     'A devoted singer of the frozen choir.', '{}'::jsonb, '{}'::jsonb)
  ) v(
    campaign_title, adventure_title, organization_name, name, kind, source, size, creature_type, subtype, alignment,
    cr_decimal, cr_text, xp, ac, hp, hit_dice,
    speed, ability_scores, saving_throws, skills, senses, languages,
    damage_resistances, damage_immunities, condition_immunities,
    traits, actions, reactions, legendary_actions, spellcasting,
    description, content, raw
  )
  join campaign_map cm
    on cm.campaign_key = lower(trim(v.campaign_title))
  join adventure_map am
    on am.campaign_id = cm.campaign_id
    and am.adventure_key = lower(trim(v.adventure_title))
  join adventure_scopes cs
    on cs.adventure_id = am.adventure_id
  left join organization_map om
    on om.campaign_id = cm.campaign_id
    and om.organization_key = lower(trim(v.organization_name))
  union all
  select
    gen_random_uuid(),
    cs.scope_id,
    cs.campaign_id,
    om.organization_id,
    v.name,
    v.kind,
    v.source,
    v.size,
    v.creature_type,
    v.subtype,
    v.alignment,
    v.cr_decimal,
    v.xp,
    v.ac,
    v.hp,
    v.hit_dice,
    v.speed,
    v.ability_scores,
    v.saving_throws,
    v.skills,
    v.senses,
    v.languages,
    v.damage_resistances,
    v.damage_immunities,
    v.condition_immunities,
    v.traits,
    v.actions,
    v.reactions,
    v.legendary_actions,
    v.spellcasting,
    v.description,
    v.content,
    v.raw
  from (values
    ('Echoes of the Astral Sea', 'Stormwake Port', 'Stormwake Dockers', 'Port Inspector Vale', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'lawful neutral',
     1.000, '1', 200, 13, 20, '4d8+2',
     jsonb_build_object('walk','30 ft'), jsonb_build_object('str',11,'dex',12,'con',12,'int',12,'wis',13,'cha',10),
     '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb,
     '[]'::jsonb, '[]'::jsonb, '[]'::jsonb,
     jsonb_build_array(jsonb_build_object('name','Port Authority','text','Can summon dock guards.')),
     jsonb_build_array(jsonb_build_object('name','Shortsword','text','Melee Weapon Attack.')),
     '[]'::jsonb, '[]'::jsonb, '{}'::jsonb,
     'A stern inspector who enforces port rules.', '{}'::jsonb, '{}'::jsonb),
    ('Echoes of the Astral Sea', 'The Shattered Ring', 'Ring Salvagers', 'Ring Scavenger', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'chaotic neutral',
     1.000, '1', 200, 12, 18, '4d8',
     jsonb_build_object('walk','30 ft'), jsonb_build_object('str',10,'dex',13,'con',11,'int',11,'wis',10,'cha',9),
     '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb,
     '[]'::jsonb, '[]'::jsonb, '[]'::jsonb,
     jsonb_build_array(jsonb_build_object('name','Scrap Sense','text','Advantage on checks to find salvage.')),
     jsonb_build_array(jsonb_build_object('name','Pick','text','Melee Weapon Attack.')),
     '[]'::jsonb, '[]'::jsonb, '{}'::jsonb,
     'A scavenger picking through the ring.', '{}'::jsonb, '{}'::jsonb),
    ('Ember Crown Rebellion', 'Ashmarket', 'Ashmarket Union', 'Union Marshal', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'neutral',
     2.000, '2', 450, 14, 24, '5d8+2',
     jsonb_build_object('walk','30 ft'), jsonb_build_object('str',12,'dex',12,'con',12,'int',11,'wis',12,'cha',11),
     '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb,
     '[]'::jsonb, '[]'::jsonb, '[]'::jsonb,
     jsonb_build_array(jsonb_build_object('name','Rally','text','Allies gain +1 to saving throws.')),
     jsonb_build_array(jsonb_build_object('name','Club','text','Melee Weapon Attack.')),
     '[]'::jsonb, '[]'::jsonb, '{}'::jsonb,
     'Keeps order among the union ranks.', '{}'::jsonb, '{}'::jsonb),
    ('Ember Crown Rebellion', 'The Red Citadel', null, 'Citadel Guard', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'lawful neutral',
     2.000, '2', 450, 15, 26, '5d8+5',
     jsonb_build_object('walk','30 ft'), jsonb_build_object('str',13,'dex',11,'con',12,'int',10,'wis',12,'cha',10),
     '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb,
     '[]'::jsonb, '[]'::jsonb, '[]'::jsonb,
     jsonb_build_array(jsonb_build_object('name','Hold the Line','text','Allies within 5 ft gain +1 AC.')),
     jsonb_build_array(jsonb_build_object('name','Spear','text','Melee Weapon Attack.')),
     '[]'::jsonb, '[]'::jsonb, '{}'::jsonb,
     'A disciplined guard of the citadel.', '{}'::jsonb, '{}'::jsonb),
    ('Winter of the Hollow Sun', 'Frostmarch', null, 'Frostmarch Bear', 'creature', 'homebrew', 'large', 'monster', null, 'unaligned',
     3.000, '3', 700, 12, 40, '7d10',
     jsonb_build_object('walk','40 ft'), jsonb_build_object('str',17,'dex',10,'con',14,'int',3,'wis',12,'cha',6),
     '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb,
     jsonb_build_array('cold'), '[]'::jsonb, '[]'::jsonb,
     jsonb_build_array(jsonb_build_object('name','Thick Fur','text','Resistance to cold damage.')),
     jsonb_build_array(jsonb_build_object('name','Claws','text','Melee Weapon Attack.')),
     '[]'::jsonb, '[]'::jsonb, '{}'::jsonb,
     'A massive bear adapted to the deep winter.', '{}'::jsonb, '{}'::jsonb),
    ('Winter of the Hollow Sun', 'The Drowned Vale', null, 'Mist Drake', 'creature', 'homebrew', 'medium', 'monster', null, 'neutral',
     4.000, '4', 1100, 14, 44, '8d8+8',
     jsonb_build_object('walk','30 ft','fly','30 ft'), jsonb_build_object('str',14,'dex',12,'con',12,'int',6,'wis',12,'cha',9),
     '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb,
     jsonb_build_array('cold'), '[]'::jsonb, '[]'::jsonb,
     jsonb_build_array(jsonb_build_object('name','Mist Shroud','text','Lightly obscured in mist.')),
     jsonb_build_array(jsonb_build_object('name','Bite','text','Melee Weapon Attack.')),
     '[]'::jsonb, '[]'::jsonb, '{}'::jsonb,
     'A drake that hunts along the drowned shore.', '{}'::jsonb, '{}'::jsonb)
  ) v(
    campaign_title, chapter_title, organization_name, name, kind, source, size, creature_type, subtype, alignment,
    cr_decimal, cr_text, xp, ac, hp, hit_dice,
    speed, ability_scores, saving_throws, skills, senses, languages,
    damage_resistances, damage_immunities, condition_immunities,
    traits, actions, reactions, legendary_actions, spellcasting,
    description, content, raw
  )
  join campaign_map cm
    on cm.campaign_key = lower(trim(v.campaign_title))
  join chapter_map chm
    on chm.campaign_id = cm.campaign_id
    and chm.chapter_key = lower(trim(v.chapter_title))
  join chapter_scopes cs
    on cs.chapter_id = chm.chapter_id
  left join organization_map om
    on om.campaign_id = cm.campaign_id
    and om.organization_key = lower(trim(v.organization_name))
  returning id, campaign_id, name
),
creature_map as (
  select c.id as creature_id, c.campaign_id, lower(trim(c.name)) as creature_key
  from creatures c
),
encounters as (
  insert into public.encounters (id, scope_id, campaign_id, title, description, content, data)
  select gen_random_uuid(), cs.scope_id, cs.campaign_id, v.title, v.description, v.content, v.data
  from (values
    ('Echoes of the Astral Sea', 'Dockside Interrogation', 'Dockside Skirmish', 'Corsairs demand a toll.', '{}'::jsonb, jsonb_build_object('xp_budget', 450)),
    ('Echoes of the Astral Sea', 'Rockfall Run', 'Rockfall Chase', 'A sprint through falling debris.', '{}'::jsonb, jsonb_build_object('xp_budget', 300)),
    ('Ember Crown Rebellion', 'Boiler Room', 'Strikebreakers', 'An ambush in the mill.', '{}'::jsonb, jsonb_build_object('xp_budget', 700)),
    ('Ember Crown Rebellion', 'Moonlit Balcony', 'Balcony Duel', 'A whispered challenge at dusk.', '{}'::jsonb, jsonb_build_object('xp_budget', 400)),
    ('Winter of the Hollow Sun', 'Frostline Trail', 'Frostline Ambush', 'Shadows emerge in the blizzard.', '{}'::jsonb, jsonb_build_object('xp_budget', 600)),
    ('Winter of the Hollow Sun', 'Under the Ice', 'Lake Wraith', 'The ice cracks and something rises.', '{}'::jsonb, jsonb_build_object('xp_budget', 1100))
  ) v(campaign_title, scene_title, title, description, content, data)
  join campaign_map cm
    on cm.campaign_key = lower(trim(v.campaign_title))
  join scene_map sm
    on sm.campaign_id = cm.campaign_id
    and sm.scene_key = lower(trim(v.scene_title))
  join scene_scopes cs
    on cs.scene_id = sm.scene_id
  union all
  select gen_random_uuid(), cs.scope_id, cs.campaign_id, v.title, v.description, v.content, v.data
  from (values
    ('Echoes of the Astral Sea', 'The Siren Ledger', 'Ledger Vault Break-in', 'Breaking into the hidden cache.', '{}'::jsonb, jsonb_build_object('xp_budget', 500)),
    ('Echoes of the Astral Sea', 'Gravemarsh Ambush', 'Gravemarsh Trap', 'Rocks and raiders close in.', '{}'::jsonb, jsonb_build_object('xp_budget', 650)),
    ('Ember Crown Rebellion', 'Spark in the Mill', 'Mill Riot', 'Chaos spreads across the mill.', '{}'::jsonb, jsonb_build_object('xp_budget', 600)),
    ('Ember Crown Rebellion', 'Masks at Court', 'Courtly Conspiracy', 'Plots unravel behind masks.', '{}'::jsonb, jsonb_build_object('xp_budget', 500)),
    ('Winter of the Hollow Sun', 'The Lost Patrol', 'Patrol Rescue', 'A rescue beneath heavy snow.', '{}'::jsonb, jsonb_build_object('xp_budget', 800)),
    ('Winter of the Hollow Sun', 'Icebound Choir', 'Choir Rising', 'The choir calls the cold.', '{}'::jsonb, jsonb_build_object('xp_budget', 900))
  ) v(campaign_title, adventure_title, title, description, content, data)
  join campaign_map cm
    on cm.campaign_key = lower(trim(v.campaign_title))
  join adventure_map am
    on am.campaign_id = cm.campaign_id
    and am.adventure_key = lower(trim(v.adventure_title))
  join adventure_scopes cs
    on cs.adventure_id = am.adventure_id
  union all
  select gen_random_uuid(), cs.scope_id, cs.campaign_id, v.title, v.description, v.content, v.data
  from (values
    ('Echoes of the Astral Sea', 'Stormwake Port', 'Stormwake Smugglers', 'A smuggling ring in the port.', '{}'::jsonb, jsonb_build_object('xp_budget', 400)),
    ('Echoes of the Astral Sea', 'The Shattered Ring', 'Ring Salvage Clash', 'Salvagers fight over a haul.', '{}'::jsonb, jsonb_build_object('xp_budget', 550)),
    ('Ember Crown Rebellion', 'Ashmarket', 'Ashmarket Uprising', 'The square erupts in conflict.', '{}'::jsonb, jsonb_build_object('xp_budget', 700)),
    ('Ember Crown Rebellion', 'The Red Citadel', 'Citadel Checkpoint', 'A tense standoff at the gate.', '{}'::jsonb, jsonb_build_object('xp_budget', 600)),
    ('Winter of the Hollow Sun', 'Frostmarch', 'Frostmarch Siege', 'Defend the walls from raiders.', '{}'::jsonb, jsonb_build_object('xp_budget', 850)),
    ('Winter of the Hollow Sun', 'The Drowned Vale', 'Drowned Vale Fog', 'Shadows move in the mist.', '{}'::jsonb, jsonb_build_object('xp_budget', 650))
  ) v(campaign_title, chapter_title, title, description, content, data)
  join campaign_map cm
    on cm.campaign_key = lower(trim(v.campaign_title))
  join chapter_map chm
    on chm.campaign_id = cm.campaign_id
    and chm.chapter_key = lower(trim(v.chapter_title))
  join chapter_scopes cs
    on cs.chapter_id = chm.chapter_id
  returning id, campaign_id, title
),
encounter_map as (
  select e.id as encounter_id, e.campaign_id, lower(trim(e.title)) as encounter_key
  from encounters e
),
encounter_creatures as (
  insert into public.encounter_creatures (id, encounter_id, creature_id, campaign_id, quantity, initiative, notes)
  select
    gen_random_uuid(),
    em.encounter_id,
    crm.creature_id,
    em.campaign_id,
    v.quantity,
    v.initiative,
    v.notes
  from (values
    ('Echoes of the Astral Sea', 'Dockside Skirmish', 'Silver Compass Corsair', 2, 12, 'Primary threat.'),
    ('Echoes of the Astral Sea', 'Dockside Skirmish', 'Dockmaster Elen', 1, 15, 'Reluctant participant.'),
    ('Echoes of the Astral Sea', 'Rockfall Chase', 'Gravemarsh Ravager', 1, 13, 'Ambusher among debris.'),
    ('Echoes of the Astral Sea', 'Ledger Vault Break-in', 'Void Maw Larva', 3, 10, 'Small but dangerous.'),
    ('Echoes of the Astral Sea', 'Gravemarsh Trap', 'Gravemarsh Ravager', 2, 11, 'Raiders at the ridge.'),
    ('Echoes of the Astral Sea', 'Stormwake Smugglers', 'Port Inspector Vale', 1, 14, 'Calls for backup.'),
    ('Echoes of the Astral Sea', 'Ring Salvage Clash', 'Ring Scavenger', 3, 12, 'Fights over scrap.'),
    ('Ember Crown Rebellion', 'Strikebreakers', 'Cinderbrand Enforcer', 2, 12, 'Enforcers on patrol.'),
    ('Ember Crown Rebellion', 'Strikebreakers', 'Steam Mephit', 1, 14, 'Unstable steam creature.'),
    ('Ember Crown Rebellion', 'Balcony Duel', 'Court Whisperer', 1, 16, 'Strikes with secrets.'),
    ('Ember Crown Rebellion', 'Mill Riot', 'Mill Foreman Rusk', 1, 13, 'Commands the workers.'),
    ('Ember Crown Rebellion', 'Courtly Conspiracy', 'Court Whisperer', 2, 15, 'Plots from the shadows.'),
    ('Ember Crown Rebellion', 'Ashmarket Uprising', 'Union Marshal', 2, 12, 'Leads the charge.'),
    ('Ember Crown Rebellion', 'Citadel Checkpoint', 'Citadel Guard', 2, 11, 'Holds the gate.'),
    ('Winter of the Hollow Sun', 'Lake Wraith', 'Hollow Lake Wraith', 1, 12, 'Ancient spirit.'),
    ('Winter of the Hollow Sun', 'Lake Wraith', 'Icebound Devourer', 1, 9, 'Massive threat.'),
    ('Winter of the Hollow Sun', 'Frostline Ambush', 'Snow Stalker', 1, 13, 'Stalks in the blizzard.'),
    ('Winter of the Hollow Sun', 'Patrol Rescue', 'Snow Stalker', 1, 11, 'Hunting the survivors.'),
    ('Winter of the Hollow Sun', 'Choir Rising', 'Icebound Acolyte', 3, 14, 'Sings the frozen hymn.'),
    ('Winter of the Hollow Sun', 'Frostmarch Siege', 'Frostmarch Bear', 1, 10, 'Breaks the line.'),
    ('Winter of the Hollow Sun', 'Drowned Vale Fog', 'Mist Drake', 1, 12, 'Lurks in the mist.')
  ) v(campaign_title, encounter_title, creature_name, quantity, initiative, notes)
  join campaign_map cm
    on cm.campaign_key = lower(trim(v.campaign_title))
  join encounter_map em
    on em.campaign_id = cm.campaign_id
    and em.encounter_key = lower(trim(v.encounter_title))
  join creature_map crm
    on crm.campaign_id = cm.campaign_id
    and crm.creature_key = lower(trim(v.creature_name))
  returning id
),
groups as (
  insert into public.groups (id, name, description, dungeon_master_user_id)
  select gen_random_uuid(), v.name, v.description, seed_user.user_id
  from seed_user
  cross join (values
    ('Astral Voyagers', 'Crew of the Astral Sea.'),
    ('Ember Cell', 'Rebels in the city.'),
    ('Hollow Scouts', 'Survivors of the frontier.')
  ) v(name, description)
  returning id, name
),
playing_campaigns as (
  insert into public.playing_campaigns (group_id, campaign_id)
  select g.id, c.id
  from groups g
  join campaigns c on
    (g.name = 'Astral Voyagers' and c.title = 'Echoes of the Astral Sea')
    or (g.name = 'Ember Cell' and c.title = 'Ember Crown Rebellion')
    or (g.name = 'Hollow Scouts' and c.title = 'Winter of the Hollow Sun')
  returning group_id
),
characters as (
  insert into public.characters (
    id, group_id, user_id, dndbeyond_character_id, name, avatar_url, level, armor_class, hit_points,
    race, background, classes, abilities, data, content, dndbeyond_raw
  )
  select
    gen_random_uuid(),
    g.id,
    seed_user.user_id,
    1234567890,
    'Sable Starling',
    null,
    3,
    15,
    24,
    'Human',
    'Sailor',
    jsonb_build_array(jsonb_build_object('class','Rogue','level',3)),
    jsonb_build_object('str',10,'dex',16,'con',12,'int',14,'wis',11,'cha',13),
    jsonb_build_object('skills', jsonb_build_array('stealth','perception')),
    jsonb_build_object('notes','Loyal to the Astral Voyagers.'),
    '{}'::jsonb
  from seed_user
  join groups g on g.name = 'Astral Voyagers'
  on conflict (user_id) do nothing
  returning id
),
session_logs as (
  insert into public.session_logs (id, group_id, session_number, session_date, title, content)
  select gen_random_uuid(), g.id, v.session_number, v.session_date, v.title, v.content
  from groups g
  join (values
    ('Astral Voyagers', 1, '2025-01-10'::date, 'First Jump', jsonb_build_object('summary','Left Stormwake Port.')),
    ('Ember Cell', 1, '2025-01-12'::date, 'Sparks Fly', jsonb_build_object('summary','Strike at Ashmarket.')),
    ('Hollow Scouts', 1, '2025-01-14'::date, 'Whiteout', jsonb_build_object('summary','Found the lost patrol trail.'))
  ) v(group_name, session_number, session_date, title, content)
  on v.group_name = g.name
  returning id
)
select
  (select count(*) from campaigns) as campaigns_created,
  (select count(*) from chapters) as chapters_created,
  (select count(*) from adventures) as adventures_created,
  (select count(*) from scenes) as scenes_created,
  (select count(*) from maps) as maps_created,
  (select count(*) from ensure_campaign_scopes) as campaign_scopes_created,
  (select count(*) from ensure_chapter_scopes) as chapter_scopes_created,
  (select count(*) from ensure_adventure_scopes) as adventure_scopes_created,
  (select count(*) from ensure_scene_scopes) as scene_scopes_created,
  (select count(*) from locations) as locations_created,
  (select count(*) from organizations) as organizations_created,
  (select count(*) from items) as items_created,
  (select count(*) from creatures) as creatures_created,
  (select count(*) from encounters) as encounters_created,
  (select count(*) from encounter_creatures) as encounter_creatures_created,
  (select count(*) from groups) as groups_created,
  (select count(*) from playing_campaigns) as playing_campaigns_created,
  (select count(*) from characters) as characters_created,
  (select count(*) from session_logs) as session_logs_created;

do $$
declare
  seed_user uuid := 'be4b8621-b222-4a9c-8a4b-d8eac240bd4f'::uuid;
  campaign_ids uuid[];
  actual_locations int;
  actual_organizations int;
  actual_items int;
  actual_creatures int;
  actual_encounters int;
  actual_encounter_creatures int;
begin
  select array_agg(id) into campaign_ids
  from public.campaigns
  where created_by = seed_user
    and title in (
      'Echoes of the Astral Sea',
      'Ember Crown Rebellion',
      'Winter of the Hollow Sun'
    );

  if campaign_ids is null then
    raise exception 'Seed abort: no campaigns found for seed user %', seed_user;
  end if;

  select count(*) into actual_locations
  from public.locations
  where campaign_id = any(campaign_ids);
  if actual_locations <> 21 then
    raise exception 'Seed abort: locations expected %, got %', 21, actual_locations;
  end if;

  select count(*) into actual_organizations
  from public.organizations
  where campaign_id = any(campaign_ids);
  if actual_organizations <> 21 then
    raise exception 'Seed abort: organizations expected %, got %', 21, actual_organizations;
  end if;

  select count(*) into actual_items
  from public.items
  where campaign_id = any(campaign_ids);
  if actual_items <> 21 then
    raise exception 'Seed abort: items expected %, got %', 21, actual_items;
  end if;

  select count(*) into actual_creatures
  from public.creatures
  where campaign_id = any(campaign_ids);
  if actual_creatures <> 18 then
    raise exception 'Seed abort: creatures expected %, got %', 18, actual_creatures;
  end if;

  select count(*) into actual_encounters
  from public.encounters
  where campaign_id = any(campaign_ids);
  if actual_encounters <> 18 then
    raise exception 'Seed abort: encounters expected %, got %', 18, actual_encounters;
  end if;

  select count(*) into actual_encounter_creatures
  from public.encounter_creatures
  where campaign_id = any(campaign_ids);
  if actual_encounter_creatures <> 21 then
    raise exception 'Seed abort: encounter_creatures expected %, got %',
      21, actual_encounter_creatures;
  end if;
end $$;

commit;

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
  select gen_random_uuid(), c.id, v.title, v.description, v.content, v.order_number
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
  select gen_random_uuid(), ch.id, ch.campaign_id, v.title, v.description, v.content, v.order_number
  from chapters ch
  join campaigns c on c.id = ch.campaign_id
  join (values
    ('Echoes of the Astral Sea', 'Stormwake Port', '1.1', 'The Siren Ledger', 'A cargo log hides a route.', '{}'::jsonb),
    ('Echoes of the Astral Sea', 'The Shattered Ring', '2.1', 'Gravemarsh Ambush', 'Raiders among the rocks.', '{}'::jsonb),
    ('Ember Crown Rebellion', 'Ashmarket', '1.1', 'Spark in the Mill', 'A strike turns violent.', '{}'::jsonb),
    ('Ember Crown Rebellion', 'The Red Citadel', '2.1', 'Masks at Court', 'A gala of knives.', '{}'::jsonb),
    ('Winter of the Hollow Sun', 'Frostmarch', '1.1', 'The Lost Patrol', 'A vanished scout team.', '{}'::jsonb),
    ('Winter of the Hollow Sun', 'The Drowned Vale', '2.1', 'Icebound Choir', 'Voices under the ice.', '{}'::jsonb)
  ) v(campaign_title, chapter_title, order_number, title, description, content)
  on v.campaign_title = c.title and v.chapter_title = ch.title
  returning id, campaign_id, chapter_id, title, order_number
),
scenes as (
  insert into public.scenes (id, adventure_id, campaign_id, title, description, content, order_number)
  select gen_random_uuid(), adv.id, adv.campaign_id, v.title, v.description, v.content, v.order_number
  from adventures adv
  join campaigns c on c.id = adv.campaign_id
  join (values
    ('Echoes of the Astral Sea', 'The Siren Ledger', '1.1.1', 'Dockside Interrogation', 'A tense chat at the piers.', '{}'::jsonb),
    ('Echoes of the Astral Sea', 'Gravemarsh Ambush', '2.1.1', 'Rockfall Run', 'A chase through drifting boulders.', '{}'::jsonb),
    ('Ember Crown Rebellion', 'Spark in the Mill', '1.1.1', 'Boiler Room', 'Steam and sabotage.', '{}'::jsonb),
    ('Ember Crown Rebellion', 'Masks at Court', '2.1.1', 'Moonlit Balcony', 'A whispered bargain.', '{}'::jsonb),
    ('Winter of the Hollow Sun', 'The Lost Patrol', '1.1.1', 'Frostline Trail', 'Tracks vanish in a blizzard.', '{}'::jsonb),
    ('Winter of the Hollow Sun', 'Icebound Choir', '2.1.1', 'Under the Ice', 'Echoes beneath the lake.', '{}'::jsonb)
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
campaign_scopes as (
  select cs.id as scope_id, cs.campaign_id, c.title as campaign_title
  from public.content_scopes cs
  join campaigns c on c.id = cs.campaign_id
  where cs.scope_type = 'campaign'
),
scene_scopes as (
  select cs.id as scope_id, cs.campaign_id, sc.title as scene_title, c.title as campaign_title
  from public.content_scopes cs
  join scenes sc on sc.id = cs.scene_id
  join campaigns c on c.id = sc.campaign_id
  where cs.scope_type = 'scene'
),
locations as (
  insert into public.locations (id, scope_id, campaign_id, name, description, content, data)
  select gen_random_uuid(), cs.scope_id, cs.campaign_id, v.name, v.description, v.content, v.data
  from campaign_scopes cs
  join (values
    ('Echoes of the Astral Sea', 'Stormwake Market', 'Orbital bazaar of salvage.', '{}'::jsonb, jsonb_build_object('tags', jsonb_build_array('market','orbital'))),
    ('Ember Crown Rebellion', 'Ashmarket Plaza', 'The rallying square.', '{}'::jsonb, jsonb_build_object('tags', jsonb_build_array('plaza','riot'))),
    ('Winter of the Hollow Sun', 'Frostmarch Keep', 'Wind-scarred fortress walls.', '{}'::jsonb, jsonb_build_object('tags', jsonb_build_array('fort','snow')))
  ) v(campaign_title, name, description, content, data)
  on v.campaign_title = cs.campaign_title
  returning id, campaign_id, name
),
organisations as (
  insert into public.organisations (id, scope_id, campaign_id, name, type, description, content, hq_location_id)
  select gen_random_uuid(), cs.scope_id, cs.campaign_id, v.name, v.type, v.description, v.content, l.id
  from campaign_scopes cs
  join (values
    ('Echoes of the Astral Sea', 'The Silver Compass', 'guild', 'Navigators who map the void.', '{}'::jsonb, 'Stormwake Market'),
    ('Ember Crown Rebellion', 'Ashmarket Union', 'faction', 'Workers pushing for reform.', '{}'::jsonb, 'Ashmarket Plaza'),
    ('Winter of the Hollow Sun', 'The Hollow Watch', 'order', 'Rangers guarding the frontier.', '{}'::jsonb, 'Frostmarch Keep')
  ) v(campaign_title, name, type, description, content, hq_location_name)
  on v.campaign_title = cs.campaign_title
  left join locations l on l.campaign_id = cs.campaign_id and l.name = v.hq_location_name
  returning id, campaign_id, name
),
items as (
  insert into public.items (id, scope_id, campaign_id, name, type, rarity, attunement, description, content, data)
  select gen_random_uuid(), cs.scope_id, cs.campaign_id, v.name, v.type, v.rarity, v.attunement, v.description, v.content, v.data
  from campaign_scopes cs
  join (values
    ('Echoes of the Astral Sea', 'Gravestone Compass', 'wondrous', 'rare', true, 'Points to the nearest starwell.', '{}'::jsonb, jsonb_build_object('charges', 3)),
    ('Ember Crown Rebellion', 'Cinderbrand Pike', 'weapon', 'uncommon', false, 'A spear that smolders at dawn.', '{}'::jsonb, jsonb_build_object('damage','1d8 piercing')),
    ('Winter of the Hollow Sun', 'Lantern of Thaw', 'wondrous', 'uncommon', false, 'Warms a small area against frost.', '{}'::jsonb, jsonb_build_object('radius','10ft'))
  ) v(campaign_title, name, type, rarity, attunement, description, content, data)
  on v.campaign_title = cs.campaign_title
  returning id, campaign_id, name
),
creatures as (
  insert into public.creatures (
    id, scope_id, campaign_id, organisation_id, name, kind, source, size, creature_type, subtype, alignment,
    challenge_rating_decimal, challenge_rating_text, experience_points, armor_class, hit_points, hit_dice,
    speed, ability_scores, saving_throws, skills, senses, languages,
    damage_resistances, damage_immunities, condition_immunities,
    traits, actions, reactions, legendary_actions, spellcasting,
    description, content, raw
  )
  select
    gen_random_uuid(),
    cs.scope_id,
    cs.campaign_id,
    o.id,
    v.name,
    v.kind,
    v.source,
    v.size,
    v.creature_type,
    v.subtype,
    v.alignment,
    v.cr_decimal,
    v.cr_text,
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
  from scene_scopes cs
  join (values
    ('Echoes of the Astral Sea', 'Dockside Interrogation', 'Silver Compass Corsair', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'chaotic neutral',
     2.000, '2', 450, 15, 27, '5d8+5',
     jsonb_build_object('walk','30 ft','fly','30 ft'), jsonb_build_object('str',12,'dex',16,'con',12,'int',13,'wis',10,'cha',14),
     '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb,
     '[]'::jsonb, '[]'::jsonb, '[]'::jsonb,
     jsonb_build_array(jsonb_build_object('name','Void Step','text','Teleport 10 ft as a bonus action.')),
     jsonb_build_array(jsonb_build_object('name','Cutlass','text','Melee Weapon Attack.')),
     '[]'::jsonb, '[]'::jsonb, '{}'::jsonb,
     'A privateer loyal to the Compass.', '{}'::jsonb, '{}'::jsonb),
    ('Ember Crown Rebellion', 'Boiler Room', 'Cinderbrand Enforcer', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'lawful evil',
     3.000, '3', 700, 16, 33, '6d8+6',
     jsonb_build_object('walk','30 ft'), jsonb_build_object('str',16,'dex',12,'con',14,'int',10,'wis',11,'cha',10),
     '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb,
     '[]'::jsonb, '[]'::jsonb, '[]'::jsonb,
     jsonb_build_array(jsonb_build_object('name','Intimidating Presence','text','Targets have disadvantage on checks.')),
     jsonb_build_array(jsonb_build_object('name','Pike','text','Melee Weapon Attack.')),
     '[]'::jsonb, '[]'::jsonb, '{}'::jsonb,
     'City guard turned enforcer.', '{}'::jsonb, '{}'::jsonb),
    ('Winter of the Hollow Sun', 'Under the Ice', 'Hollow Lake Wraith', 'creature', 'homebrew', 'medium', 'undead', null, 'neutral evil',
     4.000, '4', 1100, 15, 45, '6d8+18',
     jsonb_build_object('fly','40 ft','swim','40 ft'), jsonb_build_object('str',8,'dex',14,'con',16,'int',11,'wis',12,'cha',15),
     '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb,
     jsonb_build_array('cold'), '[]'::jsonb, '[]'::jsonb,
     jsonb_build_array(jsonb_build_object('name','Chilling Aura','text','Creatures within 10 ft take cold damage.')),
     jsonb_build_array(jsonb_build_object('name','Soul Drain','text','Melee Spell Attack.')),
     '[]'::jsonb, '[]'::jsonb, '{}'::jsonb,
     'A spirit bound beneath the ice.', '{}'::jsonb, '{}'::jsonb)
  ) v(
    campaign_title, scene_title, name, kind, source, size, creature_type, subtype, alignment,
    cr_decimal, cr_text, xp, ac, hp, hit_dice,
    speed, ability_scores, saving_throws, skills, senses, languages,
    damage_resistances, damage_immunities, condition_immunities,
    traits, actions, reactions, legendary_actions, spellcasting,
    description, content, raw
  )
  on v.campaign_title = cs.campaign_title and v.scene_title = cs.scene_title
  left join organisations o on o.campaign_id = cs.campaign_id
    and o.name = case
      when v.campaign_title = 'Echoes of the Astral Sea' then 'The Silver Compass'
      when v.campaign_title = 'Ember Crown Rebellion' then 'Ashmarket Union'
      else 'The Hollow Watch'
    end
  returning id, campaign_id, name
),
encounters as (
  insert into public.encounters (id, scope_id, campaign_id, title, description, content, data)
  select gen_random_uuid(), cs.scope_id, cs.campaign_id, v.title, v.description, v.content, v.data
  from scene_scopes cs
  join (values
    ('Echoes of the Astral Sea', 'Dockside Interrogation', 'Dockside Skirmish', 'Corsairs demand a toll.', '{}'::jsonb, jsonb_build_object('xp_budget', 450)),
    ('Ember Crown Rebellion', 'Boiler Room', 'Strikebreakers', 'An ambush in the mill.', '{}'::jsonb, jsonb_build_object('xp_budget', 700)),
    ('Winter of the Hollow Sun', 'Under the Ice', 'Lake Wraith', 'The ice cracks and something rises.', '{}'::jsonb, jsonb_build_object('xp_budget', 1100))
  ) v(campaign_title, scene_title, title, description, content, data)
  on v.campaign_title = cs.campaign_title and v.scene_title = cs.scene_title
  returning id, campaign_id, title
),
encounter_creatures as (
  insert into public.encounter_creatures (id, encounter_id, creature_id, campaign_id, quantity, initiative, notes)
  select
    gen_random_uuid(),
    e.id,
    c.id,
    e.campaign_id,
    2,
    12,
    'Primary threat.'
  from encounters e
  join creatures c on c.campaign_id = e.campaign_id
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
)
select 1;

commit;

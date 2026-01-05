-- ============================================================
-- Seed: Breath from the Deep Dark
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
    ('Breath from the Deep Dark', 'A coastal frontier heaves under a slow, unnatural tide as something old draws breath.', '{"ops": [{"insert": "Breath from the Deep Dark begins on a coast that has never been quiet, but now the tide speaks in a slow, deliberate inhale.\n\nThe sea withdraws farther each night, revealing streets of slick stone and barnacle glyphs that should have remained buried.\n\nFisher folk whisper of an old covenant with something that lives beyond light, a pact signed with lanterns and blood.\n\nThree powers vie to control the coming change: the Tidebound Council, the Lantern Guild, and the Brine Covenant that worships the deep.\n\nAcross five chapters the party must follow drowned roads, appease forgotten shrines, and chart a path through the Deep Dark Trench.\n\nThe Breath is not a storm or a beast. It is a memory that wants a body, and it will bargain with any who listen.\n\nEvery rescue, betrayal, and bargain leaves a stain of salt on the soul, and the sea counts each debt aloud.\n\nThe surface world is a thin skin over a patient abyss, and the abyss has learned the names of the heroes.\n\nBy the final chapter, the coast itself will kneel, and only a true sacrifice can silence the breathing deep.\n\nIf the party fails, the coast will learn to breathe underwater, and the world will forget the sound of air.\n"}]}'::jsonb)
  ) v(title, description, content)
  returning id, title
),
chapters as (
  insert into public.chapters (id, campaign_id, title, description, content, order_number)
  select gen_random_uuid(), c.id, v.title, v.description, v.content, v.order_number
  from campaigns c
  join (values
    ('Breath from the Deep Dark', '0', 'The Breath Beneath', 'Events in Prolog: The Breath Beneath pull the party deeper into the tide''s bargains.', '{"ops": [{"insert": "Prolog: The Breath Beneath opens with the coast shifting and the factions tightening their grip.\n\nEach scene tests the party''s resolve and reveals another layer of the Breath.\n\nThe chapter ends with a choice that changes the shape of the tide.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', '1', 'Salt and Silt', 'Events in Chapter I: Salt and Silt pull the party deeper into the tide''s bargains.', '{"ops": [{"insert": "Chapter I: Salt and Silt opens with the coast shifting and the factions tightening their grip.\n\nEach scene tests the party''s resolve and reveals another layer of the Breath.\n\nThe chapter ends with a choice that changes the shape of the tide.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', '2', 'The Drowned March', 'Events in Chapter II: The Drowned March pull the party deeper into the tide''s bargains.', '{"ops": [{"insert": "Chapter II: The Drowned March opens with the coast shifting and the factions tightening their grip.\n\nEach scene tests the party''s resolve and reveals another layer of the Breath.\n\nThe chapter ends with a choice that changes the shape of the tide.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', '3', 'Teeth of the Reef', 'Events in Chapter III: Teeth of the Reef pull the party deeper into the tide''s bargains.', '{"ops": [{"insert": "Chapter III: Teeth of the Reef opens with the coast shifting and the factions tightening their grip.\n\nEach scene tests the party''s resolve and reveals another layer of the Breath.\n\nThe chapter ends with a choice that changes the shape of the tide.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', '4', 'The Sunken Choir', 'Events in Chapter IV: The Sunken Choir pull the party deeper into the tide''s bargains.', '{"ops": [{"insert": "Chapter IV: The Sunken Choir opens with the coast shifting and the factions tightening their grip.\n\nEach scene tests the party''s resolve and reveals another layer of the Breath.\n\nThe chapter ends with a choice that changes the shape of the tide.\n"}]}'::jsonb)
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
    ('Breath from the Deep Dark', 'The Breath Beneath', '1', 'Murmurs at Tidegate', 'Trouble in murmurs at tidegate reveals another thread of the Breath.', '{"ops": [{"insert": "Murmurs at Tidegate drives the party toward the next clue in the Deep Dark.\n\nThe tension rises through negotiation, exploration, and the pull of the sea.\n\nBy the end, the party secures a hard-won advantage or debt.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'The Breath Beneath', '2', 'The Lantern Debt', 'Trouble in the lantern debt reveals another thread of the Breath.', '{"ops": [{"insert": "The Lantern Debt drives the party toward the next clue in the Deep Dark.\n\nThe tension rises through negotiation, exploration, and the pull of the sea.\n\nBy the end, the party secures a hard-won advantage or debt.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'The Breath Beneath', '3', 'Saltglass Pilgrimage', 'Trouble in saltglass pilgrimage reveals another thread of the Breath.', '{"ops": [{"insert": "Saltglass Pilgrimage drives the party toward the next clue in the Deep Dark.\n\nThe tension rises through negotiation, exploration, and the pull of the sea.\n\nBy the end, the party secures a hard-won advantage or debt.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'The Breath Beneath', '4', 'The Blackwind Wake', 'Trouble in the blackwind wake reveals another thread of the Breath.', '{"ops": [{"insert": "The Blackwind Wake drives the party toward the next clue in the Deep Dark.\n\nThe tension rises through negotiation, exploration, and the pull of the sea.\n\nBy the end, the party secures a hard-won advantage or debt.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Salt and Silt', '1', 'Siltborn Traders', 'Trouble in siltborn traders reveals another thread of the Breath.', '{"ops": [{"insert": "Siltborn Traders drives the party toward the next clue in the Deep Dark.\n\nThe tension rises through negotiation, exploration, and the pull of the sea.\n\nBy the end, the party secures a hard-won advantage or debt.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Salt and Silt', '2', 'The Borrowed Net', 'Trouble in the borrowed net reveals another thread of the Breath.', '{"ops": [{"insert": "The Borrowed Net drives the party toward the next clue in the Deep Dark.\n\nThe tension rises through negotiation, exploration, and the pull of the sea.\n\nBy the end, the party secures a hard-won advantage or debt.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Salt and Silt', '3', 'Driftwood Tribunal', 'Trouble in driftwood tribunal reveals another thread of the Breath.', '{"ops": [{"insert": "Driftwood Tribunal drives the party toward the next clue in the Deep Dark.\n\nThe tension rises through negotiation, exploration, and the pull of the sea.\n\nBy the end, the party secures a hard-won advantage or debt.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Salt and Silt', '4', 'Echoes in the Cistern', 'Trouble in echoes in the cistern reveals another thread of the Breath.', '{"ops": [{"insert": "Echoes in the Cistern drives the party toward the next clue in the Deep Dark.\n\nThe tension rises through negotiation, exploration, and the pull of the sea.\n\nBy the end, the party secures a hard-won advantage or debt.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'The Drowned March', '1', 'The Drowned Road', 'Trouble in the drowned road reveals another thread of the Breath.', '{"ops": [{"insert": "The Drowned Road drives the party toward the next clue in the Deep Dark.\n\nThe tension rises through negotiation, exploration, and the pull of the sea.\n\nBy the end, the party secures a hard-won advantage or debt.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'The Drowned March', '2', 'Marshlight Pact', 'Trouble in marshlight pact reveals another thread of the Breath.', '{"ops": [{"insert": "Marshlight Pact drives the party toward the next clue in the Deep Dark.\n\nThe tension rises through negotiation, exploration, and the pull of the sea.\n\nBy the end, the party secures a hard-won advantage or debt.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'The Drowned March', '3', 'Wreckers of Hollow Bay', 'Trouble in wreckers of hollow bay reveals another thread of the Breath.', '{"ops": [{"insert": "Wreckers of Hollow Bay drives the party toward the next clue in the Deep Dark.\n\nThe tension rises through negotiation, exploration, and the pull of the sea.\n\nBy the end, the party secures a hard-won advantage or debt.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'The Drowned March', '4', 'The Skin of the Storm', 'Trouble in the skin of the storm reveals another thread of the Breath.', '{"ops": [{"insert": "The Skin of the Storm drives the party toward the next clue in the Deep Dark.\n\nThe tension rises through negotiation, exploration, and the pull of the sea.\n\nBy the end, the party secures a hard-won advantage or debt.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Teeth of the Reef', '1', 'Reef of Knives', 'Trouble in reef of knives reveals another thread of the Breath.', '{"ops": [{"insert": "Reef of Knives drives the party toward the next clue in the Deep Dark.\n\nThe tension rises through negotiation, exploration, and the pull of the sea.\n\nBy the end, the party secures a hard-won advantage or debt.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Teeth of the Reef', '2', 'The Pearl Tithe', 'Trouble in the pearl tithe reveals another thread of the Breath.', '{"ops": [{"insert": "The Pearl Tithe drives the party toward the next clue in the Deep Dark.\n\nThe tension rises through negotiation, exploration, and the pull of the sea.\n\nBy the end, the party secures a hard-won advantage or debt.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Teeth of the Reef', '3', 'Cold Iron Kelp', 'Trouble in cold iron kelp reveals another thread of the Breath.', '{"ops": [{"insert": "Cold Iron Kelp drives the party toward the next clue in the Deep Dark.\n\nThe tension rises through negotiation, exploration, and the pull of the sea.\n\nBy the end, the party secures a hard-won advantage or debt.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Teeth of the Reef', '4', 'The Deep Dark Gate', 'Trouble in the deep dark gate reveals another thread of the Breath.', '{"ops": [{"insert": "The Deep Dark Gate drives the party toward the next clue in the Deep Dark.\n\nThe tension rises through negotiation, exploration, and the pull of the sea.\n\nBy the end, the party secures a hard-won advantage or debt.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'The Sunken Choir', '1', 'Choir of Bone', 'Trouble in choir of bone reveals another thread of the Breath.', '{"ops": [{"insert": "Choir of Bone drives the party toward the next clue in the Deep Dark.\n\nThe tension rises through negotiation, exploration, and the pull of the sea.\n\nBy the end, the party secures a hard-won advantage or debt.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'The Sunken Choir', '2', 'The Silent Anchor', 'Trouble in the silent anchor reveals another thread of the Breath.', '{"ops": [{"insert": "The Silent Anchor drives the party toward the next clue in the Deep Dark.\n\nThe tension rises through negotiation, exploration, and the pull of the sea.\n\nBy the end, the party secures a hard-won advantage or debt.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'The Sunken Choir', '3', 'Abyssal Coronation', 'Trouble in abyssal coronation reveals another thread of the Breath.', '{"ops": [{"insert": "Abyssal Coronation drives the party toward the next clue in the Deep Dark.\n\nThe tension rises through negotiation, exploration, and the pull of the sea.\n\nBy the end, the party secures a hard-won advantage or debt.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'The Sunken Choir', '4', 'Breath of the Deep Dark', 'Trouble in breath of the deep dark reveals another thread of the Breath.', '{"ops": [{"insert": "Breath of the Deep Dark drives the party toward the next clue in the Deep Dark.\n\nThe tension rises through negotiation, exploration, and the pull of the sea.\n\nBy the end, the party secures a hard-won advantage or debt.\n"}]}'::jsonb)
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
    ('Breath from the Deep Dark', 'Murmurs at Tidegate', '1', '1 Murmurs at Tidegate - First Omen', 'A first omen scene within murmurs at tidegate that forces a decision.', '{"ops": [{"insert": "0.1.1 Murmurs at Tidegate - First Omen opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Murmurs at Tidegate', '2', '2 Murmurs at Tidegate - Crossing', 'A crossing scene within murmurs at tidegate that forces a decision.', '{"ops": [{"insert": "0.1.2 Murmurs at Tidegate - Crossing opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Murmurs at Tidegate', '3', '3 Murmurs at Tidegate - Reckoning', 'A reckoning scene within murmurs at tidegate that forces a decision.', '{"ops": [{"insert": "0.1.3 Murmurs at Tidegate - Reckoning opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'The Lantern Debt', '1', '1 The Lantern Debt - First Omen', 'A first omen scene within the lantern debt that forces a decision.', '{"ops": [{"insert": "0.2.1 The Lantern Debt - First Omen opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'The Lantern Debt', '2', '2 The Lantern Debt - Crossing', 'A crossing scene within the lantern debt that forces a decision.', '{"ops": [{"insert": "0.2.2 The Lantern Debt - Crossing opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'The Lantern Debt', '3', '3 The Lantern Debt - Reckoning', 'A reckoning scene within the lantern debt that forces a decision.', '{"ops": [{"insert": "0.2.3 The Lantern Debt - Reckoning opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Saltglass Pilgrimage', '1', '1 Saltglass Pilgrimage - First Omen', 'A first omen scene within saltglass pilgrimage that forces a decision.', '{"ops": [{"insert": "0.3.1 Saltglass Pilgrimage - First Omen opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Saltglass Pilgrimage', '2', '2 Saltglass Pilgrimage - Crossing', 'A crossing scene within saltglass pilgrimage that forces a decision.', '{"ops": [{"insert": "0.3.2 Saltglass Pilgrimage - Crossing opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Saltglass Pilgrimage', '3', '3 Saltglass Pilgrimage - Reckoning', 'A reckoning scene within saltglass pilgrimage that forces a decision.', '{"ops": [{"insert": "0.3.3 Saltglass Pilgrimage - Reckoning opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'The Blackwind Wake', '1', '1 The Blackwind Wake - First Omen', 'A first omen scene within the blackwind wake that forces a decision.', '{"ops": [{"insert": "0.4.1 The Blackwind Wake - First Omen opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'The Blackwind Wake', '2', '2 The Blackwind Wake - Crossing', 'A crossing scene within the blackwind wake that forces a decision.', '{"ops": [{"insert": "0.4.2 The Blackwind Wake - Crossing opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'The Blackwind Wake', '3', '3 The Blackwind Wake - Reckoning', 'A reckoning scene within the blackwind wake that forces a decision.', '{"ops": [{"insert": "0.4.3 The Blackwind Wake - Reckoning opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Siltborn Traders', '1', '1 Siltborn Traders - First Omen', 'A first omen scene within siltborn traders that forces a decision.', '{"ops": [{"insert": "1.1.1 Siltborn Traders - First Omen opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Siltborn Traders', '2', '2 Siltborn Traders - Crossing', 'A crossing scene within siltborn traders that forces a decision.', '{"ops": [{"insert": "1.1.2 Siltborn Traders - Crossing opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Siltborn Traders', '3', '3 Siltborn Traders - Reckoning', 'A reckoning scene within siltborn traders that forces a decision.', '{"ops": [{"insert": "1.1.3 Siltborn Traders - Reckoning opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'The Borrowed Net', '1', '1 The Borrowed Net - First Omen', 'A first omen scene within the borrowed net that forces a decision.', '{"ops": [{"insert": "1.2.1 The Borrowed Net - First Omen opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'The Borrowed Net', '2', '2 The Borrowed Net - Crossing', 'A crossing scene within the borrowed net that forces a decision.', '{"ops": [{"insert": "1.2.2 The Borrowed Net - Crossing opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'The Borrowed Net', '3', '3 The Borrowed Net - Reckoning', 'A reckoning scene within the borrowed net that forces a decision.', '{"ops": [{"insert": "1.2.3 The Borrowed Net - Reckoning opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Driftwood Tribunal', '1', '1 Driftwood Tribunal - First Omen', 'A first omen scene within driftwood tribunal that forces a decision.', '{"ops": [{"insert": "1.3.1 Driftwood Tribunal - First Omen opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Driftwood Tribunal', '2', '2 Driftwood Tribunal - Crossing', 'A crossing scene within driftwood tribunal that forces a decision.', '{"ops": [{"insert": "1.3.2 Driftwood Tribunal - Crossing opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Driftwood Tribunal', '3', '3 Driftwood Tribunal - Reckoning', 'A reckoning scene within driftwood tribunal that forces a decision.', '{"ops": [{"insert": "1.3.3 Driftwood Tribunal - Reckoning opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Echoes in the Cistern', '1', '1 Echoes in the Cistern - First Omen', 'A first omen scene within echoes in the cistern that forces a decision.', '{"ops": [{"insert": "1.4.1 Echoes in the Cistern - First Omen opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Echoes in the Cistern', '2', '2 Echoes in the Cistern - Crossing', 'A crossing scene within echoes in the cistern that forces a decision.', '{"ops": [{"insert": "1.4.2 Echoes in the Cistern - Crossing opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Echoes in the Cistern', '3', '3 Echoes in the Cistern - Reckoning', 'A reckoning scene within echoes in the cistern that forces a decision.', '{"ops": [{"insert": "1.4.3 Echoes in the Cistern - Reckoning opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'The Drowned Road', '1', '1 The Drowned Road - First Omen', 'A first omen scene within the drowned road that forces a decision.', '{"ops": [{"insert": "2.1.1 The Drowned Road - First Omen opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'The Drowned Road', '2', '2 The Drowned Road - Crossing', 'A crossing scene within the drowned road that forces a decision.', '{"ops": [{"insert": "2.1.2 The Drowned Road - Crossing opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'The Drowned Road', '3', '3 The Drowned Road - Reckoning', 'A reckoning scene within the drowned road that forces a decision.', '{"ops": [{"insert": "2.1.3 The Drowned Road - Reckoning opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Marshlight Pact', '1', '1 Marshlight Pact - First Omen', 'A first omen scene within marshlight pact that forces a decision.', '{"ops": [{"insert": "2.2.1 Marshlight Pact - First Omen opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Marshlight Pact', '2', '2 Marshlight Pact - Crossing', 'A crossing scene within marshlight pact that forces a decision.', '{"ops": [{"insert": "2.2.2 Marshlight Pact - Crossing opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Marshlight Pact', '3', '3 Marshlight Pact - Reckoning', 'A reckoning scene within marshlight pact that forces a decision.', '{"ops": [{"insert": "2.2.3 Marshlight Pact - Reckoning opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Wreckers of Hollow Bay', '1', '1 Wreckers of Hollow Bay - First Omen', 'A first omen scene within wreckers of hollow bay that forces a decision.', '{"ops": [{"insert": "2.3.1 Wreckers of Hollow Bay - First Omen opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Wreckers of Hollow Bay', '2', '2 Wreckers of Hollow Bay - Crossing', 'A crossing scene within wreckers of hollow bay that forces a decision.', '{"ops": [{"insert": "2.3.2 Wreckers of Hollow Bay - Crossing opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Wreckers of Hollow Bay', '3', '3 Wreckers of Hollow Bay - Reckoning', 'A reckoning scene within wreckers of hollow bay that forces a decision.', '{"ops": [{"insert": "2.3.3 Wreckers of Hollow Bay - Reckoning opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'The Skin of the Storm', '1', '1 The Skin of the Storm - First Omen', 'A first omen scene within the skin of the storm that forces a decision.', '{"ops": [{"insert": "2.4.1 The Skin of the Storm - First Omen opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'The Skin of the Storm', '2', '2 The Skin of the Storm - Crossing', 'A crossing scene within the skin of the storm that forces a decision.', '{"ops": [{"insert": "2.4.2 The Skin of the Storm - Crossing opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'The Skin of the Storm', '3', '3 The Skin of the Storm - Reckoning', 'A reckoning scene within the skin of the storm that forces a decision.', '{"ops": [{"insert": "2.4.3 The Skin of the Storm - Reckoning opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Reef of Knives', '1', '1 Reef of Knives - First Omen', 'A first omen scene within reef of knives that forces a decision.', '{"ops": [{"insert": "3.1.1 Reef of Knives - First Omen opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Reef of Knives', '2', '2 Reef of Knives - Crossing', 'A crossing scene within reef of knives that forces a decision.', '{"ops": [{"insert": "3.1.2 Reef of Knives - Crossing opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Reef of Knives', '3', '3 Reef of Knives - Reckoning', 'A reckoning scene within reef of knives that forces a decision.', '{"ops": [{"insert": "3.1.3 Reef of Knives - Reckoning opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'The Pearl Tithe', '1', '1 The Pearl Tithe - First Omen', 'A first omen scene within the pearl tithe that forces a decision.', '{"ops": [{"insert": "3.2.1 The Pearl Tithe - First Omen opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'The Pearl Tithe', '2', '2 The Pearl Tithe - Crossing', 'A crossing scene within the pearl tithe that forces a decision.', '{"ops": [{"insert": "3.2.2 The Pearl Tithe - Crossing opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'The Pearl Tithe', '3', '3 The Pearl Tithe - Reckoning', 'A reckoning scene within the pearl tithe that forces a decision.', '{"ops": [{"insert": "3.2.3 The Pearl Tithe - Reckoning opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Cold Iron Kelp', '1', '1 Cold Iron Kelp - First Omen', 'A first omen scene within cold iron kelp that forces a decision.', '{"ops": [{"insert": "3.3.1 Cold Iron Kelp - First Omen opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Cold Iron Kelp', '2', '2 Cold Iron Kelp - Crossing', 'A crossing scene within cold iron kelp that forces a decision.', '{"ops": [{"insert": "3.3.2 Cold Iron Kelp - Crossing opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Cold Iron Kelp', '3', '3 Cold Iron Kelp - Reckoning', 'A reckoning scene within cold iron kelp that forces a decision.', '{"ops": [{"insert": "3.3.3 Cold Iron Kelp - Reckoning opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'The Deep Dark Gate', '1', '1 The Deep Dark Gate - First Omen', 'A first omen scene within the deep dark gate that forces a decision.', '{"ops": [{"insert": "3.4.1 The Deep Dark Gate - First Omen opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'The Deep Dark Gate', '2', '2 The Deep Dark Gate - Crossing', 'A crossing scene within the deep dark gate that forces a decision.', '{"ops": [{"insert": "3.4.2 The Deep Dark Gate - Crossing opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'The Deep Dark Gate', '3', '3 The Deep Dark Gate - Reckoning', 'A reckoning scene within the deep dark gate that forces a decision.', '{"ops": [{"insert": "3.4.3 The Deep Dark Gate - Reckoning opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Choir of Bone', '1', '1 Choir of Bone - First Omen', 'A first omen scene within choir of bone that forces a decision.', '{"ops": [{"insert": "4.1.1 Choir of Bone - First Omen opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Choir of Bone', '2', '2 Choir of Bone - Crossing', 'A crossing scene within choir of bone that forces a decision.', '{"ops": [{"insert": "4.1.2 Choir of Bone - Crossing opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Choir of Bone', '3', '3 Choir of Bone - Reckoning', 'A reckoning scene within choir of bone that forces a decision.', '{"ops": [{"insert": "4.1.3 Choir of Bone - Reckoning opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'The Silent Anchor', '1', '1 The Silent Anchor - First Omen', 'A first omen scene within the silent anchor that forces a decision.', '{"ops": [{"insert": "4.2.1 The Silent Anchor - First Omen opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'The Silent Anchor', '2', '2 The Silent Anchor - Crossing', 'A crossing scene within the silent anchor that forces a decision.', '{"ops": [{"insert": "4.2.2 The Silent Anchor - Crossing opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'The Silent Anchor', '3', '3 The Silent Anchor - Reckoning', 'A reckoning scene within the silent anchor that forces a decision.', '{"ops": [{"insert": "4.2.3 The Silent Anchor - Reckoning opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Abyssal Coronation', '1', '1 Abyssal Coronation - First Omen', 'A first omen scene within abyssal coronation that forces a decision.', '{"ops": [{"insert": "4.3.1 Abyssal Coronation - First Omen opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Abyssal Coronation', '2', '2 Abyssal Coronation - Crossing', 'A crossing scene within abyssal coronation that forces a decision.', '{"ops": [{"insert": "4.3.2 Abyssal Coronation - Crossing opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Abyssal Coronation', '3', '3 Abyssal Coronation - Reckoning', 'A reckoning scene within abyssal coronation that forces a decision.', '{"ops": [{"insert": "4.3.3 Abyssal Coronation - Reckoning opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Breath of the Deep Dark', '1', '1 Breath of the Deep Dark - First Omen', 'A first omen scene within breath of the deep dark that forces a decision.', '{"ops": [{"insert": "4.4.1 Breath of the Deep Dark - First Omen opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Breath of the Deep Dark', '2', '2 Breath of the Deep Dark - Crossing', 'A crossing scene within breath of the deep dark that forces a decision.', '{"ops": [{"insert": "4.4.2 Breath of the Deep Dark - Crossing opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb),
        ('Breath from the Deep Dark', 'Breath of the Deep Dark', '3', '3 Breath of the Deep Dark - Reckoning', 'A reckoning scene within breath of the deep dark that forces a decision.', '{"ops": [{"insert": "4.4.3 Breath of the Deep Dark - Reckoning opens with a clear signal from the sea and a pressing objective.\n\nPressure builds through rival moves and strange tides that complicate every plan.\n\nThe scene ends with a consequence that tightens the Breath''s hold on the coast.\n"}]}'::jsonb)
  ) v(campaign_title, adventure_title, order_number, title, description, content)
  on v.campaign_title = c.title and v.adventure_title = adv.title
  returning id, campaign_id, adventure_id, title, order_number
),
maps as (
  insert into public.maps (id, campaign_id, title, description, data)
  select gen_random_uuid(), c.id, v.title, v.description, v.data
  from campaigns c
  join (values
    ('Breath from the Deep Dark', 'Coast of Breath', 'Old harbors and exposed reefs.', '{"type": "region", "scale": "coast"}'::jsonb),
        ('Breath from the Deep Dark', 'Silted Underways', 'Canals and buried streets under the city.', '{"type": "city", "scale": "district"}'::jsonb),
        ('Breath from the Deep Dark', 'Deep Dark Trench', 'A descent into the abyss.', '{"type": "abyss", "scale": "void"}'::jsonb)
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
  insert into public.content_scopes (scope_type, campaign_id, chapter_id, adventure_id)
  select 'adventure', adv.campaign_id, adv.chapter_id, adv.id
  from adventures adv
  on conflict (adventure_id) where scope_type = 'adventure'
  do update set campaign_id = excluded.campaign_id, chapter_id = excluded.chapter_id
  returning id as scope_id, campaign_id, chapter_id, adventure_id
),
ensure_scene_scopes as (
  insert into public.content_scopes (scope_type, campaign_id, chapter_id, adventure_id, scene_id)
  select 'scene', sc.campaign_id, adv.chapter_id, sc.adventure_id, sc.id
  from scenes sc
  join adventures adv on adv.id = sc.adventure_id
  on conflict (scene_id) where scope_type = 'scene'
  do update set campaign_id = excluded.campaign_id, chapter_id = excluded.chapter_id, adventure_id = excluded.adventure_id
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
  select adv.id as adventure_id, adv.campaign_id, adv.chapter_id, lower(trim(adv.title)) as adventure_key
  from adventures adv
),
scene_map as (
  select sc.id as scene_id, sc.campaign_id, sc.adventure_id, adv.chapter_id, lower(trim(sc.title)) as scene_key
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
    ('Breath from the Deep Dark', 'Tidegate Harbor', 'Main port where the Breath is first heard.', '{}'::jsonb, '{"tags": ["campaign"]}'::jsonb),
        ('Breath from the Deep Dark', 'Siltspire Lighthouse', 'Signal tower that never goes dark.', '{}'::jsonb, '{"tags": ["campaign"]}'::jsonb),
        ('Breath from the Deep Dark', 'Deep Dark Trench', 'A scar in the sea that exhales cold.', '{}'::jsonb, '{"tags": ["campaign"]}'::jsonb)
  ) v(campaign_title, name, description, content, data)
  join campaign_map cm on cm.campaign_key = lower(trim(v.campaign_title))
  join campaign_scopes cs on cs.campaign_id = cm.campaign_id
  union all
  select gen_random_uuid(), cs.scope_id, cs.campaign_id, v.name, v.description, v.content, v.data
  from (values
    ('Breath from the Deep Dark', 'The Breath Beneath', 'Breathwatch Quay', 'A wind-bent quay that tastes of salt and iron.', '{}'::jsonb, '{"tags": ["chapter"]}'::jsonb),
        ('Breath from the Deep Dark', 'Salt and Silt', 'Salt and Silt Market', 'A bazaar built on drying canals and old anchors.', '{}'::jsonb, '{"tags": ["chapter"]}'::jsonb),
        ('Breath from the Deep Dark', 'The Drowned March', 'Drowned March Causeway', 'A drowned road lined with lantern poles.', '{}'::jsonb, '{"tags": ["chapter"]}'::jsonb),
        ('Breath from the Deep Dark', 'Teeth of the Reef', 'Knife Reef Outlook', 'A jagged overlook above the reef line.', '{}'::jsonb, '{"tags": ["chapter"]}'::jsonb),
        ('Breath from the Deep Dark', 'The Sunken Choir', 'Sunken Choir Vault', 'A hollow chamber where the choir gathers.', '{}'::jsonb, '{"tags": ["chapter"]}'::jsonb)
  ) v(campaign_title, chapter_title, name, description, content, data)
  join campaign_map cm on cm.campaign_key = lower(trim(v.campaign_title))
  join chapter_map chm on chm.campaign_id = cm.campaign_id and chm.chapter_key = lower(trim(v.chapter_title))
  join chapter_scopes cs on cs.chapter_id = chm.chapter_id
  union all
  select gen_random_uuid(), cs.scope_id, cs.campaign_id, v.name, v.description, v.content, v.data
  from (values
    ('Breath from the Deep Dark', 'Murmurs at Tidegate', '1 Murmurs at Tidegate Landing', 'A key site tied to murmurs at tidegate, marked by the Breath''s pull.', '{}'::jsonb, '{"tags": ["adventure"]}'::jsonb),
        ('Breath from the Deep Dark', 'The Lantern Debt', '2 The Lantern Debt Quay', 'A key site tied to the lantern debt, marked by the Breath''s pull.', '{}'::jsonb, '{"tags": ["adventure"]}'::jsonb),
        ('Breath from the Deep Dark', 'Saltglass Pilgrimage', '3 Saltglass Pilgrimage Cove', 'A key site tied to saltglass pilgrimage, marked by the Breath''s pull.', '{}'::jsonb, '{"tags": ["adventure"]}'::jsonb),
        ('Breath from the Deep Dark', 'The Blackwind Wake', '4 The Blackwind Wake Hall', 'A key site tied to the blackwind wake, marked by the Breath''s pull.', '{}'::jsonb, '{"tags": ["adventure"]}'::jsonb),
        ('Breath from the Deep Dark', 'Siltborn Traders', '1 Siltborn Traders Span', 'A key site tied to siltborn traders, marked by the Breath''s pull.', '{}'::jsonb, '{"tags": ["adventure"]}'::jsonb),
        ('Breath from the Deep Dark', 'The Borrowed Net', '2 The Borrowed Net Cistern', 'A key site tied to the borrowed net, marked by the Breath''s pull.', '{}'::jsonb, '{"tags": ["adventure"]}'::jsonb),
        ('Breath from the Deep Dark', 'Driftwood Tribunal', '3 Driftwood Tribunal Reef', 'A key site tied to driftwood tribunal, marked by the Breath''s pull.', '{}'::jsonb, '{"tags": ["adventure"]}'::jsonb),
        ('Breath from the Deep Dark', 'Echoes in the Cistern', '4 Echoes in the Cistern Chapel', 'A key site tied to echoes in the cistern, marked by the Breath''s pull.', '{}'::jsonb, '{"tags": ["adventure"]}'::jsonb),
        ('Breath from the Deep Dark', 'The Drowned Road', '1 The Drowned Road Vault', 'A key site tied to the drowned road, marked by the Breath''s pull.', '{}'::jsonb, '{"tags": ["adventure"]}'::jsonb),
        ('Breath from the Deep Dark', 'Marshlight Pact', '2 Marshlight Pact Crossing', 'A key site tied to marshlight pact, marked by the Breath''s pull.', '{}'::jsonb, '{"tags": ["adventure"]}'::jsonb),
        ('Breath from the Deep Dark', 'Wreckers of Hollow Bay', '3 Wreckers of Hollow Bay Jetty', 'A key site tied to wreckers of hollow bay, marked by the Breath''s pull.', '{}'::jsonb, '{"tags": ["adventure"]}'::jsonb),
        ('Breath from the Deep Dark', 'The Skin of the Storm', '4 The Skin of the Storm Grotto', 'A key site tied to the skin of the storm, marked by the Breath''s pull.', '{}'::jsonb, '{"tags": ["adventure"]}'::jsonb),
        ('Breath from the Deep Dark', 'Reef of Knives', '1 Reef of Knives Causeway', 'A key site tied to reef of knives, marked by the Breath''s pull.', '{}'::jsonb, '{"tags": ["adventure"]}'::jsonb),
        ('Breath from the Deep Dark', 'The Pearl Tithe', '2 The Pearl Tithe Weir', 'A key site tied to the pearl tithe, marked by the Breath''s pull.', '{}'::jsonb, '{"tags": ["adventure"]}'::jsonb),
        ('Breath from the Deep Dark', 'Cold Iron Kelp', '3 Cold Iron Kelp Gate', 'A key site tied to cold iron kelp, marked by the Breath''s pull.', '{}'::jsonb, '{"tags": ["adventure"]}'::jsonb),
        ('Breath from the Deep Dark', 'The Deep Dark Gate', '4 The Deep Dark Gate Trench', 'A key site tied to the deep dark gate, marked by the Breath''s pull.', '{}'::jsonb, '{"tags": ["adventure"]}'::jsonb),
        ('Breath from the Deep Dark', 'Choir of Bone', '1 Choir of Bone Wreck', 'A key site tied to choir of bone, marked by the Breath''s pull.', '{}'::jsonb, '{"tags": ["adventure"]}'::jsonb),
        ('Breath from the Deep Dark', 'The Silent Anchor', '2 The Silent Anchor Spire', 'A key site tied to the silent anchor, marked by the Breath''s pull.', '{}'::jsonb, '{"tags": ["adventure"]}'::jsonb),
        ('Breath from the Deep Dark', 'Abyssal Coronation', '3 Abyssal Coronation Anchorage', 'A key site tied to abyssal coronation, marked by the Breath''s pull.', '{}'::jsonb, '{"tags": ["adventure"]}'::jsonb),
        ('Breath from the Deep Dark', 'Breath of the Deep Dark', '4 Breath of the Deep Dark Tidepools', 'A key site tied to breath of the deep dark, marked by the Breath''s pull.', '{}'::jsonb, '{"tags": ["adventure"]}'::jsonb)
  ) v(campaign_title, adventure_title, name, description, content, data)
  join campaign_map cm on cm.campaign_key = lower(trim(v.campaign_title))
  join adventure_map am on am.campaign_id = cm.campaign_id and am.adventure_key = lower(trim(v.adventure_title))
  join adventure_scopes cs on cs.adventure_id = am.adventure_id
  returning id, campaign_id, name
),
location_map as (
  select l.id as location_id, l.campaign_id, lower(trim(l.name)) as location_key
  from locations l
),
organisations as (
  insert into public.organisations (id, scope_id, campaign_id, name, type, description, content, hq_location_id)
  select gen_random_uuid(), cs.scope_id, cs.campaign_id, v.name, v.type, v.description, v.content, lm.location_id
  from (values
    ('Breath from the Deep Dark', 'Tidebound Council', 'council', 'Keeps the old covenants and watches the tide.', '{}'::jsonb, 'Tidegate Harbor'),
        ('Breath from the Deep Dark', 'Lantern Guild', 'guild', 'Maintains the lighthouses and the secrets they hide.', '{}'::jsonb, 'Siltspire Lighthouse'),
        ('Breath from the Deep Dark', 'Brine Covenant', 'cult', 'Worshipers who want the deep to rise.', '{}'::jsonb, 'Deep Dark Trench')
  ) v(campaign_title, name, type, description, content, hq_location_name)
  join campaign_map cm on cm.campaign_key = lower(trim(v.campaign_title))
  join campaign_scopes cs on cs.campaign_id = cm.campaign_id
  left join location_map lm on lm.campaign_id = cm.campaign_id and lm.location_key = lower(trim(v.hq_location_name))
  union all
  select gen_random_uuid(), cs.scope_id, cs.campaign_id, v.name, v.type, v.description, v.content, lm.location_id
  from (values
    ('Breath from the Deep Dark', 'The Breath Beneath', 'Breathwatch Pilots', 'crew', 'Pilots who chart the exposed stones.', '{}'::jsonb, 'Breathwatch Quay'),
        ('Breath from the Deep Dark', 'Salt and Silt', 'Silt Market Brokers', 'guild', 'Traders who buy and sell in the low tide.', '{}'::jsonb, 'Salt and Silt Market'),
        ('Breath from the Deep Dark', 'The Drowned March', 'March Wardens', 'order', 'Wardens who keep the causeway safe.', '{}'::jsonb, 'Drowned March Causeway'),
        ('Breath from the Deep Dark', 'Teeth of the Reef', 'Reefcutters', 'crew', 'Salvagers who work the reef teeth.', '{}'::jsonb, 'Knife Reef Outlook'),
        ('Breath from the Deep Dark', 'The Sunken Choir', 'Choir Custodians', 'order', 'Keepers of the choir vault.', '{}'::jsonb, 'Sunken Choir Vault')
  ) v(campaign_title, chapter_title, name, type, description, content, hq_location_name)
  join campaign_map cm on cm.campaign_key = lower(trim(v.campaign_title))
  join chapter_map chm on chm.campaign_id = cm.campaign_id and chm.chapter_key = lower(trim(v.chapter_title))
  join chapter_scopes cs on cs.chapter_id = chm.chapter_id
  left join location_map lm on lm.campaign_id = cm.campaign_id and lm.location_key = lower(trim(v.hq_location_name))
  union all
  select gen_random_uuid(), cs.scope_id, cs.campaign_id, v.name, v.type, v.description, v.content, lm.location_id
  from (values
    ('Breath from the Deep Dark', 'Murmurs at Tidegate', 'Tidegate Runners', 'crew', 'Runners who move messages through the docks.', '{}'::jsonb, '1 Murmurs at Tidegate Landing'),
        ('Breath from the Deep Dark', 'The Lantern Debt', 'Lantern Debtors', 'cell', 'A cell bound by a dangerous loan.', '{}'::jsonb, '2 The Lantern Debt Quay'),
        ('Breath from the Deep Dark', 'Driftwood Tribunal', 'Driftwood Judges', 'circle', 'A council that settles tidal disputes.', '{}'::jsonb, '3 Driftwood Tribunal Reef'),
        ('Breath from the Deep Dark', 'Marshlight Pact', 'Marshlight Circle', 'circle', 'Marsh walkers bound by a luminous pact.', '{}'::jsonb, '2 Marshlight Pact Crossing'),
        ('Breath from the Deep Dark', 'Abyssal Coronation', 'Abyssal Heralds', 'cult', 'Voices that call the Breath by name.', '{}'::jsonb, '3 Abyssal Coronation Anchorage')
  ) v(campaign_title, adventure_title, name, type, description, content, hq_location_name)
  join campaign_map cm on cm.campaign_key = lower(trim(v.campaign_title))
  join adventure_map am on am.campaign_id = cm.campaign_id and am.adventure_key = lower(trim(v.adventure_title))
  join adventure_scopes cs on cs.adventure_id = am.adventure_id
  left join location_map lm on lm.campaign_id = cm.campaign_id and lm.location_key = lower(trim(v.hq_location_name))
  returning id, campaign_id, name
),
organisation_map as (
  select o.id as organisation_id, o.campaign_id, lower(trim(o.name)) as organisation_key
  from organisations o
),
items as (
  insert into public.items (id, scope_id, campaign_id, name, type, rarity, attunement, description, content, data)
  select gen_random_uuid(), cs.scope_id, cs.campaign_id, v.name, v.type, v.rarity, v.attunement, v.description, v.content, v.data
  from (values
    ('Breath from the Deep Dark', 'Tideglass Compass', 'wondrous', 'rare', true, 'Points toward the Breath when the tide turns.', '{}'::jsonb, '{"charges": 3}'::jsonb),
        ('Breath from the Deep Dark', 'Siltwoven Cloak', 'wondrous', 'uncommon', false, 'Turns damp air into a veil of mist.', '{}'::jsonb, '{"uses": 2}'::jsonb),
        ('Breath from the Deep Dark', 'Lantern of the Hollow', 'wondrous', 'rare', true, 'Reveals glyphs hidden by seawater.', '{}'::jsonb, '{"light": "cold"}'::jsonb),
        ('Breath from the Deep Dark', 'Blackwind Hook', 'weapon', 'uncommon', false, 'A hook blade that bites through rope and reed.', '{}'::jsonb, '{"damage": "1d6 slashing"}'::jsonb),
        ('Breath from the Deep Dark', 'Choirbone Token', 'wondrous', 'common', false, 'Sings softly when the deep draws near.', '{}'::jsonb, '{"whisper": "yes"}'::jsonb)
  ) v(campaign_title, name, type, rarity, attunement, description, content, data)
  join campaign_map cm on cm.campaign_key = lower(trim(v.campaign_title))
  join campaign_scopes cs on cs.campaign_id = cm.campaign_id
  returning id, campaign_id, name
),
creatures as (
  insert into public.creatures (
    id, scope_id, campaign_id, organisation_id, name, kind, source, size, creature_type, subtype, alignment,
    challenge_rating, experience_points, armor_class, hit_points, hit_dice,
    speed, ability_scores, saving_throws, skills, senses, languages,
    damage_resistances, damage_immunities, condition_immunities,
    traits, actions, reactions, legendary_actions, spellcasting,
    description, content, raw
  )
  select gen_random_uuid(), cs.scope_id, cs.campaign_id, om.organisation_id,
    v.name, v.kind, v.source, v.size, v.creature_type, v.subtype, v.alignment,
    v.cr_decimal, v.xp, v.ac, v.hp, v.hit_dice,
    v.speed, v.ability_scores, v.saving_throws, v.skills, v.senses, v.languages,
    v.damage_resistances, v.damage_immunities, v.condition_immunities,
    v.traits, v.actions, v.reactions, v.legendary_actions, v.spellcasting,
    v.description, v.content, v.raw
  from (values
    ('Breath from the Deep Dark', 'Tidebound Council', 'Harbor Matron Lysa', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'neutral', 1.000, '1', 200, 12, 18, '4d8', jsonb_build_object('walk','30 ft','swim','20 ft'), jsonb_build_object('str',10,'dex',12,'con',11,'int',11,'wis',12,'cha',12), '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, 'A key figure tied to the Tidebound Council.', '{}'::jsonb, '{}'::jsonb),
        ('Breath from the Deep Dark', 'Lantern Guild', 'Captain Orren Vale', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'neutral', 1.000, '1', 200, 12, 18, '4d8', jsonb_build_object('walk','30 ft','swim','20 ft'), jsonb_build_object('str',10,'dex',12,'con',11,'int',11,'wis',12,'cha',12), '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, 'A key figure tied to the Lantern Guild.', '{}'::jsonb, '{}'::jsonb),
        ('Breath from the Deep Dark', 'Brine Covenant', 'Archivist Sel', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'neutral', 1.000, '1', 200, 12, 18, '4d8', jsonb_build_object('walk','30 ft','swim','20 ft'), jsonb_build_object('str',10,'dex',12,'con',11,'int',11,'wis',12,'cha',12), '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, 'A keeper of the Brine Covenant records.', '{}'::jsonb, '{}'::jsonb),
        ('Breath from the Deep Dark', 'Tidebound Council', 'Tidebound Enforcer', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'neutral', 1.000, '1', 200, 12, 18, '4d8', jsonb_build_object('walk','30 ft','swim','20 ft'), jsonb_build_object('str',10,'dex',12,'con',11,'int',11,'wis',12,'cha',12), '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, 'An enforcer who collects Council debts.', '{}'::jsonb, '{}'::jsonb),
        ('Breath from the Deep Dark', 'Lantern Guild', 'Lantern Warden', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'neutral', 1.000, '1', 200, 12, 18, '4d8', jsonb_build_object('walk','30 ft','swim','20 ft'), jsonb_build_object('str',10,'dex',12,'con',11,'int',11,'wis',12,'cha',12), '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, 'A warden who patrols the lighthouse line.', '{}'::jsonb, '{}'::jsonb),
        ('Breath from the Deep Dark', 'Brine Covenant', 'Brine Acolyte', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'neutral', 1.000, '1', 200, 12, 18, '4d8', jsonb_build_object('walk','30 ft','swim','20 ft'), jsonb_build_object('str',10,'dex',12,'con',11,'int',11,'wis',12,'cha',12), '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, 'An acolyte who hears the deep breathing.', '{}'::jsonb, '{}'::jsonb)
  ) v(campaign_title, organisation_name, name, kind, source, size, creature_type, subtype, alignment,
    cr_decimal, cr_text, xp, ac, hp, hit_dice, speed, ability_scores, saving_throws, skills, senses, languages,
    damage_resistances, damage_immunities, condition_immunities, traits, actions, reactions, legendary_actions, spellcasting,
    description, content, raw)
  join campaign_map cm on cm.campaign_key = lower(trim(v.campaign_title))
  join campaign_scopes cs on cs.campaign_id = cm.campaign_id
  left join organisation_map om on om.campaign_id = cm.campaign_id and om.organisation_key = lower(trim(v.organisation_name))
  union all
  select gen_random_uuid(), cs.scope_id, cs.campaign_id, om.organisation_id,
    v.name, v.kind, v.source, v.size, v.creature_type, v.subtype, v.alignment,
    v.cr_decimal, v.xp, v.ac, v.hp, v.hit_dice,
    v.speed, v.ability_scores, v.saving_throws, v.skills, v.senses, v.languages,
    v.damage_resistances, v.damage_immunities, v.condition_immunities,
    v.traits, v.actions, v.reactions, v.legendary_actions, v.spellcasting,
    v.description, v.content, v.raw
  from (values
    ('Breath from the Deep Dark', null, 'Deep Dark Stalker', 'creature', 'homebrew', 'medium', 'monster', null, 'neutral', 2.000, '2', 450, 13, 24, '5d8', jsonb_build_object('walk','20 ft','swim','40 ft'), jsonb_build_object('str',14,'dex',12,'con',14,'int',6,'wis',10,'cha',8), '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, 'A threat that haunts the tide in Breath from the Deep Dark.', '{}'::jsonb, '{}'::jsonb),
        ('Breath from the Deep Dark', null, 'Silt Hound', 'creature', 'homebrew', 'medium', 'monster', null, 'neutral', 2.000, '2', 450, 13, 24, '5d8', jsonb_build_object('walk','20 ft','swim','40 ft'), jsonb_build_object('str',14,'dex',12,'con',14,'int',6,'wis',10,'cha',8), '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, 'A threat that haunts the tide in Breath from the Deep Dark.', '{}'::jsonb, '{}'::jsonb),
        ('Breath from the Deep Dark', null, 'Tide Wraith', 'creature', 'homebrew', 'medium', 'monster', null, 'neutral', 2.000, '2', 450, 13, 24, '5d8', jsonb_build_object('walk','20 ft','swim','40 ft'), jsonb_build_object('str',14,'dex',12,'con',14,'int',6,'wis',10,'cha',8), '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, 'A threat that haunts the tide in Breath from the Deep Dark.', '{}'::jsonb, '{}'::jsonb),
        ('Breath from the Deep Dark', null, 'Reef Maw', 'creature', 'homebrew', 'medium', 'monster', null, 'neutral', 2.000, '2', 450, 13, 24, '5d8', jsonb_build_object('walk','20 ft','swim','40 ft'), jsonb_build_object('str',14,'dex',12,'con',14,'int',6,'wis',10,'cha',8), '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, 'A threat that haunts the tide in Breath from the Deep Dark.', '{}'::jsonb, '{}'::jsonb),
        ('Breath from the Deep Dark', null, 'Echo Wisp', 'creature', 'homebrew', 'medium', 'monster', null, 'neutral', 2.000, '2', 450, 13, 24, '5d8', jsonb_build_object('walk','20 ft','swim','40 ft'), jsonb_build_object('str',14,'dex',12,'con',14,'int',6,'wis',10,'cha',8), '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, 'A threat that haunts the tide in Breath from the Deep Dark.', '{}'::jsonb, '{}'::jsonb)
  ) v(campaign_title, organisation_name, name, kind, source, size, creature_type, subtype, alignment,
    cr_decimal, cr_text, xp, ac, hp, hit_dice, speed, ability_scores, saving_throws, skills, senses, languages,
    damage_resistances, damage_immunities, condition_immunities, traits, actions, reactions, legendary_actions, spellcasting,
    description, content, raw)
  join campaign_map cm on cm.campaign_key = lower(trim(v.campaign_title))
  join campaign_scopes cs on cs.campaign_id = cm.campaign_id
  left join organisation_map om on om.campaign_id = cm.campaign_id and om.organisation_key = lower(trim(v.organisation_name))
  union all
  select gen_random_uuid(), cs.scope_id, cs.campaign_id, om.organisation_id,
    v.name, v.kind, v.source, v.size, v.creature_type, v.subtype, v.alignment,
    v.cr_decimal, v.xp, v.ac, v.hp, v.hit_dice,
    v.speed, v.ability_scores, v.saving_throws, v.skills, v.senses, v.languages,
    v.damage_resistances, v.damage_immunities, v.condition_immunities,
    v.traits, v.actions, v.reactions, v.legendary_actions, v.spellcasting,
    v.description, v.content, v.raw
  from (values
    ('Breath from the Deep Dark', 'Murmurs at Tidegate', 'Tidegate Runners', 'Guide 0.1', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'neutral', 1.000, '1', 200, 12, 18, '4d8', jsonb_build_object('walk','30 ft','swim','20 ft'), jsonb_build_object('str',10,'dex',12,'con',11,'int',11,'wis',12,'cha',12), '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, 'A local guide tied to murmurs at tidegate.', '{}'::jsonb, '{}'::jsonb),
        ('Breath from the Deep Dark', 'The Lantern Debt', 'Lantern Debtors', 'Guide 0.2', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'neutral', 1.000, '1', 200, 12, 18, '4d8', jsonb_build_object('walk','30 ft','swim','20 ft'), jsonb_build_object('str',10,'dex',12,'con',11,'int',11,'wis',12,'cha',12), '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, 'A local guide tied to the lantern debt.', '{}'::jsonb, '{}'::jsonb),
        ('Breath from the Deep Dark', 'Saltglass Pilgrimage', null, 'Guide 0.3', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'neutral', 1.000, '1', 200, 12, 18, '4d8', jsonb_build_object('walk','30 ft','swim','20 ft'), jsonb_build_object('str',10,'dex',12,'con',11,'int',11,'wis',12,'cha',12), '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, 'A local guide tied to saltglass pilgrimage.', '{}'::jsonb, '{}'::jsonb),
        ('Breath from the Deep Dark', 'The Blackwind Wake', null, 'Guide 0.4', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'neutral', 1.000, '1', 200, 12, 18, '4d8', jsonb_build_object('walk','30 ft','swim','20 ft'), jsonb_build_object('str',10,'dex',12,'con',11,'int',11,'wis',12,'cha',12), '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, 'A local guide tied to the blackwind wake.', '{}'::jsonb, '{}'::jsonb),
        ('Breath from the Deep Dark', 'Siltborn Traders', null, 'Guide 1.1', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'neutral', 1.000, '1', 200, 12, 18, '4d8', jsonb_build_object('walk','30 ft','swim','20 ft'), jsonb_build_object('str',10,'dex',12,'con',11,'int',11,'wis',12,'cha',12), '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, 'A local guide tied to siltborn traders.', '{}'::jsonb, '{}'::jsonb),
        ('Breath from the Deep Dark', 'The Borrowed Net', null, 'Guide 1.2', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'neutral', 1.000, '1', 200, 12, 18, '4d8', jsonb_build_object('walk','30 ft','swim','20 ft'), jsonb_build_object('str',10,'dex',12,'con',11,'int',11,'wis',12,'cha',12), '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, 'A local guide tied to the borrowed net.', '{}'::jsonb, '{}'::jsonb),
        ('Breath from the Deep Dark', 'Driftwood Tribunal', 'Driftwood Judges', 'Guide 1.3', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'neutral', 1.000, '1', 200, 12, 18, '4d8', jsonb_build_object('walk','30 ft','swim','20 ft'), jsonb_build_object('str',10,'dex',12,'con',11,'int',11,'wis',12,'cha',12), '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, 'A local guide tied to driftwood tribunal.', '{}'::jsonb, '{}'::jsonb),
        ('Breath from the Deep Dark', 'Echoes in the Cistern', null, 'Guide 1.4', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'neutral', 1.000, '1', 200, 12, 18, '4d8', jsonb_build_object('walk','30 ft','swim','20 ft'), jsonb_build_object('str',10,'dex',12,'con',11,'int',11,'wis',12,'cha',12), '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, 'A local guide tied to echoes in the cistern.', '{}'::jsonb, '{}'::jsonb),
        ('Breath from the Deep Dark', 'The Drowned Road', null, 'Guide 2.1', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'neutral', 1.000, '1', 200, 12, 18, '4d8', jsonb_build_object('walk','30 ft','swim','20 ft'), jsonb_build_object('str',10,'dex',12,'con',11,'int',11,'wis',12,'cha',12), '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, 'A local guide tied to the drowned road.', '{}'::jsonb, '{}'::jsonb),
        ('Breath from the Deep Dark', 'Marshlight Pact', 'Marshlight Circle', 'Guide 2.2', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'neutral', 1.000, '1', 200, 12, 18, '4d8', jsonb_build_object('walk','30 ft','swim','20 ft'), jsonb_build_object('str',10,'dex',12,'con',11,'int',11,'wis',12,'cha',12), '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, 'A local guide tied to marshlight pact.', '{}'::jsonb, '{}'::jsonb),
        ('Breath from the Deep Dark', 'Wreckers of Hollow Bay', null, 'Guide 2.3', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'neutral', 1.000, '1', 200, 12, 18, '4d8', jsonb_build_object('walk','30 ft','swim','20 ft'), jsonb_build_object('str',10,'dex',12,'con',11,'int',11,'wis',12,'cha',12), '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, 'A local guide tied to wreckers of hollow bay.', '{}'::jsonb, '{}'::jsonb),
        ('Breath from the Deep Dark', 'The Skin of the Storm', null, 'Guide 2.4', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'neutral', 1.000, '1', 200, 12, 18, '4d8', jsonb_build_object('walk','30 ft','swim','20 ft'), jsonb_build_object('str',10,'dex',12,'con',11,'int',11,'wis',12,'cha',12), '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, 'A local guide tied to the skin of the storm.', '{}'::jsonb, '{}'::jsonb),
        ('Breath from the Deep Dark', 'Reef of Knives', null, 'Guide 3.1', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'neutral', 1.000, '1', 200, 12, 18, '4d8', jsonb_build_object('walk','30 ft','swim','20 ft'), jsonb_build_object('str',10,'dex',12,'con',11,'int',11,'wis',12,'cha',12), '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, 'A local guide tied to reef of knives.', '{}'::jsonb, '{}'::jsonb),
        ('Breath from the Deep Dark', 'The Pearl Tithe', null, 'Guide 3.2', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'neutral', 1.000, '1', 200, 12, 18, '4d8', jsonb_build_object('walk','30 ft','swim','20 ft'), jsonb_build_object('str',10,'dex',12,'con',11,'int',11,'wis',12,'cha',12), '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, 'A local guide tied to the pearl tithe.', '{}'::jsonb, '{}'::jsonb),
        ('Breath from the Deep Dark', 'Cold Iron Kelp', null, 'Guide 3.3', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'neutral', 1.000, '1', 200, 12, 18, '4d8', jsonb_build_object('walk','30 ft','swim','20 ft'), jsonb_build_object('str',10,'dex',12,'con',11,'int',11,'wis',12,'cha',12), '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, 'A local guide tied to cold iron kelp.', '{}'::jsonb, '{}'::jsonb),
        ('Breath from the Deep Dark', 'The Deep Dark Gate', null, 'Guide 3.4', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'neutral', 1.000, '1', 200, 12, 18, '4d8', jsonb_build_object('walk','30 ft','swim','20 ft'), jsonb_build_object('str',10,'dex',12,'con',11,'int',11,'wis',12,'cha',12), '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, 'A local guide tied to the deep dark gate.', '{}'::jsonb, '{}'::jsonb),
        ('Breath from the Deep Dark', 'Choir of Bone', null, 'Guide 4.1', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'neutral', 1.000, '1', 200, 12, 18, '4d8', jsonb_build_object('walk','30 ft','swim','20 ft'), jsonb_build_object('str',10,'dex',12,'con',11,'int',11,'wis',12,'cha',12), '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, 'A local guide tied to choir of bone.', '{}'::jsonb, '{}'::jsonb),
        ('Breath from the Deep Dark', 'The Silent Anchor', null, 'Guide 4.2', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'neutral', 1.000, '1', 200, 12, 18, '4d8', jsonb_build_object('walk','30 ft','swim','20 ft'), jsonb_build_object('str',10,'dex',12,'con',11,'int',11,'wis',12,'cha',12), '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, 'A local guide tied to the silent anchor.', '{}'::jsonb, '{}'::jsonb),
        ('Breath from the Deep Dark', 'Abyssal Coronation', 'Abyssal Heralds', 'Guide 4.3', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'neutral', 1.000, '1', 200, 12, 18, '4d8', jsonb_build_object('walk','30 ft','swim','20 ft'), jsonb_build_object('str',10,'dex',12,'con',11,'int',11,'wis',12,'cha',12), '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, 'A local guide tied to abyssal coronation.', '{}'::jsonb, '{}'::jsonb),
        ('Breath from the Deep Dark', 'Breath of the Deep Dark', null, 'Guide 4.4', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'neutral', 1.000, '1', 200, 12, 18, '4d8', jsonb_build_object('walk','30 ft','swim','20 ft'), jsonb_build_object('str',10,'dex',12,'con',11,'int',11,'wis',12,'cha',12), '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, 'A local guide tied to breath of the deep dark.', '{}'::jsonb, '{}'::jsonb)
  ) v(campaign_title, adventure_title, organisation_name, name, kind, source, size, creature_type, subtype, alignment,
    cr_decimal, cr_text, xp, ac, hp, hit_dice, speed, ability_scores, saving_throws, skills, senses, languages,
    damage_resistances, damage_immunities, condition_immunities, traits, actions, reactions, legendary_actions, spellcasting,
    description, content, raw)
  join campaign_map cm on cm.campaign_key = lower(trim(v.campaign_title))
  join adventure_map am on am.campaign_id = cm.campaign_id and am.adventure_key = lower(trim(v.adventure_title))
  join adventure_scopes cs on cs.adventure_id = am.adventure_id
  left join organisation_map om on om.campaign_id = cm.campaign_id and om.organisation_key = lower(trim(v.organisation_name))
  union all
  select gen_random_uuid(), cs.scope_id, cs.campaign_id, om.organisation_id,
    v.name, v.kind, v.source, v.size, v.creature_type, v.subtype, v.alignment,
    v.cr_decimal, v.xp, v.ac, v.hp, v.hit_dice,
    v.speed, v.ability_scores, v.saving_throws, v.skills, v.senses, v.languages,
    v.damage_resistances, v.damage_immunities, v.condition_immunities,
    v.traits, v.actions, v.reactions, v.legendary_actions, v.spellcasting,
    v.description, v.content, v.raw
  from (values
    ('Breath from the Deep Dark', 'The Breath Beneath', 'Breathwatch Pilots', 'Pilot Jori', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'neutral', 1.000, '1', 200, 12, 18, '4d8', jsonb_build_object('walk','30 ft','swim','20 ft'), jsonb_build_object('str',10,'dex',12,'con',11,'int',11,'wis',12,'cha',12), '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, 'A chapter contact in Prolog: The Breath Beneath.', '{}'::jsonb, '{}'::jsonb),
        ('Breath from the Deep Dark', 'Salt and Silt', 'Silt Market Brokers', 'Broker Mina', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'neutral', 1.000, '1', 200, 12, 18, '4d8', jsonb_build_object('walk','30 ft','swim','20 ft'), jsonb_build_object('str',10,'dex',12,'con',11,'int',11,'wis',12,'cha',12), '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, 'A chapter contact in Chapter I: Salt and Silt.', '{}'::jsonb, '{}'::jsonb),
        ('Breath from the Deep Dark', 'The Drowned March', 'March Wardens', 'Warden Hollis', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'neutral', 1.000, '1', 200, 12, 18, '4d8', jsonb_build_object('walk','30 ft','swim','20 ft'), jsonb_build_object('str',10,'dex',12,'con',11,'int',11,'wis',12,'cha',12), '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, 'A chapter contact in Chapter II: The Drowned March.', '{}'::jsonb, '{}'::jsonb),
        ('Breath from the Deep Dark', 'Teeth of the Reef', 'Reefcutters', 'Reefcutter Sarn', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'neutral', 1.000, '1', 200, 12, 18, '4d8', jsonb_build_object('walk','30 ft','swim','20 ft'), jsonb_build_object('str',10,'dex',12,'con',11,'int',11,'wis',12,'cha',12), '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, 'A chapter contact in Chapter III: Teeth of the Reef.', '{}'::jsonb, '{}'::jsonb),
        ('Breath from the Deep Dark', 'The Sunken Choir', 'Choir Custodians', 'Custodian Elda', 'npc', 'homebrew', 'medium', 'humanoid', 'human', 'neutral', 1.000, '1', 200, 12, 18, '4d8', jsonb_build_object('walk','30 ft','swim','20 ft'), jsonb_build_object('str',10,'dex',12,'con',11,'int',11,'wis',12,'cha',12), '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, 'A chapter contact in Chapter IV: The Sunken Choir.', '{}'::jsonb, '{}'::jsonb)
  ) v(campaign_title, chapter_title, organisation_name, name, kind, source, size, creature_type, subtype, alignment,
    cr_decimal, cr_text, xp, ac, hp, hit_dice, speed, ability_scores, saving_throws, skills, senses, languages,
    damage_resistances, damage_immunities, condition_immunities, traits, actions, reactions, legendary_actions, spellcasting,
    description, content, raw)
  join campaign_map cm on cm.campaign_key = lower(trim(v.campaign_title))
  join chapter_map chm on chm.campaign_id = cm.campaign_id and chm.chapter_key = lower(trim(v.chapter_title))
  join chapter_scopes cs on cs.chapter_id = chm.chapter_id
  left join organisation_map om on om.campaign_id = cm.campaign_id and om.organisation_key = lower(trim(v.organisation_name))
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
    ('Breath from the Deep Dark', '1 Murmurs at Tidegate - First Omen', 'Encounter 0.1.1', 'A confrontation triggered during 0.1.1 murmurs at tidegate - first omen.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '2 Murmurs at Tidegate - Crossing', 'Encounter 0.1.2', 'A confrontation triggered during 0.1.2 murmurs at tidegate - crossing.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '3 Murmurs at Tidegate - Reckoning', 'Encounter 0.1.3', 'A confrontation triggered during 0.1.3 murmurs at tidegate - reckoning.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '1 The Lantern Debt - First Omen', 'Encounter 0.2.1', 'A confrontation triggered during 0.2.1 the lantern debt - first omen.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '2 The Lantern Debt - Crossing', 'Encounter 0.2.2', 'A confrontation triggered during 0.2.2 the lantern debt - crossing.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '3 The Lantern Debt - Reckoning', 'Encounter 0.2.3', 'A confrontation triggered during 0.2.3 the lantern debt - reckoning.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '1 Saltglass Pilgrimage - First Omen', 'Encounter 0.3.1', 'A confrontation triggered during 0.3.1 saltglass pilgrimage - first omen.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '2 Saltglass Pilgrimage - Crossing', 'Encounter 0.3.2', 'A confrontation triggered during 0.3.2 saltglass pilgrimage - crossing.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '3 Saltglass Pilgrimage - Reckoning', 'Encounter 0.3.3', 'A confrontation triggered during 0.3.3 saltglass pilgrimage - reckoning.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '1 The Blackwind Wake - First Omen', 'Encounter 0.4.1', 'A confrontation triggered during 0.4.1 the blackwind wake - first omen.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '2 The Blackwind Wake - Crossing', 'Encounter 0.4.2', 'A confrontation triggered during 0.4.2 the blackwind wake - crossing.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '3 The Blackwind Wake - Reckoning', 'Encounter 0.4.3', 'A confrontation triggered during 0.4.3 the blackwind wake - reckoning.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '1 Siltborn Traders - First Omen', 'Encounter 1.1.1', 'A confrontation triggered during 1.1.1 siltborn traders - first omen.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '2 Siltborn Traders - Crossing', 'Encounter 1.1.2', 'A confrontation triggered during 1.1.2 siltborn traders - crossing.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '3 Siltborn Traders - Reckoning', 'Encounter 1.1.3', 'A confrontation triggered during 1.1.3 siltborn traders - reckoning.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '1 The Borrowed Net - First Omen', 'Encounter 1.2.1', 'A confrontation triggered during 1.2.1 the borrowed net - first omen.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '2 The Borrowed Net - Crossing', 'Encounter 1.2.2', 'A confrontation triggered during 1.2.2 the borrowed net - crossing.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '3 The Borrowed Net - Reckoning', 'Encounter 1.2.3', 'A confrontation triggered during 1.2.3 the borrowed net - reckoning.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '1 Driftwood Tribunal - First Omen', 'Encounter 1.3.1', 'A confrontation triggered during 1.3.1 driftwood tribunal - first omen.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '2 Driftwood Tribunal - Crossing', 'Encounter 1.3.2', 'A confrontation triggered during 1.3.2 driftwood tribunal - crossing.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '3 Driftwood Tribunal - Reckoning', 'Encounter 1.3.3', 'A confrontation triggered during 1.3.3 driftwood tribunal - reckoning.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '1 Echoes in the Cistern - First Omen', 'Encounter 1.4.1', 'A confrontation triggered during 1.4.1 echoes in the cistern - first omen.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '2 Echoes in the Cistern - Crossing', 'Encounter 1.4.2', 'A confrontation triggered during 1.4.2 echoes in the cistern - crossing.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '3 Echoes in the Cistern - Reckoning', 'Encounter 1.4.3', 'A confrontation triggered during 1.4.3 echoes in the cistern - reckoning.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '1 The Drowned Road - First Omen', 'Encounter 2.1.1', 'A confrontation triggered during 2.1.1 the drowned road - first omen.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '2 The Drowned Road - Crossing', 'Encounter 2.1.2', 'A confrontation triggered during 2.1.2 the drowned road - crossing.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '3 The Drowned Road - Reckoning', 'Encounter 2.1.3', 'A confrontation triggered during 2.1.3 the drowned road - reckoning.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '1 Marshlight Pact - First Omen', 'Encounter 2.2.1', 'A confrontation triggered during 2.2.1 marshlight pact - first omen.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '2 Marshlight Pact - Crossing', 'Encounter 2.2.2', 'A confrontation triggered during 2.2.2 marshlight pact - crossing.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '3 Marshlight Pact - Reckoning', 'Encounter 2.2.3', 'A confrontation triggered during 2.2.3 marshlight pact - reckoning.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '1 Wreckers of Hollow Bay - First Omen', 'Encounter 2.3.1', 'A confrontation triggered during 2.3.1 wreckers of hollow bay - first omen.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '2 Wreckers of Hollow Bay - Crossing', 'Encounter 2.3.2', 'A confrontation triggered during 2.3.2 wreckers of hollow bay - crossing.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '3 Wreckers of Hollow Bay - Reckoning', 'Encounter 2.3.3', 'A confrontation triggered during 2.3.3 wreckers of hollow bay - reckoning.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '1 The Skin of the Storm - First Omen', 'Encounter 2.4.1', 'A confrontation triggered during 2.4.1 the skin of the storm - first omen.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '2 The Skin of the Storm - Crossing', 'Encounter 2.4.2', 'A confrontation triggered during 2.4.2 the skin of the storm - crossing.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '3 The Skin of the Storm - Reckoning', 'Encounter 2.4.3', 'A confrontation triggered during 2.4.3 the skin of the storm - reckoning.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '1 Reef of Knives - First Omen', 'Encounter 3.1.1', 'A confrontation triggered during 3.1.1 reef of knives - first omen.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '2 Reef of Knives - Crossing', 'Encounter 3.1.2', 'A confrontation triggered during 3.1.2 reef of knives - crossing.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '3 Reef of Knives - Reckoning', 'Encounter 3.1.3', 'A confrontation triggered during 3.1.3 reef of knives - reckoning.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '1 The Pearl Tithe - First Omen', 'Encounter 3.2.1', 'A confrontation triggered during 3.2.1 the pearl tithe - first omen.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '2 The Pearl Tithe - Crossing', 'Encounter 3.2.2', 'A confrontation triggered during 3.2.2 the pearl tithe - crossing.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '3 The Pearl Tithe - Reckoning', 'Encounter 3.2.3', 'A confrontation triggered during 3.2.3 the pearl tithe - reckoning.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '1 Cold Iron Kelp - First Omen', 'Encounter 3.3.1', 'A confrontation triggered during 3.3.1 cold iron kelp - first omen.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '2 Cold Iron Kelp - Crossing', 'Encounter 3.3.2', 'A confrontation triggered during 3.3.2 cold iron kelp - crossing.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '3 Cold Iron Kelp - Reckoning', 'Encounter 3.3.3', 'A confrontation triggered during 3.3.3 cold iron kelp - reckoning.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '1 The Deep Dark Gate - First Omen', 'Encounter 3.4.1', 'A confrontation triggered during 3.4.1 the deep dark gate - first omen.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '2 The Deep Dark Gate - Crossing', 'Encounter 3.4.2', 'A confrontation triggered during 3.4.2 the deep dark gate - crossing.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '3 The Deep Dark Gate - Reckoning', 'Encounter 3.4.3', 'A confrontation triggered during 3.4.3 the deep dark gate - reckoning.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '1 Choir of Bone - First Omen', 'Encounter 4.1.1', 'A confrontation triggered during 4.1.1 choir of bone - first omen.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '2 Choir of Bone - Crossing', 'Encounter 4.1.2', 'A confrontation triggered during 4.1.2 choir of bone - crossing.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '3 Choir of Bone - Reckoning', 'Encounter 4.1.3', 'A confrontation triggered during 4.1.3 choir of bone - reckoning.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '1 The Silent Anchor - First Omen', 'Encounter 4.2.1', 'A confrontation triggered during 4.2.1 the silent anchor - first omen.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '2 The Silent Anchor - Crossing', 'Encounter 4.2.2', 'A confrontation triggered during 4.2.2 the silent anchor - crossing.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '3 The Silent Anchor - Reckoning', 'Encounter 4.2.3', 'A confrontation triggered during 4.2.3 the silent anchor - reckoning.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '1 Abyssal Coronation - First Omen', 'Encounter 4.3.1', 'A confrontation triggered during 4.3.1 abyssal coronation - first omen.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '2 Abyssal Coronation - Crossing', 'Encounter 4.3.2', 'A confrontation triggered during 4.3.2 abyssal coronation - crossing.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '3 Abyssal Coronation - Reckoning', 'Encounter 4.3.3', 'A confrontation triggered during 4.3.3 abyssal coronation - reckoning.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '1 Breath of the Deep Dark - First Omen', 'Encounter 4.4.1', 'A confrontation triggered during 4.4.1 breath of the deep dark - first omen.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '2 Breath of the Deep Dark - Crossing', 'Encounter 4.4.2', 'A confrontation triggered during 4.4.2 breath of the deep dark - crossing.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb),
        ('Breath from the Deep Dark', '3 Breath of the Deep Dark - Reckoning', 'Encounter 4.4.3', 'A confrontation triggered during 4.4.3 breath of the deep dark - reckoning.', '{}'::jsonb, '{"xp_budget": 450}'::jsonb)
  ) v(campaign_title, scene_title, title, description, content, data)
  join campaign_map cm on cm.campaign_key = lower(trim(v.campaign_title))
  join scene_map sm on sm.campaign_id = cm.campaign_id and sm.scene_key = lower(trim(v.scene_title))
  join scene_scopes cs on cs.scene_id = sm.scene_id
  returning id, campaign_id, title
),
encounter_map as (
  select e.id as encounter_id, e.campaign_id, lower(trim(e.title)) as encounter_key
  from encounters e
),
encounter_creatures as (
  insert into public.encounter_creatures (id, encounter_id, creature_id, campaign_id, quantity, initiative, notes)
  select gen_random_uuid(), em.encounter_id, crm.creature_id, em.campaign_id, v.quantity, v.initiative, v.notes
  from (values
    ('Breath from the Deep Dark', 'Encounter 0.1.1', 'Deep Dark Stalker', 1, 10, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 0.1.1', 'Harbor Matron Lysa', 1, 12, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 0.1.2', 'Silt Hound', 2, 11, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 0.1.2', 'Captain Orren Vale', 1, 13, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 0.1.3', 'Tide Wraith', 3, 12, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 0.1.3', 'Archivist Sel', 1, 14, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 0.2.1', 'Reef Maw', 1, 13, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 0.2.1', 'Tidebound Enforcer', 1, 15, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 0.2.2', 'Echo Wisp', 2, 14, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 0.2.2', 'Lantern Warden', 1, 16, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 0.2.3', 'Harbor Matron Lysa', 3, 15, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 0.2.3', 'Brine Acolyte', 1, 17, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 0.3.1', 'Captain Orren Vale', 1, 16, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 0.3.1', 'Pilot Jori', 1, 12, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 0.3.2', 'Archivist Sel', 2, 17, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 0.3.2', 'Broker Mina', 1, 13, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 0.3.3', 'Tidebound Enforcer', 3, 10, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 0.3.3', 'Warden Hollis', 1, 14, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 0.4.1', 'Lantern Warden', 1, 11, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 0.4.1', 'Reefcutter Sarn', 1, 15, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 0.4.2', 'Brine Acolyte', 2, 12, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 0.4.2', 'Custodian Elda', 1, 16, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 0.4.3', 'Pilot Jori', 3, 13, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 0.4.3', 'Guide 0.1', 1, 17, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 1.1.1', 'Broker Mina', 1, 14, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 1.1.1', 'Guide 0.2', 1, 12, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 1.1.2', 'Warden Hollis', 2, 15, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 1.1.2', 'Guide 1.1', 1, 13, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 1.1.3', 'Reefcutter Sarn', 3, 16, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 1.1.3', 'Guide 2.2', 1, 14, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 1.2.1', 'Custodian Elda', 1, 17, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 1.2.1', 'Guide 3.4', 1, 15, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 1.2.2', 'Guide 0.1', 2, 10, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 1.2.2', 'Guide 4.3', 1, 16, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 1.2.3', 'Guide 0.2', 3, 11, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 1.2.3', 'Deep Dark Stalker', 1, 17, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 1.3.1', 'Guide 1.1', 1, 12, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 1.3.1', 'Silt Hound', 1, 12, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 1.3.2', 'Guide 2.2', 2, 13, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 1.3.2', 'Tide Wraith', 1, 13, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 1.3.3', 'Guide 3.4', 3, 14, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 1.3.3', 'Reef Maw', 1, 14, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 1.4.1', 'Guide 4.3', 1, 15, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 1.4.1', 'Echo Wisp', 1, 15, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 1.4.2', 'Deep Dark Stalker', 2, 16, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 1.4.2', 'Harbor Matron Lysa', 1, 16, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 1.4.3', 'Silt Hound', 3, 17, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 1.4.3', 'Captain Orren Vale', 1, 17, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 2.1.1', 'Tide Wraith', 1, 10, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 2.1.1', 'Archivist Sel', 1, 12, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 2.1.2', 'Reef Maw', 2, 11, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 2.1.2', 'Tidebound Enforcer', 1, 13, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 2.1.3', 'Echo Wisp', 3, 12, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 2.1.3', 'Lantern Warden', 1, 14, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 2.2.1', 'Harbor Matron Lysa', 1, 13, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 2.2.1', 'Brine Acolyte', 1, 15, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 2.2.2', 'Captain Orren Vale', 2, 14, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 2.2.2', 'Pilot Jori', 1, 16, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 2.2.3', 'Archivist Sel', 3, 15, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 2.2.3', 'Broker Mina', 1, 17, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 2.3.1', 'Tidebound Enforcer', 1, 16, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 2.3.1', 'Warden Hollis', 1, 12, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 2.3.2', 'Lantern Warden', 2, 17, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 2.3.2', 'Reefcutter Sarn', 1, 13, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 2.3.3', 'Brine Acolyte', 3, 10, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 2.3.3', 'Custodian Elda', 1, 14, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 2.4.1', 'Pilot Jori', 1, 11, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 2.4.1', 'Guide 0.1', 1, 15, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 2.4.2', 'Broker Mina', 2, 12, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 2.4.2', 'Guide 0.2', 1, 16, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 2.4.3', 'Warden Hollis', 3, 13, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 2.4.3', 'Guide 1.1', 1, 17, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 3.1.1', 'Reefcutter Sarn', 1, 14, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 3.1.1', 'Guide 2.2', 1, 12, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 3.1.2', 'Custodian Elda', 2, 15, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 3.1.2', 'Guide 3.4', 1, 13, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 3.1.3', 'Guide 0.1', 3, 16, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 3.1.3', 'Guide 4.3', 1, 14, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 3.2.1', 'Guide 0.2', 1, 17, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 3.2.1', 'Deep Dark Stalker', 1, 15, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 3.2.2', 'Guide 1.1', 2, 10, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 3.2.2', 'Silt Hound', 1, 16, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 3.2.3', 'Guide 2.2', 3, 11, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 3.2.3', 'Tide Wraith', 1, 17, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 3.3.1', 'Guide 3.4', 1, 12, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 3.3.1', 'Reef Maw', 1, 12, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 3.3.2', 'Guide 4.3', 2, 13, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 3.3.2', 'Echo Wisp', 1, 13, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 3.3.3', 'Deep Dark Stalker', 3, 14, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 3.3.3', 'Harbor Matron Lysa', 1, 14, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 3.4.1', 'Silt Hound', 1, 15, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 3.4.1', 'Captain Orren Vale', 1, 15, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 3.4.2', 'Tide Wraith', 2, 16, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 3.4.2', 'Archivist Sel', 1, 16, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 3.4.3', 'Reef Maw', 3, 17, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 3.4.3', 'Tidebound Enforcer', 1, 17, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 4.1.1', 'Echo Wisp', 1, 10, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 4.1.1', 'Lantern Warden', 1, 12, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 4.1.2', 'Harbor Matron Lysa', 2, 11, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 4.1.2', 'Brine Acolyte', 1, 13, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 4.1.3', 'Captain Orren Vale', 3, 12, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 4.1.3', 'Pilot Jori', 1, 14, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 4.2.1', 'Archivist Sel', 1, 13, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 4.2.1', 'Broker Mina', 1, 15, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 4.2.2', 'Tidebound Enforcer', 2, 14, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 4.2.2', 'Warden Hollis', 1, 16, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 4.2.3', 'Lantern Warden', 3, 15, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 4.2.3', 'Reefcutter Sarn', 1, 17, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 4.3.1', 'Brine Acolyte', 1, 16, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 4.3.1', 'Custodian Elda', 1, 12, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 4.3.2', 'Pilot Jori', 2, 17, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 4.3.2', 'Guide 0.1', 1, 13, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 4.3.3', 'Broker Mina', 3, 10, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 4.3.3', 'Guide 0.2', 1, 14, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 4.4.1', 'Warden Hollis', 1, 11, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 4.4.1', 'Guide 1.1', 1, 15, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 4.4.2', 'Reefcutter Sarn', 2, 12, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 4.4.2', 'Guide 2.2', 1, 16, 'Secondary threat.'),
        ('Breath from the Deep Dark', 'Encounter 4.4.3', 'Custodian Elda', 3, 13, 'Primary threat.'),
        ('Breath from the Deep Dark', 'Encounter 4.4.3', 'Guide 3.4', 1, 17, 'Secondary threat.')
  ) v(campaign_title, encounter_title, creature_name, quantity, initiative, notes)
  join campaign_map cm on cm.campaign_key = lower(trim(v.campaign_title))
  join encounter_map em on em.campaign_id = cm.campaign_id and em.encounter_key = lower(trim(v.encounter_title))
  join creature_map crm on crm.campaign_id = cm.campaign_id and crm.creature_key = lower(trim(v.creature_name))
  returning id
)
select
  (select count(*) from campaigns) as campaigns_created,
  (select count(*) from chapters) as chapters_created,
  (select count(*) from adventures) as adventures_created,
  (select count(*) from scenes) as scenes_created,
  (select count(*) from maps) as maps_created,
  (select count(*) from locations) as locations_created,
  (select count(*) from organisations) as organisations_created,
  (select count(*) from items) as items_created,
  (select count(*) from creatures) as creatures_created,
  (select count(*) from encounters) as encounters_created,
  (select count(*) from encounter_creatures) as encounter_creatures_created;

do $$
declare
  seed_user uuid := 'be4b8621-b222-4a9c-8a4b-d8eac240bd4f'::uuid;
  campaign_ids uuid[];
  actual_locations int;
  actual_organisations int;
  actual_items int;
  actual_creatures int;
  actual_encounters int;
  actual_encounter_creatures int;
begin
  select array_agg(id) into campaign_ids
  from public.campaigns
  where created_by = seed_user
    and title in (
      'Breath from the Deep Dark'
    );

  if campaign_ids is null then
    raise exception 'Seed abort: no campaigns found for seed user %', seed_user;
  end if;

  select count(*) into actual_locations
  from public.locations
  where campaign_id = any(campaign_ids);
  if actual_locations <> 28 then
    raise exception 'Seed abort: locations expected %, got %', 28, actual_locations;
  end if;

  select count(*) into actual_organisations
  from public.organisations
  where campaign_id = any(campaign_ids);
  if actual_organisations <> 13 then
    raise exception 'Seed abort: organisations expected %, got %', 13, actual_organisations;
  end if;

  select count(*) into actual_items
  from public.items
  where campaign_id = any(campaign_ids);
  if actual_items <> 5 then
    raise exception 'Seed abort: items expected %, got %', 5, actual_items;
  end if;

  select count(*) into actual_creatures
  from public.creatures
  where campaign_id = any(campaign_ids);
  if actual_creatures <> 36 then
    raise exception 'Seed abort: creatures expected %, got %', 36, actual_creatures;
  end if;

  select count(*) into actual_encounters
  from public.encounters
  where campaign_id = any(campaign_ids);
  if actual_encounters <> 60 then
    raise exception 'Seed abort: encounters expected %, got %', 60, actual_encounters;
  end if;

  select count(*) into actual_encounter_creatures
  from public.encounter_creatures
  where campaign_id = any(campaign_ids);
  if actual_encounter_creatures <> 120 then
    raise exception 'Seed abort: encounter_creatures expected %, got %',
      120, actual_encounter_creatures;
  end if;
end $$;

commit;


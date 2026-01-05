# Data Fetching Guide (Moonforge)

This project fetches app data from a local Drift database that is kept in sync
with Supabase through PowerSync. The UI reads streams from repositories and
Riverpod providers, so it stays live as sync updates arrive.

## High-level flow

1. Supabase handles auth and provides a backend for sync.
2. PowerSync syncs data into a local SQLite database.
3. Drift exposes tables and views as typed models.
4. Repositories (under `moonforge/lib/data/stores/`) expose streams and CRUD.
5. Riverpod providers pipe those streams into widgets.

Key files:
- `moonforge/lib/data/powersync.dart` initializes PowerSync and exposes sync state.
- `moonforge/lib/data/database.dart` defines the Drift database and provider.
- `moonforge/lib/data/models/database_classes.g.dart` defines table models.
- `moonforge/lib/data/views.dart` defines scoped views (entities + scopes).
- `moonforge/lib/data/stores/*.dart` define repositories and providers.
- `moonforge/lib/data/ref_extensions.dart` adds helpers like `watchByScopes`.

## Data models and schema

Tables are generated in `moonforge/lib/data/models/database_classes.g.dart`.
These types (e.g. `CampaignsTableData`, `ChaptersTableData`) are what you read
from and write to the repositories.

PowerSync schema is defined in `moonforge/lib/data/models/powersync-schema.dart`
and determines which tables are synced locally.

## Fetching patterns in the app

There are three common ways to fetch data:

### 1) Watch "all records" via a StreamNotifier provider

Use the `*Provider` defined in each store file for a simple list stream.
Example in `moonforge/lib/features/campaign_overview/campaign_overview_page.dart`:

```dart
final campaigns = ref.watch(campaignProvider);

if (campaigns.isLoading) {
  return content(null);
}
if (campaigns.hasError) {
  return Text('Error: ${campaigns.error}');
}

final campaign = _findCampaign(campaigns.value, campaignId);
```

This is backed by the repository in `moonforge/lib/data/stores/campaign.dart`:

```dart
class CampaignRepository {
  Stream<List<CampaignsTableData>> watchAll() {
    return _db.select(_db.campaignsTable).watch();
  }
}
```

### 2) Watch filtered data directly from repositories

Use repository methods like `watchByCampaignId` or `watchByChapterId` to stream
filtered results. Example in `moonforge/lib/features/campaign_overview/widgets/chapters_list.dart`:

```dart
final Stream<List<ChaptersTableData>>? chapters = widget.campaignId == null
    ? null
    : ref
        .watch(chaptersRepositoryProvider)
        .watchByCampaignId(widget.campaignId!);

StreamBuilder<List<ChaptersTableData>>(
  stream: chapters,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return placeholderList();
    }
    if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    }
    final chapterItems = (snapshot.data ?? []);
    // ...
  },
)
```

This pattern is used across repositories in `moonforge/lib/data/stores/`.

### 3) Watch entities by content scope (chapter/adventure/scene)

Entity tables use `content_scopes` to model where content belongs. The helper
methods in `moonforge/lib/core/providers/ref_extensions.dart` resolve scope IDs
and call repository `watchByScopes`.

Example from `moonforge/lib/features/chapter/chapter_page.dart`:

```dart
final locationsStream = ref.watchByScopes(
  chapterId: widget.chapterId,
  watchByScopes: (scopeIds) =>
      ref.watch(locationsRepositoryProvider).watchByScopes(scopeIds),
);
```

Important: `watchByScopes` requires exactly one scope ID (`campaignId`,
`chapterId`, `adventureId`, or `sceneId`). It throws if you pass none or more
than one.

### Combining multiple streams

For pages that need multiple datasets, use `multiple_stream_builder` like
`StreamBuilder3` and `StreamBuilder5` (see
`moonforge/lib/features/chapter/chapter_page.dart`):

```dart
return StreamBuilder3<CampaignsTableData?, ChaptersTableData?, List<AdventuresTableData>>(
  streams: StreamTuple3(campaignStream, chapterStream, adventuresStream),
  initialData: InitialDataTuple3(null, null, const <AdventuresTableData>[]),
  builder: (context, snapshots) {
    // Handle loading and errors per stream.
  },
);
```

This keeps UI logic localized while still letting each stream update
independently.

### Filtering streams in-place

`moonforge/lib/data/stores/creatures.dart` defines stream extensions like
`whereKind` and `whereNotKind` that map/filter a stream of creatures:

```dart
final npcsStream = ref.watchByScopes(
  chapterId: widget.chapterId,
  watchByScopes: (scopeIds) => ref
      .watch(creaturesRepositoryProvider)
      .watchByScopes(scopeIds)
      .whereKind('NPC'),
);
```

This is a cheap way to filter without introducing additional queries.

## Using the database directly (advanced)

If a query does not exist yet in a repository, you can access the database
directly via `driftDatabase` from `moonforge/lib/data/database.dart`:

```dart
final db = ref.watch(driftDatabase);
final query = db.select(db.chaptersTable)
  ..where((t) => t.campaignId.equals(campaignId));
final rows = await query.get();
```

If the query is needed in multiple places, prefer adding it to a repository in
`moonforge/lib/data/stores/` and exposing it through a provider.

## Common references in the codebase

- `moonforge/lib/features/dashboard/dashboard.dart` uses `campaignProvider` for
  a simple list of campaigns.
- `moonforge/lib/features/campaign/widgets/campaign_sidebar.dart` watches
  multiple providers (`campaignProvider`, `chaptersProvider`, `adventuresProvider`,
  `scenesProvider`) and builds a tree view.
- `moonforge/lib/features/chapter/chapter_page.dart` shows combined streams and
  scope-based fetching.

## Error and loading handling

- For StreamNotifier providers: use `AsyncValue` (`isLoading`, `hasError`,
  `.value`).
- For StreamBuilder: use `snapshot.connectionState` and `snapshot.hasError`.
- Provide placeholders for loading states (see skeletons in
  `moonforge/lib/features/chapter/chapter_page.dart` and
  `moonforge/lib/features/campaign_overview/widgets/chapters_list.dart`).

## If you add a new data fetch

1. Add a repository method in the matching file under `moonforge/lib/data/stores/`.
2. Expose it through a provider or `ref_extensions.dart` if it is widely used.
3. Use `ref.watch()` + StreamBuilder or StreamNotifier provider in the UI.
4. Keep scope-based filters in `ref_extensions.dart` to avoid duplicate logic.

## Notes about sync

- The app does not query Supabase directly for content; it reads from the local
  Drift database which PowerSync keeps updated.
- Auth state comes from Supabase (`moonforge/lib/data/supabase.dart`) and controls
  when PowerSync connects (`moonforge/lib/data/powersync.dart`).

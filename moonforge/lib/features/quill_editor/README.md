# Quill Mention Feature

This module provides mention, hashtag, and story link support for the Quill editor in Moonforge.

## Features

- **@ Mentions**: Autocomplete for creatures and organisations
- **# Hashtags**: Autocomplete for locations, items, and encounters
- **$ Story Links**: Autocomplete for chapters, adventures, and scenes
- **Clickable Links**: View entity details by clicking on mentions in the viewer
- **RTL Support**: Automatic detection and support for right-to-left text

## Usage

### Basic Editor with Mentions

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/features/quill_editor/quill_editor.dart';

// In your widget state:
final _quillController = QuillController.basic();
final _editorKey = GlobalKey();
String? _campaignId; // Set this to your current campaign ID

// In a ConsumerState/ConsumerWidget build method:
CustomQuillEditor(
  controller: _quillController,
  keyForPosition: _editorKey,
  onSearchEntities: (kinds, query) async {
    final mentionService = ref.read(entityMentionServiceProvider);
    return mentionService.searchEntities(
      campaignId: _campaignId!,
      kinds: kinds,
      query: query,
      limit: 10,
    );
  },
  padding: const EdgeInsets.all(16),
  maxHeight: 400,
)
```

### Viewer with Clickable Mentions

```dart
import 'package:moonforge/features/quill_editor/quill_editor.dart';

CustomQuillViewer(
  controller: _quillController,
  onMentionTap: (entityId, mentionType) async {
    // Navigate to entity details
  },
  padding: const EdgeInsets.all(16),
)
```

## Entity Types

### @ Mentions

- **creature**: Creatures (including NPCs)
- **organisation**: Organisations and factions

### # Hashtags

- **location**: Locations and places
- **item**: Items and equipment
- **encounter**: Encounters

### $ Story Links

- **chapter**: Chapters
- **adventure**: Adventures
- **scene**: Scenes

## Implementation Details

### Data Format

Mentions, hashtags, and story links are stored as Quill links with special prefixes:

- Mentions: `-moonforge-mention-entity-{entityId}`
- Hashtags: `-moonforge-hashtag-entity-{entityId}`
- Story: `-moonforge-story-entity-{entityId}`

### Keyboard Shortcuts

- **Enter**: Insert the first suggestion from the list
- **Alt+Enter**: Insert a newline without submitting
- **Space/Newline**: Close the suggestion overlay

## Testing

To test the mention feature:

1. Create some entities in your campaign (NPCs, locations, items, etc.)
2. Open a screen with the CustomQuillEditor
3. Type '@' to see creature/organisation suggestions
4. Type '#' to see location/item/encounter suggestions
5. Type '$' to see chapter/adventure/scene suggestions
6. Select an entity from the list or press Enter
7. The entity name will be inserted as a clickable link
8. In the viewer, click the link to navigate to the entity details

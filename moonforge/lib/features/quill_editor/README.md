# Quill Mention Feature

This module provides mention and hashtag support for the Quill editor in Moonforge.

## Features

- **@ Mentions**: Autocomplete for creatures and organisations
- **# Hashtags**: Autocomplete for locations, items, and campaign content
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

- **npc**: Non-player characters
- **creature**: Creatures (non-NPC)
- **organisation**: Organisations and factions

### # Hashtags

- **location**: Locations and places
- **item**: Items and equipment
- **map**: Maps
- **chapter**: Chapters
- **adventure**: Adventures
- **scene**: Scenes
- **encounter**: Encounters

## Implementation Details

### Data Format

Mentions and hashtags are stored as Quill links with special prefixes:

- Mentions: `-moonforge-mention-entity-{entityId}`
- Hashtags: `-moonforge-hashtag-entity-{entityId}`

### Keyboard Shortcuts

- **Enter**: Insert the first suggestion from the list
- **Alt+Enter**: Insert a newline without submitting
- **Space/Newline**: Close the suggestion overlay

## Testing

To test the mention feature:

1. Create some entities in your campaign (NPCs, locations, items, etc.)
2. Open a screen with the CustomQuillEditor
3. Type '@' to see NPC/creature/organisation suggestions
4. Type '#' to see location/item/map/chapter suggestions
5. Select an entity from the list or press Enter
6. The entity name will be inserted as a clickable link
7. In the viewer, click the link to navigate to the entity details

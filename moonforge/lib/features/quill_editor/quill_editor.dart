/// Custom Quill editor and viewer with mention support for Moonforge entities.
///
/// Provides:
/// - [CustomQuillEditor]: Editor with '@', '#', and '$' mention autocomplete
/// - [CustomQuillViewer]: Viewer with clickable mention links
/// - [EntityMentionService]: Service for fetching entities
/// - [prefixHashtag], [prefixMention], and [prefixStory]: Constants for link prefixes
library;

export 'widgets/custom_quill_editor.dart';
export 'widgets/custom_quill_viewer.dart';
export 'widgets/quill_toolbar.dart';
export 'quill_mention_constants.dart';
export 'service/entity_mention_service.dart';

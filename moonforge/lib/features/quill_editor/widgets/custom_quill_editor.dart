import 'package:flutter/material.dart' show Material, InkWell, ListTile;
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:intl/intl.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/features/quill_editor/quill_mention_constants.dart';
import 'package:moonforge/features/quill_editor/service/entity_mention_service.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Custom Quill editor with mention support for entities.
///
/// Supports:
/// - '@' for creatures and organisations
/// - '#' for locations, items, and encounters
/// - '$' for chapters, adventures, and scenes
class CustomQuillEditor extends StatefulWidget {
  final GlobalKey? keyForPosition;
  final QuillController controller;
  final Future<List<MentionEntity>> Function(String kind, String query)?
  onSearchEntities;
  final FocusNode? focusNode;
  final EdgeInsets padding;
  final double? maxHeight;
  final double? minHeight;
  final bool readOnly;
  final List<EmbedBuilder>? embedBuilders;

  const CustomQuillEditor({
    super.key,
    required this.controller,
    this.keyForPosition,
    this.onSearchEntities,
    this.focusNode,
    this.padding = const EdgeInsets.all(8),
    this.maxHeight,
    this.minHeight,
    this.readOnly = false,
    this.embedBuilders,
  });

  @override
  State<CustomQuillEditor> createState() => _CustomQuillEditorState();
}

class _CustomQuillEditorState extends State<CustomQuillEditor> {
  static const Map<String, String> _tagKindMap = {
    '@': 'creature,organisation',
    '#': 'item,location,encounter',
    r'$': 'chapter,adventure,scene',
  };

  static const Map<String, String> _tagPrefixMap = {
    '@': prefixMention,
    '#': prefixHashtag,
    r'$': prefixStory,
  };

  late final QuillController _controller;
  late final FocusNode _focusNode;

  String? _currentTaggingCharacter;
  OverlayEntry? _suggestionOverlayEntry;
  bool _isEditorLTR = true;
  int? _lastTagIndex = -1;
  final ValueNotifier<List<MentionEntity>> _entitySuggestions = ValueNotifier(
    [],
  );

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _focusNode = widget.focusNode ?? FocusNode();
    _controller.addListener(_editorListener);
    _focusNode.addListener(_focusListener);
    _controller.readOnly = widget.readOnly;
  }

  @override
  void dispose() {
    _controller.removeListener(_editorListener);
    _focusNode.removeListener(_focusListener);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.keyForPosition,
      child: QuillEditor.basic(
        controller: _controller,
        focusNode: _focusNode,
        config: QuillEditorConfig(
          padding: widget.padding,
          maxHeight: widget.maxHeight,
          minHeight: widget.minHeight,
          showCursor: !widget.readOnly,
          customShortcuts: const <ShortcutActivator, Intent>{
            SingleActivator(LogicalKeyboardKey.enter, alt: true):
                AltEnterIntent(SelectionChangedCause.keyboard),
            SingleActivator(LogicalKeyboardKey.enter): EnterIntent(
              SelectionChangedCause.keyboard,
            ),
          },
          customActions: <Type, Action<Intent>>{
            AltEnterIntent: QuillEditorAltEnterAction(_controller),
            EnterIntent: QuillEditorEnterAction(
              onEnterPressedOnKeyboard: () {
                if ((_suggestionOverlayEntry?.mounted ?? false)) {
                  // Insert first visible item from list
                  if (_entitySuggestions.value.isNotEmpty) {
                    _onTapOverlaySuggestionItem(_entitySuggestions.value.first);
                  }
                }
              },
            ),
          },
          customStyles: defaultMentionStyles,
          embedBuilders:
              widget.embedBuilders ??
              FlutterQuillEmbeds.defaultEditorBuilders(),
        ),
      ),
    );
  }

  void _editorListener() {
    try {
      final index = _controller.selection.baseOffset;
      final value = _controller.plainTextEditingValue.text;

      if (value.trim().isEmpty) {
        _removeOverlay();
        return;
      }

      if (index < 1) return;

      final newString = value.substring(index - 1, index);

      // Check text directionality
      if (newString != ' ' && newString != '\n') {
        _checkEditorTextDirection(newString);
      }
      if (newString == '\n') {
        _isEditorLTR = true;
      }

      // Detect tagging characters for entity suggestions
      if (_tagKindMap.containsKey(newString)) {
        _currentTaggingCharacter = newString;
        if (_suggestionOverlayEntry == null &&
            !(_suggestionOverlayEntry?.mounted ?? false)) {
          _lastTagIndex = _controller.selection.baseOffset;
          _showSuggestionOverlay();
        }
      }

      // Close overlay on space or newline
      if ((newString == ' ' || newString == '\n') &&
          _suggestionOverlayEntry != null &&
          _suggestionOverlayEntry!.mounted) {
        _removeOverlay();
      }

      // Update suggestions based on typed text
      if (_lastTagIndex != -1 &&
          _suggestionOverlayEntry != null &&
          (_suggestionOverlayEntry?.mounted ?? false)) {
        var searchText = value
            .substring(_lastTagIndex!, index)
            .replaceAll('\n', '')
            .toLowerCase();
        _searchEntities(searchText);
      }
    } catch (e) {
      logger.e('Exception in editor listener: $e');
    }
  }

  void _showSuggestionOverlay() {
    if (widget.keyForPosition?.currentContext == null) return;

    _suggestionOverlayEntry = _createSuggestionOverlay();
    Overlay.of(context).insert(_suggestionOverlayEntry!);
    _searchEntities(''); // Show all entities initially
  }

  void _removeOverlay() {
    try {
      if (_suggestionOverlayEntry != null && _suggestionOverlayEntry!.mounted) {
        _suggestionOverlayEntry!.remove();
        _suggestionOverlayEntry = null;
        _entitySuggestions.value = [];
        _lastTagIndex = -1;
        _currentTaggingCharacter = null;
      }
    } catch (e) {
      logger.e('Exception in removing overlay: $e');
    }
  }

  Future<void> _searchEntities(String query) async {
    if (widget.onSearchEntities == null) {
      _entitySuggestions.value = [];
      return;
    }

    try {
      final kind = _tagKindMap[_currentTaggingCharacter];
      if (kind == null) {
        _entitySuggestions.value = [];
        return;
      }

      final entities = await widget.onSearchEntities!(kind, query);
      _entitySuggestions.value = entities;

      if (entities.isEmpty) {
        _removeOverlay();
      }
    } catch (e) {
      logger.e('Exception in searching entities: $e');
      _entitySuggestions.value = [];
    }
  }

  void _checkEditorTextDirection(String text) {
    try {
      var isRTL = Bidi.detectRtlDirectionality(text);
      var style = _controller.getSelectionStyle();
      var attribute = style.attributes[Attribute.align.key];

      if (_isEditorLTR) {
        if (_isEditorLTR != !isRTL) {
          if (isRTL) {
            _isEditorLTR = false;
            _controller.formatSelection(Attribute.clone(Attribute.align, null));
            _controller.formatSelection(Attribute.rightAlignment);
            if (mounted) setState(() {});
          } else {
            var validCharacters = RegExp(r'^[a-zA-Z]+$');
            if (validCharacters.hasMatch(text)) {
              _isEditorLTR = true;
              _controller.formatSelection(
                Attribute.clone(Attribute.align, null),
              );
              _controller.formatSelection(Attribute.leftAlignment);
              if (mounted) setState(() {});
            }
          }
        } else {
          if (attribute == null && isRTL) {
            _isEditorLTR = false;
            _controller.formatSelection(Attribute.clone(Attribute.align, null));
            _controller.formatSelection(Attribute.rightAlignment);
            if (mounted) setState(() {});
          } else if (attribute == Attribute.rightAlignment && !isRTL) {
            var validCharacters = RegExp(r'^[a-zA-Z]+$');
            if (validCharacters.hasMatch(text)) {
              _isEditorLTR = true;
              _controller.formatSelection(
                Attribute.clone(Attribute.align, null),
              );
              _controller.formatSelection(Attribute.leftAlignment);
              if (mounted) setState(() {});
            }
          }
        }
      }
    } catch (e) {
      logger.e('Exception in checking text direction: $e');
    }
  }

  void _onTapOverlaySuggestionItem(MentionEntity entity) {
    if (_lastTagIndex == null || _currentTaggingCharacter == null) {
      return;
    }

    final startIndex = _lastTagIndex!;
    final endIndex = _controller.selection.extentOffset;
    final replaceLength = endIndex - startIndex;

    _controller.replaceText(startIndex, replaceLength, entity.name, null);

    _controller.updateSelection(
      TextSelection(
        baseOffset: startIndex - 1,
        extentOffset: startIndex - 1 + entity.name.length,
      ),
      ChangeSource.local,
    );

    // Format as link with entity ID
    final prefix = _tagPrefixMap[_currentTaggingCharacter] ?? prefixMention;
    _controller.formatSelection(LinkAttribute("$prefix${entity.id}"));

    // Move cursor to end and add space
    Future.delayed(Duration.zero).then((_) {
      _controller.moveCursorToEnd();
      _controller.document.insert(_controller.selection.extentOffset, ' ');
    });

    _removeOverlay();
  }

  void _focusListener() {
    FocusNode? focusedChild = FocusScope.of(context).focusedChild;
    if (focusedChild != null && !_focusNode.hasPrimaryFocus) {
      _removeOverlay();
    }
  }

  OverlayEntry _createSuggestionOverlay() {
    RenderBox box =
        widget.keyForPosition?.currentContext?.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero);
    double y = position.dy;
    double x = position.dx;

    final viewInsets = EdgeInsets.fromViewPadding(
      View.of(context).viewInsets,
      View.of(context).devicePixelRatio,
    );
    double heightKeyboard = viewInsets.bottom - viewInsets.top;

    return OverlayEntry(
      builder: (context) => Positioned(
        bottom: MediaQuery.of(context).size.height - heightKeyboard - y,
        width: MediaQuery.of(context).size.width - (2 * x),
        left: x,
        child: Material(
          elevation: 4.0,
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.card,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.border.withValues(alpha: 0.4),
              ),
            ),
            clipBehavior: Clip.hardEdge,
            constraints: const BoxConstraints(maxHeight: 200, minHeight: 50),
            child: ValueListenableBuilder<List<MentionEntity>>(
              valueListenable: _entitySuggestions,
              builder: (context, entities, child) {
                if (entities.isEmpty) {
                  return ListTile(
                    title: Text(
                      'No entities found',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.cardForeground,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: entities.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final entity = entities[index];
                    return InkWell(
                      onTap: () => _onTapOverlaySuggestionItem(entity),
                      child: ListTile(
                        leading: Icon(
                          _getIconForEntityKind(entity.kind),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        title: Text(
                          entity.name,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.cardForeground,
                          ),
                        ),
                        subtitle: entity.summary != null
                            ? Text(
                                entity.summary!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.cardForeground,
                                ),
                              )
                            : null,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForEntityKind(String kind) {
    switch (kind) {
      case 'npc':
        return Icons.person;
      case 'monster':
      case 'creature':
        return Icons.bug_report;
      case 'group':
      case 'organisation':
      case 'organization':
        return Icons.groups;
      case 'place':
      case 'location':
        return Icons.place;
      case 'item':
        return Icons.inventory_2;
      case 'map':
        return Icons.map;
      case 'chapter':
        return Icons.menu_book;
      case 'adventure':
        return Icons.explore;
      case 'scene':
        return Icons.movie;
      case 'encounter':
        return Icons.flash_on;
      case 'handout':
        return Icons.description;
      case 'journal':
        return Icons.book;
      default:
        return Icons.help_outline;
    }
  }
}

/// Custom action for Alt+Enter key combination
class QuillEditorAltEnterAction extends ContextAction<AltEnterIntent> {
  QuillEditorAltEnterAction(this.controller);

  final QuillController controller;

  @override
  void invoke(AltEnterIntent intent, [BuildContext? context]) {
    TextSelection selection = controller.plainTextEditingValue.selection;
    controller.replaceText(
      selection.start,
      selection.end - selection.start,
      '\n',
      TextSelection(
        baseOffset: selection.start + 1,
        extentOffset: selection.start + 1,
      ),
    );
  }

  @override
  bool get isActionEnabled => true;
}

/// Custom action for Enter key
class QuillEditorEnterAction extends ContextAction<EnterIntent> {
  QuillEditorEnterAction({required this.onEnterPressedOnKeyboard});

  final Function? onEnterPressedOnKeyboard;

  @override
  void invoke(EnterIntent intent, [BuildContext? context]) {
    onEnterPressedOnKeyboard?.call();
  }

  @override
  bool get isActionEnabled => true;
}

/// Intent for Alt+Enter key combination
class AltEnterIntent extends Intent {
  const AltEnterIntent(this.cause);

  final SelectionChangedCause cause;
}

/// Intent for Enter key
class EnterIntent extends Intent {
  const EnterIntent(this.cause);

  final SelectionChangedCause cause;
}

import 'package:flutter/material.dart' as material;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/core/widgets/icon_button.dart';
import 'package:moonforge/data/utils/to_delta_json.dart';
import 'package:moonforge/features/quill_editor/widgets/custom_quill_editor.dart';
import 'package:moonforge/features/quill_editor/widgets/custom_quill_viewer.dart';
import 'package:moonforge/features/quill_editor/widgets/quill_toolbar.dart';
import 'package:moonforge/gen/l10n.dart';
import 'package:moonforge/layout/app_spacing.dart';
import 'package:moonforge/layout/icons.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ContentView extends ConsumerStatefulWidget {
  const ContentView({super.key, required this.document, this.onSave});

  final Map<String, dynamic>? document;
  final Future<void> Function(Map<String, dynamic> document)? onSave;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ContentViewState();
}

class _ContentViewState extends ConsumerState<ContentView> {
  final QuillController _controller = QuillController.basic();
  bool isEditing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.document != null) {
      List<dynamic> delta = widget.document!['ops'] as List<dynamic>;
      if (delta.isNotEmpty) {
        _controller.document = Document.fromJson(delta);
      } else {
        _controller.document = Document();
      }
    } else {
      _controller.document = Document();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    Widget contentView = CustomQuillViewer(
      controller: _controller,
      onMentionTap: (entityId, mentionType) async {
        debugPrint('Tapped on mention: $entityId of type $mentionType');
      },
    );

    Widget contentEdit = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        QuillCustomToolbar(controller: _controller),
        Expanded(
          child: CustomQuillEditor(controller: _controller),
        ),
      ],
    );

    Future<void> showContentFullScreen() => showDialog(
      context: context,
      fullScreen: true,
      builder: (context) {
        final mediaQuery = material.MediaQuery.of(context);
        return material.Dialog(
          insetPadding: EdgeInsets.zero,
          child: SizedBox(
            width: mediaQuery.size.width,
            height: mediaQuery.size.height,
            child: material.SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                      vertical: AppSpacing.sm,
                    ),
                    child: Row(
                      children: [
                        iconChronicles,
                        Gap(8),
                        Text(
                          'Chronicles',
                          style: Theme.of(context).typography.h4,
                        ),
                        Spacer(),
                        isEditing
                            ? ButtonGroup(
                                children: [
                                  PrimaryButton(
                                    leading: Icon(Icons.check),
                                    onPressed: () {
                                      setState(() {
                                        widget.onSave?.call(
                                          toDeltaJson(_controller.document),
                                        );
                                        isEditing = false;
                                      });
                                    },
                                    child: Text(l10n.save),
                                  ),
                                  DestructiveButton(
                                    leading: Icon(Icons.close),
                                    onPressed: () {
                                      setState(() {
                                        isEditing = false;
                                      });
                                      Navigator.of(context).pop();
                                      showContentFullScreen();
                                    },
                                    child: Text(l10n.cancel),
                                  ),
                                ],
                              )
                            : widget.onSave != null
                            ? IconButtonCustom(
                                icon: Icon(Icons.edit),
                                variance: ButtonVariance.ghost,
                                label: l10n.edit,
                                onPressed: () {
                                  setState(() {
                                    isEditing = true;
                                  });
                                  Navigator.of(context).pop();
                                  showContentFullScreen();
                                },
                              )
                            : SizedBox.shrink(),
                        IconButtonCustom(
                          icon: Icon(Icons.close),
                          variance: ButtonVariance.ghost,
                          label: l10n.close,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Expanded(
                    child: DefaultTextStyle.merge(
                      style: Theme.of(context).typography.base.copyWith(
                        color: Theme.of(context).colorScheme.foreground,
                      ),
                      child: Padding(
                        padding: AppSpacing.paddingLg,
                        child: isEditing ? contentEdit : contentView,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.border),
        borderRadius: BorderRadius.circular(Theme.of(context).radiusLg),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                iconChronicles,
                Gap(8),
                Text('Chronicles', style: Theme.of(context).typography.h4),
                Spacer(),
                IconButtonCustom(
                  icon: Icon(Icons.open_in_full),
                  variance: ButtonVariance.ghost,
                  label: 'Focus Mode',
                  onPressed: () {
                    showContentFullScreen();
                  },
                ),
                isEditing
                    ? ButtonGroup(
                        children: [
                          PrimaryButton(
                            leading: Icon(Icons.check),
                            onPressed: () {
                              setState(() {
                                widget.onSave?.call(
                                  toDeltaJson(_controller.document),
                                );
                                isEditing = false;
                              });
                            },
                            child: Text(l10n.save),
                          ),
                          DestructiveButton(
                            leading: Icon(Icons.close),
                            onPressed: () {
                              setState(() {
                                isEditing = false;
                              });
                            },
                            child: Text(l10n.cancel),
                          ),
                        ],
                      )
                    : widget.onSave != null
                    ? IconButtonCustom(
                        icon: Icon(Icons.edit),
                        variance: ButtonVariance.ghost,
                        label: l10n.edit,
                        onPressed: () {
                          setState(() {
                            isEditing = true;
                          });
                        },
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: Padding(
              padding: AppSpacing.paddingLg,
              child: isEditing ? contentEdit : contentView,
            ),
          ),
        ],
      ),
    ).asSkeleton(enabled: widget.document == null);
  }
}

import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/core/widgets/icon_button.dart';
import 'package:moonforge/features/quill_editor/widgets/custom_quill_viewer.dart';
import 'package:moonforge/layout/app_spacing.dart';
import 'package:moonforge/layout/icons.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class ContentView extends ConsumerStatefulWidget {
  const ContentView({super.key, required this.document});

  final Map<String, dynamic>? document;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ContentViewState();
}

class _ContentViewState extends ConsumerState<ContentView> {
  final QuillController _controller = QuillController.basic();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.document != null) {
      _controller.document = Document.fromJson(
        widget.document!['ops'] as List<dynamic>,
      );
    } else {
      _controller.document = Document();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Flexible(
      child: SingleChildScrollView(
        child: CustomQuillViewer(
          controller: _controller,
          onMentionTap: (entityId, mentionType) async {
            debugPrint('Tapped on mention: $entityId of type $mentionType');
          },
        ),
      ),
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
                    showDialog(
                      context: context,
                      fullScreen: true,
                      builder: (context) => AlertDialog(
                        title: Row(
                          children: [
                            iconChronicles,
                            Gap(8),
                            Text(
                              'Chronicles',
                              style: Theme.of(context).typography.h4,
                            ),
                          ],
                        ),
                        content: DefaultTextStyle.merge(
                          style: Theme.of(context).typography.base.copyWith(
                            color: Theme.of(context).colorScheme.foreground,
                          ),
                          child: content,
                        ),
                      ),
                    );
                  },
                ),
                IconButtonCustom(
                  icon: Icon(Icons.edit),
                  variance: ButtonVariance.ghost,
                  label: 'Edit',
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Divider(),
          Padding(padding: AppSpacing.paddingLg, child: content),
        ],
      ),
    ).asSkeleton(enabled: widget.document == null);
  }
}

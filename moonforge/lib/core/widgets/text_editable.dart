import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/core/widgets/hover_editable.dart';
import 'package:moonforge/gen/l10n.dart';
import 'package:moonforge/layout/app_spacing.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

///A editable text widget that shows an edit icon when hovered.
class TextEditable extends ConsumerStatefulWidget {
  const TextEditable({
    super.key,
    required this.text,
    required this.label,
    required this.onSave,
    this.isMultiline = false,
    this.style,
    this.minChars = 0,
  });

  final String text;
  final String label;
  final void Function(String) onSave;
  final bool isMultiline;
  final TextStyle? style;
  final int minChars;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditableTextState();
}

class _EditableTextState extends ConsumerState<TextEditable> {
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    FormController? controller = FormController();
    String textValue = widget.text;

    Widget view = HoverEditableRow(
      spacing: AppSpacing.sm,
      crossAxisAlignment: widget.isMultiline
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      onEdit: () {
        setState(() {
          isEditing = true;
        });
      },
      child: Text(widget.text, style: widget.style),
    );

    List<Widget> editBody = [
      Flexible(
        child: widget.isMultiline
            ? TextArea(
                autofocus: true,
                initialValue: widget.text,
                style: widget.style,
                onChanged: (value) => textValue = value,
                initialHeight: 250,
                expandableHeight: true,
              )
            : TextField(
                autofocus: true,
                initialValue: widget.text,
                style: widget.style,
                onChanged: (value) => textValue = value,
              ),
      ),
      Gap(AppSpacing.lg),
      Row(
        children: [
          SubmitButton(
            loadingLeading: AspectRatio(
              aspectRatio: 1,
              child: CircularProgressIndicator(onSurface: true),
            ),
            child: Text(l10n.create),
          ),
          Gap(AppSpacing.md),
          DestructiveButton(
            child: Text(l10n.cancel),
            onPressed: () {
              controller.dispose();
              setState(() {
                isEditing = false;
              });
            },
          ),
        ],
      ),
    ];

    Widget edit = Form(
      controller: controller,
      onSubmit: (context, values) {
        widget.onSave(textValue);
        logger.i('Saved text: $textValue', context: LogContext.database);
        controller.dispose();
        setState(() {
          isEditing = false;
        });
      },
      child: widget.isMultiline
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: editBody,
            )
          : Row(children: editBody),
    );

    return isEditing ? edit : view;
  }
}

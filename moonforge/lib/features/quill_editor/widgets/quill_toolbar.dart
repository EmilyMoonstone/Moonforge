import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:moonforge/core/widgets/icon_button.dart';
import 'package:moonforge/layout/app_spacing.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

/// Custom toolbar that uses the buttons of [`flutter_quill`](https://pub.dev/packages/flutter_quill).
///
/// See also: [Custom toolbar](https://github.com/singerdmx/flutter-quill/blob/master/doc/custom_toolbar.md).
class QuillCustomToolbar extends StatelessWidget {
  const QuillCustomToolbar({
    super.key,
    required this.controller,
    this.imageButtonOptions,
  });

  final QuillController controller;
  final QuillToolbarImageButtonOptions? imageButtonOptions;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        ButtonGroup(
          children: [
            IconButtonCustom(
              variance: ButtonVariance.outline,
              icon: Icon(Icons.undo),
              label: 'Undo',
              onPressed: () => controller.undo(),
            ),
            IconButtonCustom(
              variance: ButtonVariance.outline,
              icon: Icon(Icons.redo),
              label: 'Redo',
              onPressed: () => controller.redo(),
            ),
          ],
        ),
        ButtonGroup(
          children: [
            IconButtonCustom(
              variance: ButtonVariance.outline,
              icon: Icon(Icons.format_bold),
              label: 'Bold',
              onPressed: () {
                controller.formatSelection(
                  controller
                              .getSelectionStyle()
                              .attributes[Attribute.bold.key] ==
                          null
                      ? Attribute.bold
                      : Attribute.clone(Attribute.bold, null),
                );
              },
            ),
            IconButtonCustom(
              variance: ButtonVariance.outline,
              icon: Icon(Icons.format_italic),
              label: 'Italic',
              onPressed: () {
                controller.formatSelection(
                  controller
                              .getSelectionStyle()
                              .attributes[Attribute.italic.key] ==
                          null
                      ? Attribute.italic
                      : Attribute.clone(Attribute.italic, null),
                );
              },
            ),
            IconButtonCustom(
              variance: ButtonVariance.outline,
              icon: Icon(Icons.format_underline),
              label: 'Underline',
              onPressed: () {
                controller.formatSelection(
                  controller
                              .getSelectionStyle()
                              .attributes[Attribute.underline.key] ==
                          null
                      ? Attribute.underline
                      : Attribute.clone(Attribute.underline, null),
                );
              },
            ),
            IconButtonCustom(
              variance: ButtonVariance.outline,
              icon: Icon(Icons.format_clear),
              label: 'Clear Format',
              onPressed: () {
                controller.formatSelection(
                  Attribute.clone(Attribute.bold, null),
                );
                controller.formatSelection(
                  Attribute.clone(Attribute.italic, null),
                );
                controller.formatSelection(
                  Attribute.clone(Attribute.underline, null),
                );
              },
            ),
          ],
        ),
        ButtonGroup(
          children: [
            QuillToolbarColorButton(
              controller: controller,
              isBackground: false,
            ),
            QuillToolbarColorButton(controller: controller, isBackground: true),
          ],
        ),
        QuillToolbarSelectHeaderStyleDropdownButton(controller: controller),
        QuillToolbarSelectLineHeightStyleDropdownButton(controller: controller),
        ButtonGroup(
          children: [
            IconButtonCustom(
              variance: ButtonVariance.outline,
              icon: Icon(Icons.format_list_bulleted),
              label: 'Bullet List',
              onPressed: () {
                controller.formatSelection(
                  controller.getSelectionStyle().attributes[Attribute.ul.key] ==
                          null
                      ? Attribute.ul
                      : Attribute.clone(Attribute.ul, null),
                );
              },
            ),
            IconButtonCustom(
              variance: ButtonVariance.outline,
              icon: Icon(Icons.format_list_numbered),
              label: 'Numbered List',
              onPressed: () {
                controller.formatSelection(
                  controller.getSelectionStyle().attributes[Attribute.ol.key] ==
                          null
                      ? Attribute.ol
                      : Attribute.clone(Attribute.ol, null),
                );
              },
            ),
            IconButtonCustom(
              variance: ButtonVariance.outline,
              icon: Icon(Icons.check_box_outlined),
              label: 'Check List',
              onPressed: () {
                controller.formatSelection(
                  controller
                              .getSelectionStyle()
                              .attributes[Attribute.checked.key] ==
                          null
                      ? Attribute.checked
                      : Attribute.clone(Attribute.checked, null),
                );
              },
            ),
            IconButtonCustom(
              variance: ButtonVariance.outline,
              icon: Icon(Icons.format_quote),
              label: 'Block Quote',
              onPressed: () {
                controller.formatSelection(
                  controller
                              .getSelectionStyle()
                              .attributes[Attribute.blockQuote.key] ==
                          null
                      ? Attribute.blockQuote
                      : Attribute.clone(Attribute.blockQuote, null),
                );
              },
            ),
            IconButtonCustom(
              variance: ButtonVariance.outline,
              icon: Icon(Icons.format_indent_increase),
              label: 'Increase Indent',
              onPressed: () {
                controller.indentSelection(true);
              },
            ),
            IconButtonCustom(
              variance: ButtonVariance.outline,
              icon: Icon(Icons.format_indent_decrease),
              label: 'Decrease Indent',
              onPressed: () {
                controller.indentSelection(false);
              },
            ),
          ],
        ),
        ButtonGroup(
          children: [
            IconButtonCustom(
              variance: ButtonVariance.outline,
              icon: Icon(Icons.format_align_left),
              label: 'Align Left',
              onPressed: () {
                controller.formatSelection(Attribute.leftAlignment);
              },
            ),
            IconButtonCustom(
              variance: ButtonVariance.outline,
              icon: Icon(Icons.format_align_center),
              label: 'Align Center',
              onPressed: () {
                controller.formatSelection(Attribute.centerAlignment);
              },
            ),
            IconButtonCustom(
              variance: ButtonVariance.outline,
              icon: Icon(Icons.format_align_right),
              label: 'Align Right',
              onPressed: () {
                controller.formatSelection(Attribute.rightAlignment);
              },
            ),
            IconButtonCustom(
              variance: ButtonVariance.outline,
              icon: Icon(Icons.format_align_justify),
              label: 'Align Justify',
              onPressed: () {
                controller.formatSelection(Attribute.justifyAlignment);
              },
            ),
          ],
        ),
        ButtonGroup(
          children: [
            QuillToolbarLinkStyleButton(controller: controller),
            QuillToolbarImageButton(
              controller: controller,
              options: imageButtonOptions,
            ),
          ],
        ),
      ],
    );
  }
}

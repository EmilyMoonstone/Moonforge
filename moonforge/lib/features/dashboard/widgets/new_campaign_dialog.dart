import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/core/utils/mounted_pop.dart';
import 'package:moonforge/core/utils/notification.dart';
import 'package:moonforge/data/constants.dart';
import 'package:moonforge/data/database.dart';
import 'package:moonforge/data/ref_extensions.dart';
import 'package:moonforge/gen/l10n.dart';
import 'package:moonforge/layout/app_spacing.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:uuid/uuid.dart';

class NewCampaignDialog extends ConsumerWidget {
  const NewCampaignDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final FormController controller = FormController();
    final titleKey = const TextFieldKey(#campaign_title);
    final descriptionKey = const TextFieldKey(#campaign_description);

    return AlertDialog(
      title: Text('${l10n.newString} ${l10n.spCampaigns('singular')}'),
      content: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 700),
        child: Form(
          controller: controller,
          onSubmit: (context, values) {
            final userId = ref.userId;
            if (userId == null) {
              showNotification(
                context,
                NotificationType.error,
                'Error',
                'There was an error while getting the user ID. Please try again or log in again.',
                null,
              );
              return;
            }
            if (controller.errors.isNotEmpty) {
              return;
            }
            final title = titleKey[values]!;
            final description = descriptionKey[values];

            ref
                .addCampaign(
                  CampaignsTableData(
                    content: emptyContent,
                    createdAt: DateTime.now().toIso8601String(),
                    createdBy: userId,
                    id: Uuid().v4(),
                    title: title,
                    updatedAt: DateTime.now().toIso8601String(),
                    description: description ?? '',
                  ),
                )
                .then((_) {
                  controller.dispose();
                  showNotification(
                    context,
                    NotificationType.success,
                    l10n.success,
                    l10n.createdX(l10n.spCampaigns('singular')),
                    null,
                  );
                  mountedPop(context);
                });
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: AppSpacing.lg,
            children: [
              FormTableLayout(
                spacing: AppSpacing.md,
                rows: [
                  FormField<String>(
                    key: titleKey,
                    label: Text(l10n.title),
                    validator: const LengthValidator(min: 3),
                    child: TextField(
                      autofocus: true,
                      placeholder: Text(
                        '${l10n.enter} ${l10n.title.toLowerCase()}...',
                      ),
                    ),
                  ),
                  FormField<String>(
                    key: descriptionKey,
                    label: Text(l10n.description),
                    child: TextArea(
                      placeholder: Text(
                        '${l10n.enter} ${l10n.description.toLowerCase()}...',
                      ),
                      expandableHeight: true,
                      initialHeight: 300,
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                ],
              ),
              Row(
                spacing: AppSpacing.md,
                children: [
                  SubmitButton(
                    loadingLeading: AspectRatio(
                      aspectRatio: 1,
                      child: CircularProgressIndicator(onSurface: true),
                    ),
                    child: Text(l10n.create),
                  ),
                  DestructiveButton(
                    child: Text(l10n.cancel),
                    onPressed: () {
                      controller.dispose();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> showNewCampaignDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => const NewCampaignDialog(),
  );
}

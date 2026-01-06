import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/core/constants/enums.dart';
import 'package:moonforge/core/providers/app_settings.dart';
import 'package:moonforge/core/utils/notification.dart';
import 'package:moonforge/core/widgets/hover_editable.dart';
import 'package:moonforge/core/widgets/text_editable.dart';
import 'package:moonforge/data/attachments/profile_picture_uploads.dart';
import 'package:moonforge/data/enums.dart';
import 'package:moonforge/data/powersync.dart';
import 'package:moonforge/data/ref_extensions.dart';
import 'package:moonforge/data/supabase.dart';
import 'package:moonforge/data/utils/image_helpers.dart';
import 'package:moonforge/features/auth/utils/get_initials.dart';
import 'package:moonforge/gen/l10n.dart';
import 'package:moonforge/layout/app_spacing.dart';
import 'package:moonforge/layout/widgets/body.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show UserAttributes;

class AccountTab extends ConsumerStatefulWidget {
  const AccountTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountTabState();
}

class _AccountTabState extends ConsumerState<AccountTab> {
  static const Map<Languages, Locale> _languageLocales = {
    Languages.english: Locale('en'),
    Languages.german: Locale('de'),
  };

  bool _isUploading = false;

  Widget buildRowItem(String label, Widget editable) {
    return Row(
      spacing: AppSpacing.lg,
      children: [
        SizedBox(
          width: 130,
          child: Text(label, textAlign: TextAlign.right).muted(),
        ),
        Flexible(
          child: Align(alignment: Alignment.centerLeft, child: editable),
        ),
      ],
    );
  }

  Languages? _languageFromLocale(Locale? locale) {
    if (locale == null) return null;
    for (final entry in _languageLocales.entries) {
      if (entry.value.languageCode == locale.languageCode) {
        return entry.key;
      }
    }
    return null;
  }

  Locale _localeForLanguage(Languages language) {
    return _languageLocales[language]!;
  }

  String _languageLabel(Languages language) {
    return languageCodes[language] ?? language.name;
  }

  bool _matchesLanguage(Languages language, String query) {
    if (query.isEmpty) return true;
    final label = _languageLabel(language).toLowerCase();
    return label.contains(query) || language.name.toLowerCase().contains(query);
  }

  List<Languages> _filteredLanguages(String? searchQuery) {
    final query = (searchQuery ?? '').trim().toLowerCase();
    return Languages.values
        .where((language) => _matchesLanguage(language, query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale =
        ref.watch(localeProvider) ?? Localizations.localeOf(context);
    final selectedLanguage = _languageFromLocale(currentLocale);
    final session = ref.watch(sessionProvider).value;
    final profilePicturePath =
        session?.user.userMetadata?['profile_picture']?.toString() ?? '';
    final imageProvider = ref
        .read(powerSyncInstanceProvider.future)
        .then(
          (db) => resolveImageProvider(
            db: db,
            bucket: StorageBuckets.profilePictures,
            path: profilePicturePath,
            preferLocal: false,
          ),
        );

    return Body(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${l10n.account} ${l10n.settings}').h1,
          Gap(AppSpacing.xxl),
          buildRowItem(
            l10n.username,
            TextEditable(
              text: ref.user?.userMetadata?['username'] ?? '',
              label: l10n.username,
              onSave: (value) async {
                final user = ref.user;
                if (user == null) return;
                await ref.updateUserMetadata({'username': value});
              },
            ),
          ),
          Gap(AppSpacing.md),
          buildRowItem(
            l10n.email,
            TextEditable(
              text: ref.user?.email ?? 'Email not found.',
              label: l10n.email,
              onSave: (value) async {
                await ref.updateUser(UserAttributes(email: value));
              },
            ),
          ),
          Gap(AppSpacing.md),
          buildRowItem(
            l10n.profilePicture,
            FutureBuilder(
              future: imageProvider,
              builder: (context, snapshot) {
                return HoverEditableAbove(
                  isLoading: _isUploading,
                  onEdit: () async {
                    FilePickerResult? pickedImage = await FilePicker.platform
                        .pickFiles(type: FileType.image);
                    if (pickedImage == null || pickedImage.files.isEmpty) {
                      return;
                    }
                    final file = pickedImage.files.first;
                    if (file.size > 50 * 1024 * 1024) {
                      showNotification(
                        context,
                        NotificationType.error,
                        l10n.fileSizeExceeds,
                        l10n.fileSizeExceedsLimit('50 MB'),
                        null,
                      );
                      return;
                    }
                    setState(() {
                      _isUploading = true;
                    });
                    await uploadProfilePicture(
                      data: file.bytes != null
                          ? Stream.value(file.bytes!)
                          : File(file.path!).openRead(),
                      mediaType: file.identifier ?? 'application/octet-stream',
                      fileExtension: file.extension ?? '',
                    );
                    setState(() {
                      _isUploading = false;
                    });
                  },
                  child: Avatar(
                    initials: getInitials(ref.user?.userMetadata?['username']),
                    provider: snapshot.data,
                    size: 64,
                  ),
                ).asSkeleton(
                  enabled: snapshot.connectionState == ConnectionState.waiting,
                );
              },
            ),
          ),
          Gap(AppSpacing.md),
          buildRowItem(
            l10n.language,
            Select<Languages>(
              value: selectedLanguage,
              placeholder: Text(l10n.language),
              itemBuilder: (context, language) {
                return Text(_languageLabel(language));
              },
              onChanged: (language) {
                if (language == null) return;
                ref
                    .read(localeProvider.notifier)
                    .setLocale(_localeForLanguage(language));
              },
              popup: SelectPopup.builder(
                searchPlaceholder: Text('${l10n.search} ${l10n.language}...'),
                builder: (context, searchQuery) {
                  final languages = _filteredLanguages(searchQuery);
                  if (languages.isEmpty) {
                    return SelectItemList(
                      children: [
                        Padding(
                          padding: AppSpacing.paddingSm,
                          child: Text(l10n.noXFound(l10n.language)).muted(),
                        ),
                      ],
                    );
                  }
                  return SelectItemList(
                    children: [
                      for (final language in languages)
                        SelectItemButton<Languages>(
                          value: language,
                          child: Text(_languageLabel(language)),
                        ),
                    ],
                  );
                },
              ).call,
            ),
          ),
        ],
      ),
    );
  }
}

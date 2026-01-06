import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' show InkWell;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/data/enums.dart';
import 'package:moonforge/data/powersync.dart';
import 'package:moonforge/data/supabase.dart';
import 'package:moonforge/data/utils/image_helpers.dart';
import 'package:moonforge/features/auth/utils/get_initials.dart';
import 'package:moonforge/gen/l10n.dart';
import 'package:moonforge/routes/app_router.gr.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  Future<ImageProvider?>? _avatarFuture;
  String? _avatarPath;

  void _showMenu(BuildContext context) {
    final router = AutoRouter.of(context);
    final l10n = AppLocalizations.of(context)!;

    showDropdown<void>(
      context: context,
      alignment: Alignment.topRight,
      anchorAlignment: Alignment.bottomRight,
      builder: (context) {
        return DropdownMenu(
          children: [
            MenuButton(
              leading: const Icon(Icons.person_outline),
              onPressed: (context) {
                closeOverlay(context);
                router.push(SettingsRoute(selectedIndex: 1));
              },
              child: Text(l10n.profile),
            ),
            MenuButton(
              leading: const Icon(Icons.settings_outlined),
              onPressed: (context) {
                closeOverlay(context);
                router.push(SettingsRoute(selectedIndex: 0));
              },
              child: Text(l10n.settings),
            ),
            const MenuDivider(),
            MenuButton(
              leading: const Icon(Icons.logout),
              onPressed: (context) {
                closeOverlay(context);
                ref.read(authProvider.notifier).signOut();
              },
              child: Text(l10n.logout),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider).value;
    final user = session?.user;
    final metadata = user?.userMetadata ?? const <String, dynamic>{};
    final username = metadata['username']?.toString();
    final profilePicturePath = metadata['profile_picture']?.toString();
    final email = user?.email;
    final displayName = (username != null && username.isNotEmpty)
        ? username
        : (email ?? 'User');

    if (_avatarPath != profilePicturePath) {
      _avatarPath = profilePicturePath;
      _avatarFuture = profilePicturePath == null || profilePicturePath.isEmpty
          ? null
          : _resolveProfileAvatar(profilePicturePath);
    }

    return InkWell(
      onTap: () => _showMenu(context),
      child: _avatarFuture == null
          ? Avatar(initials: getInitials(displayName), size: 36)
          : FutureBuilder<ImageProvider?>(
              future: _avatarFuture,
              builder: (context, snapshot) {
                return Avatar(
                  initials: getInitials(displayName),
                  size: 36,
                  provider: snapshot.data,
                );
              },
            ),
    );
  }

  Future<ImageProvider?> _resolveProfileAvatar(String path) async {
    return ref
        .read(powerSyncInstanceProvider.future)
        .then(
          (db) => resolveImageProvider(
            db: db,
            bucket: StorageBuckets.profilePictures,
            path: path,
            preferLocal: false,
          ),
        );
  }
}

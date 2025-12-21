import 'package:flutter/material.dart' show InkWell;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/data/supabase.dart';
import 'package:moonforge/features/auth/utils/get_initials.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  void _showMenu(BuildContext context) {
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
              },
              child: const Text('Profile'),
            ),
            const MenuDivider(),
            MenuButton(
              leading: const Icon(Icons.logout),
              onPressed: (context) {
                closeOverlay(context);
                ref.read(authProvider.notifier).signOut();
              },
              child: const Text('Logout'),
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
    final email = user?.email;
    final displayName =
        (username != null && username.isNotEmpty) ? username : (email ?? 'User');

    return InkWell(
      onTap: () => _showMenu(context),
      child: Avatar(
        initials: getInitials(displayName),
        size: 36,
      ),
    );
  }
}

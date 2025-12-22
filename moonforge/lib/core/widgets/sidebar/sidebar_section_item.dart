import 'package:flutter/material.dart' show InkWell;
import 'package:moonforge/layout/app_spacing.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class SidebarSectionItem extends StatelessWidget {
  const SidebarSectionItem({
    super.key,
    required this.title,
    this.subtitle,
    this.description,
    this.maxLinesDescription = 2,
    this.onTap,
    this.avatarImage,
  });

  final String title;
  final String? subtitle;
  final String? description;
  final int? maxLinesDescription;
  final VoidCallback? onTap;
  final ImageProvider<Object>? avatarImage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: theme.borderRadiusLg,
      onTap: onTap,
      child: Row(
        children: [
          if (avatarImage != null)
            Avatar(
              initials: Avatar.getInitials(title),
              provider: avatarImage,
            ),
          if (avatarImage != null) Gap(AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title).medium(),
                if (subtitle?.isNotEmpty ?? false)
                  Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Text(subtitle!).xSmall().muted(),
                  ),
                if (description?.isNotEmpty ?? false)
                  Padding(
                    padding: EdgeInsets.only(top: AppSpacing.xs),
                    child: Text(
                      description!,
                      maxLines: maxLinesDescription,
                      overflow: TextOverflow.ellipsis,
                    ).small.muted(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

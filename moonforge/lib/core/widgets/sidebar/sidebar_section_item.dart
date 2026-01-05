import 'package:moonforge/core/widgets/card.dart';
import 'package:moonforge/layout/app_spacing.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class SidebarSectionItem extends StatelessWidget {
  const SidebarSectionItem({
    super.key,
    required this.title,
    this.subtitle,
    this.tags,
    this.description,
    this.maxLinesDescription = 2,
    this.onTap,
    this.avatarImage,
  });

  final String title;
  final String? subtitle;
  final List<String>? tags;
  final String? description;
  final int? maxLinesDescription;
  final VoidCallback? onTap;
  final ImageProvider<Object>? avatarImage;

  @override
  Widget build(BuildContext context) {
    return CardCustom(
      onTap: onTap,
      padding: EdgeInsets.all(AppSpacing.sm),
      child: Row(
        children: [
          if (avatarImage != null)
            Avatar(initials: Avatar.getInitials(title), provider: avatarImage),
          if (avatarImage != null) Gap(AppSpacing.md) else Gap(AppSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title).medium(),
                    if (tags != null) ...[
                      Gap(AppSpacing.xs),
                      ...tags!.map(
                        (tag) => Padding(
                          padding: EdgeInsets.only(right: AppSpacing.xs),
                          child: SecondaryBadge(
                            child: Text(tag),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
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

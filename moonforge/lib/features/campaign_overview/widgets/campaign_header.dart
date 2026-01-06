import 'package:drift/drift.dart' show Value;
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/core/utils/notification.dart';
import 'package:moonforge/core/widgets/hover_editable.dart';
import 'package:moonforge/core/widgets/text_editable.dart';
import 'package:moonforge/data/attachments/image_uploads.dart';
import 'package:moonforge/data/database.dart';
import 'package:moonforge/data/enums.dart';
import 'package:moonforge/data/powersync.dart';
import 'package:moonforge/data/ref_extensions.dart';
import 'package:moonforge/data/utils/image_helpers.dart';
import 'package:moonforge/features/auth/utils/get_initials.dart';
import 'package:moonforge/gen/assets.gen.dart';
import 'package:moonforge/gen/l10n.dart';
import 'package:moonforge/layout/app_spacing.dart';
import 'package:moonforge/layout/design_constants.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

class CampaignHeader extends ConsumerStatefulWidget {
  const CampaignHeader({super.key, this.campaign, this.height = 220});

  final CampaignsTableData? campaign;
  final double height;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CampaignHeaderState();
}

class _CampaignHeaderState extends ConsumerState<CampaignHeader> {
  bool _isUploadingIcon = false;
  bool _isUploadingHeader = false;

  String? _iconPath;
  Future<ImageProvider?>? _iconProviderFuture;

  String? _titleImagePath;
  Future<ImageProvider?>? _titleImageProviderFuture;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final bool isLoading = widget.campaign == null;
    final campaign = widget.campaign;
    final iconPath = campaign?.icon;
    final titleImagePath = campaign?.titleImage;

    if (_iconPath != iconPath) {
      _iconPath = iconPath;
      _iconProviderFuture = _resolveImageProvider(iconPath);
    }

    if (_titleImagePath != titleImagePath) {
      _titleImagePath = titleImagePath;
      _titleImageProviderFuture = _resolveImageProvider(titleImagePath);
    }

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: widget.height),
      child: Stack(
        children: [
          Positioned.fill(
            child: FutureBuilder<ImageProvider?>(
              future: _titleImageProviderFuture,
              builder: (context, snapshot) {
                final backgroundProvider =
                    snapshot.data ??
                    Assets.images.placeholders.campaign.image().image;
                return ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(theme.radiusXl),
                    topRight: Radius.circular(theme.radiusXl),
                  ),
                  child: ShaderMask(
                    shaderCallback: (rect) => LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        theme.colorScheme.background,
                        Colors.transparent,
                      ],
                    ).createShader(rect),
                    blendMode: BlendMode.darken,
                    child:
                        HoverEditableAbove(
                          alignment: Alignment.topRight,
                          onEdit: campaign == null || _isUploadingHeader
                              ? null
                              : () => _updateTitleImage(campaign, context),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: backgroundProvider,
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                  Colors.black.withAlpha(45),
                                  BlendMode.darken,
                                ),
                              ),
                            ),
                          ),
                        ).asSkeleton(
                          enabled:
                              isLoading ||
                              snapshot.connectionState ==
                                  ConnectionState.waiting,
                        ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: AppSpacing.paddingXxxl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  spacing: AppSpacing.sm,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FutureBuilder<ImageProvider?>(
                      future: _iconProviderFuture,
                      builder: (context, snapshot) {
                        return HoverEditableAbove(
                          onEdit: campaign == null || _isUploadingIcon
                              ? null
                              : () => _updateIcon(campaign, context),
                          child: Avatar(
                            initials: getInitials(widget.campaign?.title ?? ''),
                            size: kAvatarSize,
                            borderRadius: kAvatarBorderRadius,
                            provider: snapshot.data,
                          ),
                        ).asSkeleton(
                          enabled:
                              isLoading ||
                              snapshot.connectionState ==
                                  ConnectionState.waiting,
                        );
                      },
                    ),
                    OutlineBadge(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.watch_later,
                            size: 16,
                            color: theme.colorScheme.foreground,
                          ),
                          Gap(AppSpacing.sm),
                          Text(
                            widget.campaign == null
                                ? 'some time ago'
                                : timeago.format(
                                    DateTime.parse(widget.campaign!.updatedAt),
                                  ),
                          ).foreground(fontSize: 14),
                        ],
                      ),
                    ),
                  ],
                ),
                Gap(AppSpacing.md),
                TextEditable(
                  text: widget.campaign?.title ?? 'Campaign Title',
                  label: l10n.title,
                  style: theme.typography.h2,
                  onSave: (newText) {
                    ref.updateCampaign(
                      widget.campaign!.copyWith(title: newText),
                    );
                  },
                ),
                Gap(AppSpacing.md),
                TextEditable(
                  text:
                      widget.campaign?.description ??
                      'A very detailed description of the campaign. We hope you enjoy it!',
                  label: l10n.description,
                  style: theme.typography.base,
                  isMultiline: true,
                  onSave: (newText) {
                    ref.updateCampaign(
                      widget.campaign!.copyWith(description: Value(newText)),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ).asSkeleton(enabled: isLoading);
  }

  Future<ImageProvider?> _resolveImageProvider(String? path) async {
    if (path == null || path.isEmpty) {
      return null;
    }
    final db = await ref.read(powerSyncInstanceProvider.future);
    return resolveImageProvider(
      db: db,
      bucket: StorageBuckets.images,
      path: path,
    );
  }

  Future<void> _updateIcon(CampaignsTableData campaign, BuildContext context) async {
    final file = await _pickImageFile(context);
    if (file == null) {
      return;
    }

    setState(() {
      _isUploadingIcon = true;
    });
    try {
      final db = await ref.read(powerSyncInstanceProvider.future);
      await saveCampaignIconAttachment(
        db: db,
        campaignId: campaign.id,
        data: file.data,
        mediaType: file.mediaType,
        fileExtension: file.extension,
        previousPath: campaign.icon,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingIcon = false;
        });
      }
    }
  }

  Future<void> _updateTitleImage(CampaignsTableData campaign, BuildContext context) async {
    final file = await _pickImageFile(context);
    if (file == null) {
      return;
    }

    setState(() {
      _isUploadingHeader = true;
    });
    try {
      final db = await ref.read(powerSyncInstanceProvider.future);
      await saveCampaignTitleImageAttachment(
        db: db,
        campaignId: campaign.id,
        data: file.data,
        mediaType: file.mediaType,
        fileExtension: file.extension,
        previousPath: campaign.titleImage,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUploadingHeader = false;
        });
      }
    }
  }

  Future<_PickedImage?> _pickImageFile(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final picked = await FilePicker.platform.pickFiles(type: FileType.image);
    if (picked == null || picked.files.isEmpty) {
      return null;
    }

    final file = picked.files.first;
    if (file.size > 50 * 1024 * 1024) {
      showNotification(
        context,
        NotificationType.error,
        l10n.fileSizeExceeds,
        l10n.fileSizeExceedsLimit('50 MB'),
        null,
      );
      return null;
    }
    final stream =
        file.readStream ??
        (file.bytes != null
            ? Stream.value(file.bytes!)
            : (file.path != null ? File(file.path!).openRead() : null));
    if (stream == null) {
      return null;
    }

    final extension = file.extension ?? '';
    final mediaType = _mediaTypeForExtension(extension);
    return _PickedImage(
      data: stream,
      mediaType: mediaType,
      extension: extension,
    );
  }

  String _mediaTypeForExtension(String extension) {
    switch (extension.toLowerCase()) {
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      default:
        return 'application/octet-stream';
    }
  }
}

class _PickedImage {
  const _PickedImage({
    required this.data,
    required this.mediaType,
    required this.extension,
  });

  final Stream<List<int>> data;
  final String mediaType;
  final String extension;
}

# Attachments Guide

This guide documents how Moonforge handles attachments (images) with PowerSync
and Supabase Storage.

## Buckets and Paths

- `images` bucket: campaign-related assets stored in the main DB tables.
  - Paths are stored in DB columns and follow:
    - `campaign_id/campaign_icons/<uuid>.<ext>`
    - `campaign_id/campaign_images/<uuid>.<ext>`
    - `campaign_id/campaign_maps/<uuid>.<ext>`
- `profile_pictures` bucket: user profile photos stored in Supabase Auth metadata.
  - Paths are stored in `auth.users.user_metadata.profile_picture` and follow:
    - `user_id/<uuid>.<ext>`

## Create / Upload

### Campaign images (attachments + PowerSync)

Use the helpers in `moonforge/lib/data/attachments/image_uploads.dart`.
These upload to `images` and update the DB column in the same write transaction.

```dart
final db = await ref.read(powerSyncInstanceProvider.future);

await saveCampaignIconAttachment(
  db: db,
  campaignId: campaignId,
  data: fileStream,
  mediaType: 'image/png',
  fileExtension: 'png',
);
```

Other helpers:
- `saveCampaignTitleImageAttachment`
- `saveMapImageAttachment`
- `saveItemImageAttachment`
- `saveCreatureAvatarAttachment`
- `saveOrganizationAvatarAttachment`
- `saveCharacterAvatarAttachment`

### Profile pictures (Supabase storage + auth metadata)

Use `moonforge/lib/data/attachments/profile_picture_uploads.dart`.
This uploads to `profile_pictures` and updates the user metadata.

```dart
await uploadProfilePicture(
  data: fileStream,
  mediaType: 'image/jpeg',
  fileExtension: 'jpg',
);
```

## Read / Display

Use `moonforge/lib/data/utils/image_helpers.dart` to resolve bytes or an
`ImageProvider` with local-attachments-first (for `images`) and Supabase
fallback.

```dart
final db = await ref.read(powerSyncInstanceProvider.future);
final provider = await resolveImageProvider(
  db: db,
  bucket: StorageBuckets.images,
  path: campaign.icon!,
);
```

For profile pictures:

```dart
final provider = await resolveImageProvider(
  db: db,
  bucket: StorageBuckets.profilePictures,
  path: user.userMetadata?['profile_picture'] as String,
  preferLocal: false,
);
```

## Update / Replace

Uploading a new attachment updates the DB column to point at the new path.
Old paths stop being referenced and are eventually archived locally.

To replace an existing image, call the appropriate `save*Attachment` helper
again and store the new path via the helper's built-in update hook.

## Delete

### For campaign attachments

To delete an attachment, remove the reference in the DB column:

```dart
await db.execute(
  'UPDATE items SET image = NULL WHERE id = ?',
  [itemId],
);
```

PowerSync will eventually archive the attachment locally and remove the local
file from disk.

### For profile pictures

Clear the user metadata and optionally delete the storage object:

```dart
await Supabase.instance.client.auth.updateUser(
  UserAttributes(data: {'profile_picture': null}),
);

await Supabase.instance.client.storage
  .from('profile_pictures')
  .remove([path]);
```

## Notes

- Attachments are immutable once created. Use "replace" semantics to update.
- Local storage is filesystem-based on native platforms and in-memory on web.
- Storage RLS is enforced on `storage.objects` in `supabase/sql/init_rls.sql`.

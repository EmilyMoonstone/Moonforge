enum SortTypeDataset {
  nameAsc,
  nameDesc,
  dateCreatedAsc,
  dateCreatedDesc,
  lastModifiedAsc,
  lastModifiedDesc,
}

enum StorageBuckets { images, profilePictures }

Map<StorageBuckets, String> storageBucketNames = {
  StorageBuckets.images: 'images',
  StorageBuckets.profilePictures: 'profile_pictures',
};

enum ImageFolders { avatars, images, maps, content }

Map<ImageFolders, String> imageFolderNames = {
  ImageFolders.avatars: 'avatars',
  ImageFolders.images: 'images',
  ImageFolders.maps: 'maps',
  ImageFolders.content: 'content',
};

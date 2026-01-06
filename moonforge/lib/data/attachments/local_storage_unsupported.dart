import 'package:powersync_core/attachments/attachments.dart';

Future<LocalStorage> localAttachmentStorage() async {
  return LocalStorage.inMemory();
}

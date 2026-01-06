import 'package:path_provider/path_provider.dart';
import 'package:powersync_core/attachments/attachments.dart';
import 'package:powersync_core/attachments/io.dart';

Future<LocalStorage> localAttachmentStorage() async {
  final directory = await getApplicationSupportDirectory();
  return IOLocalStorage(directory);
}

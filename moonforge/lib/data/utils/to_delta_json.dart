import 'package:flutter_quill/flutter_quill.dart';

Map<String, dynamic> toDeltaJson(Document? document) {
  if (document == null) {
    return {'ops': []};
  }
  return {'ops': document.toDelta().toJson()};
}

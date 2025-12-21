import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'root_context_provider.g.dart';

@riverpod
class RootContextNotifier extends _$RootContextNotifier {
  @override
  BuildContext? build() {
    return null;
  }

  void setBuildContext(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!ref.mounted || state == context) {
        return;
      }
      state = context;
    });
  }
}

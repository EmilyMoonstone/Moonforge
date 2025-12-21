import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/core/utils/notification.dart';
import 'package:moonforge/data/powersync.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'supabase.g.dart';

Future<void> initSupabase() async {
  await Supabase.initialize(
    url: 'https://tpzfoendnhkizbmyslxo.supabase.co',
    anonKey: 'sb_publishable_oz490cSxXqr7tsU1OkAVoA_xYocgZiJ',
  );
}

@riverpod
Stream<Session?> session(Ref ref) {
  final instance = Supabase.instance.client.auth;

  return instance.onAuthStateChange
      .map((_) => instance.currentSession)
      .startWith(instance.currentSession);
}

@riverpod
bool isLoggedIn(Ref ref) {
  return ref.watch(sessionProvider.select((session) => session.value != null));
}

@riverpod
String? userId(Ref ref) {
  return ref.watch(sessionProvider.select((session) => session.value?.user.id));
}

typedef AuthState = ({String? error, bool isBusy});

@riverpod
final class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    return (error: null, isBusy: false);
  }

  Future<void> _doWork(Future<void> Function() inner) async {
    try {
      state = (error: null, isBusy: true);
      await inner();
      state = (error: null, isBusy: false);
    } catch (e, s) {
      logger.w(
        'Auth error: $e',
        error: e,
        stackTrace: s,
        context: LogContext.database,
      );
      showNotificationFromRef(
        ref,
        NotificationType.error,
        'Authentication error',
        e.toString(),
      );
      state = (error: e.toString(), isBusy: false);
    }
  }

  Future<void> login(String username, String password) {
    return _doWork(() async {
      await Supabase.instance.client.auth.signInWithPassword(
        email: username,
        password: password,
      );
    });
  }

  Future<void> signup(String email, String password, {String? username}) async {
    return _doWork(() async {
      String redirectUri;
      if(kIsWeb) {
        redirectUri = 'https://moonforge.app/auth/callback';
      } else {
        redirectUri = 'moonforge://auth/callback';
      }

      await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        data: username == null || username.isEmpty
            ? null
            : <String, dynamic>{'username': username},
        emailRedirectTo: redirectUri
      );
      showNotificationFromRef(
        ref,
        NotificationType.success,
        'Signup successful',
        'You have successfully signed up.',
      );
    });
  }

  Future<void> signOut() async {
    await Supabase.instance.client.auth.signOut();
    await (await ref.read(
      powerSyncInstanceProvider.future,
    )).disconnectAndClear();
  }
}

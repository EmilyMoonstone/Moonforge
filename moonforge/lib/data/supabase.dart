import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonforge/core/utils/logger.dart';
import 'package:moonforge/core/utils/notification.dart';
import 'package:moonforge/data/powersync.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'supabase.g.dart';

/// Initializes Supabase with the project's URL and anon key.
///
/// Usage:
/// ```dart
/// await initSupabase();
/// ```
Future<void> initSupabase() async {
  await Supabase.initialize(
    url: 'https://tpzfoendnhkizbmyslxo.supabase.co',
    anonKey: 'sb_publishable_oz490cSxXqr7tsU1OkAVoA_xYocgZiJ',
  );
}

/// Stream provider for the current Supabase auth session.
///
/// Usage:
/// ```dart
/// final session = ref.watch(sessionProvider);
/// ```
@riverpod
Stream<Session?> session(Ref ref) {
  final instance = Supabase.instance.client.auth;

  return instance.onAuthStateChange
      .map((_) => instance.currentSession)
      .startWith(instance.currentSession);
}

/// Whether a user is currently logged in.
///
/// Usage:
/// ```dart
/// final isLoggedIn = ref.watch(isLoggedInProvider);
/// ```
@riverpod
bool isLoggedIn(Ref ref) {
  return ref.watch(sessionProvider.select((session) => session.value != null));
}

/// Returns the current user's ID, or null if not logged in.
///
/// Usage:
/// ```dart
/// final userId = ref.watch(userIdProvider);
/// ```
@riverpod
String? userId(Ref ref) {
  return ref.watch(sessionProvider.select((session) => session.value?.user.id));
}

/// Returns the current user's data, or null if not logged in.
@riverpod
User? user(Ref ref) {
  return ref.watch(sessionProvider.select((session) => session.value?.user));
}

/// Lightweight auth UI state used by [AuthNotifier].
///
/// Usage:
/// ```dart
/// final authState = ref.watch(authNotifierProvider);
/// ```
typedef AuthState = ({String? error, bool isBusy});

/// Handles Supabase authentication with loading/error state.
///
/// Usage:
/// ```dart
/// final auth = ref.read(authNotifierProvider.notifier);
/// await auth.login(email, password);
/// ```
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

  Future<void> updateUser(UserAttributes attributes) async {
    return _doWork(() async {
      await Supabase.instance.client.auth.updateUser(attributes);
    });
  }

  Future<void> updateUserMetadata(Map<String, dynamic> data) async {
    return _doWork(() async {
      Map<String, dynamic>? currentData =
          Supabase.instance.client.auth.currentUser?.userMetadata ?? {};
      currentData.addAll(data);
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(data: currentData),
      );
    });
  }

  Future<void> deleteUserMetadata(List<String> keys) async {
    return _doWork(() async {
      Map<String, dynamic>? currentData =
          Supabase.instance.client.auth.currentUser?.userMetadata ?? {};
      for (final key in keys) {
        currentData.remove(key);
      }
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(data: currentData),
      );
    });
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _doWork(() async {
      String redirectUri;
      if(kIsWeb) {
        redirectUri = 'https://moonforge.app/auth/callback';
      } else {
        redirectUri = 'moonforge://auth/callback';
      }

      await Supabase.instance.client.auth.resetPasswordForEmail(
        email,
        redirectTo: redirectUri,
      );
      showNotificationFromRef(
        ref,
        NotificationType.success,
        'Password Reset Email Sent',
        'Please check your email for instructions to reset your password.',
      );
    });
  }
}

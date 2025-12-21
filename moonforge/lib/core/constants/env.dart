import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env', useConstantCase: true)
abstract class Env {
  @EnviedField()
  static const String supabaseProjectId = _Env.supabaseProjectId;

  @EnviedField()
  static const String supabaseUrl = _Env.supabaseUrl;

  @EnviedField()
  static const String supabaseApiKey = _Env.supabaseApiKey;

  @EnviedField()
  static const String supabaseAnonKey = _Env.supabaseAnonKey;

  @EnviedField()
  static const String powersyncEndpoint = _Env.powersyncEndpoint;
}

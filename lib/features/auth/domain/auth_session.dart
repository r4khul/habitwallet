import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_session.freezed.dart';

/// Domain Entity: Represents an active authentication session.
/// Boundary Rules: Pure Dart only, immutable.
@freezed
abstract class AuthSession with _$AuthSession {
  const factory AuthSession({required String email, required bool rememberMe}) =
      _AuthSession;
}

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';

/// Singleton that tracks the current auth user and exposes derived fields
/// (avatar URL, display name). Wraps the Supabase auth state stream so any
/// widget can react to sign-in / sign-out via [userNotifier].
class AuthController {
  static final AuthController _instance = AuthController._();
  static AuthController get instance => _instance;

  AuthController._() {
    SupabaseService.client.auth.onAuthStateChange.listen((event) {
      _userNotifier.value =
          event.session?.user ?? SupabaseService.client.auth.currentUser;
    });
  }

  final ValueNotifier<User?> _userNotifier =
      ValueNotifier(SupabaseService.client.auth.currentUser);

  ValueNotifier<User?> get userNotifier => _userNotifier;
  User? get currentUser => _userNotifier.value;
  bool get isLoggedIn => currentUser != null;

  /// Google / OAuth avatar URL (stored in user_metadata by Supabase).
  String? get avatarUrl =>
      currentUser?.userMetadata?['avatar_url'] as String?;

  /// Best-effort display name: full_name → display_name → email prefix.
  String get displayName =>
      (currentUser?.userMetadata?['full_name'] as String?) ??
      (currentUser?.userMetadata?['display_name'] as String?) ??
      currentUser?.email?.split('@').first ??
      'User';

  String? get email => currentUser?.email;
}

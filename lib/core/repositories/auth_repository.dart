import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';

class AuthRepository {
  final _client = SupabaseService.client;

  /// Sign in with email and password. Returns the session user.
  Future<User> signIn({required String email, required String password}) async {
    final response = await _client.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
    if (response.user == null) throw Exception('Login failed. Please try again.');
    return response.user!;
  }

  /// Sign up a new user. Also sets display_name and username in metadata
  /// so the DB trigger can populate the profiles table correctly.
  Future<User> signUp({
    required String email,
    required String password,
    required String displayName,
    required String username,
  }) async {
    final response = await _client.auth.signUp(
      email: email.trim(),
      password: password,
      data: {
        'display_name': displayName.trim(),
        'username': username.trim(),
      },
    );
    if (response.user == null) throw Exception('Sign up failed. Please try again.');
    return response.user!;
  }

  /// Sign in with Google via Supabase OAuth.
  /// On web the browser is redirected automatically; on mobile a WebView opens.
  Future<void> signInWithGoogle() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: kIsWeb ? null : 'io.supabase.society260://login-callback',
    );
  }

  /// Sign out current user.
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  /// Returns the current user or null if not logged in.
  User? get currentUser => _client.auth.currentUser;

  /// Stream that emits auth state changes.
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  /// Fetch the current user's profile from the profiles table.
  Future<Map<String, dynamic>?> fetchProfile(String userId) async {
    final data = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
    return data;
  }

  /// Check if current user is admin.
  Future<bool> isAdmin() async {
    final uid = SupabaseService.currentUserId;
    if (uid == null) return false;
    final data = await _client
        .from('profiles')
        .select('is_admin')
        .eq('id', uid)
        .maybeSingle();
    return data?['is_admin'] == true;
  }
}

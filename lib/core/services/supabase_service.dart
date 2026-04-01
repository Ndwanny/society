import 'package:supabase_flutter/supabase_flutter.dart';

/// Central access point for the Supabase client.
/// Call [SupabaseService.client] anywhere after [Supabase.initialize].
class SupabaseService {
  SupabaseService._();

  static SupabaseClient get client => Supabase.instance.client;

  static User? get currentUser => client.auth.currentUser;

  static bool get isLoggedIn => currentUser != null;

  static String? get currentUserId => currentUser?.id;
}

/// Supabase project credentials.
///
/// Replace the placeholder values below with your own from:
/// Supabase Dashboard → Project Settings → API
class Env {
  Env._();

  /// Your project URL — looks like https://xyzabc.supabase.co
  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'YOUR_SUPABASE_URL',
  );

  /// Your anon (public) key
  static const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'YOUR_SUPABASE_ANON_KEY',
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/repositories/auth_repository.dart';
import '../../core/theme/app_colors.dart';

final _authRepo = AuthRepository();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  bool _googleLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: AppColors.black,
      body: Row(
        children: [
          // Left panel (wide screens)
          if (isWide)
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.teal.withOpacity(0.15),
                      AppColors.black,
                      AppColors.coral.withOpacity(0.08),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(60),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => context.go('/'),
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                            children: const [
                              TextSpan(
                                text: 'SOCIETY',
                                style:
                                    TextStyle(color: AppColors.white),
                              ),
                              TextSpan(
                                text: '260',
                                style:
                                    TextStyle(color: AppColors.teal),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),
                      Text(
                        'Welcome\nback.',
                        style: GoogleFonts.poppins(
                          fontSize: 56,
                          fontWeight: FontWeight.w900,
                          color: AppColors.white,
                          letterSpacing: -2,
                          height: 1.0,
                        ),
                      ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3),
                      const SizedBox(height: 24),
                      Text(
                        'Your safe space is waiting for you.',
                        style: GoogleFonts.poppins(
                          color: AppColors.textGray,
                          fontSize: 16,
                          height: 1.7,
                        ),
                      ).animate().fadeIn(delay: 400.ms),
                    ],
                  ),
                ),
              ),
            ),

          // Right panel - form
          Expanded(
            child: Container(
              color: AppColors.darkGray,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(40),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isWide) ...[
                          GestureDetector(
                            onTap: () => context.go('/'),
                            child: RichText(
                              text: TextSpan(
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                                children: const [
                                  TextSpan(
                                    text: 'SOCIETY',
                                    style: TextStyle(
                                        color: AppColors.white),
                                  ),
                                  TextSpan(
                                    text: '260',
                                    style: TextStyle(
                                        color: AppColors.teal),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                        Text(
                          'Sign In',
                          style: GoogleFonts.poppins(
                            color: AppColors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'New to Society260? ',
                              style: GoogleFonts.poppins(
                                  color: AppColors.textGray),
                            ),
                            GestureDetector(
                              onTap: () => context.go('/signup'),
                              child: Text(
                                'Create an account',
                                style: GoogleFonts.poppins(
                                  color: AppColors.teal,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),

                        // Email
                        _FormLabel('Email'),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          style: GoogleFonts.poppins(
                              color: AppColors.white),
                          decoration: _inputDecoration(
                              'you@example.com', Icons.email_outlined),
                        ),
                        const SizedBox(height: 20),

                        // Password
                        _FormLabel('Password'),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _passCtrl,
                          obscureText: _obscure,
                          style: GoogleFonts.poppins(
                              color: AppColors.white),
                          decoration: _inputDecoration(
                            '••••••••',
                            Icons.lock_outline,
                          ).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: AppColors.textGray,
                                size: 18,
                              ),
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              'Forgot password?',
                              style: GoogleFonts.poppins(
                                color: AppColors.teal,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.teal,
                              foregroundColor: AppColors.black,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                            ),
                            child: _loading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.black,
                                    ),
                                  )
                                : Text(
                                    'SIGN IN',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 24),
                        const _Divider(),
                        const SizedBox(height: 24),

                        // Google sign-in
                        _GoogleButton(
                          loading: _googleLoading,
                          onPressed: _handleGoogleSignIn,
                        ),

                        const SizedBox(height: 20),

                        // Admin link
                        Center(
                          child: TextButton(
                            onPressed: () => context.go('/admin'),
                            child: Text(
                              'Go to Admin Panel →',
                              style: GoogleFonts.poppins(
                                color: AppColors.textGray,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.textGray, size: 18),
      hintStyle: GoogleFonts.poppins(
          color: AppColors.textMuted, fontSize: 14),
      filled: true,
      fillColor: AppColors.cardBg,
      contentPadding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            const BorderSide(color: AppColors.teal, width: 1.5),
      ),
    );
  }

  void _handleGoogleSignIn() async {
    setState(() => _googleLoading = true);
    try {
      await _authRepo.signInWithGoogle();
      // On web, the page redirects — no need to navigate manually.
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Google sign-in failed: $e'),
            backgroundColor: AppColors.coral,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _googleLoading = false);
    }
  }

  void _handleLogin() async {
    final email = _emailCtrl.text.trim();
    final password = _passCtrl.text;
    if (email.isEmpty || password.isEmpty) return;

    setState(() => _loading = true);
    try {
      await _authRepo.signIn(email: email, password: password);
      if (mounted) context.go('/club260/feed');
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: AppColors.coral),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.coral),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}

// ─── Signup Screen ───────────────────────────────────────────────────────────
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameCtrl     = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _emailCtrl    = TextEditingController();
  final _passCtrl     = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  bool _googleLoading = false;
  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: AppColors.black,
      body: Row(
        children: [
          if (isWide)
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.teal.withOpacity(0.15),
                      AppColors.black,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(60),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => context.go('/'),
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                            children: const [
                              TextSpan(
                                text: 'SOCIETY',
                                style: TextStyle(color: AppColors.white),
                              ),
                              TextSpan(
                                text: '260',
                                style: TextStyle(color: AppColors.teal),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),
                      Text(
                        'Join the\nmovement.',
                        style: GoogleFonts.poppins(
                          fontSize: 56,
                          fontWeight: FontWeight.w900,
                          color: AppColors.white,
                          letterSpacing: -2,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '1,200+ members building a safer world together.',
                        style: GoogleFonts.poppins(
                          color: AppColors.textGray,
                          fontSize: 16,
                          height: 1.7,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          Expanded(
            child: Container(
              color: AppColors.darkGray,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(40),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create Account',
                          style: GoogleFonts.poppins(
                            color: AppColors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'Already a member? ',
                              style: GoogleFonts.poppins(
                                  color: AppColors.textGray),
                            ),
                            GestureDetector(
                              onTap: () => context.go('/login'),
                              child: Text(
                                'Sign in',
                                style: GoogleFonts.poppins(
                                  color: AppColors.teal,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),

                        _FormLabel('Full Name'),
                        const SizedBox(height: 8),
                        _field(_nameCtrl, 'Your name', Icons.person_outline),
                        const SizedBox(height: 20),

                        _FormLabel('Email'),
                        const SizedBox(height: 8),
                        _field(_emailCtrl, 'you@example.com',
                            Icons.email_outlined),
                        const SizedBox(height: 20),

                        _FormLabel('Password'),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _passCtrl,
                          obscureText: _obscure,
                          style: GoogleFonts.poppins(
                              color: AppColors.white),
                          decoration: _inputDecoration(
                                  '••••••••', Icons.lock_outline)
                              .copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: AppColors.textGray,
                                size: 18,
                              ),
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Terms
                        Row(
                          children: [
                            Checkbox(
                              value: _agreedToTerms,
                              onChanged: (val) => setState(
                                  () => _agreedToTerms = val ?? false),
                              activeColor: AppColors.teal,
                              checkColor: AppColors.black,
                            ),
                            Expanded(
                              child: Text(
                                'I agree to the Terms of Service and Privacy Policy',
                                style: GoogleFonts.poppins(
                                  color: AppColors.textGray,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: (_loading || !_agreedToTerms)
                                ? null
                                : _handleSignup,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.teal,
                              foregroundColor: AppColors.black,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 18),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                            ),
                            child: _loading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.black,
                                    ),
                                  )
                                : Text(
                                    'CREATE ACCOUNT',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 24),
                        const _Divider(),
                        const SizedBox(height: 24),

                        _GoogleButton(
                          loading: _googleLoading,
                          onPressed: _handleGoogleSignIn,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleGoogleSignIn() async {
    setState(() => _googleLoading = true);
    try {
      await _authRepo.signInWithGoogle();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Google sign-in failed: $e'),
            backgroundColor: AppColors.coral,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _googleLoading = false);
    }
  }

  Widget _field(
      TextEditingController ctrl, String hint, IconData icon) {
    return TextField(
      controller: ctrl,
      style: GoogleFonts.poppins(color: AppColors.white),
      decoration: _inputDecoration(hint, icon),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.textGray, size: 18),
      hintStyle:
          GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 14),
      filled: true,
      fillColor: AppColors.cardBg,
      contentPadding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide:
            const BorderSide(color: AppColors.teal, width: 1.5),
      ),
    );
  }

  void _handleSignup() async {
    final name     = _nameCtrl.text.trim();
    final username = _usernameCtrl.text.trim().replaceAll(' ', '_').toLowerCase();
    final email    = _emailCtrl.text.trim();
    final password = _passCtrl.text;
    if (name.isEmpty || email.isEmpty || password.isEmpty) return;

    setState(() => _loading = true);
    try {
      await _authRepo.signUp(
        email: email,
        password: password,
        displayName: name,
        username: username.isEmpty ? email.split('@').first : username,
      );
      if (mounted) context.go('/club260/feed');
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message), backgroundColor: AppColors.coral),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.coral),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}

class _FormLabel extends StatelessWidget {
  final String text;
  const _FormLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: AppColors.textGray,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
            child: Divider(color: AppColors.borderColor, height: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or',
            style: GoogleFonts.poppins(
                color: AppColors.textMuted, fontSize: 13),
          ),
        ),
        const Expanded(
            child: Divider(color: AppColors.borderColor, height: 1)),
      ],
    );
  }
}

// ─── Google Sign-In Button ────────────────────────────────────────────────────
class _GoogleButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onPressed;
  const _GoogleButton({required this.loading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: loading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.cardBg,
          foregroundColor: AppColors.white,
          side: const BorderSide(color: AppColors.borderColor),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.teal,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Google G icon in brand colours
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        'G',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF4285F4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Continue with Google',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

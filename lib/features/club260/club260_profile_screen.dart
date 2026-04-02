import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/controllers/auth_controller.dart';
import '../../core/services/supabase_service.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/navbar.dart';

// ─── Timeline theme definitions ───────────────────────────────────────────────
enum TimelineTheme { dark, mint, warm, soft, mono }

extension TimelineThemeX on TimelineTheme {
  String get label => switch (this) {
        TimelineTheme.dark => 'Dark',
        TimelineTheme.mint => 'Mint',
        TimelineTheme.warm => 'Warm',
        TimelineTheme.soft => 'Soft',
        TimelineTheme.mono => 'Mono',
      };

  Color get bg => switch (this) {
        TimelineTheme.dark => const Color(0xFF0A0A0A),
        TimelineTheme.mint => const Color(0xFF0D1F1C),
        TimelineTheme.warm => const Color(0xFF1A1209),
        TimelineTheme.soft => const Color(0xFF12121F),
        TimelineTheme.mono => const Color(0xFF111111),
      };

  Color get accent => switch (this) {
        TimelineTheme.dark => AppColors.teal,
        TimelineTheme.mint => const Color(0xFF34D399),
        TimelineTheme.warm => const Color(0xFFFFB800),
        TimelineTheme.soft => const Color(0xFFA78BFA),
        TimelineTheme.mono => const Color(0xFFCCCCCC),
      };

  Color get cardBg => switch (this) {
        TimelineTheme.dark => const Color(0xFF141414),
        TimelineTheme.mint => const Color(0xFF0F2420),
        TimelineTheme.warm => const Color(0xFF1F1610),
        TimelineTheme.soft => const Color(0xFF171726),
        TimelineTheme.mono => const Color(0xFF181818),
      };
}

// ─── Banner gradient presets ──────────────────────────────────────────────────
final _bannerGradients = [
  [const Color(0xFF00BFA6), const Color(0xFF004D40)],
  [const Color(0xFFFFB800), const Color(0xFF7A4500)],
  [const Color(0xFFA78BFA), const Color(0xFF3B1F8C)],
  [const Color(0xFFEC4899), const Color(0xFF7C1D6F)],
  [const Color(0xFF3B82F6), const Color(0xFF1E1B4B)],
  [const Color(0xFF6B7280), const Color(0xFF111827)],
];

class Club260ProfileScreen extends StatefulWidget {
  const Club260ProfileScreen({super.key});

  @override
  State<Club260ProfileScreen> createState() => _Club260ProfileScreenState();
}

class _Club260ProfileScreenState extends State<Club260ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Form controllers
  final _displayNameCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  final _avatarUrlCtrl = TextEditingController();
  final _twitterCtrl = TextEditingController();
  final _instagramCtrl = TextEditingController();
  final _websiteCtrl = TextEditingController();

  TimelineTheme _selectedTheme = TimelineTheme.dark;
  int _bannerIndex = 0;
  bool _saving = false;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadFromUser();
  }

  void _loadFromUser() {
    final u = AuthController.instance.currentUser;
    if (u == null) return;
    final meta = u.userMetadata ?? {};
    _displayNameCtrl.text =
        (meta['full_name'] as String?) ?? (meta['display_name'] as String?) ?? '';
    _usernameCtrl.text = (meta['username'] as String?) ?? '';
    _bioCtrl.text = (meta['bio'] as String?) ?? '';
    _avatarUrlCtrl.text = (meta['custom_avatar_url'] as String?) ?? '';
    _twitterCtrl.text = (meta['twitter'] as String?) ?? '';
    _instagramCtrl.text = (meta['instagram'] as String?) ?? '';
    _websiteCtrl.text = (meta['website'] as String?) ?? '';

    final themeStr = meta['timeline_theme'] as String?;
    if (themeStr != null) {
      _selectedTheme = TimelineTheme.values.firstWhere(
        (t) => t.name == themeStr,
        orElse: () => TimelineTheme.dark,
      );
    }
    _bannerIndex = (meta['banner_index'] as int?) ?? 0;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _displayNameCtrl.dispose();
    _usernameCtrl.dispose();
    _bioCtrl.dispose();
    _avatarUrlCtrl.dispose();
    _twitterCtrl.dispose();
    _instagramCtrl.dispose();
    _websiteCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await SupabaseService.client.auth.updateUser(
        UserAttributes(
          data: {
            'display_name': _displayNameCtrl.text.trim(),
            'full_name': _displayNameCtrl.text.trim(),
            'username': _usernameCtrl.text.trim(),
            'bio': _bioCtrl.text.trim(),
            'custom_avatar_url': _avatarUrlCtrl.text.trim(),
            'twitter': _twitterCtrl.text.trim(),
            'instagram': _instagramCtrl.text.trim(),
            'website': _websiteCtrl.text.trim(),
            'timeline_theme': _selectedTheme.name,
            'banner_index': _bannerIndex,
          },
        ),
      );
      setState(() => _saved = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _saved = false);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Save failed: $e',
                style: GoogleFonts.poppins()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    final u = AuthController.instance.currentUser;

    if (u == null) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => context.go('/login'));
      return const Scaffold(
          backgroundColor: AppColors.black,
          body: Center(
              child: CircularProgressIndicator(color: AppColors.teal)));
    }

    final avatarUrl = _avatarUrlCtrl.text.isNotEmpty
        ? _avatarUrlCtrl.text
        : (u.userMetadata?['avatar_url'] as String?);
    final displayName = _displayNameCtrl.text.isNotEmpty
        ? _displayNameCtrl.text
        : AuthController.instance.displayName;

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: const AppNavbar(),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Banner ──────────────────────────────────────────────────────
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: isWide ? 220 : 160,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _bannerGradients[_bannerIndex],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                // Avatar overlapping banner
                Positioned(
                  bottom: isWide ? -48 : -36,
                  left: isWide ? 60 : 20,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: isWide ? 52 : 40,
                        backgroundColor: AppColors.black,
                        child: CircleAvatar(
                          radius: isWide ? 48 : 37,
                          backgroundColor:
                              AppColors.teal.withOpacity(0.2),
                          backgroundImage: avatarUrl != null
                              ? NetworkImage(avatarUrl)
                              : null,
                          child: avatarUrl == null
                              ? Text(
                                  displayName.isNotEmpty
                                      ? displayName[0].toUpperCase()
                                      : 'U',
                                  style: GoogleFonts.poppins(
                                    color: AppColors.teal,
                                    fontSize: isWide ? 32 : 24,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: isWide ? 60 : 52),

            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: isWide ? 60 : 20),
              child: isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 260,
                          child: _profileSidebar(u, displayName),
                        ),
                        const SizedBox(width: 40),
                        Expanded(child: _editForm()),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _profileSidebar(u, displayName),
                        const SizedBox(height: 32),
                        _editForm(),
                      ],
                    ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _profileSidebar(User u, String displayName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          displayName,
          style: GoogleFonts.poppins(
            color: AppColors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (_usernameCtrl.text.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            '@${_usernameCtrl.text}',
            style: GoogleFonts.poppins(
                color: AppColors.teal, fontSize: 13),
          ),
        ],
        if (_bioCtrl.text.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            _bioCtrl.text,
            style: GoogleFonts.poppins(
              color: AppColors.textGray,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
        const SizedBox(height: 20),
        // Stats row
        Row(
          children: [
            _statChip('Posts', '24'),
            const SizedBox(width: 20),
            _statChip('Followers', '142'),
            const SizedBox(width: 20),
            _statChip('Following', '89'),
          ],
        ),
        const SizedBox(height: 20),
        // Social links
        if (_twitterCtrl.text.isNotEmpty)
          _socialLink('𝕏', _twitterCtrl.text),
        if (_instagramCtrl.text.isNotEmpty)
          _socialLink('📷', _instagramCtrl.text),
        if (_websiteCtrl.text.isNotEmpty)
          _socialLink('🔗', _websiteCtrl.text),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: () => context.go('/club260/feed'),
          icon: const Icon(Icons.explore_outlined,
              size: 16, color: AppColors.teal),
          label: Text('View Feed',
              style: GoogleFonts.poppins(
                  color: AppColors.teal, fontSize: 13)),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColors.teal.withOpacity(0.4)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget _statChip(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
            style: GoogleFonts.poppins(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800)),
        Text(label,
            style: GoogleFonts.poppins(
                color: AppColors.textGray, fontSize: 12)),
      ],
    );
  }

  Widget _socialLink(String icon, String handle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 8),
          Text(
            handle,
            style: GoogleFonts.poppins(
                color: AppColors.textGray, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _editForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tab bar
        Container(
          decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(color: AppColors.borderColor)),
          ),
          child: TabBar(
            controller: _tabController,
            indicatorColor: AppColors.teal,
            labelColor: AppColors.teal,
            unselectedLabelColor: AppColors.textGray,
            labelStyle: GoogleFonts.poppins(
                fontSize: 13, fontWeight: FontWeight.w600),
            tabs: const [
              Tab(text: 'Profile'),
              Tab(text: 'Appearance'),
              Tab(text: 'Social'),
            ],
          ),
        ),
        const SizedBox(height: 28),
        SizedBox(
          height: 560,
          child: TabBarView(
            controller: _tabController,
            children: [
              _profileTab(),
              _appearanceTab(),
              _socialTab(),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Save button
        Row(
          children: [
            ElevatedButton(
              onPressed: _saving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.teal,
                foregroundColor: AppColors.black,
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : Text(
                      _saved ? '✓ Saved!' : 'Save Changes',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700, fontSize: 14),
                    ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _profileTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _formLabel('Display Name'),
          _formField(_displayNameCtrl, hint: 'Your name'),
          const SizedBox(height: 20),
          _formLabel('Username'),
          _formField(_usernameCtrl,
              hint: 'yourhandle',
              prefix: Text('@',
                  style: GoogleFonts.poppins(
                      color: AppColors.textGray))),
          const SizedBox(height: 20),
          _formLabel('Bio'),
          _formField(_bioCtrl,
              hint: 'A little about you...', maxLines: 4),
          const SizedBox(height: 20),
          _formLabel('Avatar URL'),
          _formField(_avatarUrlCtrl,
              hint: 'https://... (leave blank to use Google avatar)'),
          const SizedBox(height: 8),
          Text(
            'Your Google avatar is used by default. Paste a custom image URL to override it.',
            style: GoogleFonts.poppins(
                color: AppColors.textMuted, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _appearanceTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _formLabel('Banner Style'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(_bannerGradients.length, (i) {
              final selected = _bannerIndex == i;
              return GestureDetector(
                onTap: () => setState(() => _bannerIndex = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 72,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _bannerGradients[i],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color:
                          selected ? AppColors.white : Colors.transparent,
                      width: 2.5,
                    ),
                  ),
                  child: selected
                      ? const Center(
                          child: Icon(Icons.check_rounded,
                              color: Colors.white, size: 18))
                      : null,
                ),
              );
            }),
          ),
          const SizedBox(height: 32),
          _formLabel('Post Timeline Theme'),
          const SizedBox(height: 4),
          Text(
            'Sets the colour palette of your Club260 feed',
            style: GoogleFonts.poppins(
                color: AppColors.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: TimelineTheme.values.map((t) {
              final selected = _selectedTheme == t;
              return GestureDetector(
                onTap: () => setState(() => _selectedTheme = t),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 100,
                  height: 72,
                  decoration: BoxDecoration(
                    color: t.bg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: selected
                          ? t.accent
                          : AppColors.borderColor,
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 32,
                        height: 8,
                        decoration: BoxDecoration(
                          color: t.accent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 48,
                        height: 5,
                        decoration: BoxDecoration(
                          color: t.accent.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        t.label,
                        style: GoogleFonts.poppins(
                          color: t.accent,
                          fontSize: 11,
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _socialTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _formLabel('𝕏 / Twitter'),
          _formField(_twitterCtrl,
              hint: '@yourhandle',
              prefix: Text('twitter.com/',
                  style: GoogleFonts.poppins(
                      color: AppColors.textMuted, fontSize: 13))),
          const SizedBox(height: 20),
          _formLabel('Instagram'),
          _formField(_instagramCtrl,
              hint: '@yourhandle',
              prefix: Text('instagram.com/',
                  style: GoogleFonts.poppins(
                      color: AppColors.textMuted, fontSize: 13))),
          const SizedBox(height: 20),
          _formLabel('Website'),
          _formField(_websiteCtrl, hint: 'https://yoursite.com'),
          const SizedBox(height: 32),
          const Divider(color: AppColors.borderColor),
          const SizedBox(height: 20),
          _formLabel('DANGER ZONE'),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: AppColors.darkGray,
                  title: Text('Sign out?',
                      style: GoogleFonts.poppins(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700)),
                  content: Text(
                      'You will be signed out of your account.',
                      style: GoogleFonts.poppins(
                          color: AppColors.textGray)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Cancel',
                          style: GoogleFonts.poppins(
                              color: AppColors.textGray)),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('Sign Out',
                          style: GoogleFonts.poppins(
                              color: Colors.red)),
                    ),
                  ],
                ),
              );
              if (confirm == true && mounted) {
                await SupabaseService.client.auth.signOut();
                if (mounted) context.go('/');
              }
            },
            icon: const Icon(Icons.logout, size: 16, color: Colors.red),
            label: Text('Sign Out',
                style: GoogleFonts.poppins(
                    color: Colors.red, fontSize: 13)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red, width: 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          color: AppColors.textGray,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _formField(
    TextEditingController controller, {
    required String hint,
    int maxLines = 1,
    Widget? prefix,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      onChanged: (_) => setState(() {}),
      style: GoogleFonts.poppins(color: AppColors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle:
            GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 14),
        prefixIcon: prefix != null
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                child: prefix,
              )
            : null,
        prefixIconConstraints:
            prefix != null ? const BoxConstraints() : null,
        filled: true,
        fillColor: AppColors.cardBg,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.teal),
        ),
      ),
    );
  }
}

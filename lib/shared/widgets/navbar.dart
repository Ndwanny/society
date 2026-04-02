import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/controllers/auth_controller.dart';
import '../../core/services/supabase_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_controller.dart';

class AppNavbar extends StatefulWidget implements PreferredSizeWidget {
  const AppNavbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  State<AppNavbar> createState() => _AppNavbarState();
}

class _AppNavbarState extends State<AppNavbar> {
  String? _hoveredItem;

  final List<_NavItem> _items = [
    _NavItem('Home', '/'),
    _NavItem('Club260', '/club260'),
    _NavItem('Code260', '/code260'),
    _NavItem('Events', '/events'),
    _NavItem('Blog', '/blog'),
  ];

  void _toggleTheme() {
    ThemeController.instance.toggle();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    final currentPath = GoRouterState.of(context).uri.toString();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final navBg = isDark
        ? AppColors.black.withOpacity(0.95)
        : LightColors.background.withOpacity(0.97);
    final borderCol = isDark ? AppColors.borderColor : LightColors.border;
    final textColor = isDark ? AppColors.white : LightColors.text;
    final mutedColor = isDark ? AppColors.textGray : LightColors.textGray;
    final hoverBg = isDark
        ? AppColors.white.withOpacity(0.05)
        : LightColors.surface;

    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: navBg,
        border: Border(
          bottom: BorderSide(color: borderCol, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Row(
          children: [
            // Logo
            GestureDetector(
              onTap: () => context.go('/'),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                    children: [
                      TextSpan(
                        text: 'SOCIETY',
                        style: TextStyle(color: textColor),
                      ),
                      const TextSpan(
                        text: '260',
                        style: TextStyle(color: AppColors.teal),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Spacer(),

            if (isWide) ...[
              // Nav items
              Row(
                children: _items.map((item) {
                  final isActive = currentPath == item.route ||
                      (item.route != '/' &&
                          currentPath.startsWith(item.route));

                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) =>
                        setState(() => _hoveredItem = item.label),
                    onExit: (_) => setState(() => _hoveredItem = null),
                    child: GestureDetector(
                      onTap: () => context.go(item.route),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.teal.withOpacity(0.1)
                              : _hoveredItem == item.label
                                  ? hoverBg
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isActive
                                ? AppColors.teal.withOpacity(0.4)
                                : Colors.transparent,
                          ),
                        ),
                        child: Text(
                          item.label,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: isActive
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isActive
                                ? AppColors.teal
                                : _hoveredItem == item.label
                                    ? textColor
                                    : mutedColor,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(width: 16),

              // Theme toggle
              _ThemeToggle(isDark: isDark, onToggle: _toggleTheme),

              const SizedBox(width: 16),

              // Auth area — avatar when logged in, buttons when not
              ValueListenableBuilder<User?>(
                valueListenable: AuthController.instance.userNotifier,
                builder: (context, user, _) {
                  if (user != null) {
                    return _NavUserAvatar(
                      user: user,
                      textColor: textColor,
                      borderCol: borderCol,
                    );
                  }
                  return Row(
                    children: [
                      OutlinedButton(
                        onPressed: () => context.go('/login'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          side: BorderSide(color: borderCol),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Log In',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () => context.go('/signup'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.teal,
                          foregroundColor: AppColors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Join',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ] else ...[
              // Theme toggle (mobile)
              _ThemeToggle(isDark: isDark, onToggle: _toggleTheme),
              // Hamburger
              IconButton(
                icon: Icon(Icons.menu, color: textColor),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Animated Theme Toggle ────────────────────────────────────────────────────
class _ThemeToggle extends StatelessWidget {
  final bool isDark;
  final VoidCallback onToggle;

  const _ThemeToggle({required this.isDark, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onToggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 52,
          height: 28,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: isDark
                ? AppColors.teal.withOpacity(0.15)
                : LightColors.surface,
            border: Border.all(
              color: isDark ? AppColors.teal.withOpacity(0.5) : LightColors.border,
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment:
                    isDark ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? AppColors.teal : AppColors.gold,
                  ),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Icon(
                        isDark ? Icons.dark_mode : Icons.light_mode,
                        key: ValueKey(isDark),
                        size: 12,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final String route;
  _NavItem(this.label, this.route);
}

// ─── Logged-in user avatar + popup menu ──────────────────────────────────────
class _NavUserAvatar extends StatelessWidget {
  final User user;
  final Color textColor;
  final Color borderCol;

  const _NavUserAvatar({
    required this.user,
    required this.textColor,
    required this.borderCol,
  });

  String get _displayName =>
      (user.userMetadata?['full_name'] as String?) ??
      (user.userMetadata?['display_name'] as String?) ??
      user.email?.split('@').first ??
      'User';

  String? get _avatarUrl => user.userMetadata?['avatar_url'] as String?;

  @override
  Widget build(BuildContext context) {
    final avatar = _avatarUrl;
    final name = _displayName;

    return PopupMenuButton<String>(
      offset: const Offset(0, 52),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: const Color(0xFF1A1A1A),
      onSelected: (value) async {
        if (value == 'signout') {
          await SupabaseService.client.auth.signOut();
          if (context.mounted) context.go('/');
        } else if (value == 'feed') {
          context.go('/club260/feed');
        } else if (value == 'profile') {
          context.go('/club260/profile');
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: 'feed',
          child: Row(children: [
            const Icon(Icons.explore_outlined,
                size: 16, color: AppColors.teal),
            const SizedBox(width: 10),
            Text('My Feed',
                style: GoogleFonts.poppins(
                    color: AppColors.white, fontSize: 13)),
          ]),
        ),
        PopupMenuItem(
          value: 'profile',
          child: Row(children: [
            const Icon(Icons.manage_accounts_outlined,
                size: 16, color: AppColors.teal),
            const SizedBox(width: 10),
            Text('Edit Profile',
                style: GoogleFonts.poppins(
                    color: AppColors.white, fontSize: 13)),
          ]),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'signout',
          child: Row(children: [
            const Icon(Icons.logout, size: 16, color: AppColors.textGray),
            const SizedBox(width: 10),
            Text('Sign Out',
                style: GoogleFonts.poppins(
                    color: AppColors.textGray, fontSize: 13)),
          ]),
        ),
      ],
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(color: borderCol),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.teal.withOpacity(0.2),
                backgroundImage:
                    avatar != null ? NetworkImage(avatar) : null,
                child: avatar == null
                    ? Text(
                        name[0].toUpperCase(),
                        style: GoogleFonts.poppins(
                          color: AppColors.teal,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 8),
              Text(
                name.split(' ').first,
                style: GoogleFonts.poppins(
                  color: textColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.keyboard_arrow_down,
                  size: 16, color: textColor),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Mobile Drawer ────────────────────────────────────────────────────────────
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final drawerBg = isDark ? AppColors.darkGray : LightColors.card;
    final headerBg = isDark ? AppColors.black : LightColors.surface;
    final textColor = isDark ? AppColors.white : LightColors.text;
    final borderCol = isDark ? AppColors.borderColor : LightColors.border;

    return Drawer(
      backgroundColor: drawerBg,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: headerBg),
            child: Row(
              children: [
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                    children: [
                      TextSpan(
                        text: 'SOCIETY',
                        style: TextStyle(color: textColor),
                      ),
                      const TextSpan(
                        text: '260',
                        style: TextStyle(color: AppColors.teal),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Theme toggle in drawer
                ValueListenableBuilder<ThemeMode>(
                  valueListenable: ThemeController.instance.themeMode,
                  builder: (_, mode, __) => _ThemeToggle(
                    isDark: mode == ThemeMode.dark,
                    onToggle: ThemeController.instance.toggle,
                  ),
                ),
              ],
            ),
          ),
          _drawerItem(context, 'Home', '/', textColor),
          _drawerItem(context, 'Club260', '/club260', textColor),
          _drawerItem(context, 'Code260', '/code260', textColor),
          _drawerItem(context, 'Events', '/events', textColor),
          _drawerItem(context, 'Blog', '/blog', textColor),
          Divider(color: borderCol),
          ValueListenableBuilder<User?>(
            valueListenable: AuthController.instance.userNotifier,
            builder: (context, user, _) {
              if (user != null) {
                final avatarUrl =
                    user.userMetadata?['avatar_url'] as String?;
                final name = (user.userMetadata?['full_name'] as String?) ??
                    (user.userMetadata?['display_name'] as String?) ??
                    user.email?.split('@').first ??
                    'User';
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor:
                                AppColors.teal.withOpacity(0.2),
                            backgroundImage: avatarUrl != null
                                ? NetworkImage(avatarUrl)
                                : null,
                            child: avatarUrl == null
                                ? Text(
                                    name[0].toUpperCase(),
                                    style: GoogleFonts.poppins(
                                        color: AppColors.teal,
                                        fontWeight: FontWeight.w700),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name,
                                    style: GoogleFonts.poppins(
                                        color: textColor,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13)),
                                Text(user.email ?? '',
                                    style: GoogleFonts.poppins(
                                        color: AppColors.textGray,
                                        fontSize: 11),
                                    overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.explore_outlined,
                          color: AppColors.teal, size: 20),
                      title: Text('My Feed',
                          style: GoogleFonts.poppins(
                              color: textColor, fontWeight: FontWeight.w500)),
                      onTap: () {
                        Navigator.pop(context);
                        context.go('/club260/feed');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.manage_accounts_outlined,
                          color: AppColors.teal, size: 20),
                      title: Text('Edit Profile',
                          style: GoogleFonts.poppins(
                              color: textColor, fontWeight: FontWeight.w500)),
                      onTap: () {
                        Navigator.pop(context);
                        context.go('/club260/profile');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout,
                          color: AppColors.textGray, size: 20),
                      title: Text('Sign Out',
                          style: GoogleFonts.poppins(
                              color: AppColors.textGray,
                              fontWeight: FontWeight.w500)),
                      onTap: () async {
                        Navigator.pop(context);
                        await SupabaseService.client.auth.signOut();
                        if (context.mounted) context.go('/');
                      },
                    ),
                  ],
                );
              }
              return Column(
                children: [
                  _drawerItem(context, 'Log In', '/login', textColor),
                  _drawerItem(context, 'Join', '/signup', textColor),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(
      BuildContext context, String label, String route, Color textColor) {
    return ListTile(
      title: Text(
        label,
        style: GoogleFonts.poppins(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        context.go(route);
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

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

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    final currentPath = GoRouterState.of(context).uri.toString();

    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.black.withOpacity(0.95),
        border: const Border(
          bottom: BorderSide(color: AppColors.borderColor, width: 1),
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
                    style: GoogleFonts.spaceMono(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
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
            ),

            const Spacer(),

            if (isWide) ...[
              // Nav items
              Row(
                children: _items.map((item) {
                  final isActive = currentPath == item.route ||
                      (item.route != '/' && currentPath.startsWith(item.route));

                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    onEnter: (_) => setState(() => _hoveredItem = item.label),
                    onExit: (_) => setState(() => _hoveredItem = null),
                    child: GestureDetector(
                      onTap: () => context.go(item.route),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.teal.withOpacity(0.1)
                              : _hoveredItem == item.label
                                  ? AppColors.white.withOpacity(0.05)
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
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 14,
                            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                            color: isActive
                                ? AppColors.teal
                                : _hoveredItem == item.label
                                    ? AppColors.white
                                    : AppColors.textGray,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(width: 24),

              // Auth buttons
              OutlinedButton(
                onPressed: () => context.go('/login'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  side: const BorderSide(color: AppColors.borderColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Log In',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              ElevatedButton(
                onPressed: () => context.go('/signup'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.teal,
                  foregroundColor: AppColors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Join',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ] else ...[
              // Mobile hamburger
              IconButton(
                icon: const Icon(Icons.menu, color: AppColors.white),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ],
          ],
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

// Mobile Drawer
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.darkGray,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.black),
            child: Row(
              children: [
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.spaceMono(
                      fontSize: 22,
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
              ],
            ),
          ),
          _drawerItem(context, 'Home', '/'),
          _drawerItem(context, 'Club260', '/club260'),
          _drawerItem(context, 'Code260', '/code260'),
          _drawerItem(context, 'Events', '/events'),
          _drawerItem(context, 'Blog', '/blog'),
          const Divider(color: AppColors.borderColor),
          _drawerItem(context, 'Admin', '/admin'),
        ],
      ),
    );
  }

  Widget _drawerItem(BuildContext context, String label, String route) {
    return ListTile(
      title: Text(
        label,
        style: GoogleFonts.spaceGrotesk(
          color: AppColors.white,
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

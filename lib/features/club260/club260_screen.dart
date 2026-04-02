import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/controllers/auth_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/navbar.dart';
import '../../shared/widgets/footer.dart';

class Club260Screen extends StatefulWidget {
  const Club260Screen({super.key});

  @override
  State<Club260Screen> createState() => _Club260ScreenState();
}

class _Club260ScreenState extends State<Club260Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: const AppNavbar(),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _Club260Hero(),
            _Club260Features(),
            _NextSessionBanner(),
            _MembershipPreview(),
            const AppFooter(),
          ],
        ),
      ),
    );
  }
}

class _Club260Hero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.club260Secondary,
            AppColors.black,
            const Color(0xFF0D1F1C),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: 100,
            right: 80,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.teal.withOpacity(0.08),
                  width: 1,
                ),
              ),
            ),
          ),
          Positioned(
            top: 160,
            right: 140,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.teal.withOpacity(0.06),
                  width: 1,
                ),
              ),
            ),
          ),

          // Right-side image float (desktop)
          Builder(builder: (context) {
            if (MediaQuery.of(context).size.width <= 1100) return const SizedBox.shrink();
            return Positioned(
              right: 60,
              bottom: 80,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 340,
                  height: 420,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.teal.withOpacity(0.2),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Image.network(
                    'https://i.ibb.co/gMT25r9D/6.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: AppColors.cardBg),
                  ),
                ),
              ).animate().fadeIn(delay: 300.ms, duration: 800.ms).slideY(begin: 0.1),
            );
          }),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width > 768 ? 60 : 24,
              vertical: MediaQuery.of(context).size.width > 768 ? 120 : 80,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.teal.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: AppColors.teal.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    'BY SOCIETY260',
                    style: GoogleFonts.poppins(
                      color: AppColors.teal,
                      fontSize: 11,
                      letterSpacing: 2,
                    ),
                  ),
                ).animate().fadeIn(duration: 600.ms),

                const SizedBox(height: 32),

                Text(
                  'Club',
                  style: GoogleFonts.poppins(
                    fontSize: MediaQuery.of(context).size.width > 768 ? 96 : 60,
                    fontWeight: FontWeight.w900,
                    color: AppColors.white,
                    height: 0.9,
                    letterSpacing: -3,
                  ),
                ).animate().fadeIn(delay: 100.ms, duration: 800.ms).slideY(begin: 0.3),

                Text(
                  '260',
                  style: GoogleFonts.poppins(
                    fontSize: MediaQuery.of(context).size.width > 768 ? 96 : 60,
                    fontWeight: FontWeight.w900,
                    color: AppColors.teal,
                    height: 0.9,
                    letterSpacing: -3,
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 800.ms).slideY(begin: 0.3),

                const SizedBox(height: 32),

                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Text(
                    'Society260\'s monthly virtual gathering and online community. Connect, share, grow. A safe space built by and for you.',
                    style: GoogleFonts.poppins(
                      color: AppColors.textGray,
                      fontSize: 17,
                      height: 1.7,
                    ),
                  ).animate().fadeIn(delay: 400.ms),
                ),

                const SizedBox(height: 48),

                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => context.go('/club260/feed'),
                      icon: const Icon(Icons.explore_outlined, size: 18),
                      label: const Text('ENTER COMMUNITY'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.teal,
                        foregroundColor: AppColors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 16,
                        ),
                        textStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                          fontSize: 13,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () =>
                          context.go('/club260/membership'),
                      icon: const Icon(Icons.star_outline, size: 18),
                      label: const Text('MEMBERSHIP PLANS'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.white,
                        side: const BorderSide(color: AppColors.borderColor),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 16,
                        ),
                        textStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          fontSize: 13,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 600.ms),

                const Spacer(),

                // Stats row
                Wrap(
                  spacing: 48,
                  runSpacing: 24,
                  children: [
                    _StatBadge(value: '1,200+', label: 'Members'),
                    _StatBadge(value: '5,800+', label: 'Posts'),
                    _StatBadge(value: 'Monthly', label: 'Sessions'),
                    _StatBadge(value: '4', label: 'Courses'),
                  ],
                ).animate().fadeIn(delay: 800.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String value;
  final String label;
  const _StatBadge({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: AppColors.teal,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: AppColors.textGray,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _Club260Features extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 768;

    final features = [
      (
        Icons.dynamic_feed_outlined,
        'Social Feed',
        'Share posts, images, voice notes and videos. Reblog and engage with the community.',
        '/club260/feed',
        AppColors.teal,
      ),
      (
        Icons.chat_bubble_outline,
        'Messaging',
        'Text, voice messages, and video calls with fellow members of the community.',
        '/club260/messages',
        AppColors.softBlue,
      ),
      (
        Icons.play_circle_outline,
        'Online Courses',
        'Premium courses on mental wellness, resilience, and emotional intelligence.',
        '/club260/courses',
        AppColors.lavender,
      ),
      (
        Icons.star_outline,
        'Membership',
        'Upgrade for exclusive events, 1-on-1 coaching, and premium content.',
        '/club260/membership',
        AppColors.gold,
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
      color: AppColors.darkGray,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Everything in one place',
            style: GoogleFonts.poppins(
              fontSize: isWide ? 36 : 28,
              fontWeight: FontWeight.w900,
              color: AppColors.white,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 32),
          if (isWide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: features
                  .map((f) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: _FeatureCard(
                            icon: f.$1,
                            title: f.$2,
                            description: f.$3,
                            route: f.$4,
                            color: f.$5,
                          ),
                        ),
                      ))
                  .toList(),
            )
          else
            Column(
              children: features
                  .map((f) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _FeatureCard(
                          icon: f.$1,
                          title: f.$2,
                          description: f.$3,
                          route: f.$4,
                          color: f.$5,
                        ),
                      ))
                  .toList(),
            ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final String route;
  final Color color;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.route,
    required this.color,
  });

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.go(widget.route),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: _hovered
                ? widget.color.withOpacity(0.08)
                : AppColors.cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered
                  ? widget.color.withOpacity(0.3)
                  : AppColors.borderColor,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(widget.icon, color: widget.color, size: 22),
              ),
              const SizedBox(height: 20),
              Text(
                widget.title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.description,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.textGray,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NextSessionBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    return Container(
      margin: EdgeInsets.all(isWide ? 40 : 20),
      padding: EdgeInsets.all(isWide ? 40 : 24),
      decoration: BoxDecoration(
        color: AppColors.teal.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.teal.withOpacity(0.3)),
      ),
      child: isWide
          ? Row(
              children: [
                _sessionIcon(),
                const SizedBox(width: 24),
                Expanded(child: _sessionInfo()),
                const SizedBox(width: 24),
                _rsvpButton(context),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _sessionIcon(),
                    const SizedBox(width: 16),
                    Expanded(child: _sessionInfo()),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(width: double.infinity, child: _rsvpButton(context)),
              ],
            ),
    );
  }

  Widget _sessionIcon() => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.teal.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.video_call_outlined, color: AppColors.teal, size: 32),
      );

  Widget _sessionInfo() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('NEXT SESSION',
              style: GoogleFonts.poppins(
                  color: AppColors.teal, fontSize: 11, letterSpacing: 2)),
          const SizedBox(height: 8),
          Text('Club260 Monthly Gathering — June 29, 2025',
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.white)),
          const SizedBox(height: 4),
          Text('Featuring a special guest healer & life coach · Virtual · Open to all members',
              style: GoogleFonts.poppins(color: AppColors.textGray, fontSize: 14)),
        ],
      );

  Widget _rsvpButton(BuildContext context) => ElevatedButton(
        onPressed: () => AuthController.instance.isLoggedIn
            ? context.go('/events')
            : context.go('/signup'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.teal,
          foregroundColor: AppColors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text('RSVP',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w800, letterSpacing: 1)),
      );
}

class _MembershipPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
      color: AppColors.black,
      child: Column(
        children: [
          Text(
            'Choose your journey',
            style: GoogleFonts.poppins(
              fontSize: 40,
              fontWeight: FontWeight.w900,
              color: AppColors.white,
              letterSpacing: -2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Start free, upgrade when you\'re ready.',
            style: GoogleFonts.poppins(
              color: AppColors.textGray,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: () => context.go('/club260/membership'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.teal,
              foregroundColor: AppColors.black,
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 18,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'VIEW ALL PLANS',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/navbar.dart';
import '../../shared/widgets/footer.dart';
import '../../shared/models/models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() => _scrollOffset = _scrollController.offset);
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      extendBodyBehindAppBar: true,
      appBar: const AppNavbar(),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            _HeroSection(scrollOffset: _scrollOffset),
            _MarqueeSection(),
            _AboutSection(),
            _ProgramsSection(),
            _UpcomingEventsSection(),
            _BlogPreviewSection(),
            _JoinSection(),
            const AppFooter(),
          ],
        ),
      ),
    );
  }
}

// ─── Hero Section ────────────────────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  final double scrollOffset;
  const _HeroSection({required this.scrollOffset});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0A0A0A),
            Color(0xFF0D1A18),
            Color(0xFF0A0A0A),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background noise texture effect
          Positioned.fill(
            child: CustomPaint(
              painter: _NoisePainter(scrollOffset),
            ),
          ),

          // Gradient orbs
          Positioned(
            top: -200,
            right: -100,
            child: Container(
              width: 600,
              height: 600,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.teal.withOpacity(0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: -200,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.coral.withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Main content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 72),

                // Tag line
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.teal.withOpacity(0.5),
                    ),
                    borderRadius: BorderRadius.circular(100),
                    color: AppColors.teal.withOpacity(0.08),
                  ),
                  child: Text(
                    '/ A SAFE SPACE IN MOTION',
                    style: GoogleFonts.spaceMono(
                      fontSize: 11,
                      color: AppColors.teal,
                      letterSpacing: 2,
                    ),
                  ),
                ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2),

                const SizedBox(height: 32),

                // Main headline
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Text(
                    'Society\n260',
                    style: GoogleFonts.spaceMono(
                      fontSize: MediaQuery.of(context).size.width > 768
                          ? 120
                          : 72,
                      fontWeight: FontWeight.w900,
                      color: AppColors.white,
                      height: 0.9,
                      letterSpacing: -4,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 1000.ms)
                      .slideY(begin: 0.3),
                ),

                const SizedBox(height: 24),

                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Text(
                    'An independent initiative dedicated to fostering actionable mental health awareness. Creating inclusive, safe spaces for self-expression and growth.',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: AppColors.textGray,
                      height: 1.7,
                    ),
                  ).animate().fadeIn(delay: 400.ms, duration: 800.ms),
                ),

                const SizedBox(height: 48),

                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => context.go('/club260'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.teal,
                        foregroundColor: AppColors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'JOIN CLUB260',
                        style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                          fontSize: 13,
                        ),
                      ),
                    ).animate().fadeIn(delay: 600.ms).slideX(begin: -0.2),

                    const SizedBox(width: 16),

                    OutlinedButton(
                      onPressed: () => context.go('/code260'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.white,
                        side: const BorderSide(color: AppColors.borderColor),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 18,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'EXPLORE CODE260',
                        style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          fontSize: 13,
                        ),
                      ),
                    ).animate().fadeIn(delay: 700.ms).slideX(begin: -0.2),
                  ],
                ),

                const SizedBox(height: 80),

                // Scroll indicator
                Column(
                  children: [
                    Text(
                      'Scroll',
                      style: GoogleFonts.spaceMono(
                        color: AppColors.textMuted,
                        fontSize: 11,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const SizedBox(
                      height: 40,
                      child: VerticalDivider(
                        color: AppColors.borderColor,
                        width: 1,
                      ),
                    ),
                  ],
                ).animate().fadeIn(delay: 1200.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Marquee Section ─────────────────────────────────────────────────────────
class _MarqueeSection extends StatefulWidget {
  @override
  State<_MarqueeSection> createState() => _MarqueeSectionState();
}

class _MarqueeSectionState extends State<_MarqueeSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  static const _texts = [
    '/ A SAFE SPACE IN MOTION',
    '/ MENTAL HEALTH AWARENESS',
    '/ CLUB260',
    '/ CODE260',
    '/ ART THERAPY',
    '/ SELF EXPRESSION',
    '/ WORKSHOPS',
  ];

  // Each item width (text + padding). Tweak if items look uneven.
  static const double _itemWidth = 240.0;
  static const double _setWidth = 7 * _itemWidth; // _texts.length * _itemWidth

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 22),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      color: AppColors.teal,
      child: ClipRect(
        child: OverflowBox(
          maxWidth: double.infinity,
          alignment: Alignment.centerLeft,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(-_controller.value * _setWidth, 0),
                child: child,
              );
            },
            child: Row(
              children: List.generate(_texts.length * 4, (i) {
                return SizedBox(
                  width: _itemWidth,
                  child: Center(
                    child: Text(
                      _texts[i % _texts.length],
                      style: GoogleFonts.spaceMono(
                        color: AppColors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── About Section ────────────────────────────────────────────────────────────
class _AboutSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 768;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 40),
      color: AppColors.black,
      child: Column(
        children: [
          if (isWide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ABOUT',
                        style: GoogleFonts.spaceMono(
                          color: AppColors.teal,
                          fontSize: 12,
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'A platform for those who think with their hearts.',
                        style: GoogleFonts.spaceMono(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          color: AppColors.white,
                          height: 1.1,
                          letterSpacing: -1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 80),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 48),
                      Text(
                        'Society 260 stands as an independent communicative initiative driven by a resolute commitment to instigate actionable awareness surrounding mental health.',
                        style: GoogleFonts.inter(
                          color: AppColors.offWhite,
                          fontSize: 16,
                          height: 1.8,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'At our carefully curated forums, we encourage individuals to show up authentically and foster an inclusive environment where diverse experiences are respected.',
                        style: GoogleFonts.inter(
                          color: AppColors.textGray,
                          fontSize: 15,
                          height: 1.8,
                        ),
                      ),
                      const SizedBox(height: 32),
                      TextButton.icon(
                        onPressed: () => context.go('/blog'),
                        icon: const Icon(Icons.arrow_forward,
                            color: AppColors.teal, size: 18),
                        label: Text(
                          'Read our story',
                          style: GoogleFonts.spaceGrotesk(
                            color: AppColors.teal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ABOUT',
                  style: GoogleFonts.spaceMono(
                    color: AppColors.teal,
                    fontSize: 11,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'A platform for those who think with their hearts.',
                  style: GoogleFonts.spaceMono(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppColors.white,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Society 260 stands as an independent communicative initiative driven by a resolute commitment to instigate actionable awareness surrounding mental health.',
                  style: GoogleFonts.inter(
                    color: AppColors.textGray,
                    fontSize: 15,
                    height: 1.8,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

// ─── Programs Section ─────────────────────────────────────────────────────────
class _ProgramsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 768;

    final programs = [
      _ProgramCard(
        tag: 'COMMUNITY',
        title: 'Club260',
        description:
            'Monthly virtual gatherings, social networking, and a community built on mutual growth. Connect, share, and thrive.',
        color: AppColors.teal,
        icon: Icons.people_outline,
        route: '/club260',
      ),
      _ProgramCard(
        tag: 'CHILDREN',
        title: 'Code260',
        description:
            'A children\'s mental wellness program using comics, storytelling, and play to nurture emotional intelligence.',
        color: AppColors.coral,
        icon: Icons.auto_stories_outlined,
        route: '/code260',
      ),
      _ProgramCard(
        tag: 'CREATIVE',
        title: 'Art Therapy',
        description:
            'Writing workshops, panel discussions, and activations designed for transformative journeys of self-discovery.',
        color: AppColors.lavender,
        icon: Icons.brush_outlined,
        route: '/events',
      ),
      _ProgramCard(
        tag: 'FASHION',
        title: 'Style & Identity',
        description:
            'Fashion as a language for authentic self-expression. A limitless universe where you can embrace your true self.',
        color: AppColors.gold,
        icon: Icons.diamond_outlined,
        route: '/blog',
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 40),
      color: AppColors.darkGray,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PROGRAMS',
            style: GoogleFonts.spaceMono(
              color: AppColors.teal,
              fontSize: 12,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'What we offer',
            style: GoogleFonts.spaceMono(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: AppColors.white,
              letterSpacing: -2,
            ),
          ),
          const SizedBox(height: 60),
          GridView.count(
            crossAxisCount: isWide ? 2 : 1,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: isWide ? 1.8 : 2.2,
            children: programs,
          ),
        ],
      ),
    );
  }
}

class _ProgramCard extends StatefulWidget {
  final String tag;
  final String title;
  final String description;
  final Color color;
  final IconData icon;
  final String route;

  const _ProgramCard({
    required this.tag,
    required this.title,
    required this.description,
    required this.color,
    required this.icon,
    required this.route,
  });

  @override
  State<_ProgramCard> createState() => _ProgramCardState();
}

class _ProgramCardState extends State<_ProgramCard> {
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
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: _hovered
                ? widget.color.withOpacity(0.08)
                : AppColors.cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _hovered
                  ? widget.color.withOpacity(0.4)
                  : AppColors.borderColor,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(widget.icon, color: widget.color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      widget.tag,
                      style: GoogleFonts.spaceMono(
                        color: widget.color,
                        fontSize: 10,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                widget.title,
                style: GoogleFonts.spaceMono(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.white,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.description,
                style: GoogleFonts.inter(
                  color: AppColors.textGray,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Explore',
                    style: GoogleFonts.spaceGrotesk(
                      color: widget.color,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(Icons.arrow_forward, color: widget.color, size: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Upcoming Events Section ──────────────────────────────────────────────────
class _UpcomingEventsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final events = EventModel.mockEvents.where((e) => !e.isPast).toList();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 40),
      color: AppColors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EVENTS',
                    style: GoogleFonts.spaceMono(
                      color: AppColors.teal,
                      fontSize: 12,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'What\'s coming',
                    style: GoogleFonts.spaceMono(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: AppColors.white,
                      letterSpacing: -2,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => context.go('/events'),
                child: Text(
                  'View all →',
                  style: GoogleFonts.spaceGrotesk(
                    color: AppColors.teal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),
          ...events.take(3).map((event) => _EventRow(event: event)),
        ],
      ),
    );
  }
}

class _EventRow extends StatefulWidget {
  final EventModel event;
  const _EventRow({required this.event});

  @override
  State<_EventRow> createState() => _EventRowState();
}

class _EventRowState extends State<_EventRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.go('/events'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 2),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.cardBg : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Date
              SizedBox(
                width: 60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.event.date.day.toString().padLeft(2, '0'),
                      style: GoogleFonts.spaceMono(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: AppColors.teal,
                      ),
                    ),
                    Text(
                      ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                       'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
                          [widget.event.date.month - 1]
                          .toUpperCase(),
                      style: GoogleFonts.spaceMono(
                        fontSize: 11,
                        color: AppColors.textGray,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 32),

              // Divider
              Container(
                width: 1,
                height: 50,
                color: AppColors.borderColor,
              ),
              const SizedBox(width: 32),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.event.title,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.event.location,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.textGray,
                      ),
                    ),
                  ],
                ),
              ),

              if (widget.event.isVirtual)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.softBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      color: AppColors.softBlue.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    'VIRTUAL',
                    style: GoogleFonts.spaceMono(
                      color: AppColors.softBlue,
                      fontSize: 10,
                      letterSpacing: 1,
                    ),
                  ),
                ),

              const SizedBox(width: 16),
              Icon(
                Icons.arrow_forward,
                color: _hovered ? AppColors.teal : AppColors.borderColor,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Blog Preview ─────────────────────────────────────────────────────────────
class _BlogPreviewSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final posts = BlogPost.mockPosts.take(3).toList();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 40),
      color: AppColors.darkGray,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BLOG',
                    style: GoogleFonts.spaceMono(
                      color: AppColors.coral,
                      fontSize: 12,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Latest from us',
                    style: GoogleFonts.spaceMono(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: AppColors.white,
                      letterSpacing: -2,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => context.go('/blog'),
                child: Text(
                  'All posts →',
                  style: GoogleFonts.spaceGrotesk(
                    color: AppColors.coral,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 48),
          ...posts.map((post) => _BlogPreviewRow(post: post)),
        ],
      ),
    );
  }
}

class _BlogPreviewRow extends StatefulWidget {
  final BlogPost post;
  const _BlogPreviewRow({required this.post});

  @override
  State<_BlogPreviewRow> createState() => _BlogPreviewRowState();
}

class _BlogPreviewRowState extends State<_BlogPreviewRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.go('/blog'),
        child: Container(
          margin: const EdgeInsets.only(bottom: 1),
          padding: const EdgeInsets.symmetric(vertical: 28),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.borderColor),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post.title,
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: _hovered ? AppColors.coral : AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.post.excerpt,
                      style: GoogleFonts.inter(
                        color: AppColors.textGray,
                        fontSize: 14,
                        height: 1.6,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${widget.post.authorName} · ${widget.post.readTime} min read',
                      style: GoogleFonts.inter(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform: Matrix4.translationValues(
                  _hovered ? 4 : 0,
                  0,
                  0,
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: _hovered ? AppColors.coral : AppColors.borderColor,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Join Section ────────────────────────────────────────────────────────────
class _JoinSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(40),
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 60),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.teal.withOpacity(0.15),
            AppColors.coral.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: AppColors.teal.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Ready to join the movement?',
            textAlign: TextAlign.center,
            style: GoogleFonts.spaceMono(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: AppColors.white,
              letterSpacing: -2,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Become part of a community built on empathy, growth, and authentic self-expression.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: AppColors.textGray,
              fontSize: 16,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => context.go('/signup'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.teal,
                  foregroundColor: AppColors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'JOIN FOR FREE',
                  style: GoogleFonts.spaceGrotesk(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              OutlinedButton(
                onPressed: () => context.go('/club260/membership'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.white,
                  side: const BorderSide(color: AppColors.borderColor),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'VIEW PLANS',
                  style: GoogleFonts.spaceGrotesk(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Noise Painter ────────────────────────────────────────────────────────────
class _NoisePainter extends CustomPainter {
  final double offset;
  _NoisePainter(this.offset);

  @override
  void paint(Canvas canvas, Size size) {
    // Subtle dot grid
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.015)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1;

    const spacing = 32.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_NoisePainter old) => old.offset != offset;
}

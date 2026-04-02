import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
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
            _CommunityGallery(),
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
class _HeroSection extends StatefulWidget {
  final double scrollOffset;
  const _HeroSection({required this.scrollOffset});

  @override
  State<_HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<_HeroSection> {
  late VideoPlayerController _videoCtrl;
  bool _videoReady = false;

  @override
  void initState() {
    super.initState();
    _videoCtrl = VideoPlayerController.asset('assets/videos/hero.mp4')
      ..initialize().then((_) {
        if (mounted) {
          setState(() => _videoReady = true);
          _videoCtrl
            ..setLooping(true)
            ..setVolume(0)
            ..play();
        }
      });
  }

  @override
  void dispose() {
    _videoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── Video background ──────────────────────────────────────────
          if (_videoReady)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _videoCtrl.value.size.width,
                height: _videoCtrl.value.size.height,
                child: VideoPlayer(_videoCtrl),
              ),
            )
          else
            // Fallback gradient while video loads
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0A0A0A), Color(0xFF0D1A18), Color(0xFF0A0A0A)],
                ),
              ),
            ),

          // ── Subtle overlay — video has its own dark grading ──────────
          Container(color: Colors.black.withOpacity(0.25)),

          // ── Teal colour tint at bottom-left ──────────────────────────
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
                    AppColors.teal.withOpacity(0.10),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── Noise texture ─────────────────────────────────────────────
          Positioned.fill(
            child: CustomPaint(
              painter: _NoisePainter(widget.scrollOffset),
            ),
          ),

          // ── Floating image collage — desktop only ─────────────────────
          if (size.width > 1100)
            Positioned(
              right: 60,
              top: 0,
              bottom: 0,
              width: 420,
              child: Center(
                child: SizedBox(
                  width: 420,
                  height: 520,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        right: 40,
                        child: Transform.rotate(
                          angle: -0.06,
                          child: _heroImg('https://i.ibb.co/PzMZbdBK/9.png', 210, 270),
                        ).animate().fadeIn(delay: 400.ms, duration: 800.ms).slideY(begin: 0.15),
                      ),
                      Positioned(
                        top: 140,
                        left: 0,
                        child: Transform.rotate(
                          angle: 0.05,
                          child: _heroImg('https://i.ibb.co/6cfg04wL/8.png', 185, 230),
                        ).animate().fadeIn(delay: 600.ms, duration: 800.ms).slideY(begin: 0.15),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 20,
                        child: Transform.rotate(
                          angle: -0.04,
                          child: _heroImg('https://i.ibb.co/p6q9vCD8/7.png', 230, 200),
                        ).animate().fadeIn(delay: 800.ms, duration: 800.ms).slideY(begin: 0.15),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // ── Main content ──────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 72),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.teal.withOpacity(0.5)),
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

                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Text(
                    'Society\n260',
                    style: GoogleFonts.spaceMono(
                      fontSize: size.width > 768 ? 120 : 72,
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
                      color: AppColors.offWhite.withOpacity(0.85),
                      height: 1.7,
                    ),
                  ).animate().fadeIn(delay: 400.ms, duration: 800.ms),
                ),

                const SizedBox(height: 48),

                Wrap(
                  spacing: 16,
                  runSpacing: 12,
                  children: [
                    ElevatedButton(
                      onPressed: () => context.go('/club260'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.teal,
                        foregroundColor: AppColors.black,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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

                    OutlinedButton(
                      onPressed: () => context.go('/code260'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.white,
                        side: const BorderSide(color: AppColors.borderColor),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                      child: VerticalDivider(color: AppColors.borderColor, width: 1),
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

  Widget _heroImg(String url, double w, double h) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.teal.withOpacity(0.25), width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Image.network(
          url,
          width: w,
          height: h,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(color: AppColors.cardBg),
        ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.black : LightColors.background;
    final headingColor = isDark ? AppColors.white : LightColors.text;
    final bodyColor = isDark ? AppColors.offWhite : LightColors.textGray;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 40),
      color: bgColor,
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
                          color: headingColor,
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
                          color: bodyColor,
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
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.white
                        : LightColors.text,
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

// ─── Community Gallery ────────────────────────────────────────────────────────
class _CommunityGallery extends StatelessWidget {
  static const _images = [
    'https://i.ibb.co/PzMZbdBK/9.png',
    'https://i.ibb.co/6cfg04wL/8.png',
    'https://i.ibb.co/p6q9vCD8/7.png',
    'https://i.ibb.co/gMT25r9D/6.png',
    'https://i.ibb.co/xq3yMYmD/5.png',
    'https://i.ibb.co/VYZgjWZW/4.png',
    'https://i.ibb.co/3ycFbtSN/3.png',
    'https://i.ibb.co/zW2D0LVG/11.png',
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 768;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 80,
        horizontal: isWide ? 60 : 24,
      ),
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.black
          : LightColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Real moments.',
            style: GoogleFonts.spaceMono(
              fontSize: isWide ? 52 : 34,
              fontWeight: FontWeight.w900,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.white
                  : LightColors.text,
              height: 1.0,
              letterSpacing: -2,
            ),
          ).animate().fadeIn(duration: 600.ms),
          const SizedBox(height: 12),
          Text(
            'Community captured.',
            style: GoogleFonts.inter(
              color: AppColors.teal,
              fontSize: 15,
              letterSpacing: 1,
            ),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 48),
          if (isWide) _desktopGrid() else _mobileGrid(),
        ],
      ),
    );
  }

  void _openLightbox(BuildContext context, int startIndex) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.92),
      builder: (_) => _GalleryLightbox(images: _images, initialIndex: startIndex),
    );
  }

  Widget _desktopGrid() {
    final heights1 = [300.0, 220.0, 280.0, 200.0];
    final heights2 = [200.0, 280.0, 220.0, 300.0];

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(4, (i) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: i < 3 ? 8 : 0),
                child: _GalleryTile(
                  url: _images[i],
                  height: heights1[i],
                  onTap: () => _openLightbox(context, i),
                ).animate().fadeIn(delay: Duration(milliseconds: 100 * i), duration: 600.ms),
              ),
            );
          }),
        ),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(4, (i) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: i < 3 ? 8 : 0),
                child: _GalleryTile(
                  url: _images[i + 4],
                  height: heights2[i],
                  onTap: () => _openLightbox(context, i + 4),
                ).animate().fadeIn(delay: Duration(milliseconds: 100 * i + 200), duration: 600.ms),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _mobileGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.85,
      ),
      itemCount: _images.length,
      itemBuilder: (_, i) => _GalleryTile(
        url: _images[i],
        height: 0,
        onTap: () => _openLightbox(context, i),
      ),
    );
  }
}

class _GalleryTile extends StatefulWidget {
  final String url;
  final double height;
  final VoidCallback onTap;
  const _GalleryTile({required this.url, required this.height, required this.onTap});

  @override
  State<_GalleryTile> createState() => _GalleryTileState();
}

class _GalleryTileState extends State<_GalleryTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.zoomIn,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: widget.height > 0 ? widget.height : null,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered ? AppColors.teal.withOpacity(0.5) : Colors.transparent,
              width: 2,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  widget.url,
                  fit: BoxFit.cover,
                  loadingBuilder: (_, child, progress) => progress == null
                      ? child
                      : Container(
                          color: AppColors.cardBg,
                          child: const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.5,
                                color: AppColors.teal,
                              ),
                            ),
                          ),
                        ),
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.cardBg,
                    child: const Icon(Icons.image_outlined, color: AppColors.textMuted),
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  opacity: _hovered ? 1.0 : 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, AppColors.teal.withOpacity(0.35)],
                      ),
                    ),
                    child: const Align(
                      alignment: Alignment.center,
                      child: Icon(Icons.zoom_in_rounded, color: Colors.white, size: 32),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Gallery Lightbox Modal ───────────────────────────────────────────────────
class _GalleryLightbox extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  const _GalleryLightbox({required this.images, required this.initialIndex});

  @override
  State<_GalleryLightbox> createState() => _GalleryLightboxState();
}

class _GalleryLightboxState extends State<_GalleryLightbox> {
  late int _current;
  late PageController _pageCtrl;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
    _pageCtrl = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  void _prev() {
    if (_current > 0) {
      _pageCtrl.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _next() {
    if (_current < widget.images.length - 1) {
      _pageCtrl.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          // ── Swipeable image ───────────────────────────────────────────
          PageView.builder(
            controller: _pageCtrl,
            itemCount: widget.images.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (_, i) => Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 80),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    widget.images[i],
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.cardBg,
                      child: const Icon(Icons.broken_image_outlined,
                          color: AppColors.textMuted, size: 48),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Close button ──────────────────────────────────────────────
          Positioned(
            top: 20,
            right: 20,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
          ),

          // ── Prev arrow ────────────────────────────────────────────────
          if (_current > 0)
            Positioned(
              left: 12,
              top: 0,
              bottom: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _prev,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
                  ),
                ),
              ),
            ),

          // ── Next arrow ────────────────────────────────────────────────
          if (_current < widget.images.length - 1)
            Positioned(
              right: 12,
              top: 0,
              bottom: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _next,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: const Icon(Icons.chevron_right, color: Colors.white, size: 28),
                  ),
                ),
              ),
            ),

          // ── Dot indicators ────────────────────────────────────────────
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.images.length, (i) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == _current ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i == _current
                        ? AppColors.teal
                        : Colors.white.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(100),
                  ),
                );
              }),
            ),
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
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkGray
          : LightColors.surface,
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
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.white
                  : LightColors.text,
              letterSpacing: -2,
            ),
          ),
          const SizedBox(height: 60),
          if (isWide)
            Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: programs[0]),
                      const SizedBox(width: 24),
                      Expanded(child: programs[1]),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: programs[2]),
                      const SizedBox(width: 24),
                      Expanded(child: programs[3]),
                    ],
                  ),
                ),
                if (programs.length > 4) ...[
                  const SizedBox(height: 24),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (int i = 4; i < programs.length; i++) ...[
                          if (i > 4) const SizedBox(width: 24),
                          Expanded(child: programs[i]),
                        ],
                        if (programs.length.isOdd) const Expanded(child: SizedBox()),
                      ],
                    ),
                  ),
                ],
              ],
            )
          else
            Column(
              children: programs
                  .map((p) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: p,
                      ))
                  .toList(),
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
            mainAxisSize: MainAxisSize.min,
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
              const SizedBox(height: 24),
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
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.black
          : LightColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Column(
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
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.white
                            : LightColors.text,
                        letterSpacing: -2,
                      ),
                    ),
                  ],
                ),
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
          child: Builder(builder: (context) {
            final isWide = MediaQuery.of(context).size.width > 600;
            final months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
            final dateWidget = SizedBox(
              width: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.event.date.day.toString().padLeft(2, '0'),
                    style: GoogleFonts.spaceMono(
                      fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.teal),
                  ),
                  Text(
                    months[widget.event.date.month - 1].toUpperCase(),
                    style: GoogleFonts.spaceMono(
                      fontSize: 11, color: AppColors.textGray, letterSpacing: 1),
                  ),
                ],
              ),
            );
            final contentWidget = Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.event.title,
                      style: GoogleFonts.spaceGrotesk(
                          fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.white)),
                  const SizedBox(height: 4),
                  Text(widget.event.location,
                      style: GoogleFonts.inter(fontSize: 13, color: AppColors.textGray)),
                ],
              ),
            );
            final virtualBadge = widget.event.isVirtual
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.softBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: AppColors.softBlue.withOpacity(0.3)),
                    ),
                    child: Text('VIRTUAL',
                        style: GoogleFonts.spaceMono(
                            color: AppColors.softBlue, fontSize: 10, letterSpacing: 1)),
                  )
                : const SizedBox.shrink();

            final arrowIcon = Icon(
              Icons.arrow_forward,
              color: _hovered ? AppColors.teal : AppColors.borderColor,
              size: 20,
            );

            if (isWide) {
              return Row(children: [
                dateWidget,
                const SizedBox(width: 32),
                Container(width: 1, height: 50, color: AppColors.borderColor),
                const SizedBox(width: 32),
                contentWidget,
                virtualBadge,
                const SizedBox(width: 16),
                arrowIcon,
              ]);
            }
            // Mobile layout
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                dateWidget,
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.event.title,
                          style: GoogleFonts.spaceGrotesk(
                              fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.white)),
                      const SizedBox(height: 4),
                      Text(widget.event.location,
                          style: GoogleFonts.inter(fontSize: 13, color: AppColors.textGray)),
                      if (widget.event.isVirtual) ...[
                        const SizedBox(height: 8),
                        virtualBadge,
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                arrowIcon,
              ],
            );
          }),
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
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.darkGray
          : LightColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: Column(
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
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.white
                            : LightColors.text,
                        letterSpacing: -2,
                      ),
                    ),
                  ],
                ),
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
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.white
                  : LightColors.text,
              letterSpacing: -2,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Become part of a community built on empathy, growth, and authentic self-expression.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.textGray
                  : LightColors.textGray,
              fontSize: 16,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 48),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            alignment: WrapAlignment.center,
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

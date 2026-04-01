import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/navbar.dart';
import '../../shared/widgets/footer.dart';
import '../../core/constants/app_constants.dart';

class Code260Screen extends StatefulWidget {
  const Code260Screen({super.key});

  @override
  State<Code260Screen> createState() => _Code260ScreenState();
}

class _Code260ScreenState extends State<Code260Screen>
    with TickerProviderStateMixin {
  int _selectedIssue = 1;
  int _currentPage = 0;
  bool _comicOpen = false;
  late AnimationController _flipController;

  // Issue pages - using color-coded placeholder panels
  final List<List<_ComicPanel>> _issuePages = [
    // Issue 1 pages
    [
      _ComicPanel(
          type: 'cover',
          color: const Color(0xFF1A1A2E),
          text:
              'ISSUE #1\n"The Beginning"\nJoin Zara, Moni and Sol as they journey into the big, big world.'),
      _ComicPanel(
          type: 'page',
          color: const Color(0xFF16213E),
          text:
              'First day at Lumina Academy. New faces, new opportunities. Three young minds about to find each other.'),
      _ComicPanel(
          type: 'page',
          color: const Color(0xFF0F3460),
          text:
              '"Maybe this year will be better than last year."\n"I feel like I\'m finally making new friends."\n"I\'m glad I came to this school."'),
      _ComicPanel(
          type: 'page',
          color: const Color(0xFF1A1A2E),
          text:
              '"Hi! I\'m Moni. Are you new here?"\n\nFriendships can start in the simplest moments — a kind word, a welcoming smile.'),
    ],
    // Issue 2 pages
    [
      _ComicPanel(
          type: 'cover',
          color: const Color(0xFF1A2E2B),
          text:
              'ISSUE #2\n"Back to School"\nDiving into the messy, colourful world of emotions.'),
      _ComicPanel(
          type: 'page',
          color: const Color(0xFF1C2E22),
          text:
              '"I can\'t believe I messed up my art project.. AGAIN, ugh!"\n"It\'s okay, Zara. Everyone makes mistakes."'),
      _ComicPanel(
          type: 'page',
          color: const Color(0xFF2A1F2E),
          text:
              'Sol begins to open up, sharing their struggles with body image, while Zara and Moni listen with empathy.\n\nTogether, they form a constellation of support.'),
      _ComicPanel(
          type: 'page',
          color: const Color(0xFF1A2E2B),
          text:
              '"It\'s okay to feel frustrated or disappointed sometimes. It\'s part of life."\n"The important thing is to acknowledge those feelings and find healthy ways to cope."'),
      _ComicPanel(
          type: 'page',
          color: const Color(0xFF1A1A2E),
          text:
              '✦ What is a Constellation of Support? ✦\n\nImagine a constellation — a group of stars in the night sky. Each star shines on its own, but together, they make something beautiful.'),
    ],
  ];

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.code260Bg,
      appBar: const AppNavbar(),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _Code260Hero(),
            _CharactersSection(),
            _ComicSection(
              selectedIssue: _selectedIssue,
              currentPage: _currentPage,
              comicOpen: _comicOpen,
              issuePages: _issuePages,
              onIssueSelect: (i) =>
                  setState(() {
                    _selectedIssue = i;
                    _currentPage = 0;
                  }),
              onPageChange: (p) =>
                  setState(() => _currentPage = p),
              onToggleComic: () =>
                  setState(() => _comicOpen = !_comicOpen),
            ),
            _Code260Programs(),
            const AppFooter(),
          ],
        ),
      ),
    );
  }
}

// ─── Hero ─────────────────────────────────────────────────────────────────────
class _Code260Hero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.code260Bg,
            const Color(0xFF16213E),
            AppColors.code260Bg,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Floating shapes
          ...List.generate(
              8,
              (i) => Positioned(
                    left: (i * 150.0) % 600,
                    top: (i * 80.0) % 400 + 80,
                    child: _FloatingShape(index: i),
                  )),

          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 60, vertical: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.code260Primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                        color: AppColors.code260Primary.withOpacity(0.3)),
                  ),
                  child: Text(
                    '🌈 BY SOCIETY260',
                    style: GoogleFonts.spaceMono(
                      color: AppColors.code260Primary,
                      fontSize: 11,
                      letterSpacing: 2,
                    ),
                  ),
                ).animate().fadeIn(),

                const SizedBox(height: 32),

                Text(
                  'Code',
                  style: GoogleFonts.spaceMono(
                    fontSize: MediaQuery.of(context).size.width > 768
                        ? 96
                        : 60,
                    fontWeight: FontWeight.w900,
                    color: AppColors.white,
                    height: 0.9,
                    letterSpacing: -3,
                  ),
                ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.3),

                Text(
                  '260',
                  style: GoogleFonts.spaceMono(
                    fontSize: MediaQuery.of(context).size.width > 768
                        ? 96
                        : 60,
                    fontWeight: FontWeight.w900,
                    color: AppColors.code260Primary,
                    height: 0.9,
                    letterSpacing: -3,
                  ),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3),

                const SizedBox(height: 32),

                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Text(
                    'Society260\'s children\'s mental wellness program — nurturing young minds through creativity, storytelling, and play.',
                    style: GoogleFonts.inter(
                      color: AppColors.textGray,
                      fontSize: 17,
                      height: 1.7,
                    ),
                  ).animate().fadeIn(delay: 400.ms),
                ),

                const SizedBox(height: 48),

                Wrap(
                  spacing: 16,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Text('📖', style: TextStyle(fontSize: 16)),
                      label: const Text('READ THE COMIC'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.code260Primary,
                        foregroundColor: AppColors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        textStyle: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                          fontSize: 13,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ).animate().fadeIn(delay: 600.ms),
                    OutlinedButton(
                      onPressed: () => context.go('/events'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.white,
                        side: const BorderSide(color: AppColors.borderColor),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'WORKSHOPS',
                        style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          fontSize: 13,
                        ),
                      ),
                    ).animate().fadeIn(delay: 700.ms),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingShape extends StatefulWidget {
  final int index;
  const _FloatingShape({required this.index});

  @override
  State<_FloatingShape> createState() => _FloatingShapeState();
}

class _FloatingShapeState extends State<_FloatingShape>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3 + (widget.index % 3)),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final shapes = ['⭐', '💫', '✨', '🌟', '💙', '🌈', '💚', '🎨'];
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _anim.value),
        child: Text(
          shapes[widget.index % shapes.length],
          style: TextStyle(
            fontSize: 24 + (widget.index % 3) * 8.0,
            color: Colors.white.withOpacity(0.15),
          ),
        ),
      ),
    );
  }
}

// ─── Characters ───────────────────────────────────────────────────────────────
class _CharactersSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;
    final characters = AppConstants.characters;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
      color: AppColors.black,
      child: Column(
        children: [
          Text(
            '✦ Meet the Crew ✦',
            style: GoogleFonts.spaceMono(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: AppColors.white,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Three 13-year-olds navigating the big, big world together.',
            style: GoogleFonts.inter(
              color: AppColors.textGray,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 48),
          GridView.count(
            crossAxisCount: isWide ? 3 : 1,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: isWide ? 0.75 : 1.5,
            children: characters
                .map((c) => _CharacterCard(character: c))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _CharacterCard extends StatefulWidget {
  final Map<String, dynamic> character;
  const _CharacterCard({required this.character});

  @override
  State<_CharacterCard> createState() => _CharacterCardState();
}

class _CharacterCardState extends State<_CharacterCard> {
  bool _flipped = false;

  @override
  Widget build(BuildContext context) {
    final color = Color(widget.character['color'] as int);

    return GestureDetector(
      onTap: () => setState(() => _flipped = !_flipped),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, animation) {
            return RotationYTransition(turns: animation, child: child);
          },
          child: _flipped
              ? _CharacterBack(
                  key: const ValueKey('back'),
                  character: widget.character,
                  color: color,
                )
              : _CharacterFront(
                  key: const ValueKey('front'),
                  character: widget.character,
                  color: color,
                ),
        ),
      ),
    );
  }
}

class _CharacterFront extends StatelessWidget {
  final Map<String, dynamic> character;
  final Color color;

  const _CharacterFront({
    super.key,
    required this.character,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withOpacity(0.2), AppColors.cardBg],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Character avatar placeholder
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.15),
                  border: Border.all(color: color.withOpacity(0.5), width: 2),
                ),
                child: Center(
                  child: Text(
                    character['name'][0],
                    style: GoogleFonts.spaceMono(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: color,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                character['name'],
                style: GoogleFonts.spaceMono(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: color,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Age ${character['age']}',
                style: GoogleFonts.inter(
                  color: AppColors.textGray,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                character['tagline'],
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: AppColors.offWhite,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
              ),
            ),
            const Spacer(),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  'Tap to learn more',
                  style: GoogleFonts.spaceMono(
                    color: color,
                    fontSize: 10,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CharacterBack extends StatelessWidget {
  final Map<String, dynamic> character;
  final Color color;

  const _CharacterBack({
    super.key,
    required this.character,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            character['name'],
            style: GoogleFonts.spaceMono(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: color,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 20),
          _infoRow('✦ Style', character['style'], color),
          const SizedBox(height: 16),
          _infoRow('⚡ Struggle', character['struggle'], color),
          const SizedBox(height: 16),
          _infoRow('💡 Fun Fact', character['funFact'], color),
          const Spacer(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.2)),
            ),
            child: Text(
              character['description'],
              style: GoogleFonts.inter(
                color: AppColors.offWhite,
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Tap to flip back',
              style: GoogleFonts.spaceMono(
                color: AppColors.textMuted,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.spaceMono(
            color: color,
            fontSize: 10,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            color: AppColors.textGray,
            fontSize: 13,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

// ─── Rotation Y Transition ───────────────────────────────────────────────────
class RotationYTransition extends AnimatedWidget {
  final Widget child;
  const RotationYTransition({
    super.key,
    required Animation<double> turns,
    required this.child,
  }) : super(listenable: turns);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Transform(
      transform: Matrix4.rotationY(animation.value * 3.14159),
      alignment: Alignment.center,
      child: child,
    );
  }
}

// ─── Comic Section ────────────────────────────────────────────────────────────
class _ComicSection extends StatelessWidget {
  final int selectedIssue;
  final int currentPage;
  final bool comicOpen;
  final List<List<_ComicPanel>> issuePages;
  final Function(int) onIssueSelect;
  final Function(int) onPageChange;
  final VoidCallback onToggleComic;

  const _ComicSection({
    required this.selectedIssue,
    required this.currentPage,
    required this.comicOpen,
    required this.issuePages,
    required this.onIssueSelect,
    required this.onPageChange,
    required this.onToggleComic,
  });

  @override
  Widget build(BuildContext context) {
    final pages = issuePages[selectedIssue - 1];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
      color: AppColors.darkGray,
      child: Column(
        children: [
          // Section header
          Text(
            '📚 The Comic Series',
            style: GoogleFonts.spaceMono(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: AppColors.white,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'An ongoing story of growth, friendship, and emotional discovery.',
            style: GoogleFonts.inter(
              color: AppColors.textGray,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 48),

          // Issue selector
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [1, 2].map((issue) {
              final isSelected = selectedIssue == issue;
              return GestureDetector(
                onTap: () => onIssueSelect(issue),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.code260Primary
                        : AppColors.cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.code260Primary
                          : AppColors.borderColor,
                    ),
                  ),
                  child: Text(
                    'Issue #$issue',
                    style: GoogleFonts.spaceGrotesk(
                      color: isSelected
                          ? AppColors.black
                          : AppColors.textGray,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 40),

          // Comic viewer
          AnimatedSize(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            child: comicOpen
                ? _ComicViewer(
                    pages: pages,
                    currentPage: currentPage,
                    onPageChange: onPageChange,
                    onClose: onToggleComic,
                  )
                : _ComicPreview(
                    issue: selectedIssue,
                    panel: pages.first,
                    onOpen: onToggleComic,
                  ),
          ),
        ],
      ),
    );
  }
}

class _ComicPreview extends StatelessWidget {
  final int issue;
  final _ComicPanel panel;
  final VoidCallback onOpen;

  const _ComicPreview({
    required this.issue,
    required this.panel,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 768;

    return Container(
      constraints:
          BoxConstraints(maxWidth: isWide ? 700 : double.infinity),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onOpen,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 380,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  panel.color,
                  panel.color.withBlue(
                      (panel.color.blue + 30).clamp(0, 255)),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.code260Primary.withOpacity(0.3),
              ),
            ),
            child: Stack(
              children: [
                // Decorative dots
                ...List.generate(
                    6,
                    (i) => Positioned(
                          right: 20 + (i * 40.0),
                          top: 20 + ((i % 3) * 30.0),
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                        )),

                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.code260Primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          'ISSUE #$issue',
                          style: GoogleFonts.spaceMono(
                            color: AppColors.code260Primary,
                            fontSize: 11,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        panel.text,
                        style: GoogleFonts.spaceGrotesk(
                          color: AppColors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          height: 1.5,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.code260Primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.menu_book,
                                    color: AppColors.black, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  'READ NOW',
                                  style: GoogleFonts.spaceGrotesk(
                                    color: AppColors.black,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 13,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
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

class _ComicViewer extends StatelessWidget {
  final List<_ComicPanel> pages;
  final int currentPage;
  final Function(int) onPageChange;
  final VoidCallback onClose;

  const _ComicViewer({
    required this.pages,
    required this.currentPage,
    required this.onPageChange,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final panel = pages[currentPage];
    final isWide = MediaQuery.of(context).size.width > 768;

    return Container(
      constraints:
          BoxConstraints(maxWidth: isWide ? 800 : double.infinity),
      child: Column(
        children: [
          // Comic page
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (child, animation) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.3, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOut,
                )),
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            child: Container(
              key: ValueKey(currentPage),
              height: 500,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    panel.color,
                    panel.color.withBlue(
                        (panel.color.blue + 40).clamp(0, 255)),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.code260Primary.withOpacity(0.2),
                ),
              ),
              child: Stack(
                children: [
                  // Panel grid overlay
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _ComicGridPainter(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'PAGE ${currentPage + 1} OF ${pages.length}',
                              style: GoogleFonts.spaceMono(
                                color: AppColors.code260Primary
                                    .withOpacity(0.7),
                                fontSize: 10,
                                letterSpacing: 2,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.close,
                                  color: Colors.white54, size: 20),
                              onPressed: onClose,
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          panel.text,
                          style: GoogleFonts.spaceGrotesk(
                            color: AppColors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: currentPage > 0
                    ? () => onPageChange(currentPage - 1)
                    : null,
                icon: const Icon(Icons.chevron_left),
                color: currentPage > 0 ? AppColors.white : AppColors.borderColor,
                iconSize: 32,
              ),
              const SizedBox(width: 16),
              // Page dots
              Row(
                children: List.generate(
                  pages.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == currentPage ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == currentPage
                          ? AppColors.code260Primary
                          : AppColors.borderColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: currentPage < pages.length - 1
                    ? () => onPageChange(currentPage + 1)
                    : null,
                icon: const Icon(Icons.chevron_right),
                color: currentPage < pages.length - 1
                    ? AppColors.white
                    : AppColors.borderColor,
                iconSize: 32,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ComicGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..strokeWidth = 1;

    // Horizontal lines
    for (double y = 0; y < size.height; y += size.height / 3) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Vertical lines
    for (double x = 0; x < size.width; x += size.width / 2) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(_ComicGridPainter old) => false;
}

// ─── Code260 Programs ─────────────────────────────────────────────────────────
class _Code260Programs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
      color: AppColors.black,
      child: Column(
        children: [
          Text(
            'What Code260 Offers',
            style: GoogleFonts.spaceMono(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: AppColors.white,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 48),
          GridView.count(
            crossAxisCount: isWide ? 2 : 1,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: isWide ? 2.2 : 2.5,
            children: const [
              _ProgramTile(
                icon: '🎭',
                title: 'Children\'s Workshops',
                description:
                    'Hands-on, fun workshops for kids ages 8-14 focused on emotional learning through art, storytelling, and play.',
                color: AppColors.code260Primary,
              ),
              _ProgramTile(
                icon: '📚',
                title: 'Comic Series',
                description:
                    'An ongoing comic series following Zara, Moni, and Sol as they navigate emotions, friendships, and growing up.',
                color: AppColors.code260Secondary,
              ),
              _ProgramTile(
                icon: '👩‍👧',
                title: 'Parent & Educator Toolkit',
                description:
                    'Resources for parents and teachers to foster emotionally resilient children and continue conversations at home.',
                color: AppColors.teal,
              ),
              _ProgramTile(
                icon: '🎮',
                title: 'Interactive Games',
                description:
                    'Online games and activities that make emotional learning fun — including the story creator and memory match.',
                color: AppColors.softBlue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgramTile extends StatelessWidget {
  final String icon;
  final String title;
  final String description;
  final Color color;

  const _ProgramTile({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 36)),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.spaceGrotesk(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    color: AppColors.textGray,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Data ────────────────────────────────────────────────────────────────────
class _ComicPanel {
  final String type;
  final Color color;
  final String text;
  const _ComicPanel({
    required this.type,
    required this.color,
    required this.text,
  });
}

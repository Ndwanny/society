import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/repositories/blog_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/navbar.dart';
import '../../shared/widgets/footer.dart';
import '../../shared/models/models.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  BlogCategory? _selectedCategory;
  final _repo = BlogRepository();
  List<BlogPost> _allPosts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    try {
      final posts = await _repo.fetchAll();
      if (mounted) setState(() { _allPosts = posts; _loading = false; });
    } catch (_) {
      if (mounted) setState(() { _allPosts = BlogPost.mockPosts; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final posts = _allPosts
        .where((p) =>
            _selectedCategory == null || p.category == _selectedCategory)
        .toList();
    final isWide = MediaQuery.of(context).size.width > 900;

    if (_loading) {
      return const Scaffold(
        backgroundColor: AppColors.black,
        body: Center(child: CircularProgressIndicator(color: AppColors.teal)),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: const AppNavbar(),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero
            Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 100, horizontal: 40),
              decoration: const BoxDecoration(
                color: AppColors.black,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'JOURNAL',
                    style: GoogleFonts.poppins(
                      color: AppColors.lavender,
                      fontSize: 12,
                      letterSpacing: 3,
                    ),
                  ).animate().fadeIn(),
                  const SizedBox(height: 20),
                  Text(
                    'Words that heal,\ninspire & connect.',
                    style: GoogleFonts.poppins(
                      fontSize: 64,
                      fontWeight: FontWeight.w900,
                      color: AppColors.white,
                      letterSpacing: -2,
                      height: 1.0,
                    ),
                  ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.3),
                  const SizedBox(height: 20),
                  Text(
                    'Perspectives on mental health, fashion, creativity, and life\nfrom the Society260 community.',
                    style: GoogleFonts.poppins(
                      color: AppColors.textGray,
                      fontSize: 16,
                      height: 1.7,
                    ),
                  ).animate().fadeIn(delay: 300.ms),
                ],
              ),
            ),

            // Featured post
            _FeaturedPost(post: posts.first),

            // Category filter
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 40, vertical: 32),
              color: AppColors.darkGray,
              child: Row(
                children: [
                  Text(
                    'Filter:',
                    style: GoogleFonts.poppins(
                      color: AppColors.textGray,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _CategoryChip(
                            label: 'All',
                            isSelected: _selectedCategory == null,
                            onTap: () =>
                                setState(() => _selectedCategory = null),
                          ),
                          ...BlogCategory.values.map((cat) => _CategoryChip(
                                label: _catLabel(cat),
                                isSelected: _selectedCategory == cat,
                                onTap: () => setState(
                                    () => _selectedCategory = cat),
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Posts grid
            Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  if (isWide)
                    ...List.generate(
                      (posts.length / 2).ceil(),
                      (i) {
                        final left = posts[i * 2];
                        final hasRight = (i * 2 + 1) < posts.length;
                        final right =
                            hasRight ? posts[i * 2 + 1] : null;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: Row(
                            children: [
                              Expanded(
                                  child: _BlogCard(
                                      post: left,
                                      large: i == 0)),
                              if (right != null) ...[
                                const SizedBox(width: 24),
                                Expanded(
                                    child: _BlogCard(post: right)),
                              ] else
                                const Expanded(child: SizedBox()),
                            ],
                          ),
                        );
                      },
                    )
                  else
                    ...posts.map((p) => Padding(
                          padding: const EdgeInsets.only(bottom: 24),
                          child: _BlogCard(post: p),
                        )),
                ],
              ),
            ),

            const AppFooter(),
          ],
        ),
      ),
    );
  }

  String _catLabel(BlogCategory cat) {
    return switch (cat) {
      BlogCategory.mentalHealth => 'Mental Health',
      BlogCategory.fashion => 'Fashion',
      BlogCategory.events => 'Events',
      BlogCategory.code260 => 'Code260',
      BlogCategory.community => 'Community',
    };
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.lavender : AppColors.cardBg,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: isSelected
                ? AppColors.lavender
                : AppColors.borderColor,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: isSelected ? AppColors.black : AppColors.textGray,
            fontSize: 13,
            fontWeight:
                isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _FeaturedPost extends StatelessWidget {
  final BlogPost post;
  const _FeaturedPost({required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(40),
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(27),
        child: Stack(
          children: [
            Image.network(
              post.coverImage ?? '',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.darkGray,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black87,
                  ],
                ),
              ),
            ),
            Positioned(
              left: 40,
              right: 40,
              bottom: 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.lavender,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      '✦ FEATURED',
                      style: GoogleFonts.poppins(
                        color: AppColors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    post.title,
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: AppColors.white,
                      height: 1.2,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    post.excerpt,
                    style: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        '${post.authorName} · ${post.readTime} min read',
                        style: GoogleFonts.poppins(
                          color: Colors.white60,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.lavender,
                          foregroundColor: AppColors.black,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Read More',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                          ),
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
    );
  }
}

class _BlogCard extends StatefulWidget {
  final BlogPost post;
  final bool large;
  const _BlogCard({required this.post, this.large = false});

  @override
  State<_BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<_BlogCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final categoryColors = {
      BlogCategory.mentalHealth: AppColors.teal,
      BlogCategory.fashion: AppColors.coral,
      BlogCategory.events: AppColors.gold,
      BlogCategory.code260: AppColors.code260Primary,
      BlogCategory.community: AppColors.lavender,
    };
    final color =
        categoryColors[widget.post.category] ?? AppColors.textGray;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.darkGray : AppColors.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered
                ? color.withOpacity(0.4)
                : AppColors.borderColor,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: Image.network(
                widget.post.coverImage ?? '',
                width: double.infinity,
                height: widget.large ? 220 : 180,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 180,
                  color: AppColors.borderColor,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          widget.post.category.name.toUpperCase(),
                          style: GoogleFonts.poppins(
                            color: color,
                            fontSize: 9,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${widget.post.readTime} min',
                        style: GoogleFonts.poppins(
                          color: AppColors.textMuted,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.post.title,
                    style: GoogleFonts.poppins(
                      color: AppColors.white,
                      fontSize: widget.large ? 20 : 17,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.post.excerpt,
                    style: GoogleFonts.poppins(
                      color: AppColors.textGray,
                      fontSize: 13,
                      height: 1.6,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        widget.post.authorName,
                        style: GoogleFonts.poppins(
                          color: AppColors.textGray,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Icon(Icons.visibility_outlined,
                              color: AppColors.textMuted, size: 13),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.post.views}',
                            style: GoogleFonts.poppins(
                              color: AppColors.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

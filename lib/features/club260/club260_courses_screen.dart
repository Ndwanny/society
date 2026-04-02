import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/navbar.dart';
import '../../shared/widgets/footer.dart';
import '../../shared/models/models.dart';

class Club260CoursesScreen extends StatelessWidget {
  const Club260CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final courses = CourseModel.mockCourses;
    final isWide = MediaQuery.of(context).size.width > 900;
    final hPad = isWide ? 40.0 : 20.0;

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: const AppNavbar(),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Header ───────────────────────────────────────────────────────
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: isWide ? 80 : 48, horizontal: hPad),
              color: AppColors.black,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.lavender.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                          color: AppColors.lavender.withOpacity(0.3)),
                    ),
                    child: Text(
                      'MEMBER EXCLUSIVE',
                      style: GoogleFonts.poppins(
                        color: AppColors.lavender,
                        fontSize: 11,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Online Courses',
                    style: GoogleFonts.poppins(
                      fontSize: isWide ? 56 : 36,
                      fontWeight: FontWeight.w900,
                      color: AppColors.white,
                      letterSpacing: -2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Evidence-based courses on mental wellness, emotional intelligence and personal growth — taught by trusted practitioners.',
                    style: GoogleFonts.poppins(
                      color: AppColors.textGray,
                      fontSize: isWide ? 16 : 14,
                      height: 1.7,
                    ),
                  ),
                ],
              ),
            ),

            // ── Courses list ─────────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(hPad, 0, hPad, 40),
              child: isWide
                  ? GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 24,
                        crossAxisSpacing: 24,
                        childAspectRatio: 1.65,
                      ),
                      itemCount: courses.length,
                      itemBuilder: (context, i) =>
                          _CourseCard(course: courses[i]),
                    )
                  : Column(
                      children: courses
                          .map((c) => Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: _CourseCard(course: c),
                              ))
                          .toList(),
                    ),
            ),

            // ── Unlock CTA ───────────────────────────────────────────────────
            Container(
              margin: EdgeInsets.fromLTRB(hPad, 0, hPad, 40),
              padding: EdgeInsets.all(isWide ? 48 : 28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.lavender.withOpacity(0.1),
                    AppColors.teal.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                    color: AppColors.lavender.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.lock_outline,
                    color: AppColors.lavender,
                    size: 40,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Unlock all courses with a membership',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: isWide ? 28 : 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Member and Advocate plans include unlimited access to all courses.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: AppColors.textGray,
                      fontSize: isWide ? 15 : 13,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () =>
                        context.go('/club260/membership'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lavender,
                      foregroundColor: AppColors.black,
                      padding: EdgeInsets.symmetric(
                        horizontal: isWide ? 40 : 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'VIEW MEMBERSHIP PLANS',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w800,
                        fontSize: isWide ? 14 : 12,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const AppFooter(),
          ],
        ),
      ),
    );
  }
}

// ─── Course Card ──────────────────────────────────────────────────────────────
class _CourseCard extends StatefulWidget {
  final CourseModel course;
  const _CourseCard({required this.course});

  @override
  State<_CourseCard> createState() => _CourseCardState();
}

class _CourseCardState extends State<_CourseCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    // Use landscape (row) layout when card itself is wide enough
    final cardWidth = MediaQuery.of(context).size.width;
    final useRow = cardWidth > 600;

    final thumbnail = ClipRRect(
      borderRadius: useRow
          ? const BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            )
          : const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
      child: SizedBox(
        width: useRow ? 180 : double.infinity,
        height: useRow ? double.infinity : 180,
        child: Image.network(
          widget.course.thumbnailUrl ?? '',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: AppColors.borderColor,
            child: const Icon(
              Icons.play_circle_outline,
              color: AppColors.textGray,
              size: 32,
            ),
          ),
        ),
      ),
    );

    final content = Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Level + rating row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.lavender.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  widget.course.level.name.toUpperCase(),
                  style: GoogleFonts.poppins(
                    color: AppColors.lavender,
                    fontSize: 9,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.gold.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star,
                        color: AppColors.gold, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      widget.course.rating.toString(),
                      style: GoogleFonts.poppins(
                        color: AppColors.gold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Title
          Text(
            widget.course.title,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          // Instructor
          Text(
            widget.course.instructor,
            style: GoogleFonts.poppins(
              color: AppColors.teal,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          // Meta chips
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              _metaChip(Icons.play_circle_outline,
                  '${widget.course.lessons} lessons'),
              _metaChip(Icons.people_outline,
                  '${widget.course.enrolled} enrolled'),
            ],
          ),
          const SizedBox(height: 16),
          // Enroll button
          ElevatedButton(
            onPressed: () => context.go('/club260/membership'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lavender,
              foregroundColor: AppColors.black,
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 10),
              textStyle: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Enroll'),
          ),
        ],
      ),
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered
                ? AppColors.lavender.withOpacity(0.4)
                : AppColors.borderColor,
          ),
        ),
        child: useRow
            ? IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    thumbnail,
                    Expanded(child: content),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  thumbnail,
                  content,
                ],
              ),
      ),
    );
  }

  Widget _metaChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.textGray, size: 14),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            color: AppColors.textGray,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

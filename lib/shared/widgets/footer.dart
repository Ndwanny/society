import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 768;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkGray,
        border: Border(top: BorderSide(color: AppColors.borderColor)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
      child: Column(
        children: [
          if (isWide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand Column
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.spaceMono(
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
                      const SizedBox(height: 16),
                      Text(
                        'An independent initiative to raise\nawareness for mental health.',
                        style: GoogleFonts.inter(
                          color: AppColors.textGray,
                          fontSize: 14,
                          height: 1.7,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Kabulonga Road 2A\nLusaka, Zambia',
                        style: GoogleFonts.inter(
                          color: AppColors.textMuted,
                          fontSize: 13,
                          height: 1.7,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'society260@info.com',
                        style: GoogleFonts.inter(
                          color: AppColors.teal,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                // Quick Links
                Expanded(
                  child: _footerColumn(
                    context,
                    'Navigate',
                    [
                      ('Home', '/'),
                      ('Club260', '/club260'),
                      ('Code260', '/code260'),
                      ('Events', '/events'),
                      ('Blog', '/blog'),
                    ],
                  ),
                ),

                // Programs
                Expanded(
                  child: _footerColumn(
                    context,
                    'Programs',
                    [
                      ('Club260', '/club260'),
                      ('Code260', '/code260'),
                      ('Art Therapy', '/blog'),
                      ('Workshops', '/events'),
                      ('Online Courses', '/club260/courses'),
                    ],
                  ),
                ),

                // Community
                Expanded(
                  child: _footerColumn(
                    context,
                    'Community',
                    [
                      ('Join Club260', '/signup'),
                      ('Membership', '/club260/membership'),
                      ('Events', '/events'),
                      ('Admin', '/admin'),
                      ('Contact', '/blog'),
                    ],
                  ),
                ),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.spaceMono(
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
                const SizedBox(height: 12),
                Text(
                  'A safe space in motion.',
                  style: GoogleFonts.inter(color: AppColors.textGray),
                ),
                const SizedBox(height: 24),
                Text(
                  'society260@info.com',
                  style: GoogleFonts.inter(color: AppColors.teal, fontSize: 13),
                ),
              ],
            ),

          const SizedBox(height: 48),
          const Divider(color: AppColors.borderColor),
          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '© 2025 Society260. All rights reserved.',
                style: GoogleFonts.inter(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
              Text(
                'A safe space in motion / Always',
                style: GoogleFonts.spaceMono(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _footerColumn(
    BuildContext context,
    String title,
    List<(String, String)> links,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.spaceGrotesk(
            color: AppColors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 20),
        ...links.map(
          (link) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () => context.go(link.$2),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Text(
                  link.$1,
                  style: GoogleFonts.inter(
                    color: AppColors.textGray,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

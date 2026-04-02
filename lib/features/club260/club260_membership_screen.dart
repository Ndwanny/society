import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../core/controllers/auth_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/navbar.dart';
import '../../shared/widgets/footer.dart';

class Club260MembershipScreen extends StatefulWidget {
  const Club260MembershipScreen({super.key});

  @override
  State<Club260MembershipScreen> createState() =>
      _Club260MembershipScreenState();
}

class _Club260MembershipScreenState
    extends State<Club260MembershipScreen> {
  bool _annually = false;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: const AppNavbar(),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(
                  vertical: 80, horizontal: 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.teal.withOpacity(0.1),
                    AppColors.black,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'MEMBERSHIP',
                    style: GoogleFonts.poppins(
                      color: AppColors.teal,
                      fontSize: 12,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Choose your\njourney',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                      color: AppColors.white,
                      letterSpacing: -2,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Join a community of 1,200+ members committed to mental wellness, authentic self-expression, and collective growth.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: AppColors.textGray,
                      fontSize: 16,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Toggle
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: AppColors.borderColor),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _toggleOption('Monthly', !_annually),
                        _toggleOption('Annual (Save 20%)', _annually),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Plans
            Padding(
              padding: const EdgeInsets.all(40),
              child: isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: _PlanCard(
                          name: 'Explorer',
                          price: 'Free',
                          priceSubtitle: 'Always free',
                          color: AppColors.textGray,
                          features: const [
                            'Access to Club260 feed',
                            'Post text & images',
                            'Join community discussions',
                            'View public events',
                            '1 free course per month',
                          ],
                          ctaLabel: 'Get Started Free',
                          onTap: () => _handlePlanTap(context, 'explorer'),
                        )),
                        const SizedBox(width: 24),
                        Expanded(
                            child: _PlanCard(
                          name: 'Member',
                          price: _annually ? 'ZMW 120' : 'ZMW 150',
                          priceSubtitle:
                              _annually ? '/month, billed annually' : '/month',
                          color: AppColors.teal,
                          isPopular: true,
                          features: const [
                            'Everything in Explorer',
                            'Unlimited course access',
                            'Direct messaging',
                            'Voice & video calls',
                            'Exclusive member events',
                            'Monthly Club260 sessions',
                            'Member-only content',
                            'Priority support',
                          ],
                          ctaLabel: 'Become a Member',
                          onTap: () => _handlePlanTap(context, 'member'),
                        )),
                        const SizedBox(width: 24),
                        Expanded(
                            child: _PlanCard(
                          name: 'Advocate',
                          price: _annually ? 'ZMW 280' : 'ZMW 350',
                          priceSubtitle:
                              _annually ? '/month, billed annually' : '/month',
                          color: AppColors.gold,
                          features: const [
                            'Everything in Member',
                            '1-on-1 coaching sessions',
                            'Early access to all events',
                            'Code260 educator toolkit',
                            'Quarterly wellness packages',
                            'Exclusive workshops',
                            'Society260 merch discount',
                            'Dedicated community space',
                          ],
                          ctaLabel: 'Become an Advocate',
                          onTap: () => _handlePlanTap(context, 'advocate'),
                        )),
                      ],
                    )
                  : Column(
                      children: [
                        _PlanCard(
                          name: 'Explorer',
                          price: 'Free',
                          priceSubtitle: 'Always free',
                          color: AppColors.textGray,
                          features: const [
                            'Access to Club260 feed',
                            'Post text & images',
                            'Join community discussions',
                            '1 free course per month',
                          ],
                          ctaLabel: 'Get Started Free',
                          onTap: () => _handlePlanTap(context, 'explorer'),
                        ),
                        const SizedBox(height: 24),
                        _PlanCard(
                          name: 'Member',
                          price: _annually ? 'ZMW 120' : 'ZMW 150',
                          priceSubtitle: '/month',
                          color: AppColors.teal,
                          isPopular: true,
                          features: const [
                            'Everything in Explorer',
                            'Unlimited course access',
                            'Direct messaging',
                            'Voice & video calls',
                            'Exclusive member events',
                          ],
                          ctaLabel: 'Become a Member',
                          onTap: () => _handlePlanTap(context, 'member'),
                        ),
                        const SizedBox(height: 24),
                        _PlanCard(
                          name: 'Advocate',
                          price: _annually ? 'ZMW 280' : 'ZMW 350',
                          priceSubtitle: '/month',
                          color: AppColors.gold,
                          features: const [
                            'Everything in Member',
                            '1-on-1 coaching sessions',
                            'Early access to all events',
                            'Code260 educator toolkit',
                          ],
                          ctaLabel: 'Become an Advocate',
                          onTap: () => _handlePlanTap(context, 'advocate'),
                        ),
                      ],
                    ),
            ),

            // FAQ
            _FAQSection(),
            const AppFooter(),
          ],
        ),
      ),
    );
  }

  void _handlePlanTap(BuildContext context, String plan) {
    if (AuthController.instance.isLoggedIn) {
      context.go('/club260/payment?plan=$plan&billing=${_annually ? 'annual' : 'monthly'}');
    } else {
      context.go('/signup?redirect=/club260/membership');
    }
  }

  Widget _toggleOption(String label, bool isActive) {
    return GestureDetector(
      onTap: () => setState(() => _annually = label.contains('Annual')),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.teal : Colors.transparent,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: isActive ? AppColors.black : AppColors.textGray,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String name;
  final String price;
  final String priceSubtitle;
  final Color color;
  final List<String> features;
  final String ctaLabel;
  final VoidCallback onTap;
  final bool isPopular;

  const _PlanCard({
    required this.name,
    required this.price,
    required this.priceSubtitle,
    required this.color,
    required this.features,
    required this.ctaLabel,
    required this.onTap,
    this.isPopular = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isPopular ? color.withOpacity(0.5) : AppColors.borderColor,
          width: isPopular ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isPopular)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                ),
              ),
              child: Text(
                '✦ MOST POPULAR',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: AppColors.black,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    name.toUpperCase(),
                    style: GoogleFonts.poppins(
                      color: color,
                      fontSize: 11,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  price,
                  style: GoogleFonts.poppins(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: AppColors.white,
                    letterSpacing: -2,
                  ),
                ),
                Text(
                  priceSubtitle,
                  style: GoogleFonts.poppins(
                    color: AppColors.textGray,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 32),
                ...features.map((f) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.check_circle_outline,
                              color: color, size: 18),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              f,
                              style: GoogleFonts.poppins(
                                color: AppColors.offWhite,
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: isPopular
                      ? ElevatedButton(
                          onPressed: onTap,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color,
                            foregroundColor: AppColors.black,
                            padding: const EdgeInsets.symmetric(
                                vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            ctaLabel,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        )
                      : OutlinedButton(
                          onPressed: onTap,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: color,
                            side: BorderSide(
                                color: color.withOpacity(0.4)),
                            padding: const EdgeInsets.symmetric(
                                vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            ctaLabel,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
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

class _FAQSection extends StatelessWidget {
  final List<Map<String, String>> _faqs = const [
    {
      'q': 'Can I cancel my subscription at any time?',
      'a':
          'Yes, you can cancel your membership at any time. Your access will continue until the end of your billing period.',
    },
    {
      'q': 'What payment methods do you accept?',
      'a':
          'We accept mobile money (MTN MoMo, Airtel Money), bank transfers, and major credit/debit cards.',
    },
    {
      'q': 'Is there a free trial for paid plans?',
      'a':
          'Yes! We offer a 7-day free trial for the Member plan. No credit card required.',
    },
    {
      'q': 'What are the Club260 monthly sessions like?',
      'a':
          'Monthly virtual sessions last 90 minutes and feature special guests — healers, life coaches, and mental health professionals. They are safe, guided, and welcoming.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
      color: AppColors.darkGray,
      child: Column(
        children: [
          Text(
            'Frequently Asked Questions',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: AppColors.white,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 48),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              children: _faqs
                  .map((faq) => _FAQItem(
                        question: faq['q']!,
                        answer: faq['a']!,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _FAQItem extends StatefulWidget {
  final String question;
  final String answer;
  const _FAQItem({required this.question, required this.answer});

  @override
  State<_FAQItem> createState() => _FAQItemState();
}

class _FAQItemState extends State<_FAQItem> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.borderColor),
        ),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => _open = !_open),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8, vertical: 20),
              color: Colors.transparent,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: GoogleFonts.poppins(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    _open
                        ? Icons.remove
                        : Icons.add,
                    color: AppColors.teal,
                  ),
                ],
              ),
            ),
          ),
          if (_open)
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 20, left: 8, right: 8),
              child: Text(
                widget.answer,
                style: GoogleFonts.poppins(
                  color: AppColors.textGray,
                  fontSize: 15,
                  height: 1.7,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

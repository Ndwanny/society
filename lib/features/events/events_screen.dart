import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../core/repositories/events_repository.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/navbar.dart';
import '../../shared/widgets/footer.dart';
import '../../shared/models/models.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _repo = EventsRepository();

  List<EventModel> _upcoming = [];
  List<EventModel> _past = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      final all = await _repo.fetchAll();
      if (mounted) {
        setState(() {
          _upcoming = all.where((e) => !e.isPast).toList();
          _past = all.where((e) => e.isPast).toList();
          _loading = false;
        });
      }
    } catch (_) {
      // Fallback to mock data if Supabase not yet configured
      if (mounted) {
        setState(() {
          _upcoming = EventModel.mockEvents.where((e) => !e.isPast).toList();
          _past = EventModel.mockEvents.where((e) => e.isPast).toList();
          _loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final upcoming = _upcoming;
    final past = _past;

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
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.coral.withOpacity(0.08),
                    AppColors.black,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EVENTS',
                    style: GoogleFonts.spaceMono(
                      color: AppColors.coral,
                      fontSize: 12,
                      letterSpacing: 3,
                    ),
                  ).animate().fadeIn(),
                  const SizedBox(height: 20),
                  Text(
                    'Where community\ncomes alive.',
                    style: GoogleFonts.spaceMono(
                      fontSize: 64,
                      fontWeight: FontWeight.w900,
                      color: AppColors.white,
                      letterSpacing: -2,
                      height: 1.0,
                    ),
                  ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.3),
                  const SizedBox(height: 20),
                  Text(
                    'Poetry. Music. Workshops. Panel discussions.\nAll rooted in mental wellness and self-expression.',
                    style: GoogleFonts.inter(
                      color: AppColors.textGray,
                      fontSize: 16,
                      height: 1.7,
                    ),
                  ).animate().fadeIn(delay: 300.ms),
                ],
              ),
            ),

            // Featured event
            if (upcoming.isNotEmpty)
              _FeaturedEvent(event: upcoming.first),

            // Tabs
            Container(
              color: AppColors.darkGray,
              child: TabBar(
                controller: _tabController,
                labelStyle: GoogleFonts.spaceGrotesk(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                labelColor: AppColors.white,
                unselectedLabelColor: AppColors.textGray,
                indicatorColor: AppColors.coral,
                indicatorWeight: 2,
                tabs: const [
                  Tab(text: 'Upcoming'),
                  Tab(text: 'Past Events'),
                ],
              ),
            ),

            SizedBox(
              height: 900,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _EventsList(events: upcoming),
                  _EventsList(events: past, isPast: true),
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

class _FeaturedEvent extends StatelessWidget {
  final EventModel event;
  const _FeaturedEvent({required this.event});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 768;

    return Container(
      margin: const EdgeInsets.all(40),
      height: isWide ? 400 : 500,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            AppColors.coral.withOpacity(0.15),
            AppColors.darkGray,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: AppColors.coral.withOpacity(0.3),
        ),
      ),
      child: Stack(
        children: [
          // Background image placeholder
          ClipRRect(
            borderRadius: BorderRadius.circular(27),
            child: Opacity(
              opacity: 0.15,
              child: Image.network(
                event.imageUrl ?? '',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.coral,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    '✦ FEATURED EVENT',
                    style: GoogleFonts.spaceMono(
                      color: AppColors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  event.title,
                  style: GoogleFonts.spaceMono(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: AppColors.white,
                    letterSpacing: -1,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  event.description,
                  style: GoogleFonts.inter(
                    color: AppColors.textGray,
                    fontSize: 15,
                    height: 1.6,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    _eventMeta(
                      Icons.calendar_today_outlined,
                      '${event.date.day} ${["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"][event.date.month-1]} ${event.date.year}',
                    ),
                    const SizedBox(width: 24),
                    _eventMeta(
                        Icons.location_on_outlined, event.location),
                    const SizedBox(width: 24),
                    _eventMeta(Icons.people_outline,
                        '${event.attendees} attending'),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () => context.go('/signup'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.coral,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'GET TICKETS',
                        style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
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
    );
  }

  Widget _eventMeta(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.coral, size: 16),
        const SizedBox(width: 6),
        Text(
          text,
          style: GoogleFonts.inter(
            color: AppColors.textGray,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _EventsList extends StatelessWidget {
  final List<EventModel> events;
  final bool isPast;

  const _EventsList({required this.events, this.isPast = false});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 768;

    return GridView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.all(40),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isWide ? 2 : 1,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: isWide ? 1.5 : 1.4,
      ),
      itemCount: events.length,
      itemBuilder: (context, index) =>
          _EventCard(event: events[index], isPast: isPast),
    );
  }
}

class _EventCard extends StatefulWidget {
  final EventModel event;
  final bool isPast;
  const _EventCard({required this.event, required this.isPast});

  @override
  State<_EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<_EventCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final months = [
      "JAN","FEB","MAR","APR","MAY","JUN",
      "JUL","AUG","SEP","OCT","NOV","DEC"
    ];

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => _showEventDetail(context),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.darkGray : AppColors.cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _hovered
                  ? AppColors.coral.withOpacity(0.4)
                  : AppColors.borderColor,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image area
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Image.network(
                        widget.event.imageUrl ?? '',
                        width: double.infinity,
                        height: 160,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.borderColor,
                          child: const Icon(
                            Icons.event,
                            color: AppColors.textGray,
                            size: 40,
                          ),
                        ),
                      ),
                      if (widget.isPast)
                        Container(
                          color: Colors.black54,
                          child: Center(
                            child: Text(
                              'PAST EVENT',
                              style: GoogleFonts.spaceMono(
                                color: Colors.white54,
                                fontSize: 12,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                      // Date badge
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.black.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              Text(
                                widget.event.date.day
                                    .toString()
                                    .padLeft(2, '0'),
                                style: GoogleFonts.spaceMono(
                                  color: AppColors.coral,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                months[widget.event.date.month - 1],
                                style: GoogleFonts.spaceMono(
                                  color: AppColors.textGray,
                                  fontSize: 10,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _categoryChip(widget.event.category),
                        const Spacer(),
                        if (widget.event.isVirtual)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.softBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              'VIRTUAL',
                              style: GoogleFonts.spaceMono(
                                color: AppColors.softBlue,
                                fontSize: 9,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.event.title,
                      style: GoogleFonts.spaceGrotesk(
                        color: AppColors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined,
                            color: AppColors.textGray, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          widget.event.location,
                          style: GoogleFonts.inter(
                            color: AppColors.textGray,
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.people_outline,
                            color: AppColors.textGray, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.event.attendees}',
                          style: GoogleFonts.inter(
                            color: AppColors.textGray,
                            fontSize: 12,
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
    );
  }

  Widget _categoryChip(EventCategory category) {
    final labels = {
      EventCategory.poetry: ('260 POETRY', AppColors.coral),
      EventCategory.club260: ('CLUB260', AppColors.teal),
      EventCategory.music: ('MUSIC', AppColors.lavender),
      EventCategory.workshop: ('WORKSHOP', AppColors.softBlue),
      EventCategory.code260: ('CODE260', AppColors.code260Primary),
      EventCategory.other: ('EVENT', AppColors.textGray),
    };
    final (label, color) = labels[category]!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: GoogleFonts.spaceMono(
          color: color,
          fontSize: 9,
          letterSpacing: 1,
        ),
      ),
    );
  }

  void _showEventDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkGray,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        expand: false,
        builder: (_, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.borderColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  widget.event.title,
                  style: GoogleFonts.spaceMono(
                    color: AppColors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.event.description,
                  style: GoogleFonts.inter(
                    color: AppColors.textGray,
                    fontSize: 15,
                    height: 1.7,
                  ),
                ),
                const SizedBox(height: 32),
                if (!widget.isPast)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        context.go('/signup');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.coral,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'REGISTER / GET TICKETS',
                        style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
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

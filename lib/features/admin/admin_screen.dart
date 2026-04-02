import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/models/models.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _selectedTab = 0;

  final List<_AdminTab> _tabs = [
    _AdminTab(Icons.dashboard_outlined, 'Overview'),
    _AdminTab(Icons.people_outline, 'Users'),
    _AdminTab(Icons.article_outlined, 'Posts'),
    _AdminTab(Icons.event_outlined, 'Events'),
    _AdminTab(Icons.article, 'Blog'),
    _AdminTab(Icons.play_circle_outline, 'Courses'),
    _AdminTab(Icons.settings_outlined, 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 1000;

    return Scaffold(
      backgroundColor: AppColors.black,
      body: Row(
        children: [
          // Sidebar
          Container(
            width: isWide ? 220 : 64,
            decoration: const BoxDecoration(
              color: AppColors.darkGray,
              border: Border(
                  right: BorderSide(color: AppColors.borderColor)),
            ),
            child: Column(
              children: [
                // Logo
                Container(
                  padding: const EdgeInsets.all(20),
                  child: isWide
                      ? RichText(
                          text: TextSpan(
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                            ),
                            children: const [
                              TextSpan(
                                text: 'S260',
                                style: TextStyle(color: AppColors.white),
                              ),
                              TextSpan(
                                text: ' Admin',
                                style: TextStyle(color: AppColors.teal),
                              ),
                            ],
                          ),
                        )
                      : const Icon(Icons.admin_panel_settings,
                          color: AppColors.teal),
                ),
                const Divider(color: AppColors.borderColor, height: 1),
                const SizedBox(height: 12),
                ...List.generate(
                  _tabs.length,
                  (i) => _SidebarItem(
                    tab: _tabs[i],
                    isSelected: _selectedTab == i,
                    isWide: isWide,
                    onTap: () => setState(() => _selectedTab = i),
                  ),
                ),
                const Spacer(),
                _SidebarItem(
                  tab: _AdminTab(Icons.arrow_back, 'Back to Site'),
                  isSelected: false,
                  isWide: isWide,
                  onTap: () => context.go('/'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return switch (_selectedTab) {
      0 => const _OverviewTab(),
      1 => _UsersTab(),
      2 => _PostsTab(),
      3 => _EventsTab(),
      4 => _BlogTab(),
      5 => _CoursesTab(),
      6 => _SettingsTab(),
      _ => const _OverviewTab(),
    };
  }
}

class _AdminTab {
  final IconData icon;
  final String label;
  _AdminTab(this.icon, this.label);
}

class _SidebarItem extends StatelessWidget {
  final _AdminTab tab;
  final bool isSelected;
  final bool isWide;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.tab,
    required this.isSelected,
    required this.isWide,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          padding: EdgeInsets.symmetric(
            horizontal: isWide ? 14 : 8,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.teal.withOpacity(0.12) : null,
            borderRadius: BorderRadius.circular(10),
          ),
          child: isWide
              ? Row(
                  children: [
                    Icon(tab.icon,
                        color: isSelected
                            ? AppColors.teal
                            : AppColors.textGray,
                        size: 18),
                    const SizedBox(width: 12),
                    Text(
                      tab.label,
                      style: GoogleFonts.poppins(
                        color: isSelected
                            ? AppColors.teal
                            : AppColors.textGray,
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                    ),
                  ],
                )
              : Icon(tab.icon,
                  color: isSelected
                      ? AppColors.teal
                      : AppColors.textGray,
                  size: 20),
        ),
      ),
    );
  }
}

// ─── Overview Tab ─────────────────────────────────────────────────────────────
class _OverviewTab extends StatelessWidget {
  const _OverviewTab();

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dashboard',
                    style: GoogleFonts.poppins(
                      color: AppColors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'Society260 Admin Panel',
                    style: GoogleFonts.poppins(
                      color: AppColors.textGray,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppColors.teal.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'System Online',
                      style: GoogleFonts.poppins(
                        color: AppColors.teal,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),

          // Stats cards
          GridView.count(
            crossAxisCount: isWide ? 4 : 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.6,
            children: const [
              _StatCard(
                value: '1,247',
                label: 'Total Users',
                change: '+12%',
                icon: Icons.people_outline,
                color: AppColors.teal,
              ),
              _StatCard(
                value: '389',
                label: 'Paid Members',
                change: '+8%',
                icon: Icons.star_outline,
                color: AppColors.gold,
              ),
              _StatCard(
                value: '5,823',
                label: 'Total Posts',
                change: '+23%',
                icon: Icons.article_outlined,
                color: AppColors.coral,
              ),
              _StatCard(
                value: 'ZMW 58,350',
                label: 'MRR',
                change: '+15%',
                icon: Icons.trending_up,
                color: AppColors.lavender,
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Charts row
          if (isWide)
            Row(
              children: [
                Expanded(flex: 2, child: _UserGrowthChart()),
                const SizedBox(width: 24),
                Expanded(child: _MembershipChart()),
              ],
            )
          else
            Column(
              children: [
                _UserGrowthChart(),
                const SizedBox(height: 24),
                _MembershipChart(),
              ],
            ),

          const SizedBox(height: 32),

          // Recent activity
          _RecentActivityTable(),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final String change;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.value,
    required this.label,
    required this.change,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  change,
                  style: GoogleFonts.poppins(
                    color: AppColors.success,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: AppColors.textGray,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _UserGrowthChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'User Growth',
            style: GoogleFonts.poppins(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Last 6 months',
            style: GoogleFonts.poppins(
              color: AppColors.textGray,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColors.borderColor,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text(
                        '${value.toInt()}',
                        style: GoogleFonts.poppins(
                          color: AppColors.textMuted,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const months = [
                          'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'
                        ];
                        final idx = value.toInt();
                        if (idx < 0 || idx >= months.length)
                          return const SizedBox();
                        return Text(
                          months[idx],
                          style: GoogleFonts.poppins(
                            color: AppColors.textMuted,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 780),
                      FlSpot(1, 920),
                      FlSpot(2, 1050),
                      FlSpot(3, 1100),
                      FlSpot(4, 1180),
                      FlSpot(5, 1247),
                    ],
                    isCurved: true,
                    color: AppColors.teal,
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.teal.withOpacity(0.08),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MembershipChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Membership',
            style: GoogleFonts.poppins(
              color: AppColors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Distribution',
            style: GoogleFonts.poppins(
              color: AppColors.textGray,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 180,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    color: AppColors.textGray,
                    value: 858,
                    title: 'Free\n69%',
                    titleStyle: GoogleFonts.poppins(
                      color: AppColors.white,
                      fontSize: 10,
                    ),
                    radius: 70,
                  ),
                  PieChartSectionData(
                    color: AppColors.teal,
                    value: 267,
                    title: 'Member\n21%',
                    titleStyle: GoogleFonts.poppins(
                      color: AppColors.black,
                      fontSize: 10,
                    ),
                    radius: 80,
                  ),
                  PieChartSectionData(
                    color: AppColors.gold,
                    value: 122,
                    title: 'Advocate\n10%',
                    titleStyle: GoogleFonts.poppins(
                      color: AppColors.black,
                      fontSize: 10,
                    ),
                    radius: 85,
                  ),
                ],
                sectionsSpace: 2,
                centerSpaceRadius: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentActivityTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Text(
                  'Recent Activity',
                  style: GoogleFonts.poppins(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'View all',
                    style: GoogleFonts.poppins(
                      color: AppColors.teal,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.borderColor, height: 1),
          ...PostModel.mockPosts.take(5).map((post) => Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 16),
                decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: AppColors.borderColor)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.teal.withOpacity(0.15),
                      child: Text(
                        post.authorName[0],
                        style: GoogleFonts.poppins(
                          color: AppColors.teal,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.authorName,
                            style: GoogleFonts.poppins(
                              color: AppColors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            (post.textContent ?? '').length > 60
                                ? '${(post.textContent ?? '').substring(0, 60)}...'
                                : (post.textContent ?? ''),
                            style: GoogleFonts.poppins(
                              color: AppColors.textGray,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.teal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            post.type.name.toUpperCase(),
                            style: GoogleFonts.poppins(
                              color: AppColors.teal,
                              fontSize: 9,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${post.likes} likes',
                          style: GoogleFonts.poppins(
                            color: AppColors.textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ─── Users Tab ────────────────────────────────────────────────────────────────
class _UsersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _tabHeader('Users', 'Manage all registered users'),
          const SizedBox(height: 32),
          // Search & filters
          Row(
            children: [
              Expanded(
                child: TextField(
                  style: GoogleFonts.poppins(color: AppColors.white),
                  decoration: InputDecoration(
                    hintText: 'Search users...',
                    prefixIcon: const Icon(Icons.search,
                        color: AppColors.textGray, size: 18),
                    filled: true,
                    fillColor: AppColors.cardBg,
                    hintStyle: GoogleFonts.poppins(
                        color: AppColors.textMuted),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: AppColors.borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: AppColors.borderColor),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.person_add_outlined, size: 16),
                label: const Text('Add User'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.teal,
                  foregroundColor: AppColors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Users table
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 14),
                  decoration: const BoxDecoration(
                    border: Border(
                        bottom:
                            BorderSide(color: AppColors.borderColor)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                          flex: 3,
                          child: _tableHeader('User')),
                      Expanded(
                          flex: 2,
                          child: _tableHeader('Email')),
                      Expanded(
                          child: _tableHeader('Plan')),
                      Expanded(
                          child: _tableHeader('Joined')),
                      _tableHeader('Actions'),
                    ],
                  ),
                ),
                ...UserModel.mockUsers.map((user) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: AppColors.borderColor)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor:
                                      AppColors.teal.withOpacity(0.15),
                                  child: Text(
                                    user.displayName[0],
                                    style: GoogleFonts.poppins(
                                        color: AppColors.teal),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.displayName,
                                      style: GoogleFonts.poppins(
                                        color: AppColors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '@${user.username}',
                                      style: GoogleFonts.poppins(
                                        color: AppColors.textGray,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              user.email,
                              style: GoogleFonts.poppins(
                                color: AppColors.textGray,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Expanded(
                            child: _membershipBadge(user.membership),
                          ),
                          Expanded(
                            child: Text(
                              '${user.joinedAt.day}/${user.joinedAt.month}/${user.joinedAt.year}',
                              style: GoogleFonts.poppins(
                                color: AppColors.textGray,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined,
                                    color: AppColors.textGray, size: 16),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: AppColors.error, size: 16),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _membershipBadge(MembershipTier tier) {
    final (label, color) = switch (tier) {
      MembershipTier.free => ('FREE', AppColors.textGray),
      MembershipTier.pro => ('MEMBER', AppColors.teal),
      MembershipTier.advocate => ('ADVOCATE', AppColors.gold),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          color: color,
          fontSize: 9,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ─── Posts Tab ───────────────────────────────────────────────────────────────
class _PostsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _tabHeader('Posts', 'Manage all community posts'),
          const SizedBox(height: 32),
          ...PostModel.mockPosts.map((post) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.authorName,
                            style: GoogleFonts.poppins(
                              color: AppColors.teal,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            (post.textContent ?? '').length > 80
                                ? '${(post.textContent ?? '').substring(0, 80)}...'
                                : (post.textContent ?? ''),
                            style: GoogleFonts.poppins(
                              color: AppColors.offWhite,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _metaText('${post.likes} likes'),
                              const SizedBox(width: 16),
                              _metaText('${post.comments} comments'),
                              const SizedBox(width: 16),
                              _metaText(post.type.name),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.visibility_outlined,
                              color: AppColors.textGray, size: 16),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              color: AppColors.error, size: 16),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _metaText(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: AppColors.textMuted,
        fontSize: 10,
      ),
    );
  }
}

// ─── Events Tab ───────────────────────────────────────────────────────────────
class _EventsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _tabHeader('Events', 'Manage all events'),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Create Event'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.coral,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          ...EventModel.mockEvents.map((event) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.coral.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text(
                            event.date.day.toString(),
                            style: GoogleFonts.poppins(
                              color: AppColors.coral,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][event.date.month-1],
                            style: GoogleFonts.poppins(
                              color: AppColors.textGray,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event.title,
                            style: GoogleFonts.poppins(
                              color: AppColors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${event.location} · ${event.attendees} attending',
                            style: GoogleFonts.poppins(
                              color: AppColors.textGray,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: event.isPast
                            ? AppColors.textMuted.withOpacity(0.1)
                            : AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        event.isPast ? 'PAST' : 'UPCOMING',
                        style: GoogleFonts.poppins(
                          color: event.isPast
                              ? AppColors.textMuted
                              : AppColors.success,
                          fontSize: 9,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined,
                          color: AppColors.textGray, size: 16),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: AppColors.error, size: 16),
                      onPressed: () {},
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ─── Blog Tab ─────────────────────────────────────────────────────────────────
class _BlogTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _tabHeader('Blog Posts', 'Manage blog content'),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 16),
                label: const Text('New Post'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lavender,
                  foregroundColor: AppColors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          ...BlogPost.mockPosts.map((post) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.title,
                            style: GoogleFonts.poppins(
                              color: AppColors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${post.authorName} · ${post.readTime} min · ${post.views} views',
                            style: GoogleFonts.poppins(
                              color: AppColors.textGray,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined,
                          color: AppColors.textGray, size: 16),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: AppColors.error, size: 16),
                      onPressed: () {},
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ─── Courses Tab ──────────────────────────────────────────────────────────────
class _CoursesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _tabHeader('Courses', 'Manage online courses'),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add, size: 16),
                label: const Text('New Course'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lavender,
                  foregroundColor: AppColors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          ...CourseModel.mockCourses.map((course) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.title,
                            style: GoogleFonts.poppins(
                              color: AppColors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${course.instructor} · ${course.lessons} lessons · ${course.enrolled} enrolled',
                            style: GoogleFonts.poppins(
                              color: AppColors.textGray,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: AppColors.gold, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          course.rating.toString(),
                          style: GoogleFonts.poppins(
                            color: AppColors.gold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined,
                          color: AppColors.textGray, size: 16),
                      onPressed: () {},
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ─── Settings Tab ─────────────────────────────────────────────────────────────
class _SettingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _tabHeader('Settings', 'Configure your platform'),
          const SizedBox(height: 32),
          _SettingsSection(
            title: 'General',
            items: [
              _SettingsItem('Site Name', 'Society260', TextEditingController(text: 'Society260')),
              _SettingsItem('Tagline', 'A Safe Space In Motion', TextEditingController(text: 'A Safe Space In Motion')),
              _SettingsItem('Contact Email', 'society260@info.com', TextEditingController(text: 'society260@info.com')),
            ],
          ),
          const SizedBox(height: 24),
          _SettingsSection(
            title: 'Membership Pricing (ZMW)',
            items: [
              _SettingsItem('Member Plan', '150', TextEditingController(text: '150')),
              _SettingsItem('Advocate Plan', '350', TextEditingController(text: '350')),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<_SettingsItem> items;

  const _SettingsSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.label,
                      style: GoogleFonts.poppins(
                        color: AppColors.textGray,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: item.controller,
                      style: GoogleFonts.poppins(
                          color: AppColors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.black,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: AppColors.borderColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                              color: AppColors.borderColor),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.teal,
              foregroundColor: AppColors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Save Changes',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsItem {
  final String label;
  final String placeholder;
  final TextEditingController controller;
  _SettingsItem(this.label, this.placeholder, this.controller);
}

// ─── Helpers ──────────────────────────────────────────────────────────────────
Widget _tabHeader(String title, String subtitle) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: GoogleFonts.poppins(
          color: AppColors.white,
          fontSize: 24,
          fontWeight: FontWeight.w900,
        ),
      ),
      Text(
        subtitle,
        style: GoogleFonts.poppins(
          color: AppColors.textGray,
          fontSize: 13,
        ),
      ),
    ],
  );
}

Widget _tableHeader(String label) {
  return Text(
    label,
    style: GoogleFonts.poppins(
      color: AppColors.textGray,
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
    ),
  );
}

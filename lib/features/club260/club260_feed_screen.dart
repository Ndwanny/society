import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../core/theme/app_colors.dart';
import '../../shared/models/models.dart';

class Club260FeedScreen extends StatefulWidget {
  const Club260FeedScreen({super.key});

  @override
  State<Club260FeedScreen> createState() => _Club260FeedScreenState();
}

class _Club260FeedScreenState extends State<Club260FeedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _createPostController = TextEditingController();
  bool _showCreatePost = false;
  List<PostModel> _posts = PostModel.mockPosts;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _createPostController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 1100;

    return Scaffold(
      backgroundColor: AppColors.black,
      body: Row(
        children: [
          // Left sidebar
          if (isWide) _LeftSidebar(),

          // Main feed
          Expanded(
            child: Column(
              children: [
                _FeedHeader(
                  onCreatePost: () =>
                      setState(() => _showCreatePost = !_showCreatePost),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (_showCreatePost)
                          _CreatePostWidget(
                            controller: _createPostController,
                            onPost: (text) {
                              setState(() {
                                _posts = [
                                  PostModel(
                                    id: DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString(),
                                    authorId: 'me',
                                    authorName: 'You',
                                    type: PostType.text,
                                    textContent: text,
                                    createdAt: DateTime.now(),
                                  ),
                                  ..._posts,
                                ];
                                _showCreatePost = false;
                                _createPostController.clear();
                              });
                            },
                          ),
                        ..._posts.map((post) => PostCard(post: post)),
                        const SizedBox(height: 48),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Right sidebar
          if (isWide) _RightSidebar(),
        ],
      ),
    );
  }
}

// ─── Left Sidebar ─────────────────────────────────────────────────────────────
class _LeftSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.darkGray,
        border: Border(right: BorderSide(color: AppColors.borderColor)),
      ),
      child: Column(
        children: [
          // Logo
          Container(
            padding: const EdgeInsets.all(24),
            child: GestureDetector(
              onTap: () => context.go('/'),
              child: Row(
                children: [
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.spaceMono(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                      ),
                      children: const [
                        TextSpan(
                          text: 'CLUB',
                          style: TextStyle(color: AppColors.white),
                        ),
                        TextSpan(
                          text: '260',
                          style: TextStyle(color: AppColors.teal),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(color: AppColors.borderColor, height: 1),

          // Nav items
          const SizedBox(height: 16),
          _sidebarItem(context, Icons.home_outlined, 'Home', '/'),
          _sidebarItem(
              context, Icons.explore_outlined, 'Explore', '/club260/feed'),
          _sidebarItem(context, Icons.chat_bubble_outline, 'Messages',
              '/club260/messages'),
          _sidebarItem(context, Icons.play_circle_outline, 'Courses',
              '/club260/courses'),
          _sidebarItem(context, Icons.star_outline, 'Membership',
              '/club260/membership'),
          _sidebarItem(
              context, Icons.event_outlined, 'Events', '/events'),
          _sidebarItem(context, Icons.article_outlined, 'Blog', '/blog'),

          const Spacer(),
          const Divider(color: AppColors.borderColor),

          // User card
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.teal.withOpacity(0.2),
                        child: const Text('U',
                            style: TextStyle(color: AppColors.teal)),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Guest User',
                            style: GoogleFonts.spaceGrotesk(
                              color: AppColors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Free Plan',
                            style: GoogleFonts.inter(
                              color: AppColors.textGray,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () =>
                          context.go('/club260/membership'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.teal,
                        foregroundColor: AppColors.black,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        textStyle: GoogleFonts.spaceGrotesk(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('UPGRADE'),
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

  Widget _sidebarItem(
      BuildContext context, IconData icon, String label, String route) {
    final currentPath = GoRouterState.of(context).uri.toString();
    final isActive = currentPath == route;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go(route),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? AppColors.teal.withOpacity(0.1) : null,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isActive ? AppColors.teal : AppColors.textGray,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: GoogleFonts.spaceGrotesk(
                  color: isActive ? AppColors.teal : AppColors.textGray,
                  fontSize: 14,
                  fontWeight:
                      isActive ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Right Sidebar ────────────────────────────────────────────────────────────
class _RightSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.darkGray,
        border: Border(left: BorderSide(color: AppColors.borderColor)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trending tags
            Text(
              'Trending',
              style: GoogleFonts.spaceGrotesk(
                color: AppColors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                '#mentalhealth',
                '#healing',
                '#club260',
                '#260poetry',
                '#safespace',
                '#code260',
                '#zambia',
                '#selfcare',
              ]
                  .map((tag) => GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.cardBg,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                                color: AppColors.borderColor),
                          ),
                          child: Text(
                            tag,
                            style: GoogleFonts.inter(
                              color: AppColors.teal,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),

            const SizedBox(height: 32),
            const Divider(color: AppColors.borderColor),
            const SizedBox(height: 24),

            // Suggested users
            Text(
              'People to follow',
              style: GoogleFonts.spaceGrotesk(
                color: AppColors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            ...UserModel.mockUsers
                .take(3)
                .map((user) => _UserSuggestion(user: user)),

            const SizedBox(height: 24),
            const Divider(color: AppColors.borderColor),
            const SizedBox(height: 24),

            // Next session
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.teal.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border:
                    Border.all(color: AppColors.teal.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NEXT SESSION',
                    style: GoogleFonts.spaceMono(
                      color: AppColors.teal,
                      fontSize: 10,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'June 29, 2025\nClub260 Monthly Gathering',
                    style: GoogleFonts.spaceGrotesk(
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.go('/signup'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.teal,
                        foregroundColor: AppColors.black,
                        padding:
                            const EdgeInsets.symmetric(vertical: 10),
                        textStyle:
                            GoogleFonts.spaceGrotesk(fontSize: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('RSVP'),
                    ),
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

class _UserSuggestion extends StatelessWidget {
  final UserModel user;
  const _UserSuggestion({required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.teal.withOpacity(0.15),
            child: Text(
              user.displayName[0],
              style: GoogleFonts.spaceGrotesk(
                color: AppColors.teal,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.displayName,
                  style: GoogleFonts.spaceGrotesk(
                    color: AppColors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '@${user.username}',
                  style: GoogleFonts.inter(
                    color: AppColors.textGray,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: AppColors.teal,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
            child: Text(
              'Follow',
              style: GoogleFonts.spaceGrotesk(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Feed Header ──────────────────────────────────────────────────────────────
class _FeedHeader extends StatelessWidget {
  final VoidCallback onCreatePost;
  const _FeedHeader({required this.onCreatePost});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.black,
        border: Border(bottom: BorderSide(color: AppColors.borderColor)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.white),
            onPressed: () => context.go('/club260'),
          ),
          const SizedBox(width: 8),
          Text(
            'Club260 Feed',
            style: GoogleFonts.spaceMono(
              color: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: onCreatePost,
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Create Post'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.teal,
              foregroundColor: AppColors.black,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              textStyle: GoogleFonts.spaceGrotesk(
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Create Post Widget ───────────────────────────────────────────────────────
class _CreatePostWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onPost;

  const _CreatePostWidget({
    required this.controller,
    required this.onPost,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.teal.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What\'s on your mind?',
            style: GoogleFonts.spaceGrotesk(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            maxLines: 4,
            style: GoogleFonts.inter(color: AppColors.offWhite, fontSize: 15),
            decoration: InputDecoration(
              hintText:
                  'Share something with the community...',
              hintStyle: GoogleFonts.inter(
                color: AppColors.textMuted,
                fontSize: 15,
              ),
              filled: true,
              fillColor: AppColors.black,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _postTypeButton(Icons.image_outlined, 'Image'),
              const SizedBox(width: 8),
              _postTypeButton(Icons.mic_outlined, 'Voice Note'),
              const SizedBox(width: 8),
              _postTypeButton(Icons.videocam_outlined, 'Video'),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  if (controller.text.trim().isNotEmpty) {
                    onPost(controller.text.trim());
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.teal,
                  foregroundColor: AppColors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'POST',
                  style: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _postTypeButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.borderColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textGray),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              color: AppColors.textGray,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Post Card ────────────────────────────────────────────────────────────────
class PostCard extends StatefulWidget {
  final PostModel post;
  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late int _likes;
  late bool _isLiked;
  bool _showComments = false;

  @override
  void initState() {
    super.initState();
    _likes = widget.post.likes;
    _isLiked = widget.post.isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pinned indicator
          if (widget.post.isPinned)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: const BoxDecoration(
                color: AppColors.teal,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.push_pin,
                      size: 12, color: AppColors.black),
                  const SizedBox(width: 6),
                  Text(
                    'Pinned Post',
                    style: GoogleFonts.spaceGrotesk(
                      color: AppColors.black,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Author row
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.teal.withOpacity(0.15),
                      child: Text(
                        widget.post.authorName[0],
                        style: GoogleFonts.spaceGrotesk(
                          color: AppColors.teal,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.post.authorName,
                          style: GoogleFonts.spaceGrotesk(
                            color: AppColors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          timeago.format(widget.post.createdAt),
                          style: GoogleFonts.inter(
                            color: AppColors.textGray,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Icon(Icons.more_horiz,
                        color: AppColors.textGray, size: 20),
                  ],
                ),

                const SizedBox(height: 16),

                // Content
                if (widget.post.textContent != null)
                  Text(
                    widget.post.textContent!,
                    style: GoogleFonts.inter(
                      color: AppColors.offWhite,
                      fontSize: 15,
                      height: 1.7,
                    ),
                  ),

                // Image
                if (widget.post.mediaUrls != null &&
                    widget.post.mediaUrls!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.post.mediaUrls!.first,
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                      errorBuilder: (context, _, __) => Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: AppColors.borderColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.image_outlined,
                          color: AppColors.textGray,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ],

                // Tags
                if (widget.post.tags.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: widget.post.tags
                        .map((tag) => Text(
                              '#$tag',
                              style: GoogleFonts.inter(
                                color: AppColors.teal,
                                fontSize: 13,
                              ),
                            ))
                        .toList(),
                  ),
                ],

                const SizedBox(height: 20),

                // Action bar
                Row(
                  children: [
                    _ActionButton(
                      icon: _isLiked
                          ? Icons.favorite
                          : Icons.favorite_border,
                      label: _likes.toString(),
                      color: _isLiked ? AppColors.coral : null,
                      onTap: () {
                        setState(() {
                          _isLiked = !_isLiked;
                          _likes += _isLiked ? 1 : -1;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    _ActionButton(
                      icon: Icons.chat_bubble_outline,
                      label: widget.post.comments.toString(),
                      onTap: () =>
                          setState(() => _showComments = !_showComments),
                    ),
                    const SizedBox(width: 8),
                    _ActionButton(
                      icon: Icons.repeat_outlined,
                      label: widget.post.reposts.toString(),
                      onTap: () {},
                    ),
                    const Spacer(),
                    _ActionButton(
                      icon: Icons.bookmark_border,
                      label: '',
                      onTap: () {},
                    ),
                    const SizedBox(width: 8),
                    _ActionButton(
                      icon: Icons.share_outlined,
                      label: '',
                      onTap: () {},
                    ),
                  ],
                ),

                // Comments section
                if (_showComments) ...[
                  const Divider(color: AppColors.borderColor),
                  const SizedBox(height: 12),
                  TextField(
                    style: GoogleFonts.inter(
                      color: AppColors.offWhite,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Write a comment...',
                      hintStyle: GoogleFonts.inter(
                        color: AppColors.textMuted,
                        fontSize: 14,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      filled: true,
                      fillColor: AppColors.black,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: Icon(Icons.send,
                          color: AppColors.teal, size: 18),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.color,
    required this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.borderColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                size: 18,
                color: widget.color ??
                    (_hovered ? AppColors.white : AppColors.textGray),
              ),
              if (widget.label.isNotEmpty) ...[
                const SizedBox(width: 6),
                Text(
                  widget.label,
                  style: GoogleFonts.spaceGrotesk(
                    color: widget.color ?? AppColors.textGray,
                    fontSize: 13,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

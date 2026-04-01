import 'package:uuid/uuid.dart';

const _uuid = Uuid();

// ─── User Model ────────────────────────────────────────────────────────────
class UserModel {
  final String id;
  final String username;
  final String displayName;
  final String email;
  final String? avatarUrl;
  final String? bio;
  final MembershipTier membership;
  final DateTime joinedAt;
  final int followers;
  final int following;
  final int postCount;

  const UserModel({
    required this.id,
    required this.username,
    required this.displayName,
    required this.email,
    this.avatarUrl,
    this.bio,
    this.membership = MembershipTier.free,
    required this.joinedAt,
    this.followers = 0,
    this.following = 0,
    this.postCount = 0,
  });

  // Mock data
  static List<UserModel> mockUsers = [
    UserModel(
      id: _uuid.v4(),
      username: 'chanda_lumi',
      displayName: 'Chanda Lumina',
      email: 'chanda@example.com',
      bio: 'Mental health advocate 💙 | Lusaka, Zambia',
      membership: MembershipTier.pro,
      joinedAt: DateTime(2024, 1, 15),
      followers: 342,
      following: 128,
      postCount: 47,
    ),
    UserModel(
      id: _uuid.v4(),
      username: 'naledi_m',
      displayName: 'Naledi Moyo',
      email: 'naledi@example.com',
      bio: 'Artist | Storyteller | Safe space creator ✨',
      membership: MembershipTier.advocate,
      joinedAt: DateTime(2023, 11, 3),
      followers: 891,
      following: 234,
      postCount: 203,
    ),
    UserModel(
      id: _uuid.v4(),
      username: 'society260_official',
      displayName: 'Society260',
      email: 'society260@info.com',
      bio: 'A safe space in motion 🌿 | Mental health awareness | Lusaka, Zambia',
      membership: MembershipTier.advocate,
      joinedAt: DateTime(2023, 6, 1),
      followers: 5420,
      following: 312,
      postCount: 847,
    ),
  ];
}

enum MembershipTier { free, pro, advocate }

// ─── Post Model ────────────────────────────────────────────────────────────
class PostModel {
  final String id;
  final String authorId;
  final String authorName;
  final String? authorAvatar;
  final PostType type;
  final String? textContent;
  final List<String>? mediaUrls;
  final String? audioUrl;
  final List<String> tags;
  final int likes;
  final int comments;
  final int reposts;
  final DateTime createdAt;
  final bool isLiked;
  final bool isPinned;

  const PostModel({
    required this.id,
    required this.authorId,
    required this.authorName,
    this.authorAvatar,
    required this.type,
    this.textContent,
    this.mediaUrls,
    this.audioUrl,
    this.tags = const [],
    this.likes = 0,
    this.comments = 0,
    this.reposts = 0,
    required this.createdAt,
    this.isLiked = false,
    this.isPinned = false,
  });

  // Mock feed posts
  static List<PostModel> mockPosts = [
    PostModel(
      id: _uuid.v4(),
      authorId: '1',
      authorName: 'Society260',
      type: PostType.text,
      textContent: '💙 Reminder that healing is not linear. Some days you\'ll feel like you\'re going backwards — that\'s okay. You\'re still moving. Still growing. Still here.\n\nA safe space in motion means we move together, at our own pace. 🌿',
      tags: ['mentalhealth', 'healing', 'safespace'],
      likes: 284,
      comments: 43,
      reposts: 91,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isPinned: true,
    ),
    PostModel(
      id: _uuid.v4(),
      authorId: '2',
      authorName: 'Naledi Moyo',
      type: PostType.image,
      textContent: 'New artwork exploring the theme of emotional landscapes 🎨 Sometimes feelings look like this — layered, complex, but always beautiful in their own way.',
      mediaUrls: ['https://picsum.photos/seed/art1/600/400'],
      tags: ['art', 'emotions', 'creative'],
      likes: 156,
      comments: 28,
      reposts: 34,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    PostModel(
      id: _uuid.v4(),
      authorId: '3',
      authorName: 'Chanda Lumina',
      type: PostType.text,
      textContent: 'Attended the Club260 virtual session last Sunday and honestly? It changed something in me. The way everyone showed up for each other... we don\'t talk enough about how healing community can be. 🙏✨',
      tags: ['club260', 'community', 'healing'],
      likes: 203,
      comments: 67,
      reposts: 78,
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),
    PostModel(
      id: _uuid.v4(),
      authorId: '1',
      authorName: 'Society260',
      type: PostType.text,
      textContent: '📢 260 POETRY – CHAPTER 3 is coming August 23, 2025!\n\nA community-rooted creative evening where words become worlds. Featuring writers, spoken word artists, and healing spaces.\n\nMark your calendars. This one\'s going to be something special. 🌙',
      tags: ['260poetry', 'events', 'poetry'],
      likes: 445,
      comments: 112,
      reposts: 203,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    PostModel(
      id: _uuid.v4(),
      authorId: '2',
      authorName: 'Naledi Moyo',
      type: PostType.image,
      textContent: 'The new Code260 comic characters are absolutely stunning 😭 Zara, Moni, and Sol are going to mean so much to young people in Zambia.',
      mediaUrls: ['https://picsum.photos/seed/comic1/500/500'],
      tags: ['code260', 'comics', 'mentalhealth'],
      likes: 312,
      comments: 89,
      reposts: 145,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];
}

enum PostType { text, image, video, audio, mixed }

// ─── Event Model ────────────────────────────────────────────────────────────
class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final bool isVirtual;
  final String? imageUrl;
  final int attendees;
  final EventCategory category;
  final bool isPast;

  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    this.isVirtual = false,
    this.imageUrl,
    this.attendees = 0,
    required this.category,
    this.isPast = false,
  });

  static List<EventModel> mockEvents = [
    EventModel(
      id: _uuid.v4(),
      title: '260 Poetry — Chapter 3',
      description: 'A community-rooted creative program that uses poetry, spoken word, and storytelling as tools for mental wellness and self-expression. An evening where words heal.',
      date: DateTime(2025, 8, 23, 18, 0),
      location: 'Lusaka, Zambia',
      imageUrl: 'https://picsum.photos/seed/poetry3/800/500',
      attendees: 234,
      category: EventCategory.poetry,
    ),
    EventModel(
      id: _uuid.v4(),
      title: 'Club260 Virtual Gathering — June',
      description: 'Our monthly safe space gathering featuring a special guest healer and life coach. This session focuses on navigating anxiety in everyday life.',
      date: DateTime(2025, 6, 29, 14, 0),
      location: 'Virtual (Zoom)',
      isVirtual: true,
      imageUrl: 'https://picsum.photos/seed/club260/800/500',
      attendees: 89,
      category: EventCategory.club260,
    ),
    EventModel(
      id: _uuid.v4(),
      title: 'Sauti Society Vol. 1',
      description: 'SAUTI SOCIETY is a dynamic program celebrating voice, sound, and musical self-expression as pathways to mental wellness.',
      date: DateTime(2025, 4, 26, 17, 0),
      location: 'Lusaka, Zambia',
      imageUrl: 'https://picsum.photos/seed/sauti/800/500',
      attendees: 312,
      category: EventCategory.music,
      isPast: true,
    ),
    EventModel(
      id: _uuid.v4(),
      title: '260 Poetry Vol. II',
      description: 'Experience #260Poetry Volume II featuring writers, spoken word artists, and an intimate evening of healing through words.',
      date: DateTime(2024, 4, 30, 18, 0),
      location: 'Lusaka, Zambia',
      imageUrl: 'https://picsum.photos/seed/poetry2/800/500',
      attendees: 278,
      category: EventCategory.poetry,
      isPast: true,
    ),
    EventModel(
      id: _uuid.v4(),
      title: 'Code260 Children\'s Workshop',
      description: 'A fun, interactive workshop for children ages 8-14. Through storytelling, art, and play, we explore emotions and build resilience.',
      date: DateTime(2025, 7, 12, 9, 0),
      location: 'Kabulonga, Lusaka',
      imageUrl: 'https://picsum.photos/seed/code260w/800/500',
      attendees: 45,
      category: EventCategory.code260,
    ),
  ];
}

enum EventCategory { poetry, club260, music, workshop, code260, other }

// ─── Blog Post Model ────────────────────────────────────────────────────────
class BlogPost {
  final String id;
  final String title;
  final String excerpt;
  final String content;
  final String authorName;
  final String? authorAvatar;
  final String? coverImage;
  final List<String> tags;
  final DateTime publishedAt;
  final int readTime;
  final int views;
  final BlogCategory category;

  const BlogPost({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.content,
    required this.authorName,
    this.authorAvatar,
    this.coverImage,
    this.tags = const [],
    required this.publishedAt,
    this.readTime = 5,
    this.views = 0,
    required this.category,
  });

  static List<BlogPost> mockPosts = [
    BlogPost(
      id: _uuid.v4(),
      title: 'What Does It Mean to Hold Space?',
      excerpt: 'In our communities, we often talk about "being there" for someone. But holding space is something deeper — it\'s an active, intentional presence.',
      content: '',
      authorName: 'Society260',
      coverImage: 'https://picsum.photos/seed/blog1/800/400',
      tags: ['healing', 'community', 'support'],
      publishedAt: DateTime(2025, 5, 15),
      readTime: 6,
      views: 1243,
      category: BlogCategory.mentalHealth,
    ),
    BlogPost(
      id: _uuid.v4(),
      title: 'The Language of Fashion: Wearing Your True Self',
      excerpt: 'Society260 has always believed that fashion is more than aesthetics. It\'s a language — one that speaks before you do.',
      content: '',
      authorName: 'Naledi Moyo',
      coverImage: 'https://picsum.photos/seed/fashion/800/400',
      tags: ['fashion', 'identity', 'selfexpression'],
      publishedAt: DateTime(2025, 4, 28),
      readTime: 4,
      views: 876,
      category: BlogCategory.fashion,
    ),
    BlogPost(
      id: _uuid.v4(),
      title: 'Introducing Code260: Raising Emotionally Resilient Children',
      excerpt: 'Children feel deeply. Code260 was born from the belief that mental wellness education should start early — wrapped in creativity and joy.',
      content: '',
      authorName: 'Society260',
      coverImage: 'https://picsum.photos/seed/code260b/800/400',
      tags: ['code260', 'children', 'education'],
      publishedAt: DateTime(2025, 3, 10),
      readTime: 7,
      views: 2341,
      category: BlogCategory.code260,
    ),
    BlogPost(
      id: _uuid.v4(),
      title: 'Recap: 260 Poetry Vol. II — Words That Healed',
      excerpt: 'Forty-three writers. One stage. An evening that reminded us why storytelling is sacred.',
      content: '',
      authorName: 'Chanda Lumina',
      coverImage: 'https://picsum.photos/seed/poetryrecap/800/400',
      tags: ['poetry', 'events', 'recap'],
      publishedAt: DateTime(2025, 5, 5),
      readTime: 5,
      views: 1567,
      category: BlogCategory.events,
    ),
  ];
}

enum BlogCategory { mentalHealth, fashion, events, code260, community }

// ─── Message Model ────────────────────────────────────────────────────────
class MessageModel {
  final String id;
  final String senderId;
  final String senderName;
  final String? senderAvatar;
  final MessageType type;
  final String? text;
  final String? mediaUrl;
  final Duration? audioDuration;
  final DateTime sentAt;
  final bool isRead;
  final bool isMine;

  const MessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.type,
    this.text,
    this.mediaUrl,
    this.audioDuration,
    required this.sentAt,
    this.isRead = false,
    this.isMine = false,
  });
}

enum MessageType { text, image, audio, video }

// ─── Course Model ────────────────────────────────────────────────────────
class CourseModel {
  final String id;
  final String title;
  final String description;
  final String instructor;
  final String? thumbnailUrl;
  final int lessons;
  final Duration totalDuration;
  final double rating;
  final int enrolled;
  final CourseLevel level;
  final bool isPremium;
  final List<String> topics;

  const CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.instructor,
    this.thumbnailUrl,
    required this.lessons,
    required this.totalDuration,
    this.rating = 4.5,
    this.enrolled = 0,
    this.level = CourseLevel.beginner,
    this.isPremium = true,
    this.topics = const [],
  });

  static List<CourseModel> mockCourses = [
    CourseModel(
      id: _uuid.v4(),
      title: 'Understanding Your Emotions',
      description: 'A foundational course exploring the science and experience of emotions. Learn to identify, name, and navigate your inner world.',
      instructor: 'Dr. Amara Phiri',
      thumbnailUrl: 'https://picsum.photos/seed/course1/400/225',
      lessons: 12,
      totalDuration: const Duration(hours: 4, minutes: 30),
      rating: 4.9,
      enrolled: 342,
      level: CourseLevel.beginner,
    ),
    CourseModel(
      id: _uuid.v4(),
      title: 'Building Resilience in Daily Life',
      description: 'Practical tools and mindset shifts for bouncing back from setbacks, cultivating inner strength, and thriving through adversity.',
      instructor: 'Thandi Mwansa',
      thumbnailUrl: 'https://picsum.photos/seed/course2/400/225',
      lessons: 8,
      totalDuration: const Duration(hours: 3),
      rating: 4.7,
      enrolled: 218,
      level: CourseLevel.intermediate,
    ),
    CourseModel(
      id: _uuid.v4(),
      title: 'Art as Healing: Creative Expression Workshop',
      description: 'Explore art therapy techniques — journaling, collage, and visual storytelling — as pathways to emotional processing and self-discovery.',
      instructor: 'Naledi Banda',
      thumbnailUrl: 'https://picsum.photos/seed/course3/400/225',
      lessons: 10,
      totalDuration: const Duration(hours: 5),
      rating: 4.8,
      enrolled: 456,
      level: CourseLevel.beginner,
    ),
    CourseModel(
      id: _uuid.v4(),
      title: 'Parenting for Emotional Intelligence',
      description: 'A guide for parents and caregivers to nurture emotionally resilient children. Includes Code260 companion resources.',
      instructor: 'Dr. Amara Phiri',
      thumbnailUrl: 'https://picsum.photos/seed/course4/400/225',
      lessons: 15,
      totalDuration: const Duration(hours: 6, minutes: 45),
      rating: 4.9,
      enrolled: 189,
      level: CourseLevel.intermediate,
      topics: ['code260', 'parenting', 'children'],
    ),
  ];
}

enum CourseLevel { beginner, intermediate, advanced }

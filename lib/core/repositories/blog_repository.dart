import '../services/supabase_service.dart';
import '../../shared/models/models.dart';

class BlogRepository {
  final _client = SupabaseService.client;

  /// Fetch all published blog posts.
  Future<List<BlogPost>> fetchAll() async {
    final data = await _client
        .from('blog_posts')
        .select('*, profiles(display_name, avatar_url)')
        .eq('is_published', true)
        .order('published_at', ascending: false);
    return _mapList(data);
  }

  /// Fetch posts by category.
  Future<List<BlogPost>> fetchByCategory(String category) async {
    final data = await _client
        .from('blog_posts')
        .select('*, profiles(display_name, avatar_url)')
        .eq('is_published', true)
        .eq('category', category)
        .order('published_at', ascending: false);
    return _mapList(data);
  }

  /// Fetch a single post by ID and increment view count.
  Future<BlogPost?> fetchById(String id) async {
    final data = await _client
        .from('blog_posts')
        .select('*, profiles(display_name, avatar_url)')
        .eq('id', id)
        .maybeSingle();
    if (data == null) return null;
    // increment views
    await _client.rpc('increment_blog_views', params: {'post_id': id});
    return _mapRow(data);
  }

  /// Admin: create a blog post.
  Future<void> createPost(Map<String, dynamic> postData) async {
    final uid = SupabaseService.currentUserId;
    await _client.from('blog_posts').insert({...postData, 'author_id': uid});
  }

  /// Admin: publish/unpublish a post.
  Future<void> setPublished(String id, {required bool published}) async {
    await _client
        .from('blog_posts')
        .update({'is_published': published})
        .eq('id', id);
  }

  List<BlogPost> _mapList(List<dynamic> data) =>
      data.map((row) => _mapRow(row as Map<String, dynamic>)).toList();

  BlogPost _mapRow(Map<String, dynamic> row) {
    final profile = row['profiles'] as Map<String, dynamic>? ?? {};
    return BlogPost(
      id: row['id'],
      title: row['title'],
      excerpt: row['excerpt'] ?? '',
      content: row['content'] ?? '',
      authorName: profile['display_name'] ?? 'Society260',
      authorAvatar: profile['avatar_url'] ?? '',
      coverImage: row['cover_image'] ?? '',
      tags: List<String>.from(row['tags'] ?? []),
      publishedAt: DateTime.parse(row['published_at'] ?? row['created_at']),
      readTime: row['read_time'] ?? 5,
      views: row['views'] ?? 0,
      category: BlogCategory.values.firstWhere(
        (e) => e.name == row['category'],
        orElse: () => BlogCategory.community,
      ),
    );
  }
}

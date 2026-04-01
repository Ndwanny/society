import '../services/supabase_service.dart';
import '../../shared/models/models.dart';

class PostsRepository {
  final _client = SupabaseService.client;

  /// Fetch paginated feed posts with author profile joined.
  Future<List<PostModel>> fetchFeed({int limit = 20, int offset = 0}) async {
    final data = await _client
        .from('posts')
        .select('*, profiles(username, display_name, avatar_url)')
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    final uid = SupabaseService.currentUserId;
    // Fetch liked post IDs for current user in one query
    Set<String> likedIds = {};
    if (uid != null) {
      final likes = await _client
          .from('post_likes')
          .select('post_id')
          .eq('user_id', uid);
      likedIds = {for (final l in likes) l['post_id'] as String};
    }

    return (data as List).map((row) {
      final profile = row['profiles'] as Map<String, dynamic>? ?? {};
      return PostModel(
        id: row['id'],
        authorId: row['author_id'],
        authorName: profile['display_name'] ?? profile['username'] ?? 'Unknown',
        authorAvatar: profile['avatar_url'] ?? '',
        type: PostType.values.firstWhere(
          (e) => e.name == row['type'],
          orElse: () => PostType.text,
        ),
        textContent: row['text_content'] ?? '',
        mediaUrls: List<String>.from(row['media_urls'] ?? []),
        audioUrl: row['audio_url'],
        tags: List<String>.from(row['tags'] ?? []),
        likes: row['likes'] ?? 0,
        comments: row['comments'] ?? 0,
        reposts: row['reposts'] ?? 0,
        createdAt: DateTime.parse(row['created_at']),
        isLiked: likedIds.contains(row['id']),
        isPinned: row['is_pinned'] ?? false,
      );
    }).toList();
  }

  /// Create a new text post.
  Future<void> createPost({
    required String textContent,
    List<String> tags = const [],
  }) async {
    final uid = SupabaseService.currentUserId;
    if (uid == null) throw Exception('Must be logged in to post.');
    await _client.from('posts').insert({
      'author_id': uid,
      'type': 'text',
      'text_content': textContent,
      'tags': tags,
    });
  }

  /// Toggle like on a post. Returns new liked state.
  Future<bool> toggleLike(String postId) async {
    final uid = SupabaseService.currentUserId;
    if (uid == null) throw Exception('Must be logged in to like.');

    final existing = await _client
        .from('post_likes')
        .select()
        .eq('post_id', postId)
        .eq('user_id', uid)
        .maybeSingle();

    if (existing != null) {
      await _client
          .from('post_likes')
          .delete()
          .eq('post_id', postId)
          .eq('user_id', uid);
      return false;
    } else {
      await _client.from('post_likes').insert({
        'post_id': postId,
        'user_id': uid,
      });
      return true;
    }
  }

  /// Delete a post (only the author can delete).
  Future<void> deletePost(String postId) async {
    await _client.from('posts').delete().eq('id', postId);
  }
}

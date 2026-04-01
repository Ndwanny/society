import '../services/supabase_service.dart';
import '../../shared/models/models.dart';

class MessagesRepository {
  final _client = SupabaseService.client;

  /// Fetch all conversations for the current user.
  Future<List<Map<String, dynamic>>> fetchConversations() async {
    final uid = SupabaseService.currentUserId;
    if (uid == null) return [];
    final data = await _client
        .from('conversations')
        .select('*, p1:profiles!participant1(display_name, avatar_url), p2:profiles!participant2(display_name, avatar_url)')
        .or('participant1.eq.$uid,participant2.eq.$uid')
        .order('last_message_at', ascending: false);
    return List<Map<String, dynamic>>.from(data);
  }

  /// Fetch messages for a conversation.
  Future<List<MessageModel>> fetchMessages(String conversationId) async {
    final uid = SupabaseService.currentUserId;
    final data = await _client
        .from('messages')
        .select('*, profiles(display_name, avatar_url)')
        .eq('conversation_id', conversationId)
        .order('sent_at', ascending: true);

    return (data as List).map((row) {
      final profile = row['profiles'] as Map<String, dynamic>? ?? {};
      return MessageModel(
        id: row['id'],
        senderId: row['sender_id'],
        senderName: profile['display_name'] ?? 'Unknown',
        senderAvatar: profile['avatar_url'] ?? '',
        type: MessageType.values.firstWhere(
          (e) => e.name == row['type'],
          orElse: () => MessageType.text,
        ),
        text: row['text'] ?? '',
        mediaUrl: row['media_url'],
        audioDuration: row['audio_duration'],
        sentAt: DateTime.parse(row['sent_at']),
        isRead: row['is_read'] ?? false,
        isMine: row['sender_id'] == uid,
      );
    }).toList();
  }

  /// Send a text message. Creates conversation if it doesn't exist.
  Future<void> sendMessage({
    required String recipientId,
    required String text,
  }) async {
    final uid = SupabaseService.currentUserId;
    if (uid == null) throw Exception('Must be logged in to send messages.');

    // Find or create conversation
    String conversationId = await _findOrCreateConversation(uid, recipientId);

    await _client.from('messages').insert({
      'conversation_id': conversationId,
      'sender_id': uid,
      'type': 'text',
      'text': text,
    });
  }

  /// Subscribe to real-time message updates in a conversation.
  RealtimeChannel subscribeToMessages(
    String conversationId,
    void Function(Map<String, dynamic>) onMessage,
  ) {
    return _client
        .channel('messages:$conversationId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'conversation_id',
            value: conversationId,
          ),
          callback: (payload) => onMessage(payload.newRecord),
        )
        .subscribe();
  }

  Future<String> _findOrCreateConversation(
      String uid, String recipientId) async {
    // Try participant1=uid, participant2=recipientId
    var existing = await _client
        .from('conversations')
        .select('id')
        .eq('participant1', uid)
        .eq('participant2', recipientId)
        .maybeSingle();

    existing ??= await _client
        .from('conversations')
        .select('id')
        .eq('participant1', recipientId)
        .eq('participant2', uid)
        .maybeSingle();

    if (existing != null) return existing['id'] as String;

    final created = await _client.from('conversations').insert({
      'participant1': uid,
      'participant2': recipientId,
    }).select('id').single();

    return created['id'] as String;
  }
}

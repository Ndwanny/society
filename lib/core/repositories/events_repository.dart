import '../services/supabase_service.dart';
import '../../shared/models/models.dart';

class EventsRepository {
  final _client = SupabaseService.client;

  /// Fetch all upcoming events (is_past = false).
  Future<List<EventModel>> fetchUpcoming() async {
    final data = await _client
        .from('events')
        .select()
        .eq('is_past', false)
        .order('date', ascending: true);
    return _mapList(data);
  }

  /// Fetch all past events.
  Future<List<EventModel>> fetchPast() async {
    final data = await _client
        .from('events')
        .select()
        .eq('is_past', true)
        .order('date', ascending: false);
    return _mapList(data);
  }

  /// Fetch all events (upcoming + past).
  Future<List<EventModel>> fetchAll() async {
    final data = await _client
        .from('events')
        .select()
        .order('date', ascending: false);
    return _mapList(data);
  }

  /// Register current user for an event.
  Future<void> register(String eventId) async {
    final uid = SupabaseService.currentUserId;
    if (uid == null) throw Exception('Must be logged in to register.');
    await _client.from('event_registrations').insert({
      'event_id': eventId,
      'user_id': uid,
    });
  }

  /// Unregister current user from an event.
  Future<void> unregister(String eventId) async {
    final uid = SupabaseService.currentUserId;
    if (uid == null) return;
    await _client
        .from('event_registrations')
        .delete()
        .eq('event_id', eventId)
        .eq('user_id', uid);
  }

  /// Check if current user is registered for an event.
  Future<bool> isRegistered(String eventId) async {
    final uid = SupabaseService.currentUserId;
    if (uid == null) return false;
    final data = await _client
        .from('event_registrations')
        .select()
        .eq('event_id', eventId)
        .eq('user_id', uid)
        .maybeSingle();
    return data != null;
  }

  /// Admin: create a new event.
  Future<void> createEvent(Map<String, dynamic> eventData) async {
    final uid = SupabaseService.currentUserId;
    await _client.from('events').insert({...eventData, 'created_by': uid});
  }

  /// Admin: delete an event.
  Future<void> deleteEvent(String eventId) async {
    await _client.from('events').delete().eq('id', eventId);
  }

  List<EventModel> _mapList(List<dynamic> data) {
    return data.map((row) => EventModel(
      id: row['id'],
      title: row['title'],
      description: row['description'] ?? '',
      date: DateTime.parse(row['date']),
      location: row['location'] ?? '',
      isVirtual: row['is_virtual'] ?? false,
      imageUrl: row['image_url'] ?? '',
      attendees: row['attendees'] ?? 0,
      category: EventCategory.values.firstWhere(
        (e) => e.name == row['category'],
        orElse: () => EventCategory.other,
      ),
      isPast: row['is_past'] ?? false,
    )).toList();
  }
}

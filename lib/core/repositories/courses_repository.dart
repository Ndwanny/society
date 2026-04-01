import '../services/supabase_service.dart';
import '../../shared/models/models.dart';

class CoursesRepository {
  final _client = SupabaseService.client;

  /// Fetch all courses.
  Future<List<CourseModel>> fetchAll() async {
    final data = await _client
        .from('courses')
        .select()
        .order('created_at', ascending: false);
    return _mapList(data);
  }

  /// Fetch courses the current user is enrolled in.
  Future<List<String>> fetchEnrolledIds() async {
    final uid = SupabaseService.currentUserId;
    if (uid == null) return [];
    final data = await _client
        .from('course_enrollments')
        .select('course_id')
        .eq('user_id', uid);
    return List<String>.from(data.map((r) => r['course_id']));
  }

  /// Enroll current user in a course.
  Future<void> enroll(String courseId) async {
    final uid = SupabaseService.currentUserId;
    if (uid == null) throw Exception('Must be logged in to enroll.');
    await _client.from('course_enrollments').insert({
      'course_id': courseId,
      'user_id': uid,
    });
  }

  /// Unenroll current user from a course.
  Future<void> unenroll(String courseId) async {
    final uid = SupabaseService.currentUserId;
    if (uid == null) return;
    await _client
        .from('course_enrollments')
        .delete()
        .eq('course_id', courseId)
        .eq('user_id', uid);
  }

  List<CourseModel> _mapList(List<dynamic> data) {
    return data.map((row) => CourseModel(
      id: row['id'],
      title: row['title'],
      description: row['description'] ?? '',
      instructor: row['instructor'],
      thumbnailUrl: row['thumbnail_url'] ?? '',
      lessons: row['lessons'] ?? 0,
      totalDuration: row['total_duration'] ?? '',
      rating: (row['rating'] as num).toDouble(),
      enrolled: row['enrolled'] ?? 0,
      level: CourseLevel.values.firstWhere(
        (e) => e.name == row['level'],
        orElse: () => CourseLevel.beginner,
      ),
      isPremium: row['is_premium'] ?? false,
      topics: List<String>.from(row['topics'] ?? []),
    )).toList();
  }
}

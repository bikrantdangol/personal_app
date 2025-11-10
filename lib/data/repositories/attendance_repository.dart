import '../models/attendance_model.dart';
import '../../core/services/api_service.dart';
import '../../core/constants/api_endpoints.dart';

class AttendanceRepository {
  final ApiService _apiService = ApiService();

  Future<void> markAttendance(AttendanceModel attendance) async {
    await _apiService.setDocument(ApiEndpoints.attendanceCollection, attendance.id, attendance.toMap());
  }

  Stream<List<AttendanceModel>> getAttendance(String userId) {
    return _apiService.getCollectionStream(ApiEndpoints.attendanceCollection)
        .map((snapshot) => snapshot.docs
            .where((doc) => doc['userId'] == userId)
            .map((doc) => AttendanceModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }
}
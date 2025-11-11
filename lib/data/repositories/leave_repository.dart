import '../models/leave_model.dart';
import '../../core/services/api_service.dart';
import '../../core/constants/api_endpoints.dart';

class LeaveRepository {
  final ApiService _apiService = ApiService();

  Future<void> submitLeave(LeaveModel leave) async {
    await _apiService.setDocument(ApiEndpoints.leavesCollection, leave.userId, leave.toMap());
  }

  Stream<List<LeaveModel>> getLeaves(String userId) {
    return _apiService.getCollectionStream(ApiEndpoints.leavesCollection)
        .map((snapshot) => snapshot.docs
            .where((doc) => doc['userId'] == userId)
            .map((doc) => LeaveModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> updateLeaveStatus(String id, String status) async {
    await _apiService.updateDocument(ApiEndpoints.leavesCollection, id, {'status': status});
  }
}
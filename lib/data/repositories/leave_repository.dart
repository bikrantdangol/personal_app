import 'package:cloud_firestore/cloud_firestore.dart';

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
    Stream<List<LeaveModel>> getLeavesStream() {
    return _apiService
        .getCollectionStream("leaves") 
        .map((snapshot) => snapshot.docs
            .map((doc) => LeaveModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> updateLeaveStatus(String leaveId, String status) async {
    await FirebaseFirestore.instance
      .collection('leaves')
      .doc(leaveId)
      .update({'status': status});
  }

  Future<void> deleteLeaveByUserId(String userId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
        .collection('leaves')
        .where('userId', isEqualTo: userId)
        .get();

      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }

      print("Deleted all leave requests for userId: $userId");
    } catch (e) {
      print("Error deleting leave by userId: $e");
      rethrow;
    }
  }

}
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../network/response_status.dart';
import '/domain/data/models/models.dart';

class UserRemoteDataSource {
  Future<UserModel?> getUserInfo(String token) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await FirebaseFirestore.instance.collection('user').doc(token).get();
      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  Future<UserModel?> getUserByEmail(String email) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('user')
              .where('id', isEqualTo: email)
              .get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
            querySnapshot.docs.first;
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> updateUser(
      String userId, Map<String, dynamic> updatedData) async {
    try {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(userId)
          .update(updatedData);
      return {
        'status': ResponseStatus.response200Ok,
      };
    } catch (e) {
      return {
        'status': ResponseStatus.response500InternalServerError,
        'data': e.toString(),
      };
    }
  }
}

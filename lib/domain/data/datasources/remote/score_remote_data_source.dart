import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../network/response_status.dart';
import '../../models/score_model.dart';
import '../../models/user_model.dart';

class ScoreRemoteDataSource {
  static const collectionScore = "score";

  Future<Map<String, dynamic>> createScore(UserModel user) async {
    try {
      ScoreModel score = ScoreModel();
      score.userId = user.id;
      score.score = 0;
      score.username = user.username;
      var scoreCreate = await FirebaseFirestore.instance
          .collection(collectionScore)
          .add(score.toMap());
      return {
        'status': ResponseStatus.response201Created,
        'data': scoreCreate.id,
      };
    } catch (e) {
      return {
        'status': ResponseStatus.response500InternalServerError,
        'data': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> updateScore(UserModel user) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection(collectionScore)
          .where('user_id', isEqualTo: user.id)
          .get();
      Map<String, dynamic> updatedData = {
        'user_id': user.id,
        'username': user.username,
        'score': user.score,
      };

      if (querySnapshot.docs.isNotEmpty) {
        String scoreId = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection(collectionScore)
            .doc(scoreId)
            .update(updatedData);
        return {
          'status': ResponseStatus.response200Ok,
        };
      } else {
        var scoreCreate = await FirebaseFirestore.instance
            .collection(collectionScore)
            .add(updatedData);
        return {
          'status':  ResponseStatus.response200Ok,
          'data': scoreCreate.id,
        };
      }
    } catch (e) {
      return {
        'status': ResponseStatus.response500InternalServerError,
        'data': e.toString(),
      };
    }
  }

  Future<List<ScoreModel>> getAllScoresSortedByScore() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection(collectionScore)
          .orderBy('score', descending: true)
          .limit(50)
          .get();
      return querySnapshot.docs
          .map((doc) => ScoreModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      return [];
    }
  }

}
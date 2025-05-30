import 'package:cloud_firestore/cloud_firestore.dart';

class ScoreEntity {
  String? userId;
  String? username;
  int? score;

  ScoreEntity();

  ScoreEntity.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    username = json['username'];
    score = json['score'];
  }

  ScoreEntity.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    userId = data['user_id'];
    username = data['username'];
    score = data['score'];
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'score': score,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'username': username,
      'score': score,
    };
  }
}

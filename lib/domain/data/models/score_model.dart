import 'package:cloud_firestore/cloud_firestore.dart';

import '../entities/score_entity.dart';

class ScoreModel extends ScoreEntity {
  ScoreModel();

  ScoreModel.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  ScoreModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : super.fromSnapshot(snapshot);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    // Add any additional fields or transformation if needed
    return data;
  }
}
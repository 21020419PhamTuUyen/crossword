import 'package:cloud_firestore/cloud_firestore.dart';

import '../entities/question_entity.dart';

class QuestionModel extends QuestionEntity {
  QuestionModel();

  QuestionModel.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  QuestionModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : super.fromSnapshot(snapshot);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    // Add any additional fields or transformation if needed
    return data;
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

import '../entities/stage_entity.dart';

class StageModel extends StageEntity {
  StageModel();

  StageModel.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  StageModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : super.fromSnapshot(snapshot);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    // Add any additional fields or transformation if needed
    return data;
  }
}

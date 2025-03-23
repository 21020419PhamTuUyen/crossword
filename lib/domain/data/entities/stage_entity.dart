import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/question_model.dart';

class StageEntity {
  int? stage;
  int? gridSize;
  dynamic inputCell;
  List<QuestionModel>? questions;
  bool? done;
  List<dynamic>? listChar;
  bool? isChallenge;
  String? topic;

  StageEntity();

  StageEntity.fromJson(Map<String, dynamic> json) {
    stage = json['stage'];
    gridSize = json['gridSize'];
    inputCell = json['inputCell'];
    questions = (json['questions'] as List<dynamic>?)
        ?.map((item) => QuestionModel.fromJson(item as Map<String, dynamic>))
        .toList();
    done = json['done'];
    listChar = json['listChar'];
    isChallenge = json['isChallenge'];
    topic = json['topic'];
  }

  StageEntity.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    List<List<int>> _inputCell = [];
    if (data['inputCell'] != null) {
      final inputCellMap = data['inputCell'] as Map<String, dynamic>;
      if (inputCellMap.isNotEmpty) {
        final sortedKeys = inputCellMap.keys.toList()
          ..sort((a, b) => int.parse(a).compareTo(int.parse(b)));

        _inputCell =
            sortedKeys.map((key) => List<int>.from(inputCellMap[key])).toList();
      }
    }
    stage = data['stage'];
    gridSize = data['gridSize'];
    inputCell = _inputCell;
    questions = data['questions']
        ?.map((item) => QuestionModel.fromJson(item as Map<String, dynamic>))
        .toList();
    done = data['done'];
    listChar = data['listChar'];
    isChallenge = data['isChallenge'];
    topic = data['topic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['stage'] = this.stage;
    data['gridSize'] = this.gridSize;
    data['inputCell'] = this.inputCell;
    data['questions'] = this.questions?.map((q) => q.toJson()).toList();
    data['done'] = this.done;
    data['listChar'] = this.listChar;
    data['isChallenge'] = this.isChallenge;
    data['topic'] = this.topic;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'stage': stage,
      'gridSize': gridSize,
      'inputCell': inputCell,
      'questions': questions?.map((q) => q.toMap()).toList(),
      'done': done,
      'listChar': listChar,
      'isChallenge': isChallenge,
      'topic': topic
    };
  }
}

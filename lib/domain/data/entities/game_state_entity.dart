
import '../models/stage_model.dart';

class GameStateEntity {
  int? id;
  StageModel? stage;
  int? currentSelectedIndex;
  var currentSelectedQuestion;
  var isHorizontal;
  var answers = [];
  List<int>? isDoneIndex;
  List<int>? isDoneQuestion;
  int? suggestion;
  int? seconds;
  bool? isWin;
  bool? isShowQuestion = false;

  GameStateEntity({
    this.id,
    this.stage,
    this.currentSelectedIndex,
    this.currentSelectedQuestion,
    this.isHorizontal,
    this.answers = const [],
    this.isDoneIndex,
    this.isDoneQuestion,
    this.suggestion,
    this.seconds,
    this.isWin
  });

  GameStateEntity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stage = StageModel.fromJson(json['stage']);
    currentSelectedIndex = json['currentSelectedIndex'];
    currentSelectedQuestion = json['currentSelectedQuestion'];
    isHorizontal = json['isHorizontal'];
    answers = json['answers'] ?? [];
    isDoneIndex = List<int>.from(json['isDoneIndex'] ?? []);
    isDoneQuestion = List<int>.from(json['isDoneQuestion'] ?? []);
    suggestion = json['suggestion'];
    seconds = json['seconds'];
    isWin = json['isWin'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stage': stage?.toJson(),
      'currentSelectedIndex': currentSelectedIndex,
      'currentSelectedQuestion': currentSelectedQuestion,
      'isHorizontal': isHorizontal,
      'answers': answers,
      'isDoneIndex': isDoneIndex,
      'isDoneQuestion': isDoneQuestion,
      'suggestion': suggestion,
      'seconds': seconds,
      'isWin': isWin,
    };
  }
}

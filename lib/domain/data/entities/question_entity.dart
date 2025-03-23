import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionEntity {
  int? order;
  int? stage;
  int? id;
  int? qid;
  String? question;
  bool? isHorizontal;
  String? answer;
  bool? done;

  QuestionEntity();

  QuestionEntity.fromJson(Map<String, dynamic> json) {
    order = json['order'];
    stage = json['stage'];
    id = json['id'];
    qid = json['qid'];
    question = json['question'];
    isHorizontal = json['isHor'];
    answer = json['answer'];
    done = json['done'];
  }

  QuestionEntity.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    order = data['order'];
    stage = data['stage'];
    id = data['id'];
    qid = data['qid'];
    question = data['question'];
    isHorizontal = data['isHor'];
    answer = data['answer'];
    done = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order'] = this.order;
    data['stage'] = this.stage;
    data['id'] = this.id;
    data['qid'] = this.qid;
    data['question'] = this.question;
    data['isHor'] = this.isHorizontal;
    data['answer'] = this.answer;
    data['done'] = this.done;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'order': order,
      'stage': stage,
      'id': id,
      'qid': qid,
      'question': question,
      'isHor': isHorizontal,
      'answer': answer,
      'done': done
    };
  }
}

import 'base_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntity extends BaseEntity {
  String? id;
  String? email;
  String? username;
  String? password;
  List<dynamic>? doneStages;
  List<dynamic>? doneExtraStages;
  int? score;
  int? suggestion;

  UserEntity();

  @override
  UserEntity.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    email = json['email'];
    password = json['password'];
    username = json['username'];
    doneStages = json['doneStages'];
    doneExtraStages = json['doneExtraStages'];
    score = json['score'];
    suggestion = json['suggestion'];
  }

  UserEntity.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : super.fromSnapshot(snapshot) {
    final data = snapshot.data()!;
    id = snapshot.id;
    email = data['email'];
    password = data['password'];
    username = data['username'];
    doneStages = data['doneStages'];
    doneExtraStages = data['doneExtraStages'];
    score = data['score'];
    suggestion = data['suggestion'];
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['email'] = this.email;
    data['username'] = this.username;
    data['password'] = this.password;
    data['doneStages'] = this.doneStages;
    data['doneExtraStages'] = this.doneExtraStages;
    data['score'] = this.score;
    data['suggestion'] = this.suggestion;
    return data;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
      'password': password,
      'doneStages': doneStages ?? [],
      'doneExtraStages': doneExtraStages ?? [],
      'score': score ?? 0,
      'suggestion': suggestion ?? 3
    };
  }
}

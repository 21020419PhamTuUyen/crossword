import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/game_state_entity.dart';

class GameStateModel extends GameStateEntity {
  GameStateModel();

  GameStateModel.fromJson(Map<String, dynamic> json) : super.fromJson(json);

  GameStateModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : super.fromJson(snapshot.data()!);

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    return data;
  }
}

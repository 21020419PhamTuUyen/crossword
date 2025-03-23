import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseEntity {
  Map<String, dynamic> toJson();
  Map<String, dynamic> toMap();

  BaseEntity();

  BaseEntity.fromJson(Map<String, dynamic> map);

  BaseEntity.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot);
}

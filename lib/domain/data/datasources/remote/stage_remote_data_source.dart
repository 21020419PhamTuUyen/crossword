import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../network/response_status.dart';
import '../../models/stage_model.dart';




class StageRemoteDataSource{
  static const collectionStage = "stage";
  final int pageSize = 10;
  static DocumentSnapshot<Object?>? _lastDocument = null;


  Future<Map<String, dynamic>> createStage(StageModel stage) async {
    try {
      var stageCreate = await FirebaseFirestore.instance
          .collection(collectionStage)
          .add(stage.toMap());
      return {
        'status': ResponseStatus.response201Created,
        'data': stageCreate.id,
      };
    } catch (e) {
      return {
        'status': ResponseStatus.response500InternalServerError,
        'data': e.toString(),
      };
    }
  }

  static Future<StageModel?> getStage(int stage) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance
          .collection(collectionStage)
          .where('stage', isEqualTo: stage)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
            querySnapshot.docs.first;
        return StageModel.fromSnapshot(documentSnapshot);
      } else {
        return null;
      }
    } catch (e) {
      print('Error getting stage: $e');
      return null;
    }
  }

  Future<List<StageModel>> getAllExtraStage() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection(collectionStage)
          .where('isExtra', isEqualTo: true)
          .orderBy('stage')
          .get();
      return querySnapshot.docs
          .map((doc) => StageModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<StageModel>> getAllStage() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection(collectionStage)
          .where('isExtra', isEqualTo: false)
          .orderBy('stage')
          .get();
      return querySnapshot.docs
          .map((doc) => StageModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> deleteStage(String stageId) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionStage)
          .doc(stageId)
          .delete();
      return {
        'status': ResponseStatus.response204NoContent,
      };
    } catch (e) {
      return {
        'status': ResponseStatus.response500InternalServerError,
        'data': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> updateStage(String stageId, Map<String, dynamic> updatedData) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionStage)
          .doc(stageId)
          .update(updatedData);
      return {
        'status': ResponseStatus.response200Ok,
      };
    } catch (e) {
      return {
        'status': ResponseStatus.response500InternalServerError,
        'data': e.toString(),
      };
    }
  }


  Future<List<StageModel>> fetchStagesWithPagination({
    required int limit,
  }) async {
    try {
      Query<Map<String, dynamic>> query = FirebaseFirestore.instance
          .collection(collectionStage)
          .where('stage', isGreaterThan: 0)
          .orderBy('stage')
          .limit(limit);


      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();

      if(querySnapshot.size == 0){
        return [];
      }

      _lastDocument = querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;

      List<StageModel> stages = querySnapshot.docs
          .map((doc) => StageModel.fromSnapshot(doc))
          .toList();
      return stages;
    } catch (e) {
      print(e);
      return [];
    }
  }

  void clearData() {
    _lastDocument = null;
  }

  Future<StageModel?> getChallengeStage() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection(collectionStage)
        .where('stage', isEqualTo: 0)
        .limit(1) // Giới hạn chỉ lấy 1 document
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      return StageModel.fromSnapshot(querySnapshot.docs.first);
    }
    return null;
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../network/response_status.dart';
import '../../models/question_model.dart';

class QuestionRemoteDataSource {
  static const collectionQuestion = "question";

  Future<Map<String, dynamic>> createQuestion(QuestionModel question) async {
    try {
      var questionCreate = await FirebaseFirestore.instance
          .collection(collectionQuestion)
          .add(question.toMap());
      return {
        'status': ResponseStatus.response201Created,
        'data': questionCreate.id,
      };
    } catch (e) {
      return {
        'status': ResponseStatus.response500InternalServerError,
        'data': e.toString(),
      };
    }
  }

  Future<List<QuestionModel>> findQuestionsByStage(int stage) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection(collectionQuestion)
              .where('stage', isEqualTo: stage)
              .where('isExtra', isEqualTo: false)
              .orderBy('order')
              .get();
      return querySnapshot.docs
          .map((doc) => QuestionModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<List<QuestionModel>> findQuestionsByExtraStage(int stage) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection(collectionQuestion)
              .where('stage', isEqualTo: stage)
              .where('isExtra', isEqualTo: true)
              .orderBy('order')
              .get();
      return querySnapshot.docs
          .map((doc) => QuestionModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<Map<String, dynamic>> deleteQuestion(String questionId) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionQuestion)
          .doc(questionId)
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

  Future<Map<String, dynamic>> updateQuestion(
      String questionId, Map<String, dynamic> updatedData) async {
    try {
      await FirebaseFirestore.instance
          .collection(collectionQuestion)
          .doc(questionId)
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

  Future<Map<String, dynamic>> deleteQuestionsWithDuplicateOrder(
      int stage) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection(collectionQuestion)
              .where('stage', isEqualTo: stage)
              .get();

      // Group questions by order
      Map<int, List<QueryDocumentSnapshot<Map<String, dynamic>>>>
          groupedByOrder = {};

      print(querySnapshot.docs.length);

      for (var doc in querySnapshot.docs) {
        int order = doc['order'];
        if (groupedByOrder.containsKey(order)) {
          groupedByOrder[order]!.add(doc);
        } else {
          groupedByOrder[order] = [doc];
        }
      }

      // Find and delete duplicates
      for (var entry in groupedByOrder.entries) {
        if (entry.value.length > 1) {
          // If there are duplicates, delete all but one
          for (int i = 1; i < entry.value.length; i++) {
            await FirebaseFirestore.instance
                .collection(collectionQuestion)
                .doc(entry.value[i].id)
                .delete();
          }
        }
      }

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
}

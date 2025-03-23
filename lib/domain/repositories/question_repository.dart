import '../data/datasources/remote/question_remote_data_source.dart';
import '../data/models/question_model.dart';

class QuestionRepository {
  final QuestionRemoteDataSource remoteDataSource;

  QuestionRepository({
    required this.remoteDataSource,
  });

  Future<Map<String, dynamic>> createQuestion(QuestionModel question) async {
    return await remoteDataSource.createQuestion(question);
  }

  Future<List<QuestionModel>> findQuestionsByStage(int stage) async {
    return await remoteDataSource.findQuestionsByStage(stage);
  }

  Future<List<QuestionModel>> findQuestionsByExtraStage(int stage) async {
    return await remoteDataSource.findQuestionsByExtraStage(stage);
  }

  Future<Map<String, dynamic>> deleteQuestion(String questionId) async {
    return await remoteDataSource.deleteQuestion(questionId);
  }

  Future<Map<String, dynamic>> updateQuestion(
      String questionId, Map<String, dynamic> updatedData) async {
    return await remoteDataSource.updateQuestion(questionId, updatedData);
  }

  Future<Map<String, dynamic>> deleteQuestionsWithDuplicateOrder(
      int stage) async {
    return await remoteDataSource.deleteQuestionsWithDuplicateOrder(stage);
  }
}

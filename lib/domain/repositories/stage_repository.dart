
import '../data/datasources/remote/stage_remote_data_source.dart';
import '/domain/data/models/stage_model.dart';

class StageRepository {
  final StageRemoteDataSource remoteDataSource;

  StageRepository({
    required this.remoteDataSource,
  });

  Future<Map<String, dynamic>> createStage(StageModel stageModel) {
    return remoteDataSource.createStage(stageModel);
  }

  Future<StageModel?> getStage(int stage) {
    return StageRemoteDataSource.getStage(stage);
  }

  Future<List<StageModel>> getAllStages() {
    return remoteDataSource.getAllStage();
  }

  Future<List<StageModel>> getAllExtraStages() {
    return remoteDataSource.getAllExtraStage();
  }

  Future<Map<String, dynamic>> deleteStage(String stageId) {
    return remoteDataSource.deleteStage(stageId);
  }

  Future<Map<String, dynamic>> updateStage(String stageId, Map<String, dynamic> updatedData) {
    return remoteDataSource.updateStage(stageId, updatedData);
  }

  Future<List<StageModel>> fetchStagesWithPagination({required int limit}) {
    return remoteDataSource.fetchStagesWithPagination(limit: limit);
  }

  void clearData() {
    remoteDataSource.clearData();
  }

  Future<StageModel?> getChallengeStage() {
    return remoteDataSource.getChallengeStage();
  }
}

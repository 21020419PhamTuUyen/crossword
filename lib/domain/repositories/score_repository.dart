import '../data/datasources/remote/score_remote_data_source.dart';
import '/domain/data/models/score_model.dart';
import '/domain/data/models/user_model.dart';

class ScoreRepository {
  final ScoreRemoteDataSource remoteDataSource;

  ScoreRepository({
    required this.remoteDataSource,
  });

  Future<Map<String, dynamic>> createScore(UserModel score) {
    return remoteDataSource.createScore(score);
  }

  Future<Map<String, dynamic>> updateScore(UserModel user) {
    return remoteDataSource.updateScore(user);
  }

  Future<List<ScoreModel>> getAllScoresSortedByScore() {
    return remoteDataSource.getAllScoresSortedByScore();
  }
}

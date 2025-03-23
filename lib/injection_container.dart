import 'package:crossword/blocs/score_cubit.dart';
import 'package:crossword/domain/data/datasources/remote/score_remote_data_source.dart';
import 'package:crossword/domain/repositories/score_repository.dart';
import 'package:get_it/get_it.dart';

import 'blocs/game_cubit.dart';
import 'blocs/sound_cubit.dart';
import 'blocs/stage_cubit.dart';
import 'blocs/user_info_cubit.dart';
import 'domain/data/datasources/local/game_state_local_data_source.dart';
import 'domain/data/datasources/local/user_local_data_source.dart';
import 'domain/data/datasources/remote/auth_remote_data_source.dart';
import 'domain/data/datasources/remote/question_remote_data_source.dart';
import 'domain/data/datasources/remote/stage_remote_data_source.dart';
import 'domain/data/datasources/remote/user_remote_data_source.dart';
import 'domain/network/network_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/game_repository.dart';
import 'domain/repositories/question_repository.dart';
import 'domain/repositories/stage_repository.dart';
import 'domain/repositories/user_repository.dart';

final getIt = GetIt.instance;

Future<void> init({GetIt? getIt}) async {
  if (getIt == null) {
    getIt = GetIt.instance;
  }
  // network
  registerNetwork(getIt);
  // data source
  registerDataSource(getIt);
  // repositories
  registerRepositories(getIt);
  // bloc cubit
  registerCubit(getIt);
}

void registerCubit(GetIt getIt) {
  getIt.registerLazySingleton(
    () => UserInfoCubit(repository: getIt.get<UserRepositoryImpl>()),
  );

  getIt.registerLazySingleton(
    () => StageCubit(repository: getIt.get<StageRepository>()),
  );

  getIt.registerLazySingleton(
      () => GameCubit(gameRepository: getIt.get<GameRepository>(), questionRepository: getIt.get<QuestionRepository>())
  );
  getIt.registerLazySingleton(
          () => SoundCubit()
  );
  getIt.registerLazySingleton(
          () => ScoreCubit(repository: getIt.get<ScoreRepository>())
  );
}

void registerRepositories(GetIt getIt) {
  getIt.registerLazySingleton(
    () => AuthRepository(remoteDataSource: getIt.get()),
  );
  getIt.registerLazySingleton(
    () => UserRepositoryImpl(
      userLocalDataSource: getIt.get(),
      userRemoteDataSource: getIt.get(),
    ),
  );
  getIt.registerLazySingleton(
    () => StageRepository(
      remoteDataSource: getIt.get(),
    ),
  );

  getIt.registerLazySingleton(
        () => QuestionRepository(
      remoteDataSource: getIt.get(),
    ),
  );
  getIt.registerLazySingleton(
      () => GameRepository(localDataSource: getIt.get()));
  getIt.registerLazySingleton(
          () => ScoreRepository(remoteDataSource: getIt.get()));
}

void registerDataSource(GetIt getIt) {
  getIt.registerLazySingleton(() => AuthRemoteDataSource());
  getIt.registerLazySingleton(() => UserLocalDataSource());
  getIt.registerLazySingleton(() => UserRemoteDataSource());
  getIt.registerLazySingleton(() => StageRemoteDataSource());
  getIt.registerLazySingleton(() => QuestionRemoteDataSource());
  getIt.registerLazySingleton(() => GameStateLocalDataSource());
  getIt.registerLazySingleton(() => ScoreRemoteDataSource());
}

void registerNetwork(GetIt getIt) {
  getIt.registerLazySingleton(() => Network.instance());
}

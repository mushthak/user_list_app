import 'package:get_it/get_it.dart';
import 'features/user_list/data/datasources/user_local_data_source.dart';
import 'features/user_list/data/repositories/user_repository_impl.dart';
import 'features/user_list/domain/repositories/user_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Data sources
  final localDataSource = UserLocalDataSourceImpl();
  await localDataSource.init();
  sl.registerLazySingleton<UserLocalDataSource>(() => localDataSource);

  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(localDataSource: sl()),
  );
}

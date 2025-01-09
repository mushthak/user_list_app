import 'package:get_it/get_it.dart';
import 'core/config/environment.dart';
import 'features/user_list/data/datasources/user_local_data_source.dart';
import 'features/user_list/data/repositories/user_repository_impl.dart';
import 'features/user_list/domain/repositories/user_repository.dart';
import 'features/user_list/domain/usecases/add_user.dart';
import 'features/user_list/domain/usecases/delete_user.dart';
import 'features/user_list/domain/usecases/get_users.dart';
import 'features/user_list/presentation/controllers/user_list_controller.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - User List
  await _initUserFeature();

  // Core
  _initCore();
}

Future<void> _initUserFeature() async {
  // Controllers
  sl.registerFactory(
    () => UserListController(
      getUsers: sl(),
      addUser: sl(),
      deleteUser: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetUsers(sl()));
  sl.registerLazySingleton(() => AddUser(sl()));
  sl.registerLazySingleton(() => DeleteUser(sl()));

  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(localDataSource: sl()),
  );

  // Data Sources
  final dataSource = UserLocalDataSourceImpl();
  await dataSource.init();
  sl.registerLazySingleton<UserLocalDataSource>(() => dataSource);
}

void _initCore() {
  sl.registerLazySingleton(() => AppConfig.getConfig());
}

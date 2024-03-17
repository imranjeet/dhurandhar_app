import 'package:dhurandhar/services/shared_preference_manager_telemed.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => SharedPreferenceManager());
}

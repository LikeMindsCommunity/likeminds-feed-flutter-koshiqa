import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.I;

void setupLocator() {
  locator.registerLazySingleton(() => LikeMindsService());
}

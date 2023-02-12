import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:get_it/get_it.dart';
import 'package:likeminds_feed/likeminds_feed.dart';

GetIt locator = GetIt.I;

void setupLocator(LMSdkCallback callback) {
  locator.registerLazySingleton(() => LikeMindsService(callback));
}

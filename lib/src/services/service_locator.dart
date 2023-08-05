export 'package:feed_sx/src/navigation/navigation_service.dart';
import 'package:feed_sx/feed.dart';
import 'package:get_it/get_it.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:likeminds_feed/likeminds_feed.dart';

final GetIt locator = GetIt.I;

void _setupLocator(LMSDKCallback callback, String apiKey) {
  locator.allowReassignment = true;
  if (!locator.isRegistered<LikeMindsService>()) {
    locator.registerSingleton(LikeMindsService(callback, apiKey));
  }
  if (!locator.isRegistered<NavigationService>()) {
    locator.registerSingleton(NavigationService());
  }
}

void setupLMFeed(LMSDKCallback callback, String apiKey) {
  _setupLocator(callback, apiKey);
}

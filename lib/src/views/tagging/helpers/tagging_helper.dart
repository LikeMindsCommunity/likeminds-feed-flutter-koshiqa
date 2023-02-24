import 'package:collection/collection.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:feed_sx/src/services/service_locator.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:overlay_support/overlay_support.dart';

class TaggingHelper {
  static final RegExp tagRegExp = RegExp(r'@([a-z\sA-Z]+)~');

  static String encodeString(String string, List<UserTag> userTags) {
    final Iterable<RegExpMatch> matches = tagRegExp.allMatches(string);
    for (final match in matches) {
      final String tag = match.group(1)!;
      final UserTag? userTag =
          userTags.firstWhereOrNull((element) => element.name! == tag);
      if (userTag != null) {
        string = string.replaceAll('@$tag~',
            '<<${userTag.name}|route://member/${userTag.userUniqueId}>>');
      }
    }
    return string;
  }

  static Map<String, String> decodeString(String string) {
    Map<String, String> result = {};
    final Iterable<RegExpMatch> matches =
        RegExp(r'<<([a-z\sA-Z]+)\|route://member/([a-zA-Z-0-9]+)>>')
            .allMatches(string);
    for (final match in matches) {
      final String tag = match.group(1)!;
      final String id = match.group(2)!;
      string = string.replaceAll('<<$tag|route://member/$id>>', '@$tag');
      result.addAll({string: id});
    }
    return result;
  }

  static List<UserTag> matchTags(String text, List<UserTag> items) {
    final List<UserTag> tags = [];
    final Iterable<RegExpMatch> matches = tagRegExp.allMatches(text);
    for (final match in matches) {
      final String tag = match.group(1)!;
      final UserTag? userTag =
          items.firstWhereOrNull((element) => element.name! == tag);
      if (userTag != null) {
        tags.add(userTag);
      }
    }
    return tags;
  }

  static void routeToProfile(String userId) {
    print(userId);
    if (!locator<LikeMindsService>().isProd) {
      toast('Profile call back fired');
      locator<LikeMindsService>().routeToProfile(userId);
    }
  }
}

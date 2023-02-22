import 'package:collection/collection.dart';
import 'package:likeminds_feed/likeminds_feed.dart';

class TaggingHelper {
  static final RegExp tagRegExp = RegExp(r'@([a-z\sA-Z]+)~');

  static String encodeString(String string, List<UserTag> userTags) {
    final Iterable<RegExpMatch> matches = tagRegExp.allMatches(string);
    for (final match in matches) {
      final String tag = match.group(1)!;
      final UserTag? userTag =
          userTags.firstWhereOrNull((element) => element.name! == tag);
      if (userTag != null) {
        string = string.replaceAll(
            '@$tag~', '<<${userTag.name}|route://member/${userTag.id}>>');
      }
    }
    return string;
  }

  static String decodeString(String string) {
    final Iterable<RegExpMatch> matches =
        RegExp(r'<<([a-z\sA-Z]+)\|route://member/([0-9]+)>>')
            .allMatches(string);
    for (final match in matches) {
      final String tag = match.group(1)!;
      final String id = match.group(2)!;
      string = string.replaceAll('<<$tag|route://member/$id>>', '@$tag');
    }
    return string;
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

  static void routeToProfile(dynamic d) {
    print(d);
  }
}

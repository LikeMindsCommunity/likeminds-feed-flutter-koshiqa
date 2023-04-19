import 'package:collection/collection.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:feed_sx/src/services/service_locator.dart';
import 'package:likeminds_feed/likeminds_feed.dart';

class TaggingHelper {
  static final RegExp tagRegExp = RegExp(r'@([a-z\sA-Z]+)~');

  /// Encodes the string with the user tags and returns the encoded string
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

  /// Decodes the string with the user tags and returns the decoded string
  static Map<String, String> decodeString(String string) {
    Map<String, String> result = {};
    final Iterable<RegExpMatch> matches =
        RegExp(r'<<([a-z\sA-Z]+)\|route://member/([a-zA-Z-0-9]+)>>')
            .allMatches(string);
    for (final match in matches) {
      final String tag = match.group(1)!;
      final String id = match.group(2)!;
      string = string.replaceAll('<<$tag|route://member/$id>>', '@$tag~');
      result.addAll({'@$tag': id});
    }
    return result;
  }

  /// Matches the tags in the string and returns the list of matched tags
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
    // if (!locator<LikeMindsService>().isProd) {
    //   toast('Profile call back fired');
    // }
    locator<LikeMindsService>().routeToProfile(userId);
  }

  static String convertRouteToTag(String text, {bool withTilde = true}) {
    final Iterable<RegExpMatch> matches =
        RegExp(r'<<([a-z\sA-Z]+)\|route://member/([a-zA-Z-0-9]+)>>')
            .allMatches(text);

    for (final match in matches) {
      final String tag = match.group(1)!;
      final String id = match.group(2)!;
      text = text.replaceAll('<<$tag|route://member/$id>>', '@$tag~');
    }
    return text;
  }

  static Map<String, dynamic> convertRouteToTagAndUserMap(String text,
      {bool withTilde = true}) {
    final Iterable<RegExpMatch> matches =
        RegExp(r'<<([a-z\sA-Z]+)\|route://member/([a-zA-Z-0-9]+)>>')
            .allMatches(text);
    List<UserTag> userTags = [];
    for (final match in matches) {
      final String tag = match.group(1)!;
      final String id = match.group(2)!;
      text = text.replaceAll('<<$tag|route://member/$id>>', '@$tag~');
      userTags.add(UserTag(userUniqueId: id, name: tag));
    }
    return {'text': text, 'userTags': userTags};
  }

  static List<UserTag> addUserTagsIfMatched(String input) {
    final Iterable<RegExpMatch> matches =
        RegExp(r'<<([a-z\sA-Z]+)\|route://member/([a-zA-Z-0-9]+)>>')
            .allMatches(input);
    List<UserTag> userTags = [];
    for (final match in matches) {
      final String tag = match.group(1)!;
      final String id = match.group(2)!;
      userTags.add(UserTag(userUniqueId: id, name: tag));
    }
    return userTags;
  }
}

List<String> extractLinkFromString(String text) {
  RegExp exp = RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
  Iterable<RegExpMatch> matches = exp.allMatches(text);
  List<String> links = [];
  matches.forEach((match) {
    String link = text.substring(match.start, match.end);
    if (link.isNotEmpty) {
      links.add(link);
    }
  });
  if (links.isNotEmpty) {
    return links;
  } else {
    return [];
  }
}

String getFirstValidLinkFromString(String text) {
  try {
    List<String> links = extractLinkFromString(text);
    List<String> validLinks = [];
    String validLink = '';
    if (links.isNotEmpty) {
      for (String link in links) {
        if (Uri.parse(link).isAbsolute) {
          validLinks.add(link);
        } else {
          link = "https://$link";
          if (Uri.parse(link).isAbsolute) {
            validLinks.add(link);
          }
        }
      }
    }
    if (validLinks.isNotEmpty) {
      validLink = validLinks.first;
    }
    return validLink;
  } catch (e) {
    return '';
  }
}

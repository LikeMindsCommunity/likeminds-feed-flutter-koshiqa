import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:share_plus/share_plus.dart';

import 'package:feed_sx/src/utils/local_preference/user_local_preference.dart';

part 'deep_link_request.dart';
part 'deep_link_response.dart';

class SharePost {
  // fetches the domain given by client at time of initialization of Feed

  // below function creates a link from domain and post id
  String createLink(String postId) {
    final String domain = UserLocalPreference.instance.getAppDomain();
    int length = domain.length;
    if (domain[length - 1] == '/') {
      return "$domain/post?post_id=$postId";
    } else {
      return "$domain/post?post_id=$postId";
    }
  }

  // Below functions takes the user outside of the application
  // using the domain provided at the time of initialization
  // TODO: Add prefix text, image as per your requirements
  void sharePost(String postId) {
    String postUrl = createLink(postId);
    Share.share(postUrl);
  }

  String getFirstPathSegment(String url) {
    final uri = Uri.parse(url);
    final pathSegments = uri.pathSegments;
    if (pathSegments.isNotEmpty) {
      return pathSegments.first;
    } else {
      return '';
    }
  }

  Future<DeepLinkResponse> handlePostDeepLink(DeepLinkRequest request) async {
    List secondPathSegment = request.link.split('post_id=');
    if (secondPathSegment.length > 1 && secondPathSegment[1] != null) {
      String postId = secondPathSegment[1];
      // setupLMFeed(request.callback, request.apiKey);
      // InitiateUserResponse initiateUserResponse =
      //     await locator<LikeMindsService>()
      //         .initiateUser((InitiateUserRequestBuilder()
      //               ..userId(request.userUniqueId)
      //               ..userName(request.userName))
      //             .build());
      // if (!initiateUserResponse.success) {
      //   return DeepLinkResponse(
      //     success: false,
      //     errorMessage: "URI parsing failed. Please try after some time.",
      //   );
      // }
      // locator<NavigationService>().navigateTo(
      //   AllCommentsScreen.route,
      //   arguments: AllCommentsScreenArguments(
      //       postId: postId, feedRoomId: request.feedRoomId),
      // );
      return DeepLinkResponse(
        success: true,
        postId: postId,
      );
    } else {
      return DeepLinkResponse(
        success: false,
        errorMessage: 'URI not supported',
      );
    }
  }

  Future<DeepLinkResponse> parseDeepLink(DeepLinkRequest request) async {
    if (Uri.parse(request.link).isAbsolute) {
      final firstPathSegment = getFirstPathSegment(request.link);
      if (firstPathSegment == "post") {
        return handlePostDeepLink(request);
      }
      return DeepLinkResponse(
          success: false, errorMessage: 'URI not supported');
    } else {
      return DeepLinkResponse(
        success: false,
        errorMessage: 'URI not supported',
      );
    }
  }
}
import 'package:feed_sx/feed.dart';
import 'package:feed_sx/src/navigation/arguments.dart';
import 'package:feed_sx/src/services/likeminds_service.dart';
import 'package:feed_sx/src/utils/local_preference/user_local_preference.dart';
import 'package:likeminds_feed/likeminds_feed.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:share_plus/share_plus.dart';

part 'deep_link_request.dart';
part 'deep_link_response.dart';

class SharePost {
  // fetches the domain given by client at time of initialization of Feed

  // below function creates a link from domain and post id
  String createLink(String postId) {
    final String domain = UserLocalPreference.instance.getAppDomain();
    int length = domain.length;
    if (domain[length - 1] == '/') {
      return "https://${domain}post?post_id=$postId";
    } else {
      return "https://$domain/post?post_id=$postId";
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

      final GetPostResponse postDetails =
          await locator<LikeMindsService>().getPost(
        (GetPostRequestBuilder()
              ..postId(postId)
              ..page(1)
              ..pageSize(10))
            .build(),
      );
      if (postDetails.success) {
        locator<NavigationService>().navigateTo(
          AllCommentsScreen.route,
          arguments: AllCommentsScreenArguments(
            post: postDetails.post!,
            feedroomId: locator<LikeMindsService>().feedroomId ?? 0,
          ),
        );
        return DeepLinkResponse(success: true);
      } else {
        toast(postDetails.errorMessage!);
        return DeepLinkResponse(
            success: false,
            errorMessage: "URI parsing failed. Please try after some time.");
      }
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

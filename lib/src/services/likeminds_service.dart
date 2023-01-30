import 'package:feed_sdk/feed_sdk.dart';

abstract class ILikeMindsService {
  Future<InitiateUserResponse> initiateUser(InitiateUserRequest request);
  Future<UniversalFeedResponse> getUniversalFeed(UniversalFeedRequest request);
  Future<AddPostResponse> addPost(AddPostRequest request);
  Future<GetPostResponse> getPost(GetPostRequest request);
  Future<GetPostLikesResponse> getPostLikes(GetPostLikesRequest request);
  Future<DeletePostResponse> deletePost(DeletePostRequest request);
  Future<LikePostResponse> likePost(LikePostRequest request);
}

class LikeMindsService implements ILikeMindsService {
  late final SdkApplication _sdkApplication;
  final String apiKey = "bad53fff-c85a-4098-b011-ac36703cc98b";

  LikeMindsService() {
    _sdkApplication = LikeMindsFeedSDK.initiateLikeMinds(apiKey);
  }

  @override
  Future<InitiateUserResponse> initiateUser(InitiateUserRequest request) async {
    return await _sdkApplication.getAuthApi().initiateUser(request);
  }

  @override
  Future<UniversalFeedResponse> getUniversalFeed(
      UniversalFeedRequest request) async {
    return await _sdkApplication.getFeedApi().getUniversalFeed(request);
  }

  @override
  Future<AddPostResponse> addPost(AddPostRequest request) async {
    return await _sdkApplication.getPostApi().addPost(request);
  }

  @override
  Future<DeletePostResponse> deletePost(DeletePostRequest request) async {
    return await _sdkApplication.getPostApi().deletePost(request);
  }

  @override
  Future<GetPostResponse> getPost(GetPostRequest request) async {
    return await _sdkApplication.getPostApi().getPost(request);
  }

  @override
  Future<GetPostLikesResponse> getPostLikes(GetPostLikesRequest request) async {
    return await _sdkApplication.getPostApi().getPostLikes(request);
  }

  @override
  Future<LikePostResponse> likePost(LikePostRequest likePostRequest) async {
    return await _sdkApplication.getPostApi().likePost(likePostRequest);
  }
}

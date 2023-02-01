import 'dart:io';

import 'package:feed_sdk/feed_sdk.dart';
import 'package:feed_sx/src/services/credential_service.dart';

abstract class ILikeMindsService {
  FeedApi getFeedApi();
  Future<InitiateUserResponse> initiateUser(InitiateUserRequest request);
  Future<bool> getMemberState();
  Future<UniversalFeedResponse?> getUniversalFeed(UniversalFeedRequest request);
  Future<GetFeedRoomResponse> getFeedRoom(GetFeedRoomRequest request);
  Future<GetFeedOfFeedRoomResponse> getFeedOfFeedRoom(
      GetFeedOfFeedRoomRequest request);
  Future<AddPostResponse> addPost(AddPostRequest request);
  Future<GetPostResponse> getPost(GetPostRequest request);
  Future<GetPostLikesResponse> getPostLikes(GetPostLikesRequest request);
  Future<DeletePostResponse> deletePost(DeletePostRequest request);
  Future<LikePostResponse> likePost(LikePostRequest request);
  Future<String?> uploadFile(File file);
}

class LikeMindsService implements ILikeMindsService {
  late final SdkApplication _sdkApplication;
  final String apiKey = "bad53fff-c85a-4098-b011-ac36703cc98b";

  LikeMindsService() {
    _sdkApplication = LMClient.initiateLikeMinds(apiKey);
  }

  @override
  Future<InitiateUserResponse> initiateUser(InitiateUserRequest request) async {
    return await _sdkApplication.getAuthApi().initiateUser(request);
  }

  @override
  FeedApi getFeedApi() {
    return _sdkApplication.getFeedApi();
  }

  @override
  Future<UniversalFeedResponse?> getUniversalFeed(
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

  @override
  Future<String?> uploadFile(File file) async {
    return await _sdkApplication.getMediaApi().uploadFile(file);
  }

  @override
  Future<GetFeedOfFeedRoomResponse> getFeedOfFeedRoom(
      GetFeedOfFeedRoomRequest request) async {
    return await _sdkApplication.getFeedApi().getFeedOfFeedRoom(request);
  }

  @override
  Future<GetFeedRoomResponse> getFeedRoom(GetFeedRoomRequest request) async {
    return await _sdkApplication.getFeedApi().getFeedRoom(request);
  }

  @override
  Future<bool> getMemberState() async {
    return await _sdkApplication.getAccessApi().getMemberState();
  }
}

import 'package:feed_sdk/feed_sdk.dart';

abstract class ILikeMindsService {
  Future<InitiateUserResponse> initiateUser(InitiateUserRequest request);
  Future<AddPostResponse> addPost(AddPostRequest request);
  Future<bool> getMemberState();
}

class LikeMindsService implements ILikeMindsService {
  late SdkApplication _sdkApplication;
  final String apiKey = "bad53fff-c85a-4098-b011-ac36703cc98b";

  LikeMindsService() {
    final SdkApplication sdk = LMClient.initiateLikeMinds(apiKey);
  }

  @override
  Future<InitiateUserResponse> initiateUser(InitiateUserRequest request) async {
    return await _sdkApplication.getAuthApi().initiateUser(request);
  }

  @override
  Future<AddPostResponse> addPost(AddPostRequest request) {
    return _sdkApplication.getPostApi().addPost(request);
  }

  @override
  Future<bool> getMemberState() {
    return _sdkApplication.getAccessApi().getMemberState();
  }
}

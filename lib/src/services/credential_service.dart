class CredentialService {
  String apiKey;
  String? userId;
  String? communityId;

  CredentialService({required this.apiKey, this.userId, this.communityId});

  String get getApiKey => apiKey;
  String get getUserId => userId!;
  String get getCommunityId => communityId!;

  static set setUserId(String userId) {
    userId = userId;
  }

  static set setCommunityId(String communityId) {
    communityId = communityId;
  }

  static set setApiKey(String apiKey) {
    apiKey = apiKey;
  }
}

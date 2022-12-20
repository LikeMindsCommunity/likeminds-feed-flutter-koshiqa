// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:feed_sx/src/data/local/local_db.dart';
import 'package:feed_sx/src/data/models/branding.dart';
import 'package:feed_sx/src/sdk/mock_sdk.dart';

class MockRepository {
  final MockSDK _mockSDK;
  final LocalDB _localDB;
  MockRepository({
    required MockSDK mockSDK,
    required LocalDB localDB,
  })  : _mockSDK = mockSDK,
        _localDB = localDB;
  Future<Branding?> getCommunityBranding(String communityId) async {
    await Future.delayed(Duration(seconds: 1));
    Branding? branding;
    try {
      branding = await _mockSDK.getBrandingData();
    } catch (e) {
      //TODO
    }
    if (branding != null) {
      _localDB.saveBranding(branding: branding.toEntity());
    } else {
      BrandingEntity? brandingEntity = await _localDB.getSavedBranding();
      if (brandingEntity != null) {
        branding = Branding.fromEntity(brandingEntity);
      }
    }

    return branding;
  }
}

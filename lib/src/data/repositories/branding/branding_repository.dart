// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:feed_sx/src/data/local_db/local_db.dart';
import 'package:feed_sx/src/data/models/branding/branding.dart';
import 'package:feed_sx/src/sdk/branding_sdk.dart';

class BrandingRepository {
  final BrandingSDK _mockSDK;
  final LocalDB _localDB;
  BrandingRepository({
    required BrandingSDK mockSDK,
    required LocalDB localDB,
  })  : _mockSDK = mockSDK,
        _localDB = localDB;
  Future<Branding?> getCommunityBranding(String communityId) async {
    Branding? branding;
    BrandingEntity? brandingEntity = await _localDB.getSavedBranding();
    if (brandingEntity != null) {
      branding = Branding.fromEntity(brandingEntity);
    }

    updateCommunityBranding(communityId);
    if (branding == null) return Branding();
    return branding;
  }

  Future<Branding?> updateCommunityBranding(String communityId) async {
    Branding? branding;
    branding = await _mockSDK.getBrandingData();
    if (branding != null) {
      await _localDB.saveBranding(branding: branding.toEntity());
    }
    return branding;
  }
}

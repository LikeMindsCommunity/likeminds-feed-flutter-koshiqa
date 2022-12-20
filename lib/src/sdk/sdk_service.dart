// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:feed_sx/src/data/local/local_db.dart';
import 'package:feed_sx/src/data/models/branding.dart';
import 'package:feed_sx/src/data/repositories/mock_repository.dart';

class SDKService {
  final MockRepository repository;
  final LocalDB localDB;
  SDKService({
    required this.repository,
    required this.localDB,
  });
  Future<Branding?> getCommunityBranding(String communityId) async {
    await Future.delayed(Duration(seconds: 1));
    Branding? branding;
    try {
      branding = await repository.getBrandingData();
    } catch (e) {
      //TODO
    }
    if (branding != null) {
      localDB.saveBranding(branding: branding.toEntity());
    } else {
      BrandingEntity? brandingEntity = await localDB.getSavedBranding();
      if (brandingEntity != null) {
        branding = Branding.fromEntity(brandingEntity);
      }
    }

    return branding;
  }
}

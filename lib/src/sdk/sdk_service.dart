// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:feed_sx/src/data/local_db_service.dart';
import 'package:feed_sx/src/data/mock_repository.dart';
import 'package:feed_sx/src/models/branding.dart';

class SDKService {
  final MockRepository repository;
  final LocalDBService localDBService;
  SDKService({
    required this.repository,
    required this.localDBService,
  });
  Future<Branding?> getCommunityBranding(String communityId) async {
    await Future.delayed(Duration(seconds: 1));
    Branding? branding;
    try {
      branding = await repository.getBrandingData();
    } catch (e) {
      print('Error (Community Branding): ' + e.toString());
    }
    if (branding != null) {
      localDBService.saveBranding(branding: branding.toEntity());
    } else {
      BrandingEntity? brandingEntity = await localDBService.getSavedBranding();
      if (brandingEntity != null) {
        branding = Branding.fromEntity(brandingEntity);
      }
    }

    return branding;
  }
}

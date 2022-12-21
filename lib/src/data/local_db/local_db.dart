import 'package:feed_sx/src/data/models/branding/branding.dart';

abstract class LocalDB {
  Future<BrandingEntity?> getSavedBranding();
  Future<void> saveBranding({required BrandingEntity branding});
}

import 'package:feed_sx/src/models/advanced_branding.dart';
import 'package:feed_sx/src/models/basic_branding.dart';
import 'package:feed_sx/src/models/branding.dart';
import 'package:hive_flutter/hive_flutter.dart';

class LocalDBService {
  static const getItInstanceName = "local_db_service";
  final String brandingBoxKey = 'branding_box';
  final String brandingKey = 'branding_box';

  static Future<LocalDBService> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter<BrandingBasicEntity>(BrandingBasicEntityAdapter(),
        override: true);
    Hive.registerAdapter<BrandingAdvancedEntity>(
        BrandingAdvancedEntityAdapter(),
        override: true);
    Hive.registerAdapter<BrandingEntity>(BrandingEntityAdapter(),
        override: true);

    return LocalDBService();
  }

  Future<BrandingEntity?> getSavedBranding() async {
    var brandingBox = await Hive.openBox(brandingBoxKey);
    BrandingEntity? branding;
    if (brandingBox.containsKey(brandingKey)) {
      branding = brandingBox.get(brandingKey);
    }

    return branding;
  }

  Future<void> saveBranding({required BrandingEntity branding}) async {
    var brandingBox = await Hive.openBox(brandingBoxKey);
    if (brandingBox.containsKey(brandingKey)) {
      await brandingBox.delete(brandingKey);
    }

    await brandingBox.put(0, branding);
  }
}

import 'package:feed_sx/src/data/local_db/local_db.dart';
import 'package:feed_sx/src/data/models/branding/branding_advanced.dart';
import 'package:feed_sx/src/data/models/branding/branding_basic.dart';
import 'package:feed_sx/src/data/models/branding/branding.dart';

import 'package:hive_flutter/hive_flutter.dart';

class LocalDBImpl extends LocalDB {
  static const getItInstanceName = "local_db_service";
  final String brandingBoxKey = 'branding_box';
  final String brandingKey = 'branding_key';

  static Future<LocalDBImpl> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter<BrandingBasicEntity>(BrandingBasicEntityAdapter(),
        override: true);
    Hive.registerAdapter<BrandingAdvancedEntity>(
        BrandingAdvancedEntityAdapter(),
        override: true);
    Hive.registerAdapter<BrandingEntity>(BrandingEntityAdapter(),
        override: true);

    return LocalDBImpl();
  }

  @override
  Future<BrandingEntity?> getSavedBranding() async {
    var brandingBox = await Hive.openBox(brandingBoxKey);
    BrandingEntity? branding;
    if (brandingBox.containsKey(brandingKey)) {
      branding = brandingBox.get(brandingKey);
    }

    return branding;
  }

  @override
  Future<void> saveBranding({required BrandingEntity branding}) async {
    var brandingBox = await Hive.openBox(brandingBoxKey);
    if (brandingBox.containsKey(brandingKey)) {
      await brandingBox.delete(brandingKey);
    }

    await brandingBox.put(brandingKey, branding);
  }
}

import 'package:feed_sx/src/data/models/branding.dart';

class MockRepository {
  Future<Branding> getBrandingData() async {
    Map<String, dynamic> mockData = {
      'branding': {
        'basic': {'primary_colour': '0x00ffffff'},
        'advanced': {
          'header_colour': '0x00ffffff',
          'button_icons_colour': '0x00ffffff',
          'text_links_colour': '0x00ffffff',
        },
      }
    };
    BrandingEntity brandingEntity =
        BrandingEntity.fromJson(mockData['branding']);
    return Branding.fromEntity(brandingEntity);
  }
}

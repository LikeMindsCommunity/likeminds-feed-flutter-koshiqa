import 'package:feed_sx/src/data/models/branding.dart';

class MockSDK {
  Future<Branding> getBrandingData() async {
    Map<String, dynamic> mockData = {
      'branding': {
        'basic': {'primary_colour': '0x00ffffff'},
        'advanced': {
          'header_colour': '0x009B9B9B',
          'button_icons_colour': '0x009B9B9B',
          'text_links_colour': '0x009B9B9B',
        },
      }
    };
    BrandingEntity brandingEntity =
        BrandingEntity.fromJson(mockData['branding']);
    return Branding.fromEntity(brandingEntity);
  }
}

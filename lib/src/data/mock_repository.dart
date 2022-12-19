import 'package:feed_sx/src/models/branding.dart';

class MockRepository {
  Future<Branding> getBrandingData() async {
    Map<String, dynamic> mockData = {
      'branding': {
        'basic': {'primary_colour': '#ffffff'},
        'advanced': {
          'header_colour': '#ffffff',
          'buttons_icons_colour': '#ffffff',
          'text_links_colour': '#ffffff',
        },
      }
    };
    BrandingEntity brandingEntity = BrandingEntity.fromJson(mockData);
    return Branding.fromEntity(brandingEntity);
  }
}

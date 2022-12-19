import 'dart:ui';

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:feed_sx/src/utils/utils.dart';
part 'basic_branding.g.dart';

class BrandingBasic {
  final Color? primaryColor;
  BrandingBasic({this.primaryColor});
  factory BrandingBasic.fromEntity(BrandingBasicEntity entity) {
    return BrandingBasic(primaryColor: entity.primaryColor?.toColor());
  }
  BrandingBasicEntity toEntity() {
    return BrandingBasicEntity(primaryColor: primaryColor?.value.toString());
  }
  // Color? getPrimaryColor() {
  //   if (primaryColor != null) {
  //     if (int.tryParse(primaryColor!) != null) {
  //       return Color(int.tryParse(primaryColor!)!);
  //     } else {
  //       return kprimaryColor;
  //     }
  //   }
  //   return kprimaryColor;
  // }
}

@HiveType(typeId: 2)
@JsonSerializable()
class BrandingBasicEntity extends HiveObject {
  @HiveField(0)
  @JsonKey(name: 'primary_colour')
  final String? primaryColor;
  BrandingBasicEntity({this.primaryColor});
  Map<String, dynamic> toJson() => _$BrandingBasicEntityToJson(this);
  factory BrandingBasicEntity.fromJson(Map<String, dynamic> data) =>
      _$BrandingBasicEntityFromJson(data);
}

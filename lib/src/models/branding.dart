import 'package:feed_sx/src/models/advanced_branding.dart';
import 'package:feed_sx/src/models/basic_branding.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'branding.g.dart';

class Branding {
  final BrandingBasic? basic;

  final BrandingAdvanced? advanced;

  Branding({this.basic, this.advanced});
  factory Branding.fromEntity(BrandingEntity entity) {
    return Branding(
        basic: entity.basic != null
            ? BrandingBasic.fromEntity(entity.basic!)
            : null,
        advanced: entity.advanced != null
            ? BrandingAdvanced.fromEntity(entity.advanced!)
            : null);
  }
  BrandingEntity toEntity() {
    return BrandingEntity(
        basic: basic?.toEntity(), advanced: advanced?.toEntity());
  }
}

@HiveType(typeId: 1)
@JsonSerializable(explicitToJson: true)
class BrandingEntity extends HiveObject {
  @HiveField(0)
  final BrandingBasicEntity? basic;
  @HiveField(1)
  final BrandingAdvancedEntity? advanced;

  BrandingEntity({this.basic, this.advanced});

  Map<String, dynamic> toJson() => _$BrandingEntityToJson(this);
  factory BrandingEntity.fromJson(Map<String, dynamic> data) =>
      _$BrandingEntityFromJson(data);
}

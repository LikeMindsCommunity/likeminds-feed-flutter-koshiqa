// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:feed_sx/src/data/models/branding/branding_advanced.dart';
import 'package:feed_sx/src/data/models/branding/branding_basic.dart';

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

  @override
  String toString() => 'Branding(basic: $basic, advanced: $advanced)';
}

@HiveType(typeId: 1)
@JsonSerializable(explicitToJson: true)
class BrandingEntity extends HiveObject {
  @JsonKey(name: 'basic')
  @HiveField(0)
  final BrandingBasicEntity? basic;

  @JsonKey(name: 'advanced')
  @HiveField(1)
  final BrandingAdvancedEntity? advanced;

  BrandingEntity({this.basic, this.advanced});

  Map<String, dynamic> toJson() => _$BrandingEntityToJson(this);
  factory BrandingEntity.fromJson(Map<String, dynamic> data) =>
      _$BrandingEntityFromJson(data);
}

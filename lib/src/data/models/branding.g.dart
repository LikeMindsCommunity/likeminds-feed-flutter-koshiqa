// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branding.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BrandingEntityAdapter extends TypeAdapter<BrandingEntity> {
  @override
  final int typeId = 1;

  @override
  BrandingEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BrandingEntity(
      basic: fields[0] as BrandingBasicEntity?,
      advanced: fields[1] as BrandingAdvancedEntity?,
    );
  }

  @override
  void write(BinaryWriter writer, BrandingEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.basic)
      ..writeByte(1)
      ..write(obj.advanced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrandingEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrandingEntity _$BrandingEntityFromJson(Map<String, dynamic> json) =>
    BrandingEntity(
      basic: json['basic'] == null
          ? null
          : BrandingBasicEntity.fromJson(json['basic'] as Map<String, dynamic>),
      advanced: json['advanced'] == null
          ? null
          : BrandingAdvancedEntity.fromJson(
              json['advanced'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$BrandingEntityToJson(BrandingEntity instance) =>
    <String, dynamic>{
      'basic': instance.basic?.toJson(),
      'advanced': instance.advanced?.toJson(),
    };

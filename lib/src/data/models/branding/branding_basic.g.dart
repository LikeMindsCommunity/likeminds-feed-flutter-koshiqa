// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branding_basic.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BrandingBasicEntityAdapter extends TypeAdapter<BrandingBasicEntity> {
  @override
  final int typeId = 2;

  @override
  BrandingBasicEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BrandingBasicEntity(
      primaryColor: fields[0] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BrandingBasicEntity obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.primaryColor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrandingBasicEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrandingBasicEntity _$BrandingBasicEntityFromJson(Map<String, dynamic> json) =>
    BrandingBasicEntity(
      primaryColor: json['primary_colour'] as String?,
    );

Map<String, dynamic> _$BrandingBasicEntityToJson(
        BrandingBasicEntity instance) =>
    <String, dynamic>{
      'primary_colour': instance.primaryColor,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'advanced_branding.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BrandingAdvancedEntityAdapter
    extends TypeAdapter<BrandingAdvancedEntity> {
  @override
  final int typeId = 3;

  @override
  BrandingAdvancedEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BrandingAdvancedEntity(
      headerColor: fields[0] as String?,
      buttonIconsColor: fields[1] as String?,
      textLinksColor: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BrandingAdvancedEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.headerColor)
      ..writeByte(1)
      ..write(obj.buttonIconsColor)
      ..writeByte(2)
      ..write(obj.textLinksColor);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrandingAdvancedEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrandingAdvancedEntity _$BrandingAdvancedEntityFromJson(
        Map<String, dynamic> json) =>
    BrandingAdvancedEntity(
      headerColor: json['header_colour'] as String?,
      buttonIconsColor: json['button_icons_colour'] as String?,
      textLinksColor: json['text_links_colur'] as String?,
    );

Map<String, dynamic> _$BrandingAdvancedEntityToJson(
        BrandingAdvancedEntity instance) =>
    <String, dynamic>{
      'header_colour': instance.headerColor,
      'button_icons_colour': instance.buttonIconsColor,
      'text_links_colur': instance.textLinksColor,
    };

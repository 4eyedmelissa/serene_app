// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_group.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SupportGroupAdapter extends TypeAdapter<SupportGroup> {
  @override
  final int typeId = 5;

  @override
  SupportGroup read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SupportGroup(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      memberCount: fields[3] as int,
      imageUrl: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SupportGroup obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.memberCount)
      ..writeByte(4)
      ..write(obj.imageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SupportGroupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

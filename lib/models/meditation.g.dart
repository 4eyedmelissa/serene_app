// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meditation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MeditationAdapter extends TypeAdapter<Meditation> {
  @override
  final int typeId = 3;

  @override
  Meditation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Meditation(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      durationMinutes: fields[3] as int,
      imageAsset: fields[4] as String?,
      audioAsset: fields[5] as String,
      tags: (fields[6] as List).cast<String>(),
      isFavorite: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Meditation obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.durationMinutes)
      ..writeByte(4)
      ..write(obj.imageAsset)
      ..writeByte(5)
      ..write(obj.audioAsset)
      ..writeByte(6)
      ..write(obj.tags)
      ..writeByte(7)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeditationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

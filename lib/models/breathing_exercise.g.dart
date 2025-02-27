// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'breathing_exercise.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BreathingExerciseAdapter extends TypeAdapter<BreathingExercise> {
  @override
  final int typeId = 0;

  @override
  BreathingExercise read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BreathingExercise(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      inhaleDuration: fields[3] as int,
      holdDuration: fields[4] as int,
      exhaleDuration: fields[5] as int,
      cycles: fields[6] as int,
      imageAsset: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BreathingExercise obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.inhaleDuration)
      ..writeByte(4)
      ..write(obj.holdDuration)
      ..writeByte(5)
      ..write(obj.exhaleDuration)
      ..writeByte(6)
      ..write(obj.cycles)
      ..writeByte(7)
      ..write(obj.imageAsset);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BreathingExerciseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

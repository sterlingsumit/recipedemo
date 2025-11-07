// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecipeHiveModelAdapter extends TypeAdapter<RecipeHiveModel> {
  @override
  final int typeId = 0;

  @override
  RecipeHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecipeHiveModel(
      id: fields[0] as int,
      title: fields[1] as String,
      image: fields[2] as String,
      readyInMinutes: fields[3] as int,
      aggregateLikes: fields[4] as int,
      description: fields[5] as String?,
      ingredients: (fields[6] as List?)?.cast<String>(),
      instructions: (fields[7] as List?)?.cast<String>(),
      servings: fields[8] as int?,
      rating: fields[9] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, RecipeHiveModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.readyInMinutes)
      ..writeByte(4)
      ..write(obj.aggregateLikes)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.ingredients)
      ..writeByte(7)
      ..write(obj.instructions)
      ..writeByte(8)
      ..write(obj.servings)
      ..writeByte(9)
      ..write(obj.rating);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecipeHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

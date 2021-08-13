import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Movie {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String director;
  @HiveField(3)
  final String imageUrl;

  const Movie({
    required this.id,
    required this.director,
    required this.imageUrl,
    required this.name,
  });

  Movie.copy(
    Movie copy, {
    String? id,
    String? director,
    String? name,
    String? imageUrl,
  }) : this(
          id: id ?? copy.id,
          director: director ?? copy.director,
          name: name ?? copy.name,
          imageUrl: imageUrl ?? copy.imageUrl,
        );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'director': director,
    };
  }

  factory Movie.fromJson(Map<String, dynamic> json, id) {
    return Movie(
      id: id,
      name: json['name'],
      director: json['director'],
      imageUrl: json['imageUrl'],
    );
  }
}

// Can be generated automatically
class MovieModelAdapter extends TypeAdapter<Movie> {
  @override
  final typeId = 0;

  @override
  Movie read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Movie(
      id: fields[0] as String,
      name: fields[1] as String,
      director: fields[2] as String,
      imageUrl: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Movie obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.director)
      ..writeByte(3)
      ..write(obj.imageUrl);
  }
}

import 'dart:convert';

import 'package:hive/hive.dart';
part 'source.g.dart';

@HiveType(typeId: 1)
class Source {
  Source(
      {this.name,
        this.id,
      });

  @HiveField(0)
  String? id;
  @HiveField(1)
  String? name;



  factory Source.fromRawJson(String str) =>
      Source.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Source.fromJson(Map<String, dynamic> json) => Source(
    name: json["name"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
  };
}
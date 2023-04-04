// To parse this JSON data, do
//
//     final dataModel = dataModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class DataModel {
  DataModel({
    required this.memes,
  });

  final List<Meme> memes;

  DataModel copyWith({
    List<Meme>? memes,
  }) =>
      DataModel(
        memes: memes ?? this.memes,
      );

  factory DataModel.fromJson(String str) => DataModel.fromMap(json.decode(str));

  String toJson() => json.encode(toJson());

  factory DataModel.fromMap(Map<String, dynamic> json) => DataModel(
    memes: List<Meme>.from(json["memes"].map((x) => Meme.fromJson(x))),
  );

  Map<String, dynamic> toMap() => {
    "memes": List<dynamic>.from(memes.map((x) => x.toJson())),
  };
}

class Meme {
  Meme({
    required this.id,
    required this.name,
    required this.url,
    required this.width,
    required this.height,
    required this.boxCount,
    required this.captions,
  });

  final String id;
  final String name;
  final String url;
  final int width;
  final int height;
  final int boxCount;
  final int captions;

  Meme copyWith({
    String? id,
    String? name,
    String? url,
    int? width,
    int? height,
    int? boxCount,
    int? captions,
  }) =>
      Meme(
        id: id ?? this.id,
        name: name ?? this.name,
        url: url ?? this.url,
        width: width ?? this.width,
        height: height ?? this.height,
        boxCount: boxCount ?? this.boxCount,
        captions: captions ?? this.captions,
      );

  factory Meme.fromJson(String str) => Meme.fromMap(json.decode(str));

  String toJson() => json.encode(toJson());

  factory Meme.fromMap(Map<String, dynamic> json) => Meme(
    id: json["id"],
    name: json["name"],
    url: json["url"],
    width: json["width"],
    height: json["height"],
    boxCount: json["box_count"],
    captions: json["captions"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "url": url,
    "width": width,
    "height": height,
    "box_count": boxCount,
    "captions": captions,
  };
}

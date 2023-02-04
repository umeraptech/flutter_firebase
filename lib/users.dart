import 'package:firebase_database/firebase_database.dart';

class Users {
  // final String id;
  final String name;
  final String comment;

  Users(this.name,this.comment);

  Users.fromJson(Map<dynamic, dynamic> json):
      // id = json['id'] as String,
      name = json['name'] as String,
      comment = json['comment'] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
    // 'id' : id,
    'name': name,
    'comment': comment,
  };

  Map<String,dynamic> toMap() => <String,dynamic>{
    'name': name,
    'comment': comment
  };


}
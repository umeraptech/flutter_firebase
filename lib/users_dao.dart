
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_firebase/users.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class UsersDao {
  final _databaseRef = FirebaseDatabase.instance.ref("users");



  void saveUsers(Users users) {
    _databaseRef.push().set(users.toJson());
  }

  Query getMessageQuery() {

    if(!kIsWeb){
      FirebaseDatabase.instance.setPersistenceEnabled(true);
    }


    return _databaseRef;
  }

  void deleteUser(String key){
    _databaseRef.child(key).remove();

  }
  void updateUser(String key, Users users){
    _databaseRef.child(key).update(users.toMap());
  }
}

import 'dart:async';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase/users.dart';
import 'package:flutter_firebase/users_dao.dart';
//import 'package:flutter_firebase/users_widget.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  final usersDoa = UsersDao();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _nameController = TextEditingController();
  final _commentController = TextEditingController();
  final Future<FirebaseApp> _future = Firebase.initializeApp();
  final ScrollController _scrollController = ScrollController();
  String key = "";
  bool editStatus = false;
  final GlobalKey<ScaffoldState> _scaffoldKey= GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    final connectedRef =  widget.usersDoa.getMessageQuery();
    connectedRef.keepSynced(true);
    super.initState();

  }

  void _addData(String name, String comment) {
    final users = Users(name.toUpperCase(), comment.toLowerCase());
    switch (editStatus) {
      case false:
        widget.usersDoa.saveUsers(users);
        _clearData();
        break;
      case true:
        editStatus = false;
        _updateData(key, users);
        _clearData();
        break;
    }
  }

  void _deleteData(String key) {
    widget.usersDoa.deleteUser(key);
    _clearData();
  }

  void _updateData(String key, Users users) {
    widget.usersDoa.updateUser(key, users);
  }

  void _clearData() {
    _nameController.clear();
    _commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) => _scrollToBottom());


    return Scaffold(
      //key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Firebase Demo"),
      ),
      body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {

              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(hintText: "Enter Name"),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: _commentController,
                      decoration:
                          const InputDecoration(hintText: "Enter Comment"),
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Center(
                      child: TextButton(
                          child: const Text("Save to Database"),
                          onPressed: () {
                            _addData(
                                _nameController.text, _commentController.text);
                            //call method flutter upload
                          })),
                  const SizedBox(height: 5.0),
                  _getMessageList(),
                ],
              );
            }
          }),
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  // Widget _getMessageList() {
  //   return Expanded(
  //       child: FirebaseAnimatedList(
  //         controller: _scrollController,
  //         query: widget.usersDoa.getMessageQuery(),
  //         itemBuilder: (context, snapshot, animation, index) {
  //           final json = snapshot.value as Map<dynamic, dynamic>;
  //           final users = Users.fromJson(json);
  //           return UsersWidget(users.name, users.comment);
  //         },
  //       )
  //   );
  // }
  Widget _getMessageList() {
    return Expanded(
        child: FirebaseAnimatedList(
      controller: _scrollController,
      query: widget.usersDoa.getMessageQuery(),
      itemBuilder: (context, snapshot, animation, index) {
        final json = snapshot.value as Map<dynamic, dynamic>;
        final users = Users.fromJson(json);
        return Card(
          child: ListTile(
            title: Text(users.name),
            subtitle: Text(users.comment),
            trailing: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () {
                      key = snapshot.key as String;
                      _nameController.text = users.name;
                      _commentController.text = users.comment;
                      editStatus = true;
                      print("Selected: $key");
                    },
                    icon: const Icon(Icons.edit)),
                IconButton(
                    onPressed: () {
                      setState(() {
                        key = snapshot.key as String;
                        _deleteData(key);
                      });
                    },
                    icon: const Icon(Icons.delete)),
              ],
            ),
          ),
        );
      },
    ));
  }
}

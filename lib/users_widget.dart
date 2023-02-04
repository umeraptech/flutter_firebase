import 'package:flutter/material.dart';

class UsersWidget extends StatelessWidget {
  //const MessageWidget({Key? key}) : super(key: key);
  final String name;
  final String comment;

  UsersWidget(this.name, this.comment);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Text("Name: $name"),
          const SizedBox(
            height: 10.0,
          ),
          Text("Comment: $comment")
        ],
      ),
    );
  }
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mess_app/models/user_chat.dart';
import 'package:mess_app/screens/chat_screen.dart';

class ChatList extends StatefulWidget {
  final UserChat user;
  const ChatList({
    super.key,
    required this.user,
  });

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ChatScreen(
                      user: widget.user,
                    )));
      },
      leading: widget.user.image.isEmpty
          ? CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              radius: 22,
              child: Center(
                child: Text(
                  widget.user.name[0],
                  style: TextStyle(fontSize: 25, color: Colors.grey[800]),
                ),
              ),
            )
          : CircleAvatar(
              radius: 22,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
      title: Text(widget.user.name),
      subtitle: Text(widget.user.about),
      trailing: Text(
        '12:30 PM',
        style: TextStyle(
            fontSize: 13, color: Theme.of(context).colorScheme.onSecondary),
      ),
    );
  }
}

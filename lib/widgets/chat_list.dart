import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mess_app/api/api_system.dart';
import 'package:mess_app/helper/my_date.dart';
import 'package:mess_app/main.dart';
import 'package:mess_app/models/message.dart';
import 'package:mess_app/models/user_chat.dart';
import 'package:mess_app/screens/chat_screen.dart';
import 'package:mess_app/widgets/dialogs/profile_dialogue.dart';
import 'package:provider/provider.dart';

class ChatList extends StatefulWidget {
  final UserChat user;

  const ChatList({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  Message? _message;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: APISystem.getLastMessage(widget.user),
      builder: (context, snapshot) {
        final data = snapshot.data?.docs;
        final list =
            data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
        if (list.isNotEmpty) {
          _message = list[0];
        }

        var unreadMessageCount = _message?.fromId != APISystem.user.uid
            ? list.where((message) => message.read.isEmpty).length
            : null;

        if (list.isEmpty) {
          return Container(); // Returning an empty container when there are no messages
        }

        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(
                  user: widget.user,
                ),
              ),
            );
          },
          leading: Padding(
            padding: const EdgeInsets.all(3.0),
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => ProfileDialog(user: widget.user),
                );
              },
              child: widget.user.image.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        width: 50,
                        height: 50,
                        imageUrl: widget.user.image,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                          ),
                        ),
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.person),
                      ),
                    )
                  : const Icon(Icons.person),
            ),
          ),
          title: Text(widget.user.name),
          subtitle: _message?.type == Type.image
              ? const Row(
                  children: [
                    Icon(
                      Icons.image,
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text('image'),
                  ],
                )
              : Text(
                  _message != null ? _message!.msg : widget.user.about,
                  maxLines: 1,
                ),
          trailing: _message == null
              ? null
              : _message!.read.isEmpty && _message!.fromId != APISystem.user.uid
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          MyDate.getLastMessageTime(
                            context: context,
                            time: _message!.sent,
                          ),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          child: Center(
                            child: Text('$unreadMessageCount'),
                          ),
                        ),
                      ],
                    )
                  : Text(
                      MyDate.getLastMessageTime(
                        context: context,
                        time: _message!.sent,
                      ),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
        );
      },
    );
  }
}

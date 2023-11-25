import 'package:flutter/material.dart';
import 'package:mess_app/api/api_system.dart';
import 'package:mess_app/main.dart';
import 'package:mess_app/models/message.dart';

class MessageCard extends StatefulWidget {
  final Message message;
  const MessageCard({super.key, required this.message});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APISystem.user.uid == widget.message.fromId
        ? _violetMessage()
        : _blueMessage();
  }

  Widget _blueMessage() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .03),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .03, vertical: mq.height * .01),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: Theme.of(context).colorScheme.secondary),
            child: Text(widget.message.msg),
          ),
        ),
        const Icon(Icons.done_all_rounded),
        Text(
          widget.message.sent,
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        )
      ],
    );
  }

  Widget _violetMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          widget.message.read,
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
        const Icon(Icons.done_all_rounded),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width * .03),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .03, vertical: mq.height * .01),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: Theme.of(context).colorScheme.secondary),
            child: Text(widget.message.msg),
          ),
        ),
      ],
    );
  }
}

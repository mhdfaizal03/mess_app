import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mess_app/api/api_system.dart';
import 'package:mess_app/helper/my_date.dart';
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
        ? _sendMessage()
        : _receiveMessage();
  }

  Widget _receiveMessage() {
    if (widget.message.read.isEmpty) {
      APISystem.updateMessageCheckStatus(widget.message);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(top: mq.height * 0.01),
            child: Container(
                padding: EdgeInsets.all(widget.message.type == Type.image
                    ? mq.width * .01
                    : mq.width * .028),
                margin: EdgeInsets.symmetric(
                  horizontal: mq.width * .02,
                ),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Theme.of(context).colorScheme.secondary),
                child: widget.message.type == Type.text
                    ? Text(widget.message.msg)
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(mq.height * .01),
                        child: CachedNetworkImage(
                          width: mq.width * .50,
                          height: mq.height * .30,
                          imageUrl: widget.message.msg,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) {
                            return const Icon(
                              Icons.image,
                              size: 70,
                            );
                          },
                        ),
                      )),
          ),
        ),
        Text(
          MyDate.getFormatedTime(context: context, time: widget.message.sent),
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
              fontSize: mq.height * .011),
        )
      ],
    );
  }

  Widget _sendMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          MyDate.getFormatedTime(context: context, time: widget.message.sent),
          style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
              fontSize: mq.height * .013),
        ),
        Flexible(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(top: mq.height * 0.01),
                child: Container(
                    padding: EdgeInsets.all(widget.message.type == Type.image
                        ? mq.width * .01
                        : mq.width * .028),
                    margin: EdgeInsets.symmetric(
                      horizontal: mq.width * .03,
                      vertical: mq.width * .01,
                    ),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: Theme.of(context).colorScheme.secondary),
                    child: widget.message.type == Type.text
                        ? Text(widget.message.msg)
                        : ClipRRect(
                            borderRadius:
                                BorderRadius.circular(mq.height * .01),
                            child: CachedNetworkImage(
                              placeholder: (context, url) {
                                return Container(
                                  width: mq.width * .50,
                                  height: mq.height * .30,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(mq.height * .01),
                                  ),
                                  child: const Center(
                                      child: CircularProgressIndicator(
                                    strokeWidth: 1.5,
                                  )),
                                );
                              },
                              width: mq.width * .50,
                              height: mq.height * .30,
                              imageUrl: widget.message.msg,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) {
                                return const Icon(
                                  Icons.image,
                                  size: 70,
                                );
                              },
                            ),
                          )),
              ),
              widget.message.read.isNotEmpty
                  ? Positioned(
                      bottom: 5,
                      right: 15,
                      child: Icon(
                        Icons.done_all_rounded,
                        color: Colors.blue,
                        size: mq.width * 0.034,
                      ),
                    )
                  : Positioned(
                      bottom: 5,
                      right: 15,
                      child: Icon(
                        Icons.done_rounded,
                        color: Colors.grey[800],
                        size: mq.width * 0.034,
                      ),
                    )
            ],
          ),
        ),
      ],
    );
  }
}

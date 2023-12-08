import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:mess_app/api/api_system.dart';
import 'package:mess_app/helper/dialog.dart';
import 'package:mess_app/helper/my_date.dart';
import 'package:mess_app/main.dart';
import 'package:mess_app/models/message.dart';
import 'package:mess_app/screens/profile_page.dart';

class MessageCard extends StatefulWidget {
  final Message message;
  const MessageCard({super.key, required this.message});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool isMe = APISystem.user.uid == widget.message.fromId;
    return InkWell(
        onLongPress: () {
          _showBottomSheet(isMe);
        },
        child: isMe ? _sendMessage() : _receiveMessage());
  }

  Widget _receiveMessage() {
    if (widget.message.read.isEmpty) {
      APISystem.updateMessageCheckStatus(widget.message);
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 60,
        ),
        child: Card(
            elevation: 1,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            color: Theme.of(context).colorScheme.secondary,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: widget.message.type == Type.text
                ? widget.message.msg.length > 20
                    ? Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 20,
                              top: 5,
                              bottom: 20,
                            ),
                            child: Text(
                              widget.message.msg,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 10,
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0),
                                  child: Text(
                                    MyDate.getFormatedTime(
                                        context: context,
                                        time: widget.message.sent),
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary,
                                        fontSize: mq.height * .013),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                                top: 5,
                                bottom: 10,
                              ),
                              child: Text(
                                widget.message.msg,
                                style: const TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  MyDate.getFormatedTime(
                                      context: context,
                                      time: widget.message.sent),
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                      fontSize: mq.height * .013),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                : Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Dialogs.showFullScreenImage(
                                context, widget.message.msg);
                          },
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            child: CachedNetworkImage(
                              placeholder: (context, url) {
                                return Container(
                                  width: mq.width * .60,
                                  height: mq.height * .40,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(mq.height * .03),
                                  ),
                                  child: const Center(
                                      child: CircularProgressIndicator(
                                    strokeWidth: 1.5,
                                  )),
                                );
                              },
                              width: mq.width * .60,
                              height: mq.height * .40,
                              imageUrl: widget.message.msg,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) {
                                return const Icon(
                                  Icons.image,
                                  size: 70,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              MyDate.getFormatedTime(
                                  context: context, time: widget.message.sent),
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                  fontSize: mq.height * .013),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
      ),
    );
  }

  Widget _sendMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 60,
        ),
        child: Card(
            elevation: 1,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10))),
            color: Theme.of(context).colorScheme.secondary,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: widget.message.type == Type.text
                ? widget.message.msg.length > 20
                    ? Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 20,
                              top: 5,
                              bottom: 25,
                            ),
                            child: Text(
                              widget.message.msg,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 10,
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(bottom: 5, top: 10),
                                  child: Text(
                                    MyDate.getFormatedTime(
                                        context: context,
                                        time: widget.message.sent),
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSecondary,
                                        fontSize: mq.height * .013),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                widget.message.read.isNotEmpty
                                    ? const Icon(
                                        Icons.done_all,
                                        size: 18,
                                        color: Colors.blue,
                                      )
                                    : const Icon(
                                        Icons.done,
                                        size: 18,
                                        color: Colors.grey,
                                      )
                              ],
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 10,
                              right: 10,
                              top: 5,
                              bottom: 15,
                            ),
                            child: Text(
                              widget.message.msg,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              children: [
                                Text(
                                  MyDate.getFormatedTime(
                                      context: context,
                                      time: widget.message.sent),
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                      fontSize: mq.height * .013),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                widget.message.read.isNotEmpty
                                    ? const Icon(
                                        Icons.done_all,
                                        size: 18,
                                        color: Colors.blue,
                                      )
                                    : const Icon(
                                        Icons.done,
                                        size: 18,
                                        color: Colors.grey,
                                      )
                              ],
                            ),
                          ),
                        ],
                      )
                : Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          child: GestureDetector(
                            onTap: () {
                              Dialogs.showFullScreenImage(
                                  context, widget.message.msg);
                            },
                            child: CachedNetworkImage(
                              placeholder: (context, url) {
                                return Container(
                                  width: mq.width * .60,
                                  height: mq.height * .40,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(mq.height * .03),
                                  ),
                                  child: const Center(
                                      child: CircularProgressIndicator(
                                    strokeWidth: 1.5,
                                  )),
                                );
                              },
                              width: mq.width * .60,
                              height: mq.height * .40,
                              imageUrl: widget.message.msg,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) {
                                return const Icon(
                                  Icons.image,
                                  size: 70,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              MyDate.getFormatedTime(
                                  context: context, time: widget.message.sent),
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                  fontSize: mq.height * .013),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            widget.message.read.isNotEmpty
                                ? const Icon(
                                    Icons.done_all,
                                    size: 18,
                                    color: Colors.blue,
                                  )
                                : const Icon(
                                    Icons.done,
                                    size: 18,
                                    color: Colors.grey,
                                  )
                          ],
                        ),
                      ],
                    ),
                  )),
      ),
    );
  }

  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(
                    vertical: mq.height * .011, horizontal: mq.width * .4),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              widget.message.type == Type.text
                  ? _OptionItems(
                      icon: const Icon(Icons.copy),
                      name: 'Copy Text',
                      onTap: () async {
                        await Clipboard.setData(
                                ClipboardData(text: widget.message.msg))
                            .then((value) {
                          Navigator.pop(context);

                          Dialogs.showSnackBar(context, 'text copied');
                        });
                      })
                  : _OptionItems(
                      icon: const Icon(Icons.save_alt_rounded),
                      name: 'Save image',
                      onTap: () async {
                        await downloadFile();
                      }),
              if (isMe)
                if (widget.message.type == Type.text && isMe)
                  _OptionItems(
                      icon: const Icon(Icons.edit),
                      name: 'Edit Message',
                      onTap: () {
                        String updateMsg = widget.message.msg;
                        Navigator.pop(context);

                        showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          context: context,
                          builder: (context) {
                            return SingleChildScrollView(
                              physics: const ClampingScrollPhysics(),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom,
                                ),
                                child: Form(
                                  key: _formkey,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: mq.height * .02,
                                      left: mq.height * .02,
                                      right: mq.height * .02,
                                    ),
                                    child: Column(
                                      children: [
                                        const Text(
                                          'Enter the message',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        SizedBox(
                                          height: mq.height * .02,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            onChanged: (value) =>
                                                updateMsg = value,
                                            autofocus: true,
                                            onSaved: (val) =>
                                                APISystem.me.about = val ?? '',
                                            validator: (val) =>
                                                val != null && val.isEmpty
                                                    ? 'Enter atleast a word'
                                                    : null,
                                            initialValue: widget.message.msg,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                // Add your save logic here

                                                if (_formkey.currentState
                                                        ?.validate() ??
                                                    false) {
                                                  // The form is valid, process the data
                                                  Navigator.pop(context);
                                                  APISystem.updateMessage(
                                                      widget.message,
                                                      updateMsg);
                                                }
                                                Dialogs.showSnackBar(
                                                  context,
                                                  'edited successfully',
                                                );
                                              },
                                              child: const Text('Update'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }),
              // if (isMe)
              _OptionItems(
                  icon: const Icon(Icons.delete_forever),
                  name: 'Delete Message',
                  onTap: () async {
                    if (isMe) {
                      await APISystem.deleteMessage(widget.message)
                          .then((value) {
                        Navigator.pop(context);
                      });
                    } else {
                      _showDeleteConfirmationDialog(
                              context: context,
                              message: widget.message,
                              userId: widget.message.fromId)
                          .then((value) => Navigator.pop(context));
                    }
                  }),
              Divider(
                color: Colors.grey,
                endIndent: mq.width * 0.05,
                indent: mq.width * 0.05,
              ),
              _OptionItems(
                  icon: const Icon(Icons.access_time),
                  name:
                      'Sent At : ${MyDate.getMessageTime(context: context, time: widget.message.sent)} ',
                  onTap: () {}),
              _OptionItems(
                  icon: const Icon(Icons.remove_red_eye_rounded),
                  name: widget.message.read.isEmpty
                      ? "Read At : Not seen yet"
                      : 'Read At : ${MyDate.getMessageTime(context: context, time: widget.message.read)}',
                  onTap: () {}),
            ],
          );
        });
  }

  Future<void> downloadFile() async {
    try {
      // Replace this URL with the actual URL of the file you want to download
      var fileUrl = widget.message.msg;

      var httpClient = HttpClient();
      var request = await httpClient.getUrl(Uri.parse(fileUrl));
      var response = await request.close();

      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);

        var time = DateTime.now().millisecondsSinceEpoch;
        var path = "/storage/emulated/0/Download";

        var file = File(path);
        await file.writeAsBytes(bytes);

        log("File downloaded and saved to: $path");
      } else {
        log("Failed to download the file. Status code: ${response.statusCode}");
      }
    } catch (error) {
      log("Error downloading file: $error");
    }
  }

  Future<void> _showDeleteConfirmationDialog(
      {required BuildContext context,
      required Message message,
      required String userId}) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: const Text('Delete Message'),
          content: const Text(
              'Are you sure you want to delete this message from user?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Perform the delete operation
                // await deleteMessageFromUser(message, userId);

                // Close the dialog
                Navigator.pop(context);
                try {
                  await APISystem.deleteMessageFromUser(message, userId)
                      .then((value) => Navigator.pop(context));
                } catch (e) {
                  log('something happened on $e');
                }
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class _OptionItems extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;
  const _OptionItems({
    required this.icon,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      leading: icon,
      onTap: () => onTap(),
    );
  }
}

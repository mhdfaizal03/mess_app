import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mess_app/api/api_system.dart';
import 'package:mess_app/helper/my_date.dart';
import 'package:mess_app/main.dart';
import 'package:mess_app/models/message.dart';
import 'package:mess_app/models/user_chat.dart';
import 'package:mess_app/screens/user_profile_page.dart';
import 'package:mess_app/themes/light_theme.dart';
import 'package:mess_app/widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  final UserChat user;
  const ChatScreen({
    super.key,
    required this.user,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _textController = TextEditingController();

  //for showing emoji / hiding
  bool _showEmoji = false, _isUploading = false;

  List<Message> _list = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () {
          if (_showEmoji) {
            setState(() => _showEmoji = !_showEmoji);
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            automaticallyImplyLeading: false,
            flexibleSpace: Padding(
              padding: EdgeInsets.only(top: mq.height * 0.034),
              child: _appBar(),
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: Theme.of(context).colorScheme.brightness ==
                            Brightness.light
                        ? const AssetImage('images/bglight.jpg')
                        : const AssetImage('images/bgDark.jpg'),
                    fit: BoxFit.cover)),
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                      stream: APISystem.getAllMessages(widget.user),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          //when data loading
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return const SizedBox();

                          //when all data is loaded
                          case ConnectionState.active:
                          case ConnectionState.done:
                            final data = snapshot.data?.docs;
                            // print('data ${jsonEncode(data![0].data())}');

                            _list = data
                                    ?.map((e) => Message.fromJson(e.data()))
                                    .toList() ??
                                [];

                            if (_list.isNotEmpty) {
                              return ListView.builder(
                                  reverse: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemCount: _list.length,
                                  itemBuilder: (context, index) {
                                    return MessageCard(
                                      message: _list[index],
                                    );
                                  });
                            } else {
                              return Center(
                                  child: TextButton(
                                      onPressed: () {
                                        _textController.text = 'Hii 👋';
                                      },
                                      child: const Text('Say Hii 👋',
                                          style: TextStyle(fontSize: 18))));
                            }
                        }
                      }),
                ),

                //indicator for showing something uploading

                if (_isUploading)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: mq.width * .03),
                      child: Container(
                        width: mq.width * .40,
                        height: mq.height * .050,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).colorScheme.secondary),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sending image',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            SizedBox(
                              height: 15,
                              width: 15,
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                _chatInputs(),

                if (_showEmoji)
                  SizedBox(
                    height: mq.height * 0.35,
                    child: EmojiPicker(
                      textEditingController: _textController,
                      config: Config(
                        bgColor: Theme.of(context).colorScheme.background,
                        columns: 7,
                        emojiSizeMax: 28 * (Platform.isIOS ? 1.30 : 1.0),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget? _appBar() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => UserProfilePage(
                      user: widget.user,
                    )));
      },
      child: StreamBuilder(
        stream: APISystem.getUserInfo(widget.user),
        builder: (context, snapshot) {
          final data = snapshot.data?.docs;
          final list =
              data?.map((e) => UserChat.fromJson(e.data())).toList() ?? [];

          return Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back)),
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .03),
                  child: CachedNetworkImage(
                    width: 40,
                    height: 40,
                    imageUrl: widget.user.image,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) {
                      return const CircleAvatar(
                        child: Icon(Icons.person),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                width: mq.width * 0.028,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    list.isNotEmpty ? list[0].name : widget.user.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    list.isNotEmpty
                        ? list[0].isOnline
                            ? 'Online'
                            : MyDate.getLastActiveTime(
                                context: context,
                                lastActive: list[0].lastActive)
                        : MyDate.getLastActiveTime(
                            context: context,
                            lastActive: widget.user.lastActive),
                    style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSecondary),
                  ),
                ],
              )
            ],
          );
        },
      ),
    );
  }

  Widget _chatInputs() {
    return Padding(
      padding: EdgeInsets.all(mq.width * .01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(mq.width * .0),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          setState(() => _showEmoji = !_showEmoji);
                        },
                        icon: const Icon(Icons.emoji_emotions_outlined)),
                    Expanded(
                        child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onTap: () {
                        if (_showEmoji) {
                          setState(() => _showEmoji = !_showEmoji);
                        }
                      },
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type message here'),
                    )),
                    IconButton(
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();

                          final List<XFile> images =
                              await picker.pickMultiImage(imageQuality: 70);

                          for (var i in images) {
                            log('image path: ${i.path}');
                            setState(() => _isUploading = true);
                            await APISystem.sentImage(
                                widget.user, File(i.path));
                            setState(() => _isUploading = false);
                          }
                        },
                        icon: const Icon(Icons.image)),
                    IconButton(
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();

                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);
                          if (image != null) {
                            log('Image path : ${image.path}');
                            setState(() => _isUploading = true);
                            await APISystem.sentImage(
                                widget.user, File(image.path));
                            setState(() => _isUploading = false);
                          }
                        },
                        icon: const Icon(Icons.camera_alt)),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: FloatingActionButton(
              onPressed: () {
                if (_textController.text.isNotEmpty) {
                  APISystem.sendMessage(
                      widget.user, _textController.text, Type.text);
                  _textController.text = '';
                }
              },
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: const Icon(Icons.send),
            ),
          )
        ],
      ),
    );
  }
}

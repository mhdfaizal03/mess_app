// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mess_app/api/api_system.dart';
import 'package:mess_app/helper/dialog.dart';
import 'package:mess_app/helper/my_date.dart';
import 'package:mess_app/main.dart';
import 'package:mess_app/models/user_chat.dart';

class UserProfilePage extends StatefulWidget {
  final UserChat user;
  const UserProfilePage({super.key, required this.user});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  // String? _image;

  List<UserChat> list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Joined On: ',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            Text(
              MyDate.getLastMessageTime(
                  context: context, time: widget.user.createAt, showYear: true),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
                fontSize: 15,
              ),
            ),
          ],
        ),
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          title: const Text(
            'Profile',
            style: TextStyle(fontSize: 20),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
            child: Column(
              children: [
                SizedBox(
                  height: mq.height * .03,
                  width: mq.width,
                ),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 100,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(mq.height * .5),
                          child: CachedNetworkImage(
                            width: 200,
                            height: 200,
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
                    ),
                  ],
                ),
                SizedBox(
                  height: mq.height * .01,
                ),
                Column(
                  children: [
                    Text(
                      widget.user.name,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: widget.user.id));
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor:
                                    Theme.of(context).colorScheme.onBackground,
                                behavior: SnackBarBehavior.floating,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 100, vertical: 60),
                                content: const Text('ID copied')));
                          },
                          child: Row(
                            children: [
                              Text(
                                widget.user.id,
                                style: const TextStyle(fontSize: 13),
                              ),
                              const Icon(Icons.copy)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: mq.height * .02,
                ),
                SizedBox(
                  height: mq.height * .02,
                ),
                Container(
                  height: mq.height * .07,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  child: Center(
                    child: ListTile(
                      title: Text(widget.user.about),
                      leading: const Icon(Icons.info_outline),
                    ),
                  ),
                ),
                SizedBox(
                  height: mq.height * .02,
                ),
                Container(
                  height: mq.height * .07,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  child: Center(
                    child: ListTile(
                      leading: const Icon(Icons.mail),
                      title: Text(widget.user.email),
                      trailing: IconButton(
                        onPressed: () {
                          Clipboard.setData(
                              ClipboardData(text: widget.user.email));
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.onBackground,
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 50),
                              content: const Text('email copied')));
                        },
                        icon: const Icon(
                          Icons.copy,
                          size: 21,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

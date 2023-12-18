// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mess_app/api/api_system.dart';
import 'package:mess_app/helper/dialog.dart';
import 'package:mess_app/main.dart';
import 'package:mess_app/models/user_chat.dart';

class ProfilePage extends StatefulWidget {
  final UserChat user;
  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formkey = GlobalKey<FormState>();

  String? _image;

  List<UserChat> list = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
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
                  height: mq.height * .05,
                  width: mq.width,
                ),
                Stack(
                  children: [
                    Container(
                      height: 202,
                      width: 202,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: GestureDetector(
                            onTap: () {
                              if (widget.user.image.isNotEmpty) {
                                Dialogs.showFullScreenImage(
                                    context, widget.user.image);
                              } else {
                                Dialogs.showFullScreenImage(
                                    context, 'No profile picture');
                              }
                            },
                            child: widget.user.image.isNotEmpty
                                ? CachedNetworkImage(
                                    width: 200,
                                    height: 200,
                                    imageUrl: widget.user.image,
                                    placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator(
                                      strokeWidth: 1.5,
                                    )),
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.person),
                                  )
                                : const Icon(Icons.person),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          _showPictureBottomSheet();
                        },
                        child: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.onSecondary,
                          radius: 25,
                          child: const Icon(Icons.camera_alt_rounded),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: mq.height * .03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.user.id,
                      style: const TextStyle(fontSize: 13),
                    ),
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: widget.user.id));
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor:
                                Theme.of(context).colorScheme.onBackground,
                            behavior: SnackBarBehavior.floating,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 100, vertical: 50),
                            content: const Text('ID copied')));
                      },
                      icon: const Icon(
                        Icons.copy,
                        size: 15,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: mq.height * .03,
                ),
                Container(
                  height: mq.height * .07,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  child: Center(
                    child: ListTile(
                      title: Text(widget.user.name),
                      leading: const Icon(Icons.person),
                      trailing: IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            // isScrollControlled: true,
                            backgroundColor:
                                Theme.of(context).colorScheme.background,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            context: context,
                            builder: (_) {
                              return Form(
                                key: _formkey,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: mq.height * .02,
                                      left: mq.height * .02,
                                      right: mq.height * .02),
                                  // Wrap the content inside SingleChildScrollView
                                  child: Padding(
                                    // height: mq.height * .30,
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),

                                    child: ListView(
                                      shrinkWrap: true,
                                      children: [
                                        const Text(
                                          'Enter your name',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        SizedBox(
                                          height: mq.height * .02,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            autofocus: true,
                                            onSaved: (val) =>
                                                APISystem.me.name = val ?? '',
                                            validator: (val) =>
                                                val != null && val.isEmpty
                                                    ? 'Required Field'
                                                    : null,
                                            initialValue: widget.user.name,
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
                                                if (_formkey.currentState!
                                                    .validate()) {
                                                  _formkey.currentState!.save();
                                                  // Create a map containing the updated user information
                                                  Map<String, dynamic>
                                                      updatedUserInfo = {
                                                    'name': APISystem.me.name,
                                                    'about': APISystem.me.about,
                                                    // Add other fields as needed
                                                  };
                                                  // Pass the updatedUserInfo back to the previous screen
                                                  Navigator.pop(
                                                      context, updatedUserInfo);
                                                  APISystem.updateUserExist()
                                                      .then((value) =>
                                                          Dialogs.showSnackBar(
                                                            context,
                                                            'Profile updated successfully',
                                                          ));
                                                }
                                                // Navigator.pop(context);
                                              },
                                              child: const Text('Save'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: mq.height * .02,
                ),
                Container(
                  height: mq.height * .07,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  child: Center(
                    child: ListTile(
                      title: Text(widget.user.about),
                      leading: const Icon(Icons.info_outline),
                      trailing: IconButton(
                        onPressed: () {
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
                            builder: (_) {
                              return Form(
                                key: _formkey,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: mq.height * .02,
                                      left: mq.height * .02,
                                      right: mq.height * .02),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom),
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: [
                                        const Text(
                                          'Enter your name',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        SizedBox(
                                          height: mq.height * .02,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(
                                            autofocus: true,
                                            onSaved: (val) =>
                                                APISystem.me.about = val ?? '',
                                            validator: (val) =>
                                                val != null && val.isEmpty
                                                    ? 'Required Field'
                                                    : null,
                                            initialValue: widget.user.about,
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
                                                if (_formkey.currentState!
                                                    .validate()) {
                                                  _formkey.currentState!.save();
                                                  APISystem.updateUserExist();
                                                }
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Save'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: mq.height * .02,
                ),
                Container(
                  height: mq.height * .07,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
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

  void _showPictureBottomSheet() {
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
                height: 3,
                margin:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 170),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              const Text(
                'Select Profile Picture',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: mq.height * .02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                          fixedSize: Size(mq.width * .3, mq.height * .15),
                          shape: const CircleBorder()),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          print('Image path : ${image.path}');
                          setState(() {
                            _image = image.path;
                            APISystem.updateProfileImage(File(_image!));
                            Navigator.pop(context);
                          });
                        }
                      },
                      child: Image.asset(
                        'images/camera.png',
                        // width: 30,
                      )),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                          fixedSize: Size(mq.width * .3, mq.height * .15),
                          shape: const CircleBorder()),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();

                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          print('Image path : ${image.path}');
                          setState(() {
                            _image = image.path;
                            APISystem.updateProfileImage(File(_image!));
                            Navigator.pop(context);
                          });
                        }
                      },
                      child: Image.asset(
                        'images/gallery.png',
                        // width: 30,
                      )),
                ],
              ),
              const SizedBox(
                height: 40,
              )
            ],
          );
        });
  }
}

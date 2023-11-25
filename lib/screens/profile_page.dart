// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mess_app/api/api_system.dart';
import 'package:mess_app/helper/dialog.dart';
import 'package:mess_app/main.dart';
import 'package:mess_app/models/user_chat.dart';

class ProfilePage extends StatefulWidget {
  final UserChat user;
  const ProfilePage({super.key, required this.user});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formkey = GlobalKey<FormState>();

  String? _image;

  List<UserChat> list = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Profile',
            style: TextStyle(fontSize: 20),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
          child: Column(
            children: [
              SizedBox(
                height: mq.height * .03,
                width: mq.width,
              ),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          radius: 80,
                          backgroundImage: Image.file(File(_image!)).image,
                        )
                      : CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          radius: 80,
                          child: Center(
                            child: Text(
                              widget.user.name[0],
                              style: TextStyle(
                                  fontSize: 70, color: Colors.grey[800]),
                            ),
                          ),
                        ),
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: GestureDetector(
                      onTap: () {
                        _showPictureBottomSheet();
                      },
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        radius: 25,
                        child: const Icon(Icons.camera_alt_rounded),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: mq.height * .03,
              ),
              Text(
                widget.user.email,
              ),
              SizedBox(
                height: mq.height * .04,
              ),
              Container(
                height: mq.height * .07,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Theme.of(context).colorScheme.secondary,
                ),
                child: Center(
                  child: ListTile(
                    title: Text(widget.user.name),
                    leading: const Icon(Icons.person),
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
                                padding: EdgeInsets.all(mq.height * .02),
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
                                                  BorderRadius.circular(30),
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
                                                APISystem.updateUserExist()
                                                    .then((value) =>
                                                        Dialogs.showSnackBar(
                                                          context,
                                                          'Profile updated successfully',
                                                        ));
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
                  borderRadius: BorderRadius.circular(30),
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
                                padding: EdgeInsets.all(mq.height * .02),
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
                                                  BorderRadius.circular(30),
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
              )
            ],
          ),
        ));
  }

  void _showPictureBottomSheet() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .02, bottom: mq.height * .05),
            children: [
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
                          });
                          APISystem.updateProfileImage(File(_image!));
                          Navigator.pop(context);
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
                          });
                          APISystem.updateProfileImage(File(_image!));
                          Navigator.pop(context);
                        }
                      },
                      child: Image.asset(
                        'images/gallery.png',
                        // width: 30,
                      )),
                ],
              )
            ],
          );
        });
  }
}

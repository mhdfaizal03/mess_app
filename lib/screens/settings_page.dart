import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mess_app/api/api_system.dart';
import 'package:mess_app/helper/dialog.dart';
import 'package:mess_app/main.dart';
import 'package:mess_app/models/user_chat.dart';
import 'package:mess_app/screens/authentication/login_page.dart';
import 'package:mess_app/screens/profile_page.dart';

class SettingsPage extends StatefulWidget {
  final UserChat user;
  const SettingsPage({
    super.key,
    required this.user,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<UserChat> list = [];
  @override
  Widget build(BuildContext context) {
    Widget divider = Divider(
      color: Theme.of(context).colorScheme.secondary,
    );
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: false,
              backgroundColor: Theme.of(context).colorScheme.background,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.all(25),
                title: Text(
                  'Settings',
                  style: TextStyle(
                      fontSize: 28,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ),
              expandedHeight: 160,
            ),
            SliverToBoxAdapter(
              child: StreamBuilder(
                  stream: APISystem.firestore.collection('users').snapshots(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      //when data loading
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const Center(child: CircularProgressIndicator());

                      //when all data is loaded
                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        list = data
                                ?.map((e) => UserChat.fromJson(e.data()))
                                .toList() ??
                            [];

                        return Column(
                          children: [
                            // Container(
                            //   height: mq.height * .15,
                            //   width: double.infinity,
                            //   color: Theme.of(context).colorScheme.secondary,
                            //   child: Padding(
                            //     padding: EdgeInsets.only(
                            //         top: mq.height * 0.065,
                            //         right: mq.height * 0.01,
                            //         left: mq.height * 0.02),
                            //     child: const Text(
                            //       'Settings',
                            //       style: TextStyle(
                            //         fontSize: 30,
                            //         fontWeight: FontWeight.bold,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfilePage(
                                      user: APISystem.me,
                                    ),
                                  ),
                                );
                              },
                              leading: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(mq.height * .03),
                                  child: CachedNetworkImage(
                                    width: 50,
                                    height: 50,
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
                              title: Text(widget.user.name),
                              subtitle: Text(widget.user.about),
                              trailing: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.qr_code)),
                            ),
                            divider,
                            const SizedBox(
                              height: 15,
                            ),
                            ListTile(
                              onTap: () async {
                                await APISystem.updateActiveStatus(false);

                                APISystem.auth = FirebaseAuth.instance;

                                Dialogs.showProgressBar(context);
                                await APISystem.auth
                                    .signOut()
                                    .then((value) async {
                                  await GoogleSignIn().signOut().then((value) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => const LoginPage()));
                                  });
                                });
                              },
                              leading: const Icon(Icons.logout),
                              title: const Text('Logout'),
                            ),
                          ],
                        );
                    }
                  }),
            ),
          ],
        ));
  }
}

// import 'dart:io';

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
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(0.0),
                  bottomRight: Radius.circular(50.0),
                ),
              ),
              // floating: true,
              pinned: true,
              stretch: true,
              bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(0), child: Container()),
              backgroundColor: Theme.of(context).colorScheme.secondary,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 12, bottom: 25),
                title: Text(
                  'Settings',
                  style: TextStyle(
                      fontSize: 25,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ),
              expandedHeight: 150,
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: mq.height,
                child: StreamBuilder(
                    stream: APISystem.firestore.collection('users').snapshots(),
                    builder: (context, snapshot) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
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
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  width: 50,
                                  height: 50,
                                  imageUrl: widget.user.image,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: const Icon(Icons.person),
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
                                await GoogleSignIn().signOut().then(
                                  (value) {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => LoginPage(
                                            onTap: () => APISystem,
                                          ),
                                        ),
                                        (route) => false);
                                  },
                                );
                              });
                            },
                            leading: const Icon(Icons.logout),
                            title: const Text('Logout'),
                          ),
                        ],
                      );
                    }),
              ),
            ),
          ],
        ));
  }
}

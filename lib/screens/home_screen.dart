import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mess_app/api/api_system.dart';
import 'package:mess_app/models/user_chat.dart';

import 'package:mess_app/screens/home_screen_items.dart';
import 'package:mess_app/screens/settings_page.dart';

import '../models/bottom_app_bar_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<UserChat> list = [];
  void onChangedTabs(int index) {
    setState(() {
      this.index = index;
    });
  }

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {},
          child: Icon(
            CupertinoIcons.person_2,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBarIcons(
          index: index,
          onChangedTab: onChangedTabs,
        ),
        body: StreamBuilder(
            stream: APISystem.firestore.collection('users').snapshots(),
            builder: (context, snapshot) {
              final pages = [
                const HomeScreenItems(),
                SettingsPage(
                  user: APISystem.me,
                ),
              ];
              switch (snapshot.connectionState) {
                //when data loading
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Center(child: Container());

                //when all data is loaded
                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  list =
                      data?.map((e) => UserChat.fromJson(e.data())).toList() ??
                          [];

                  return pages[index];
              }
            }));
  }
}

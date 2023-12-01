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
        backgroundColor: Theme.of(context).colorScheme.secondary,
        extendBody: true,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            //onwork
          },
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
              return pages[index];
            }));
  }
}

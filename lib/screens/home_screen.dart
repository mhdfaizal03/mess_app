import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mess_app/api/api_system.dart';
import 'package:mess_app/models/user_chat.dart';
import 'package:mess_app/screens/home_screen_items.dart';
import 'package:mess_app/screens/settings_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<UserChat> list = [];
  int index = 0;

  void onChangedTabs(int newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        onPressed: () async {
          //onwork
        },
        child: Icon(
          CupertinoIcons.person_2,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: onChangedTabs,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              size: 30,
            ),
            label: 'Home',
            activeIcon: Icon(
              Icons.home,
              size: 30,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings_outlined,
              size: 30,
            ),
            label: 'Settings',
            activeIcon: Icon(
              Icons.settings,
              size: 30,
            ),
          ),
        ],
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey[600],
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: IndexedStack(
        index: index,
        children: [
          const HomeScreenItems(),
          SettingsPage(user: APISystem.me),
        ],
      ),
    );
  }
}

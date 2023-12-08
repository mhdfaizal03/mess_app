import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mess_app/api/api_system.dart';
import 'package:mess_app/models/user_chat.dart';
import 'package:mess_app/screens/add_user.dart';
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 10,
        onPressed: () async {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddUser(),
              ));
        },
        child: Icon(
          CupertinoIcons.person_2,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40.0),
        ),
        child: BottomNavigationBar(
          selectedFontSize: 15,
          elevation: 5,
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
                size: 32,
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
                size: 32,
              ),
            ),
          ],
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey[600],
          backgroundColor: Theme.of(context).colorScheme.secondary,
          enableFeedback: true,
        ),
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

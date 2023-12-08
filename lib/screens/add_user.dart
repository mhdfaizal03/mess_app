import 'package:flutter/material.dart';

class AddUser extends StatefulWidget {
  const AddUser({super.key});

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: const Row(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search Contact',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

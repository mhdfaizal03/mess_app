import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mess_app/main.dart';

class BottomAppBarIcons extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChangedTab;
  const BottomAppBarIcons({
    super.key,
    required this.index,
    required this.onChangedTab,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        notchMargin: 8,
        height: mq.height * .069,
        color: Theme.of(context).colorScheme.secondary,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildTabItem(
              index: 0,
              icon: const Icon(
                Icons.home,
                size: 30,
              ),
            ),
            const SizedBox(),
            buildTabItem(
              index: 1,
              icon: const Icon(
                Icons.settings,
                size: 30,
              ),
            )
          ],
        ));
  }

  Widget buildTabItem({
    required int index,
    required Icon icon,
  }) {
    return IconButton(
      icon: icon,
      onPressed: () => onChangedTab(index),
    );
  }
}

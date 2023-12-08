import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mess_app/helper/dialog.dart';
import 'package:mess_app/main.dart';
import 'package:mess_app/models/user_chat.dart';
import 'package:mess_app/screens/user_profile_page.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});

  final UserChat user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Theme.of(context).colorScheme.background.withOpacity(.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      content: SizedBox(
        width: mq.width * .4,
        height: mq.height * .32,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: GestureDetector(
                  onTap: () {
                    Dialogs.showFullScreenImage(context, user.image);
                  },
                  child: CachedNetworkImage(
                    width: mq.width * .44,
                    height: mq.width * .44,
                    imageUrl: user.image,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) {
                      return const CircleAvatar(
                        child: Icon(CupertinoIcons.person),
                      );
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              left: mq.width * .035,
              top: mq.height * .018,
              width: mq.width * .55,
              child: Text(
                user.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => UserProfilePage(user: user)));
                      },
                      icon: const Icon(Icons.info_outline))),
            )
          ],
        ),
      ),
    );
  }
}

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mess_app/models/message.dart';
import 'package:mess_app/models/user_chat.dart';

class APISystem {
  //to store self information
  static UserChat me = UserChat(
    image: user.photoURL.toString(),
    name: user.displayName.toString(),
    about: 'Hey I\'m using MessApp',
    lastActive: '',
    isOnline: false,
    id: user.uid,
    createAt: '',
    email: user.email,
    pushToken: '',
  );

  //to return current user
  static get user => auth.currentUser!;

  //for authentication on google
  static FirebaseAuth auth = FirebaseAuth.instance;

  //for accessing storage firebase
  static FirebaseStorage storage = FirebaseStorage.instance;

  //for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  static Future<void> getFireBaseMessageToken() async {
    await fMessaging.requestPermission();
   await fMessaging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
        log('push_token $t');
      }
    });
  }

  //for checking user is exist or not
  static Future<bool> isUserExist() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  //for getting currnet user info
  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) {
      if (user.exists) {
        me = UserChat.fromJson(user.data()!);
        getFireBaseMessageToken();
        log('My data : ${user.data()}');
      } else {
        userCreate().then(
          (user) => getSelfInfo(),
        );
      }
    });
  }

  //to create new user
  static Future<void> userCreate() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = UserChat(
      image: user.photoURL.toString(),
      name: user.displayName.toString(),
      about: 'Hey I\'m using MessApp',
      lastActive: time,
      isOnline: false,
      id: user.uid,
      createAt: time,
      email: user.email,
      pushToken: '',
    );

    return firestore.collection('users').doc(user.uid).set(chatUser.toJson());
  }

  //TO GET ALL USERS FROM DATABASE
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  //for checking user is exist or not
  static Future<void> updateUserExist() async {
    await firestore.collection('users').doc(user.uid).update({
      'name': me.name,
      'about': me.about,
    });
  }

  static Future<void> updateProfileImage(File file) async {
    final extension = file.path.split('.').last;

    log('extension : $extension');

    final ref = storage.ref().child('profilepictures/${user.uid}.$extension');

    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$extension'))
        .then((p0) {
      log('data transmitted : ${p0.bytesTransferred / 1000} kb');
    });

    me.image = await ref.getDownloadURL();

    await firestore.collection('users').doc(user.uid).update({
      'image': me.image,
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      UserChat chatUser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken,
    });
  }

  //********************used for chat purpose******************//

  //getting conversation id
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  //for getting all messages of a  specific conversation from firestore db
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      UserChat user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  //for sending message
  static Future<void> sendMessage(
      UserChat userChat, String msg, Type type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //update read status of message
    final Message message = Message(
      msg: msg,
      toId: userChat.id,
      read: '',
      type: type,
      sent: time,
      fromId: user.uid,
    );

    final ref = firestore
        .collection('chats/${getConversationID(userChat.id)}/messages/');
    await ref.doc(time).set(message.toJson());
  }

  //for use to know last message(bluetick)
  static Future<void> updateMessageCheckStatus(Message message) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  //to get latest message show
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      UserChat user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> sentImage(UserChat chatUser, File file) async {
    final extension = file.path.split('.').last;

    log('extension : $extension');

    final ref = storage.ref().child(
        'images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$extension');

    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$extension'))
        .then((p0) {
      log('data transmitted : ${p0.bytesTransferred / 1000} kb');
    });

    final imageUrl = await ref.getDownloadURL();

    await sendMessage(chatUser, imageUrl, Type.image);
  }
}

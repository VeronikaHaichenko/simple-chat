import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:collection/collection.dart';
import 'package:simple_chat/models/user_model.dart';
import 'package:simple_chat/widgets/auth/auth_form.dart';
import 'package:simple_chat/widgets/chats/chat_card.dart';

import '../models/chat_card_model.dart';

final log = Logger();

class DatabaseService {
  String chatUid = '';
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference chatsCollection =
      FirebaseFirestore.instance.collection('chats');

  //Создание юзера
  Future updateUserData(
      String uid, String url, String username, String email) async {
    return await usersCollection.doc(uid).set({
      'username': username,
      'email': email,
      'user_image': url,
      'user_id': uid,
    });
  }

  //Проверка на наличие чата по двум айди
  Future searchChat(String firstUid, String secondUid) async {
    bool chatExists = false;
    await chatsCollection.get().then((value) {
      // log.i(value.docs.first.data());
      value.docs.firstWhereOrNull(
        (element) {
          final Map data = element.data() as Map;
          // log.i(data);
          chatExists = (data['first_id'] == firstUid &&
                  data['second_id'] == secondUid ||
              data['first_id'] == secondUid && data['second_id'] == firstUid);
          // log.i(chatExists);
          return chatExists;
        },
      );
    });
    return chatExists;
  }

  //Получение айди чатов списом, среди которых есть текущий юзер
  Future getChatsUids() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    List<QueryDocumentSnapshot>? list;
    List<String> chatsUids = [];
    await chatsCollection.get().then((value) {
      list = value.docs.where((element) {
        final Map data = element.data() as Map;
        return data['first_id'] == currentUser!.uid ||
            data['second_id'] == currentUser.uid;
      }).toList();
    });
    for (QueryDocumentSnapshot document in list!) {
      chatsUids.add(document.id);
    }
    // log.i('USERCHATS: ${chatsUids.runtimeType}');
    // log.i('USERCHATS: $chatsUids');
    return chatsUids;
  }

  //Получение данных для карточки чата - списком
  Future<List<ChatCardModel>?> getChatData() async {
    List<ChatCardModel> chatCards = [];
    List<String> chatUids = await getChatsUids();
    // log.i(chatUids);
    for (String uid in chatUids) {
      var chatSnapshot =
          await FirebaseFirestore.instance.collection('chats').doc(uid).get();
      Map<String, dynamic>? chatData = chatSnapshot.data();
      // log.i(chatData!['first_id']);
      // log.i('CURRENT UID $currentUid');
      String targetUid;
      chatData!['first_id'] == currentUid
          ? targetUid = chatData['second_id']
          : targetUid = chatData['first_id'];
      // log.i('TARGET UID $targetUid');
      var userSnapshot = await usersCollection.doc(targetUid).get();
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      String username = userData['username'];
      String userImageUrl = userData['user_image'];
      String? lastMessage;
      DateTime createdAtDate = DateTime.now();
      Timestamp createdAtTimestamp;
      if (await messagesExist(uid)) {
        var messagesSnapshot = await chatsCollection
            .doc(uid)
            .collection('messages')
            .orderBy('createdAt', descending: true)
            .get();
        lastMessage = messagesSnapshot.docs.first.data()['text'];
        createdAtTimestamp = messagesSnapshot.docs.first.data()['createdAt'];
        createdAtDate = createdAtTimestamp.toDate().toLocal();
        // createdAt = DateFormat().add_MMMMd().add_Hm().format(createdAtDate);
      }
      if (lastMessage != null) {
        chatCards.add(
          ChatCardModel(
            chatUid: uid,
            userImageUrl: userImageUrl,
            username: username,
            lastMessage: lastMessage,
            createdAt: createdAtDate,
          ),
        );
      }
    }
    log.i('CHATCARDS $chatCards');
    return chatCards;
  }

  //Проверка на наличие сообщений в чате - bool
  Future<bool> messagesExist(chatUid) async {
    CollectionReference messages = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatUid)
        .collection('messages');
    QuerySnapshot querySnapshot = await messages.get();
    return querySnapshot.docs.isNotEmpty;
  }

  Future createNewChat(String firstUid, String secondUid) async {
    return await chatsCollection.doc().set({
      'first_id': firstUid,
      'second_id': secondUid,
    });
  }

  //Получение айди первого чата по совпадению айди собеседников
  Future getChatUid(String firstUid, String secondUid) async {
    String chatUid = '';
    await chatsCollection.get().then((value) {
      // log.i(value.docs.first.data());
      value.docs.firstWhereOrNull(
        (element) {
          chatUid = element.id;
          final Map data = element.data() as Map;
          return data['first_id'] == firstUid &&
                  data['second_id'] == secondUid ||
              data['first_id'] == secondUid && data['second_id'] == firstUid;
        },
      );
    });
    return chatUid;
  }

  //Отправка сообщения
  void createMessage(String chatUid, String enteredMessage) {
    final currentUser = FirebaseAuth.instance.currentUser;
    chatsCollection.doc(chatUid).collection('messages').doc().set({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': currentUser!.uid,
    });
  }

  //Получение отсортированного стрима сообщений чата
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessagesFromChat(
      String chatUid) {
    Stream<QuerySnapshot<Map<String, dynamic>>> messagesSnapshot;
    messagesSnapshot = chatsCollection
        .doc(chatUid)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots();
    return messagesSnapshot;
  }
}

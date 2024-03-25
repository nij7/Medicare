import 'package:bcrud/controllers/firestorePaths.dart';
import 'package:bcrud/models/appuserModel.dart';
import 'package:bcrud/models/chatModel.dart';
import 'package:bcrud/models/messageModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ChatController {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //static final CollectionReference<Appuser> _doctorRef =
  //    _firestore.collection(FirestorePaths.users).withConverter<Appuser>(
  //          fromFirestore: (snapshot, _) => Appuser.fromJson(snapshot.data()!),
  //          toFirestore: (user, _) => user.toJson(),
  //        );
  //static final CollectionReference<Appuser> _usersRef =
  //    _firestore.collection(FirestorePaths.users).withConverter<Appuser>(
  //          fromFirestore: (snapshot, _) => Appuser.fromJson(snapshot.data()!),
  //          toFirestore: (user, _) => user.toJson(),
  //);
  static final CollectionReference<ChatModel> _chatRef = _firestore
      .collection(FirestorePaths.chats)
      .withConverter(
          fromFirestore: (snapshot, _) => ChatModel.fromJson(snapshot.data()!),
          toFirestore: (chat, _) => chat.toJson());

  static getAllUserChats(String uid) async {
    try {
      return await _chatRef
          .where('participants', arrayContains: uid)
          .get()
          .then((v) => v.docs.map((e) => e.exists ? e.data() : null).toList());
    } catch (e) {
      return null;
    }
  }

  static getChatDetails(String chatId) async {
    try {
      return await _chatRef
          .doc(chatId)
          .get()
          .then((v) => v.exists ? v.data() : null);
    } catch (e) {
      return null;
    }
  }

  static getChatIdWith(String uid, String participantId) async {
    try {
      return await _chatRef
          .where('participants', isEqualTo: [uid, participantId])
          .get()
          .then((v) => v.docs[0].id);
      //var dcs = res.docs;
      //var docs = dcs.map((e) => e.exists ? e.data() : null).toList();
      //return 'ok';
    } catch (e) {
      return null;
    }
  }

  static createChatIdWith(
      String uid, String participantId, String title) async {
    try {
      return await _chatRef
          .add(ChatModel(
              title: title,
              updatedAt: DateTime.now(),
              participants: [uid, participantId]))
          .then((v) => v.id);
      //await _chatRef.add({
      //  'title': title,
      //  'participants': [uid, participantId]
      //}).then((v) => v.id);
      //var dcs = res.docs;
      //var docs = dcs.map((e) => e.exists ? e.data() : null).toList();
      //return 'ok';
    } catch (e) {
      return null;
    }
  }

  static sendMessage(String uid, String chatId, String text) async {
    await _chatRef.doc(chatId).update({'updatedAt': DateTime.now()});
    await _chatRef
        .doc(chatId)
        .collection('msgs')
        .add({'text': text, 'createdBy': uid, 'createdAt': Timestamp.now()});
  }

  static nukeAllMsgs(String chatId) async {
    final instance = FirebaseFirestore.instance;
    final batch = instance.batch();
    var snapshots = await _chatRef.doc(chatId).collection('msgs').get();
    for (var doc in snapshots.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  static Stream<QuerySnapshot<Msg>> createMessageStream(String chatId) =>
      _chatRef
          .doc(chatId)
          .collection('msgs')
          .withConverter<Msg>(
              fromFirestore: (snapshot, _) => Msg.fromJson(snapshot.data()!),
              toFirestore: (msg, _) => msg.toJson())
          .orderBy('createdAt', descending: true)
          .snapshots();

  static Stream<QuerySnapshot<ChatModel>> createChatListStream(String uid) =>
      _chatRef
          .withConverter<ChatModel>(
              fromFirestore: (snapshot, _) =>
                  ChatModel.fromJson(snapshot.data()!),
              toFirestore: (chatModel, _) => chatModel.toJson())
          .where('participants', arrayContains: uid)
          .orderBy('updatedAt', descending: true)
          .snapshots();
}

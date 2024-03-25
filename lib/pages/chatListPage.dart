import 'package:bcrud/controllers/chatController.dart';
import 'package:bcrud/controllers/userController.dart';
import 'package:bcrud/core/appColors.dart';
import 'package:bcrud/models/appuserModel.dart';
import 'package:bcrud/models/chatModel.dart';
import 'package:bcrud/pages/chatPage.dart';
import 'package:bcrud/providers/authProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatListPage extends ConsumerStatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends ConsumerState<ChatListPage> {
  late Stream<QuerySnapshot<ChatModel>> _chatListStream;
  @override
  void initState() {
    createChatListStream();
    super.initState();
  }

  createChatListStream() {
    final currentUser = ref.read(currentUserProvider);
    _chatListStream =
        ChatController.createChatListStream(currentUser?.uid ?? '');
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size.width;
    var mqh = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: StreamBuilder<QuerySnapshot<ChatModel>>(
        stream: _chatListStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.data?.docs.length == 0) {
              return const Center(
                child: Text('Start chatting with someone first..'),
              );
            }
            return ListView.builder(
              reverse: true,
              shrinkWrap: true,
              padding: EdgeInsets.all(mq * 0.01),
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (_, i) => ChatListTile(
                chatId: snapshot.data?.docs[i].id ?? '',
                chat: snapshot.data?.docs[i].data() ?? ChatModel(),
              ),
            );
          }
        },
      ),
    );
  }
}

class ChatListTile extends ConsumerStatefulWidget {
  const ChatListTile({Key? key, required this.chatId, required this.chat})
      : super(key: key);
  final ChatModel chat;
  final String chatId;

  @override
  _ChatListTileState createState() => _ChatListTileState();
}

class _ChatListTileState extends ConsumerState<ChatListTile> {
  ChatModel chat = ChatModel();
  bool isGC = false;
  String title = '';
  Appuser user = Appuser();

  @override
  void initState() {
    chat = widget.chat;
    initializeData();
    super.initState();
  }

  initializeData() async {
    final currentUser = ref.read(currentUserProvider);
    chat.participants ??= [];
    var templ = chat.participants?.length ?? 0;
    if (templ > 2) {
      setState(() {
        isGC = true;
        title = chat.title ?? '';
        user = Appuser();
      });
    } else {
      var userId = chat.participants![0] == currentUser?.uid
          ? chat.participants![1]
          : chat.participants![0];
      user = await UserController.getUserDetails(userId) ?? Appuser();
      setState(() {
        isGC = false;
        title = user.name ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //initializeData();
    return ListTile(
      title: Text(title == '' ? '. . .' : title),
      leading: const Icon(Icons.person_rounded),
      iconColor: AppColors.primary,
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => ChatPage(widget.chatId))),
    );
  }
}

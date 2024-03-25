import 'dart:convert';

import 'package:bcrud/controllers/chatController.dart';
import 'package:bcrud/controllers/userController.dart';
import 'package:bcrud/core/appColors.dart';
import 'package:bcrud/core/appdata.dart';
import 'package:bcrud/models/appuserModel.dart';
import 'package:bcrud/models/chatModel.dart';
import 'package:bcrud/models/messageModel.dart';
import 'package:bcrud/providers/authProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage(this.chatId, {Key? key}) : super(key: key);
  final String chatId;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _msgController = TextEditingController();
  FocusNode focusNode = FocusNode();
  bool isLoading = false, isLoadingMsg = false, isGC = false;
  ChatModel chat = ChatModel();
  Appuser user = Appuser();
  String title = '';
  late Stream<QuerySnapshot<Msg>> _mssageStream;
  @override
  void initState() {
    focusNode = FocusNode();
    getChatDetails(widget.chatId);
    createMessageStream();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getChatDetails(String chatId) async {
    try {
      setState(() => isLoading = true);
      final currentUser = ref.read(currentUserProvider);
      chat = await ChatController.getChatDetails(chatId);
      chat.participants ??= [];
      var templ = chat.participants?.length ?? 0;
      if (templ > 2) {
        isGC = true;
        title = chat.title ?? '';
        user = Appuser();
      } else {
        var userId = chat.participants![0] == currentUser?.uid
            ? chat.participants![1]
            : chat.participants![0];
        user = await UserController.getUserDetails(userId) ?? Appuser();
        title = user.name ?? '';
      }
      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  sendMsg() async {
    try {
      FocusScope.of(context).requestFocus(focusNode);
      var tmpvar = _msgController.text;
      _msgController.text = '';
      setState(() => isLoadingMsg = true);
      final currentUser = ref.read(currentUserProvider);
      await ChatController.sendMessage(
          currentUser?.uid ?? '', widget.chatId, tmpvar);
      FocusScope.of(context).requestFocus(focusNode);
      setState(() => isLoadingMsg = false);
    } catch (e) {
      setState(() => isLoadingMsg = false);
    }
  }

  createMessageStream() async {
    _mssageStream = ChatController.createMessageStream(widget.chatId);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.read(currentUserProvider);
    var mq = MediaQuery.of(context).size.width;
    var mqh = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(title),
      ),
      body: isLoading
          ? const LinearProgressIndicator()
          : SizedBox(
              height: mqh,
              width: mq,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      child: StreamBuilder<QuerySnapshot<Msg>>(
                        stream: _mssageStream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else {
                            return ListView.builder(
                              reverse: true,
                              shrinkWrap: true,
                              padding: EdgeInsets.all(mq * 0.01),
                              itemCount: snapshot.data?.docs.length,
                              itemBuilder: (_, i) => ChatBubble(
                                msg: snapshot.data?.docs[i].data() ?? Msg(),
                                currentUser: currentUser ?? Appuser(),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: mqh * 0.05,
                    width: mq,
                    child: ChatInputBox(
                      focusNode: focusNode,
                      controller: _msgController,
                      sendMessage: sendMsg,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  const ChatBubble({Key? key, required this.msg, required this.currentUser})
      : super(key: key);
  final Msg msg;
  final Appuser currentUser;

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size.width;
    bool myMsg = msg.createdBy == currentUser.uid;
    return Container(
      margin: EdgeInsets.all(mq * 0.01),
      alignment: myMsg ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        padding: EdgeInsets.all(mq * 0.01),
        constraints: BoxConstraints(
          minWidth: mq * 0.55,
          maxWidth: mq * 0.8,
        ),
        decoration: BoxDecoration(
            color: myMsg ? AppColors.secondaryAccent : AppColors.primary,
            borderRadius: BorderRadius.circular(mq * 0.02)),
        child: Padding(
          padding: EdgeInsets.all(mq * 0.01),
          child: Column(
            crossAxisAlignment:
                myMsg ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(mq * 0.01),
                child: Text(
                  msg.text ?? '',
                  style:
                      const TextStyle(fontSize: 18, color: AppColors.secondary),
                ),
              ),
              Text(
                '${msg.createdAt?.hour}:${msg.createdAt?.minute}:${msg.createdAt?.second}',
                style:
                    const TextStyle(fontSize: 10, color: AppColors.secondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatInputBox extends StatelessWidget {
  const ChatInputBox({
    Key? key,
    required this.controller,
    required this.sendMessage,
    required this.focusNode,
  }) : super(key: key);
  final TextEditingController controller;
  final VoidCallback sendMessage;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size.width;
    return Row(
      children: [
        SizedBox(
          //height: 200,
          width: mq * 0.85,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              autofocus: true,
              focusNode: focusNode,
              controller: controller,
              onSubmitted: (value) => sendMessage(),
              decoration: const InputDecoration(hintText: 'Message'),
            ),
          ),
        ),
        IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.send,
              color: AppColors.primary,
            ))
      ],
    );
  }
}


/*

String myuid = currentuser?.uid ?? '';


null


*/
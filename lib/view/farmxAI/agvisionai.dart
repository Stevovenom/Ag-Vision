import 'dart:io';
import 'dart:typed_data';

import 'package:agrotech_hackat/view/nav_roots.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';

class AiChatBot extends StatefulWidget {
  const AiChatBot({Key? key}) : super(key: key);

  @override
  State<AiChatBot> createState() => _AiChatBotState();
}

class _AiChatBotState extends State<AiChatBot> {
  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];
  ChatUser currentUser =
      ChatUser(id: "0", firstName: "User", profileImage: "image/user.jpeg");
  ChatUser geminiUser =
      ChatUser(id: "1", firstName: "Gemini", profileImage: "image/gemini.jpg");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.to(() => const NavBarRoots());
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const Text(
          "Agvision AI Chat App",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return DashChat(
      inputOptions: InputOptions(trailing: [
        IconButton(
          onPressed: _sendMediaMessage,
          icon: const Icon(Icons.image),
        ),
      ]),
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });
    try {
      String question = chatMessage.text;
      List<Uint8List>? images;
      if (chatMessage.medias?.isEmpty ?? false) {
        images = [
          File(chatMessage.medias!.first.url).readAsBytesSync(),
        ];
      }
      gemini.streamGenerateContent(question, images: images).listen((event) {
        ChatMessage? lastMessage = messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0);

          String response = event.content?.parts?.fold(
                "",
                (previousValue, currentValue) =>
                    "$previousValue ${currentValue.text}",
              ) ??
              "";
          lastMessage.text += response;
          setState(() {
            messages = [lastMessage!, ...messages];
          });
        } else {
          String response = event.content?.parts?.fold(
                  "",
                  (previousValue, currentValue) =>
                      "$previousValue ${currentValue.text}") ??
              "";
          ChatMessage message = ChatMessage(
              user: geminiUser, createdAt: DateTime.now(), text: response);
          setState(() {
            messages = [message, ...messages];
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void _sendMediaMessage() async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (file != null) {
      ChatMessage chatMessage = ChatMessage(
          user: currentUser,
          createdAt: DateTime.now(),
          text: "Identify the Disease and also Provide some of the precautions",
          medias: [
            ChatMedia(
              url: file.path,
              fileName: "",
              type: MediaType.image,
            ),
          ]);
      _sendMessage(chatMessage);
    }
  }
}

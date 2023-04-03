import 'package:flutter/material.dart';

class ChatBot extends StatefulWidget {
  static const String routeName = '/chatbot';
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Chat Bot'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      
    );
  }
}



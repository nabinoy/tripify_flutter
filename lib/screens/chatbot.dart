import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';

Duration duration = const Duration();
Duration position = const Duration();
bool isPlaying = false;
bool isLoading = false;
bool isPause = false;

class ChatBot extends StatefulWidget {
  static const String routeName = '/chatbot';
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  List<Widget> chatList = [
    const BubbleSpecialTwo(
      text: 'bubble special tow with tail',
      isSender: true,
      color: Color(0xFFE8E8EE),
    ),
    Row(children: [
      Container(
        height: 25,
        width: 25,
        color: Colors.amber,
      ),
      const BubbleSpecialTwo(
        text: 'bubble special tow with tail',
        isSender: false,
        color: Color(0xFF1B97F3),
        textStyle: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    ])
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Chat Bot'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: chatList.map((widget) {
                return widget;
              }).toList(),
            ),
          ),
          MessageBar(
            //messageBarColor: Colors.white,
            onSend: (_) {
              setState(() {
                chatList.add(
                  const BubbleSpecialTwo(
                    text: 'demo chat',
                    isSender: true,
                    color: Color(0xFFE8E8EE),
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}

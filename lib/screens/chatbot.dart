import 'dart:async';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:tripify/services/api_service.dart';

late StreamSubscription<bool> keyboardSubscription;

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
  final _scrollController = ScrollController();

  String chatResponse = '';

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
    ]),
  ];

  @override
  void initState() {
    super.initState();

    var keyboardVisibilityController = KeyboardVisibilityController();

    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (visible) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nameNotifier = ValueNotifier<String>('');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Chat Bot'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: chatList.map((widget) {
                    return widget;
                  }).toList(),
                ),
              ),
            ),
            MessageBar(
              //messageBarColor: Colors.white,
              onTextChanged: (value) {
                nameNotifier.value = value;
              },
              onSend: (_) async {
                HapticFeedback.lightImpact;
                setState(() {
                  chatList.add(
                    BubbleSpecialTwo(
                      tail: false,
                      text: nameNotifier.value,
                      isSender: true,
                      color: const Color(0xFF1B97F3),
                      textStyle:
                          const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  );
                });
                await APIService.askChatBot(nameNotifier.value)
                    .then((value) => {chatResponse = value});
                setState(() {
                  chatList.add(
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 25,
                            width: 25,
                            color: Colors.amber,
                          ),
                          BubbleSpecialTwo(
                            tail: false,
                            text: chatResponse,
                            isSender: false,
                            color: const Color(0xFFE8E8EE),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ]),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

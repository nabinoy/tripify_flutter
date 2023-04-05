import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tripify/services/api_service.dart';

//late StreamSubscription<bool> keyboardSubscription;

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

  List<Widget> chatList = [];

  @override
  void initState() {
    super.initState();
    //var keyboardVisibilityController = KeyboardVisibilityController();

    // keyboardSubscription =
    //     keyboardVisibilityController.onChange.listen((bool visible) {
    //   if (visible) {
    //   }
    // });
  }

  @override
  void dispose() {
    _scrollController.dispose(); //keyboardSubscription.cancel();
    super.dispose();
  }

  // void scrollToLast() {
  //   _scrollController.animateTo(
  //     _scrollController.position.minScrollExtent,
  //     duration: const Duration(milliseconds: 300),
  //     curve: Curves.easeOut,
  //   );
  // }

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
      body: Column(
        // mainAxisSize: MainAxisSize.min,
        //mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              child: ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: chatList.length,
                  itemBuilder: (context, index) {
                    return chatList[index];
                  }),
            ),
          ),
          //Padding(padding: EdgeInsets.symmetric(vertical.: 10)),
          MessageBar(
            //messageBarColor: Colors.white,
            onTextChanged: (value) {
              nameNotifier.value = value;
            },
            onSend: (_) async {
              HapticFeedback.mediumImpact();
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
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
    );
  }
}

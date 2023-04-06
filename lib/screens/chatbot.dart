import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:tripify/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

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
  double typeAnimationHeight = 0;
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
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    controller: _scrollController,
                    shrinkWrap: true,
                    itemCount: chatList.length,
                    itemBuilder: (context, index) {
                      return chatList[index];
                    }),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 0, 10),
            height: typeAnimationHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Container(
                    height: 74,
                    width: 64,
                    color: const Color.fromARGB(255, 212, 212, 214),
                    child: const SpinKitThreeBounce(
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          MessageBar(
            //messageBarColor: Colors.white,
            onTextChanged: (value) {
              nameNotifier.value = value;
            },
            onSend: (_) async {
              HapticFeedback.mediumImpact();
              setState(() {
                typeAnimationHeight = 40;
                chatList.add(
                  BubbleNormal(
                    tail: true,
                    text: nameNotifier.value,
                    isSender: true,
                    color: const Color(0xFF1B97F3),
                    textStyle:
                        const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                );
              });
              await APIService.askChatBot(nameNotifier.value)
                  .then((value) => {chatResponse = value});
              setState(() {
                typeAnimationHeight = 0;
                chatList.add(
                  Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 3.0),
                      child: randomAvatar('saytoonz', height: 32, width: 32),
                    ),
                    Container(
                      color: Colors.transparent,
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * .8),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 2),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFE8E8EE),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 4),
                            child: Html(
                              data: chatResponse,
                              onLinkTap: (String? url, RenderContext context,
                                  Map<String, String> attributes, _) {
                                launchUrl(Uri.parse(url!));
                              },
                            ),
                          ),
                        ),
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

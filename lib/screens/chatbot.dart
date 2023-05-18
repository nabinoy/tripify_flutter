import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
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
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nameNotifier = ValueNotifier<String>('');

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage('assets/images/chatbot_profile.png'),
            ),
            SizedBox(width: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tripy',
                  style: TextStyle(fontSize: 16.0),
                ),
                Text(
                  'Personalized ML assistant',
                  style: TextStyle(fontSize: 12.0),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          (chatList.isEmpty)
              ? Expanded(
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 200,
                          child: Lottie.asset(
                            'assets/lottie/chatbot.json',
                            frameRate: FrameRate.max,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Say",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              " Hi!",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.lightBlue[800],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 200,
                          margin: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * .03),
                        ),
                      ],
                    ),
                  ),
                )
              : Expanded(
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
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: BubbleNormal(
                      tail: true,
                      text: nameNotifier.value,
                      isSender: true,
                      color: const Color(0xFF1B97F3),
                      textStyle:
                          const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                );
              });
              await APIService.askChatBot(nameNotifier.value)
                  .then((value) => {chatResponse = value});
              setState(() {
                typeAnimationHeight = 0;
                chatList.add(
                  Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 3.0),
                      child: CircleAvatar(
                        radius: 16,
                        backgroundImage:
                            AssetImage('assets/images/chatbot_profile.png'),
                      ),
                    ),
                    Container(
                      color: Colors.transparent,
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * .7),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
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

import 'package:flutter/material.dart';

class OnboardModel {
  String img;
  String text;
  String desc;
  Color bg;

  OnboardModel({
    required this.img,
    required this.text,
    required this.desc,
    required this.bg,
  });
}

List<OnboardModel> screens = <OnboardModel>[
  OnboardModel(
    img: "assets/onboard/onboard_image1.json",
    text:
        "Welcome to Tripify! Your One-Stop Shop for Planning Your Dream Vacation!",
    desc:
        "Welcome to our tourism app! We are thrilled to have you on board and ready to explore the world with us.",
    bg: Colors.white,
  ),
  OnboardModel(
    img: "assets/onboard/onboard_image2.json",
    text:
        "Discover Our Featured Destinations: Handpicked for Your Next Adventure!",
    desc:
        "Looking for inspiration for your next vacation? Check out our featured destinations!",
    bg: Colors.white,
  ),
  OnboardModel(
    img: "assets/onboard/onboard_image2.json",
    text: "Personalize Your Interests and Budget!",
    desc:
        "Ready to start planning your trip? Our trip planner makes it easy to create a personalized itinerary that fits your interests and budget.",
    bg: Colors.white,
  ),
];

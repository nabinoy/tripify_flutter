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
    text: "Welcome to Tripify!",
    desc:
        "Get Ready to Be Inspired! Discover Your Dream Destination with Tripify - Your Ultimate Travel Companion.",
    bg: Colors.white,
  ),
  OnboardModel(
    img: "assets/onboard/onboard_image2.json",
    text: "Plan Your Perfect Trip!",
    desc:
        "Design Your Dream Vacation with Ease! Plan Your Perfect Trip with Tripify's User-Friendly Interface. Start planning now!",
    bg: Colors.white,
  ),
  OnboardModel(
    img: "assets/onboard/onboard_image3.json",
    text: "Get Started with Tripify!",
    desc:
        "Begin Your Travel Journey with Tripify - Your Ultimate Guide to Unforgettable Adventures. Let's Get Started Today!",
    bg: Colors.white,
  ),
];

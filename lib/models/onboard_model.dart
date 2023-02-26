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
    text: "Belajar Dengan Metode Learning by Doing",
    desc:
        "Sebuah metode belajar yang terbuktiampuh dalam meningkatkan produktifitas belajar, Learning by Doing. shdsdhsidhihknkr trthrht ",
    bg: Colors.white,
  ),
  OnboardModel(
    img: "assets/onboard/onboard_image2.json",
    text: "Dapatkan Kemudahan Akses Kapanpun dan Dimanapun",
    desc:
        "Tidak peduli dimanapun kamu, semua kursus yang telah kamu ikuti bias kamu akses sepenuhnya",
    bg: Colors.white,
  ),
  OnboardModel(
    img: "assets/onboard/onboard_image2.json",
    text: "Gunakan Fitur Kolaborasi Untuk Pengalaman Lebih",
    desc:
        "Tersedia fitur Kolaborasi dengan tujuan untuk mengasah skill lebih dalam karena bias belajar bersama",
    bg: Colors.white,
  ),
];

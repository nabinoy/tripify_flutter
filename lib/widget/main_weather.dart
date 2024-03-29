import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tripify/models/weather_model.dart';

class MainWeather extends StatefulWidget {
  final String weatherLocationName;
  const MainWeather(this.weatherLocationName, {super.key});

  @override
  State<MainWeather> createState() => _MainWeatherState();
}

class _MainWeatherState extends State<MainWeather> {
  final TextStyle _style1 = const TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 18,
  );

  final TextStyle _style2 = TextStyle(
    fontWeight: FontWeight.w400,
    color: Colors.grey[700],
    fontSize: 14,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 5, 24, 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on_outlined),
              Text(widget.weatherLocationName,
                  style: _style1.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 10.0),
          Text(
            DateFormat.yMMMEd().add_jm().format(DateTime.now()),
            style: _style2,
          ),
          const SizedBox(height: 2.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 90,
                  width: 110,
                  child: Image.network(
                    'http://openweathermap.org/img/wn/$ico@4x.png',
                    fit: BoxFit.cover,
                  )),
              Text(
                temperature,
                style: const TextStyle(
                  fontSize: 75,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 40),
                child: const Text(
                  "°c",
                  style: TextStyle(
                      color: Color.fromARGB(255, 52, 52, 52), fontSize: 24),
                ),
              )
            ],
          ),
          const SizedBox(height: 2.0),
          Text(
            'MAX $tempMax°       MIN $tempMin°',
            style: _style1.copyWith(fontSize: 14),
          ),
          const SizedBox(height: 10.0),
          Text(
            'SUNRISE  $sunrise       SUNSET  $sunset',
            style: _style1.copyWith(fontSize: 12),
          ),
          const SizedBox(height: 5.0),
          Text(
            desc1,
            style: _style1.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 5.0),
          Text(
            desc2,
            style: _style2.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

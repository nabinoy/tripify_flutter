import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tripify/models/weather_model.dart';

class HourForecast extends StatefulWidget {
  const HourForecast({super.key});

  @override
  State<HourForecast> createState() => _HourForecastState();
}

class _HourForecastState extends State<HourForecast> {
  @override
  void dispose() {
    hourForecasts.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 2 * 0.33,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            itemCount: hourForecasts.length,
            itemBuilder: (BuildContext context, int index) {
              Map item = hourForecasts[index];
              return SizedBox(
                width: 100.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('EEE, hh a')
                          .format(DateTime.parse(item['date'])),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 43, 43, 43),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      width: 70,
                      child: Image.network(
                        'http://openweathermap.org/img/wn/${item["ico"]}@4x.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      "${item['temperature']}°c",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

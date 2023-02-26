import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tripify/models/weather_model.dart';

class DayForecast extends StatelessWidget {
  const DayForecast({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            '5 day forecast',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 2 * 0.75,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            itemCount: dayForecasts.length,
            itemBuilder: (BuildContext context, int index) {
              Map item = dayForecasts[index];
              return SizedBox(
                width: 100.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 130,
                      padding: const EdgeInsets.only(left: 6),
                      child: Text(
                        textAlign: TextAlign.center,
                        DateFormat('EEEE').format(DateTime.parse(item['date'])),
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
                    const SizedBox(width: 50),
                    Text(
                      "${item['temperature']}°c",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 40),
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

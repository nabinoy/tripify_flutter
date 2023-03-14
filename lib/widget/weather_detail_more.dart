import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tripify/models/weather_model.dart';

class WeatherDetail extends StatelessWidget {
  const WeatherDetail({super.key});

  Widget _gridWeatherBuilder(String header, String body, IconData icon) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(15),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Colors.lightBlue,
              size: 35,
            ),
            const SizedBox(width: 15.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  child: Text(
                    header,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
                FittedBox(
                  child: Text(
                    body,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 12),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8),
          child: Text(
            'Today details',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 2 * 0.74,
          width: MediaQuery.of(context).size.width,
          child: GridView(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 250,
              childAspectRatio: 2 / 1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            children: [
              _gridWeatherBuilder('$clouds%', 'Clouds', MdiIcons.cloud),
              _gridWeatherBuilder(
                  '${visibility}km', 'Visibility', MdiIcons.eye),
              _gridWeatherBuilder(
                  '$humidity%', 'Humidity', MdiIcons.waterPercent),
              _gridWeatherBuilder('${wind}kmph', 'Wind', MdiIcons.weatherWindy),
              _gridWeatherBuilder(
                  '$feelsLike°c', 'Feels Like', MdiIcons.temperatureCelsius),
              _gridWeatherBuilder(
                  '${pressure}hPa', 'Pressure', MdiIcons.arrowDownCircle),
            ],
          ),
        ),
      ],
    );
  }
}

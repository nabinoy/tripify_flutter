import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:tripify/constants/config.dart';
import 'package:tripify/screens/place.dart';

String weatherLatAPI = '';
String weatherLongAPI = '';

String ico = '';
String desc1 = '';
String desc2 = '';
String placeName = '';
String temperature = '';
String feelsLike = '';
String tempMax = '';
String tempMin = '';
String pressure = '';
String sunrise = '';
String sunset = '';
String wind = '';
double deg = 0.0;
String humidity = '';
String visibility = '';
String clouds = '';

Future<void> getWeatherInfo() async {
  final uri = Uri.parse(
      'http://api.openweathermap.org/data/2.5/weather?lat=$weatherLatAPI&lon=$weatherLongAPI&appid=${Config.weatherAPI}');
  var response = await http.get(uri);
  if (response.statusCode == 200) {
    var weatherData = json.decode(response.body);
    clouds = weatherData['clouds']['all'].toString();
    visibility = (weatherData['visibility'] / 1000).toString();
    placeName = weatherData['name'];
    sunrise = (DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(
            weatherData['sys']['sunrise'] * 1000)))
        .toString();
    sunset = (DateFormat.Hm().format(DateTime.fromMillisecondsSinceEpoch(
            weatherData['sys']['sunset'] * 1000)))
        .toString();
    desc1 = weatherData['weather'][0]['main'].toString();
    desc2 = weatherData['weather'][0]['description'].toString();
    ico = weatherData['weather'][0]['icon'].toString();
    temperatureNotifier.value =
        temperature = (weatherData['main']['temp'] - 273.15).toStringAsFixed(0);
    feelsLike = (weatherData['main']['feels_like'] - 273.15).toStringAsFixed(0);
    tempMin = (weatherData['main']['temp_min'] - 273.15).toStringAsFixed(0);
    tempMax = (weatherData['main']['temp_max'] - 273.15).toStringAsFixed(0);
    humidity = weatherData['main']['humidity'].toString();
    pressure = weatherData['main']['pressure'].toString();
    wind = weatherData['wind']['speed'].toStringAsFixed(1);
    deg = weatherData['wind']['deg'];
  }
}

List<Map<String, String>> hourForecasts = [];
List<Map<String, String>> tempHourForecast = [];

void getPreviousForecastData() {
  hourForecasts = tempHourForecast;
}

Future<void> getForcastInfo() async {
  final uri = Uri.parse(
      'http://api.openweathermap.org/data/2.5/forecast?lat=$weatherLatAPI&lon=$weatherLongAPI&appid=${Config.weatherAPI}');
  var response = await http.get(uri);
  if (response.statusCode == 200) {
    var forecastData = json.decode(response.body);
    hourForecasts.clear();
    for (var i = 2; i < 10; i++) {
      Map<String, String> hourForecast = {};
      hourForecast['ico'] =
          forecastData['list'][i]['weather'][0]['icon'].toString();
      hourForecast['temperature'] =
          (forecastData['list'][i]['main']['temp'] - 273.15).toStringAsFixed(0);
      hourForecast['date'] = forecastData['list'][i]['dt_txt'].toString();
      hourForecasts.add(hourForecast);
    }
    tempHourForecast = hourForecasts;
  }
}

List<Map<String, String>> dayForecasts = [];

Future<void> getDayForcastInfo() async {
  final uri = Uri.parse(
      'http://api.openweathermap.org/data/2.5/forecast?lat=$weatherLatAPI&lon=$weatherLongAPI&appid=${Config.weatherAPI}');
  var response = await http.get(uri);
  if (response.statusCode == 200) {
    var dayforecastData = json.decode(response.body);
    int count = 0;
    for (var i = 2; count < 5; i += 8) {
      Map<String, String> dayForecast = {};
      dayForecast['ico'] =
          dayforecastData['list'][i]['weather'][0]['icon'].toString();
      dayForecast['temperature'] =
          (dayforecastData['list'][i]['main']['temp'] - 273.15)
              .toStringAsFixed(0);
      dayForecast['date'] = dayforecastData['list'][i]['dt_txt'].toString();
      dayForecasts.add(dayForecast);
      count++;
    }
  }
}

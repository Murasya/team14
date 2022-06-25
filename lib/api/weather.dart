import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

// weather response class
// https://developer.yahoo.co.jp/webapi/map/openlocalplatform/v1/weather.html
class Weather {
  // observation or forecast
  final String type;

  // DateTime format
  final DateTime date;

  // [mm/h]
  final double rainfall;

  const Weather({
    required this.type,
    required this.date,
    required this.rainfall,
  });
}

class WeatherResponse {
  final List<Weather> weatherList;

  WeatherResponse(
    this.weatherList,
  );

  // toString
  @override
  String toString() {
    var str = '';
    for (var weather in weatherList) {
      str +=
          'Type:${weather.type}, Date:${weather.date}, Rainfall:${weather.rainfall}\n';
    }
    return str;
  }

  // from response
  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    List<Weather> weatherList = [];
    List<dynamic> listJson =
        json['Feature'][0]['Property']['WeatherList']['Weather'];
    for (var weatherJson in listJson) {
      var weather = Weather(
        type: weatherJson['Type'],
        date: _toDateTime(weatherJson['Date']) ?? DateTime.now(),
        rainfall: weatherJson['Rainfall'],
      );
      weatherList.add(weather);
    }
    return WeatherResponse(weatherList);
  }
}

DateTime? _toDateTime(String timeStr) {
  try {
    final int year = int.parse(timeStr.substring(0, 4));
    final int month = int.parse(timeStr.substring(4, 6));
    final int day = int.parse(timeStr.substring(6, 8));
    final int hour = int.parse(timeStr.substring(8, 10));
    final int minute = int.parse(timeStr.substring(10, 12));

    return DateTime(year, month, day, hour, minute);
  } on RangeError catch (e) {
    print('[RangeError] ${e.message}');
    return null;
  } on FormatException catch (e) {
    print('[FormatException] ${e.message}');
    return null;
  } catch (e) {
    print(e);
    return null;
  }
}

// get weather
Future<WeatherResponse> getWeather({
  required String appId,
  required String coordinates,
  String output = 'json',
  String date = '',
  int past = 0,
  int interval = 10,
}) async {
  // check output type arg
  if (!['xml', 'json'].contains(output)) {
    throw Exception('output type should be xml or json');
  }
  // check interval arg
  if (![10, 5].contains(interval)) {
    throw Exception('interval should be 10 or 5');
  }

  // url
  var url = Uri.parse(
      'https://map.yahooapis.jp/weather/V1/place?coordinates=$coordinates&appid=$appId&output=$output&interval=$interval');
  // get response
  var response = await http.get(url);
  // convert response to List of weather
  var weatherResponse =
      WeatherResponse.fromJson(convert.jsonDecode(response.body));

  if (response.statusCode == 200) {
    return Future<WeatherResponse>.value(weatherResponse);
  } else {
    throw Exception(
        'Failed to get weather, response code : ${response.statusCode}');
  }
}

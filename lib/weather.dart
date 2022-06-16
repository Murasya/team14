import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

// weather response class
// https://developer.yahoo.co.jp/webapi/map/openlocalplatform/v1/weather.html
class Weather {}

class WeatherResponse {
  final String id;
  final String name;
  final String geometryType;
  final String geometryCoordinates;

  // List<Weather> weatherList;

  WeatherResponse(
    this.id,
    this.name,
    this.geometryType,
    this.geometryCoordinates,
  );
}

// get weather
Future<http.Response> getWeather({
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
      'https://map.yahooapis.jp/weather/V1/place?coordinates=$coordinates&appid=$appId');
  // get response
  var response = await http.get(url);

  if (response.statusCode == 200) {
    return Future<http.Response>.value(response);
  } else {
    throw Exception('Failed to get weather');
  }
}

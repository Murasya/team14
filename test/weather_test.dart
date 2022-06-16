import 'package:flutter_test/flutter_test.dart';
import 'package:team14/weather.dart';

void main() async {
  try {
    var jsonResponse = await getWeather(
      appId: 'dj00aiZpPVhBbmd1Q3hQaDdpYSZzPWNvbnN1bWVyc2VjcmV0Jng9Y2Y-',
      coordinates: '139.752686,35.685148',
      output: 'json',
      interval: 10,
    );
    print(jsonResponse);
  } on Exception catch (e) {
    print(e.toString());
  }
}

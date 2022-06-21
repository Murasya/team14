import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:team14/weather.dart';

void main() async {
  // テストコードだとdotenvうごきません
  // await dotenv.load(fileName: '.env');
  // // avoid null-safety check: dotenv.get()
  // String appID = dotenv.get('Y_API');

  String appID = '';

  // 動作確認ずみ
  try {
    var jsonResponse = await getWeather(
      appId: appID,
      coordinates: '139.752686,35.685148',
      output: 'json',
      interval: 10,
    );
    print(jsonResponse);
  } on Exception catch (e) {
    print(e.toString());
  }
}

import 'package:shared_preferences/shared_preferences.dart';

const String keyName = 'defaultTemplate';

class DefaultTemplateProvider {
  DefaultTemplateProvider();

  Future<void> setDefaultTemplateId({required int id}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(keyName, id);
  }

  Future<int?> getDefaultTemplateId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(keyName);
  }
}

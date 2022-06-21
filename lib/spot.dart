import 'dbHelper.dart';

class Spot {
  int? id;
  String title;
  num temperature;
  num gpsLatitude;
  num gpsLongitude;
  int memoTemplateId;
  String textBox;
  List<String> radioButtonList;
  int pullDown;
  DateTime createdAt;
  DateTime updatedAt;

  Spot(
    this.title,
    this.temperature,
    this.gpsLatitude,
    this.gpsLongitude,
    this.memoTemplateId,
    this.textBox,
    this.radioButtonList,
    this.pullDown,
    this.createdAt,
    this.updatedAt,
  );

  Map<String, Object?> toMap() {
    var map = <String, Object>{
      columnTitle: title,
      columnTemperature: temperature,
      columnGpsLatitude: gpsLatitude,
      columnGpsLongitude: gpsLongitude,
      columnMemoTemplateId: memoTemplateId,
      columnTextBox: textBox,
      columnRadioButtonList: radioButtonList.join('\n'),
      columnPullDown: pullDown,
      columnCreatedAt: createdAt.toIso8601String(),
      columnUpdatedAt: updatedAt.toIso8601String(),
    };
    return map;
  }

  Spot.fromMap(Map<String, Object?> map)
      : id = map[columnId] as int,
        title = map[columnTitle] as String,
        temperature = map[columnTemperature] as num,
        gpsLatitude = map[columnGpsLatitude] as num,
        gpsLongitude = map[columnGpsLongitude] as num,
        memoTemplateId = map[columnMemoTemplateId] as int,
        textBox = map[columnTextBox] as String,
        radioButtonList = map[columnRadioButtonList].toString().split('\n'),
        pullDown = map[columnPullDown] as int,
        createdAt = DateTime.parse(map[columnCreatedAt] as String).toLocal(),
        updatedAt = DateTime.parse(map[columnUpdatedAt] as String).toLocal();

  @override
  String toString() =>
      '$id, $title, $temperature, $gpsLatitude, $gpsLongitude, $memoTemplateId, $textBox, $radioButtonList, $pullDown, $createdAt, $updatedAt';

  // For Debug
  void dumpAllColumns() => print(this.toString());
}

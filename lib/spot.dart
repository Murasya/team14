import 'dbHelper.dart';

class Spot {
  int? id;
  String title;
  num temperature;
  num gpsLatitude;
  num gpsLongitude;
  int memoTemplateId;
  String textBox;
  List<String> multipleSelectList; // List of items that are ON
  int singleSelect; // Index of applicable items
  DateTime createdAt;
  DateTime updatedAt;

  Spot(
    this.title,
    this.temperature,
    this.gpsLatitude,
    this.gpsLongitude,
    this.memoTemplateId,
    this.textBox,
    this.multipleSelectList,
    this.singleSelect,
    this.createdAt,
    this.updatedAt,
  );

  Map<String, Object?> toMap() {
    var map = <String, Object>{
      spotColumnTitle: title,
      spotColumnTemperature: temperature,
      spotColumnGpsLatitude: gpsLatitude,
      spotColumnGpsLongitude: gpsLongitude,
      spotColumnMemoTemplateId: memoTemplateId,
      spotColumnTextBox: textBox,
      spotColumnMultipleSelectList: multipleSelectList.join('\n'),
      spotColumnSingleSelect: singleSelect,
      spotColumnCreatedAt: createdAt.toIso8601String(),
      spotColumnUpdatedAt: updatedAt.toIso8601String(),
    };
    return map;
  }

  Spot.fromMap(Map<String, Object?> map)
      : id = map[spotColumnId] as int,
        title = map[spotColumnTitle] as String,
        temperature = map[spotColumnTemperature] as num,
        gpsLatitude = map[spotColumnGpsLatitude] as num,
        gpsLongitude = map[spotColumnGpsLongitude] as num,
        memoTemplateId = map[spotColumnMemoTemplateId] as int,
        textBox = map[spotColumnTextBox] as String,
        multipleSelectList =
            map[spotColumnMultipleSelectList].toString().split('\n'),
        singleSelect = map[spotColumnSingleSelect] as int,
        createdAt =
            DateTime.parse(map[spotColumnCreatedAt] as String).toLocal(),
        updatedAt =
            DateTime.parse(map[spotColumnUpdatedAt] as String).toLocal();

  @override
  String toString() =>
      '$id, $title, $temperature, $gpsLatitude, $gpsLongitude, $memoTemplateId, $textBox, ${multipleSelectList.join('/')}, $singleSelect, $createdAt, $updatedAt';

  // For Debug
  void dumpAllColumns() => print(this.toString());
}

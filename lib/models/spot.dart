import 'dbHelper.dart';

class Spot {
  int? id;
  String title;
  num temperature;
  num gpsLatitude;
  num gpsLongitude;
  int memoTemplateId;
  String? textBox;
  List<bool>? multipleSelectList; // List of items on/off
  int? singleSelect; // Index of applicable items
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
    var map = <String, Object?>{
      spotColumnTitle: title,
      spotColumnTemperature: temperature,
      spotColumnGpsLatitude: gpsLatitude,
      spotColumnGpsLongitude: gpsLongitude,
      spotColumnMemoTemplateId: memoTemplateId,
      spotColumnTextBox: textBox,
      spotColumnMultipleSelectList: multipleSelectList
          ?.map((value) => value == true ? 1 : 0)
          .toList()
          .join('\n'),
      spotColumnSingleSelect: singleSelect,
      spotColumnCreatedAt: createdAt.toIso8601String(),
      spotColumnUpdatedAt: updatedAt.toIso8601String(),
    };
    if (multipleSelectList != null && multipleSelectList!.isEmpty) {
      map[spotColumnMultipleSelectList] = null;
    }
    return map;
  }

  Spot.fromMap(Map<String, Object?> map)
      : id = map[spotColumnId] as int,
        title = map[spotColumnTitle] as String,
        temperature = map[spotColumnTemperature] as num,
        gpsLatitude = map[spotColumnGpsLatitude] as num,
        gpsLongitude = map[spotColumnGpsLongitude] as num,
        memoTemplateId = map[spotColumnMemoTemplateId] as int,
        textBox = map[spotColumnTextBox] as String?,
        multipleSelectList = map[spotColumnMultipleSelectList]
            ?.toString()
            .split('\n')
            .map((value) => value == '1' ? true : false)
            .toList(),
        singleSelect = map[spotColumnSingleSelect] as int?,
        createdAt =
            DateTime.parse(map[spotColumnCreatedAt] as String).toLocal(),
        updatedAt =
            DateTime.parse(map[spotColumnUpdatedAt] as String).toLocal();

  @override
  String toString() =>
      '$id, $title, $temperature, $gpsLatitude, $gpsLongitude, $memoTemplateId, $textBox, ${multipleSelectList?.join('/')}, $singleSelect, $createdAt, $updatedAt';

  // For Debug
  void dumpAllColumns() => print(this.toString());
}

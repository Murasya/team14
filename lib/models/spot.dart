import 'dbHelper.dart';

class Spot {
  int? id;
  String title;
  DateTime weatherObsDate;
  List<double> rainfallList;
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
    this.weatherObsDate,
    this.rainfallList,
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
      spotColumnWeatherObsDate: weatherObsDate.toIso8601String(),
      spotColumnRainfallList: rainfallList.join('\n'),
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
        weatherObsDate =
            DateTime.parse(map[spotColumnWeatherObsDate] as String).toLocal(),
        rainfallList = map[spotColumnRainfallList]
            .toString()
            .split('\n')
            .map((e) => double.parse(e))
            .toList(),
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
      '$id, $title, $weatherObsDate, ${rainfallList.join('/')}, $gpsLatitude, $gpsLongitude, $memoTemplateId, $textBox, ${multipleSelectList?.join('/')}, $singleSelect, $createdAt, $updatedAt';

  // For Debug
  void dumpAllColumns() => print(this.toString());
}

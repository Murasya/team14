import 'dbHelper.dart';

class Memo {
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

  Memo(
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
      memoColumnTitle: title,
      memoColumnWeatherObsDate: weatherObsDate.toIso8601String(),
      memoColumnRainfallList: rainfallList.join('\n'),
      memoColumnGpsLatitude: gpsLatitude,
      memoColumnGpsLongitude: gpsLongitude,
      memoColumnMemoTemplateId: memoTemplateId,
      memoColumnTextBox: textBox,
      memoColumnMultipleSelectList: multipleSelectList
          ?.map((value) => value == true ? 1 : 0)
          .toList()
          .join('\n'),
      memoColumnSingleSelect: singleSelect,
      memoColumnCreatedAt: createdAt.toIso8601String(),
      memoColumnUpdatedAt: updatedAt.toIso8601String(),
    };
    if (multipleSelectList != null && multipleSelectList!.isEmpty) {
      map[memoColumnMultipleSelectList] = null;
    }
    return map;
  }

  Memo.fromMap(Map<String, Object?> map)
      : id = map[memoColumnId] as int,
        title = map[memoColumnTitle] as String,
        weatherObsDate =
            DateTime.parse(map[memoColumnWeatherObsDate] as String).toLocal(),
        rainfallList = map[memoColumnRainfallList]
            .toString()
            .split('\n')
            .map((e) => double.parse(e))
            .toList(),
        gpsLatitude = map[memoColumnGpsLatitude] as num,
        gpsLongitude = map[memoColumnGpsLongitude] as num,
        memoTemplateId = map[memoColumnMemoTemplateId] as int,
        textBox = map[memoColumnTextBox] as String?,
        multipleSelectList = map[memoColumnMultipleSelectList]
            ?.toString()
            .split('\n')
            .map((value) => value == '1' ? true : false)
            .toList(),
        singleSelect = map[memoColumnSingleSelect] as int?,
        createdAt =
            DateTime.parse(map[memoColumnCreatedAt] as String).toLocal(),
        updatedAt =
            DateTime.parse(map[memoColumnUpdatedAt] as String).toLocal();

  @override
  String toString() =>
      '$id, $title, $weatherObsDate, ${rainfallList.join('/')}, $gpsLatitude, $gpsLongitude, $memoTemplateId, ${textBox?.replaceAll('\n', ' ')}, ${multipleSelectList?.join('/')}, $singleSelect, $createdAt, $updatedAt';

  // For Debug
  void dumpAllColumns() => print(this.toString());
}

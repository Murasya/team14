const String columnId = '_id';
const String columnTitle = 'title';
const String columnTemperature = 'temperature';
const String columnGpsLatitude = 'gps_latitude';
const String columnGpsLongitude = 'gps_longitude';
const String columnMemo = 'memo';
const String columnCreatedAt = 'created_at';
const String columnUpdatedAt = 'updated_at';

class Spot {
  int? id;
  String title;
  num temperature;
  num gpsLatitude;
  num gpsLongitude;
  String memo;
  DateTime createdAt;
  DateTime updatedAt;

  Spot(
    this.title,
    this.temperature,
    this.gpsLatitude,
    this.gpsLongitude,
    this.memo,
    this.createdAt,
    this.updatedAt,
  );

  Map<String, Object?> toMap() {
    var map = <String, Object>{
      columnTitle: title,
      columnTemperature: temperature,
      columnGpsLatitude: gpsLatitude,
      columnGpsLongitude: gpsLongitude,
      columnMemo: memo,
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
        memo = map[columnMemo] as String,
        createdAt = DateTime.parse(map[columnCreatedAt] as String).toLocal(),
        updatedAt = DateTime.parse(map[columnUpdatedAt] as String).toLocal();

  // For Debug
  void dumpAllColumns() {
    print(
        '$id: $title, $temperature, $gpsLatitude, $gpsLongitude, $memo, $createdAt, $updatedAt');
  }
}

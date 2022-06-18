const String columnId = '_id';
const String columnTitle = 'title';
const String columnTemperature = 'temperature';
const String columnGpsPosition = 'gps_position';
const String columnMemo = 'memo';
const String columnCreatedAt = 'created_at';
const String columnUpdatedAt = 'updated_at';

class Spot {
  int id;
  String title;
  num temperature;
  String gpsPosition;
  String memo;
  DateTime createdAt;
  DateTime updatedAt;

  Spot(
    this.id,
    this.title,
    this.temperature,
    this.gpsPosition,
    this.memo,
    this.createdAt,
    this.updatedAt,
  );

  Map<String, Object?> toMap() {
    var map = <String, Object>{
      columnId: id,
      columnTitle: title,
      columnTemperature: temperature,
      columnGpsPosition: gpsPosition,
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
        gpsPosition = map[columnGpsPosition] as String,
        memo = map[columnMemo] as String,
        createdAt = DateTime.parse(map[columnCreatedAt] as String).toLocal(),
        updatedAt = DateTime.parse(map[columnUpdatedAt] as String).toLocal();

  // For Debug
  void dumpAllColumns() {
    print(
        '$id: $title, $temperature, $gpsPosition, $memo, $createdAt, $updatedAt');
  }
}

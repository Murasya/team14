const String columnId = '_id';
const String columnTitle = 'title';
const String columnTemperature = 'temperature';
const String columnGpsPosition = 'gpsPosition';
const String columnMemo = 'memo';
const String columnCreatedAt = 'createdAt';
const String columnUpdatedAt = 'updatedAt';

class Spot {
  int id;
  String title;
  num temperature;
  String gpsPosition;
  String memo;
  String createdAt;
  String updatedAt;

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
      columnCreatedAt: createdAt,
      columnUpdatedAt: updatedAt,
    };
    return map;
  }

  Spot.fromMap(Map<String, Object?> map)
      : id = map[columnId] as int,
        title = map[columnTitle] as String,
        temperature = map[columnTemperature] as num,
        gpsPosition = map[columnGpsPosition] as String,
        memo = map[columnMemo] as String,
        createdAt = map[columnCreatedAt] as String,
        updatedAt = map[columnUpdatedAt] as String;

  // For Debug
  void dumpAllColumns() {
    print(
        '$id: $title, $temperature, $gpsPosition, $memo, $createdAt, $updatedAt');
  }
}

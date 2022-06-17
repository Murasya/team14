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
}

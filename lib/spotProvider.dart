import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'spot.dart';

const String dbName = 'memo-app.db';
const String tableName = 'spot';

class SpotProvider {
  late Database db;

  SpotProvider() {
    _open();
  }

  Future _open() async {
    final dbDirectory = await getApplicationSupportDirectory();
    final dbFilePath = dbDirectory.path;
    db = await openDatabase(join(dbFilePath, dbName), version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableName (
  $columnId integer primary key autoincrement,
  $columnTitle text not null,
  $columnTemperature real not null,
  $columnGpsLatitude real not null,
  $columnGpsLongitude real not null,
  $columnMemo text not null,
  $columnCreatedAt text not null,
  $columnUpdatedAt text not null)
''');
    });
  }

  Future<int> insert(Spot spot) async {
    return await db.insert(tableName, spot.toMap());
  }

  Future<List<Spot>> selectAll() async {
    final maps = await db.query(
      tableName,
      orderBy: '$columnId DESC',
    );
    if (maps.isEmpty) return [];
    return maps.map((map) => Spot.fromMap(map)).toList();
  }

  Future<int> update(Spot spot) async {
    return await db.update(tableName, spot.toMap(),
        where: '$columnId = ?', whereArgs: [spot.id]);
  }

  Future<int> delete(int id) async {
    return await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  Future close() async => db.close();
}

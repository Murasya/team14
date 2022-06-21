import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dbHelper.dart';
import 'spot.dart';

class SpotProvider {
  Future<Database> _open() async {
    return await openHelper();
  }

  Future<int> insert(Spot spot) async {
    final db = await _open();
    return await db.insert(tableName, spot.toMap());
  }

  Future<List<Spot>> selectAll() async {
    final db = await _open();
    final maps = await db.query(
      tableName,
      orderBy: '$columnId DESC',
    );
    if (maps.isEmpty) return [];
    return maps.map((map) => Spot.fromMap(map)).toList();
  }

  Future<int> update(Spot spot) async {
    final db = await _open();
    return await db.update(tableName, spot.toMap(),
        where: '$columnId = ?', whereArgs: [spot.id]);
  }

  Future<int> delete(int id) async {
    final db = await _open();
    return await db.delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  Future shareAsCsvFromDB({String fileName = 'latest_db.csv'}) async {
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/$fileName';
    var file = File(filePath);
    String fileContents =
        '$columnId, $columnTitle, $columnTemperature, $columnGpsLatitude, $columnGpsLongitude, $columnMemoTemplateId, $columnTextBox, $columnRadioButtonList, $columnPullDown, $columnCreatedAt, $columnUpdatedAt\n';
    await selectAll().then((spots) => fileContents += spots.join('\n'));
    await file.writeAsString(fileContents);
    Share.shareFiles([filePath]);
  }

  Future close() async {
    final db = await _open();
    db.close();
  }
}

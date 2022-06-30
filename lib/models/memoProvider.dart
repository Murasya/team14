import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dbHelper.dart';
import 'memo.dart';

class MemoProvider {
  Future<Database> _open() async {
    return await openHelper();
  }

  Future<int> insert(Memo memo) async {
    final db = await _open();
    return await db.insert(memoTableName, memo.toMap());
  }

  Future<Memo?> selectMemo(int id) async {
    final db = await _open();
    final maps = await db.query(
      memoTableName,
      where: '$memoColumnId = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Memo.fromMap(maps.first);
  }

  Future<List<Memo>> selectMemoWithinSameTemplate(int templateId) async {
    final db = await _open();
    final maps = await db.query(
      memoTableName,
      where: '$memoColumnMemoTemplateId = ?',
      whereArgs: [templateId],
    );
    if (maps.isEmpty) return [];
    return maps.map((map) => Memo.fromMap(map)).toList();
  }

  Future<List<Memo>> selectAll() async {
    final db = await _open();
    final maps = await db.query(
      memoTableName,
      orderBy: '$memoColumnId DESC',
    );
    if (maps.isEmpty) return [];
    return maps.map((map) => Memo.fromMap(map)).toList();
  }

  Future<int> update(Memo memo) async {
    final db = await _open();
    return await db.update(memoTableName, memo.toMap(),
        where: '$memoColumnId = ?', whereArgs: [memo.id]);
  }

  Future<int> delete(int id) async {
    final db = await _open();
    return await db
        .delete(memoTableName, where: '$memoColumnId = ?', whereArgs: [id]);
  }

  Future shareAsCsvFromDB({String fileName = 'latest_db.csv'}) async {
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/$fileName';
    var file = File(filePath);
    String fileContents =
        '$memoColumnId, $memoColumnTitle, $memoColumnWeatherObsDate, $memoColumnRainfallList, $memoColumnGpsLatitude, $memoColumnGpsLongitude, $memoColumnMemoTemplateId, $memoColumnTextBox, $memoColumnMultipleSelectList, $memoColumnSingleSelect, $memoColumnCreatedAt, $memoColumnUpdatedAt\n';
    await selectAll().then((memos) => fileContents += memos.join('\n'));
    await file.writeAsString(fileContents);
    Share.shareFiles([filePath]);
  }

  Future close() async {
    final db = await _open();
    db.close();
  }
}

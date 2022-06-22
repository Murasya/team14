import 'package:sqflite/sqflite.dart';
import 'dbHelper.dart';
import 'memoTemplate.dart';

class MemoTemplateProvider {
  Future<Database> _open() async {
    return await openHelper();
  }

  Future<int> insert(MemoTemplate memoTemplate) async {
    final db = await _open();
    return await db.insert(memoTemplateTableName, memoTemplate.toMap());
  }

  Future<MemoTemplate?> selectLatestMemoTemplate() async {
    final db = await _open();
    final maps = await db.query(
      memoTemplateTableName,
      orderBy: '$memoTemplateColumnId DESC',
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return MemoTemplate.fromMap(maps.first);
  }

  Future<List<MemoTemplate>> selectAll() async {
    final db = await _open();
    final maps = await db.query(
      memoTemplateTableName,
      orderBy: '$memoTemplateColumnId DESC',
    );
    if (maps.isEmpty) return [];
    return maps.map((map) => MemoTemplate.fromMap(map)).toList();
  }

  /// CAUTION: If a field is updated when it has child records,
  /// the consistency will be broken.
  /// Therefore, the following is used when there are no child records.
  // Future<int> update(MemoTemplate memoTemplate) async {
  //   final db = await _open();
  //   return await db.update(memoTemplateTableName, memoTemplate.toMap(),
  //       where: '$memoTemplateColumnId = ?', whereArgs: [memoTemplate.id]);
  // }

  Future<int> delete(int id) async {
    final db = await _open();
    return await db.delete(memoTemplateTableName,
        where: '$memoTemplateColumnId = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await _open();
    db.close();
  }
}

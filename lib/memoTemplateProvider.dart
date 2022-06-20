import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'memoTemplate.dart';

const String dbName = 'memo-app.db';
const String memoTemplateTableName = 'memo_template';

class MemoTemplateProvider {
  Future<Database> _open() async {
    final dbDirectory = await getApplicationSupportDirectory();
    final dbFilePath = dbDirectory.path;
    return await openDatabase(join(dbFilePath, dbName), version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $memoTemplateTableName (
  $memoTemplateColumnId integer primary key autoincrement,
  $memoTemplateColumnName text unique not null,
  $memoTemplateColumnTextBox integer not null,
  $memoTemplateColumnRadioButtonList text not null,
  $memoTemplateColumnPullDownList text not null)
''');
    });
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

  Future<int> update(MemoTemplate memoTemplate) async {
    final db = await _open();
    return await db.update(memoTemplateTableName, memoTemplate.toMap(),
        where: '$memoTemplateColumnId = ?', whereArgs: [memoTemplate.id]);
  }

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

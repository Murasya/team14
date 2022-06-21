import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'memoTemplate.dart';
import 'spot.dart';

const String dbName = 'memo-app.db';
const String memoTemplateTableName = 'memo_template';
const String tableName = 'spot';

Future<Database> openHelper() async {
  final dbDirectory = await getApplicationSupportDirectory();
  final dbFilePath = dbDirectory.path;
  return await openDatabase(join(dbFilePath, dbName), version: 1,
      onConfigure: (Database db) async {
    await db.execute('pragma foreign_keys = ON');
  }, onCreate: (Database db, int version) async {
    await db.execute('''
create table $memoTemplateTableName (
  $memoTemplateColumnId integer primary key autoincrement,
  $memoTemplateColumnName text unique not null,
  $memoTemplateColumnTextBox integer not null,
  $memoTemplateColumnRadioButtonList text not null,
  $memoTemplateColumnPullDownList text not null)
''');
    await db.execute('''
create table $tableName (
  $columnId integer primary key autoincrement,
  $columnTitle text not null,
  $columnTemperature real not null,
  $columnGpsLatitude real not null,
  $columnGpsLongitude real not null,
  $columnMemoTemplateId integer references $memoTemplateTableName($memoTemplateColumnId) on delete restrict,
  $columnTextBox text not null,
  $columnRadioButtonList text not null,
  $columnPullDown integer not null,
  $columnCreatedAt text not null,
  $columnUpdatedAt text not null)
''');
  });
}

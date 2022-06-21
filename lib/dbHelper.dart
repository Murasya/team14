import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

const String dbName = 'memo-app.db';

// memo template table
const String memoTemplateTableName = 'memo_template';
const String memoTemplateColumnId = '_id';
const String memoTemplateColumnName = 'name';
const String memoTemplateColumnTextBox = 'text_box';
const String memoTemplateColumnRadioButtonList = 'radio_button_list';
const String memoTemplateColumnPullDownList = 'pull_down_list';

// spot table
const String tableName = 'spot';
const String columnId = '_id';
const String columnTitle = 'title';
const String columnTemperature = 'temperature';
const String columnGpsLatitude = 'gps_latitude';
const String columnGpsLongitude = 'gps_longitude';
const String columnMemoTemplateId = 'memo_template_id';
const String columnTextBox = 'text_box';
const String columnRadioButtonList = 'radio_button_list';
const String columnPullDown = 'pull_down';
const String columnCreatedAt = 'created_at';
const String columnUpdatedAt = 'updated_at';

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

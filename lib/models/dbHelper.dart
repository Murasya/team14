import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

const String dbName = 'memo-app.db';

// memo template table
const String memoTemplateTableName = 'memo_template';
const String memoTemplateColumnId = '_id';
const String memoTemplateColumnName = 'name';
const String memoTemplateColumnTextBox = 'text_box';
const String memoTemplateColumnMultipleSelectList = 'multiple_select_list';
const String memoTemplateColumnSingleSelectList = 'single_select_list';

// memo table
const String memoTableName = 'memo';
const String memoColumnId = '_id';
const String memoColumnTitle = 'title';
const String memoColumnWeatherObsDate = 'weather_obs_date';
const String memoColumnRainfallList = 'rainfall_list';
const String memoColumnGpsLatitude = 'gps_latitude';
const String memoColumnGpsLongitude = 'gps_longitude';
const String memoColumnMemoTemplateId = 'memo_template_id';
const String memoColumnTextBox = 'text_box';
const String memoColumnMultipleSelectList = 'multiple_select_list';
const String memoColumnSingleSelect = 'single_select';
const String memoColumnCreatedAt = 'created_at';
const String memoColumnUpdatedAt = 'updated_at';

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
  $memoTemplateColumnMultipleSelectList text,
  $memoTemplateColumnSingleSelectList text)
''');
    await db.execute('''
create table $memoTableName (
  $memoColumnId integer primary key autoincrement,
  $memoColumnTitle text not null,
  $memoColumnWeatherObsDate text not null,
  $memoColumnRainfallList text not null,
  $memoColumnGpsLatitude real not null,
  $memoColumnGpsLongitude real not null,
  $memoColumnMemoTemplateId integer references $memoTemplateTableName($memoTemplateColumnId) on delete restrict,
  $memoColumnTextBox text,
  $memoColumnMultipleSelectList text,
  $memoColumnSingleSelect integer,
  $memoColumnCreatedAt text not null,
  $memoColumnUpdatedAt text not null)
''');
  });
}

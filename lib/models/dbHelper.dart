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

// spot table
const String spotTableName = 'spot';
const String spotColumnId = '_id';
const String spotColumnTitle = 'title';
const String spotColumnWeatherObsDate = 'weather_obs_date';
const String spotColumnRainfallList = 'rainfall_list';
const String spotColumnGpsLatitude = 'gps_latitude';
const String spotColumnGpsLongitude = 'gps_longitude';
const String spotColumnMemoTemplateId = 'memo_template_id';
const String spotColumnTextBox = 'text_box';
const String spotColumnMultipleSelectList = 'multiple_select_list';
const String spotColumnSingleSelect = 'single_select';
const String spotColumnCreatedAt = 'created_at';
const String spotColumnUpdatedAt = 'updated_at';

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
  $memoTemplateColumnMultipleSelectList text not null,
  $memoTemplateColumnSingleSelectList text not null)
''');
    await db.execute('''
create table $spotTableName (
  $spotColumnId integer primary key autoincrement,
  $spotColumnTitle text not null,
  $spotColumnWeatherObsDate text not null,
  $spotColumnRainfallList text not null,
  $spotColumnGpsLatitude real not null,
  $spotColumnGpsLongitude real not null,
  $spotColumnMemoTemplateId integer references $memoTemplateTableName($memoTemplateColumnId) on delete restrict,
  $spotColumnTextBox text,
  $spotColumnMultipleSelectList text,
  $spotColumnSingleSelect integer,
  $spotColumnCreatedAt text not null,
  $spotColumnUpdatedAt text not null)
''');
  });
}

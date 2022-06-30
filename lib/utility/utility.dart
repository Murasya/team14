import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:team14/models/dbHelper.dart';
import 'package:team14/models/memoTemplate.dart';
import 'package:team14/models/memo.dart';

final memoColumns = [
  memoColumnId,
  memoColumnTitle,
  memoColumnWeatherObsDate,
  memoColumnRainfallList,
  memoColumnGpsLatitude,
  memoColumnGpsLongitude,
  memoColumnMemoTemplateId,
  memoColumnTextBox,
  memoColumnMultipleSelectList,
  memoColumnSingleSelect,
  memoColumnCreatedAt,
  memoColumnUpdatedAt,
];

Future shareAsCsv({
  String fileName = 'latest_db.csv',
  required List<MemoTemplate> memoTemplates,
  required List<Memo> memos,
}) async {
  final directory = await getTemporaryDirectory();
  final filePath = '${directory.path}/$fileName';
  final file = File(filePath);
  final fileContents = '${memoColumns.join(',')}\n${memos.join('\n')}';

  await file.writeAsString(fileContents);
  Share.shareFiles([filePath]);
}

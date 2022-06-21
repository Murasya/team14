import 'dbHelper.dart';

class MemoTemplate {
  int? id;
  String name;
  bool textBox;
  Set<String> multipleSelectList; // Each element is a unique item.
  Set<String>
      singleSelectList; // The first element is the title, and the rest are unique items.

  MemoTemplate(
    this.name,
    this.textBox,
    this.multipleSelectList,
    this.singleSelectList,
  );

  Map<String, Object?> toMap() {
    var map = <String, Object>{
      memoTemplateColumnName: name,
      memoTemplateColumnTextBox: textBox == true ? 1 : 0,
      memoTemplateColumnMultipleSelectList: multipleSelectList.join('\n'),
      memoTemplateColumnSingleSelectList: singleSelectList.join('\n'),
    };
    return map;
  }

  MemoTemplate.fromMap(Map<String, Object?> map)
      : id = map[memoTemplateColumnId] as int,
        name = map[memoTemplateColumnName] as String,
        textBox = map[memoTemplateColumnTextBox] == 1,
        multipleSelectList = map[memoTemplateColumnMultipleSelectList]
            .toString()
            .split('\n')
            .toSet(),
        singleSelectList = map[memoTemplateColumnSingleSelectList]
            .toString()
            .split('\n')
            .toSet();

  @override
  String toString() =>
      '$id, $name, $textBox, $multipleSelectList, $singleSelectList';

  // For Debug
  void dumpAllColumns() => print(this.toString());
}

const String memoTemplateColumnId = '_id';
const String memoTemplateColumnName = 'name';
const String memoTemplateColumnTextBox = 'text_box';
const String memoTemplateColumnRadioButtonList = 'radio_button_list';
const String memoTemplateColumnPullDownList = 'pull_down_list';

class MemoTemplate {
  int? id;
  String name;
  bool textBox;
  List<String> radioButtonList;
  List<String> pullDownList;

  MemoTemplate(
    this.name,
    this.textBox,
    this.radioButtonList,
    this.pullDownList,
  );

  Map<String, Object?> toMap() {
    var map = <String, Object>{
      memoTemplateColumnName: name,
      memoTemplateColumnTextBox: textBox == true ? 1 : 0,
      memoTemplateColumnRadioButtonList: radioButtonList.join('\n'),
      memoTemplateColumnPullDownList: pullDownList.join('\n'),
    };
    return map;
  }

  MemoTemplate.fromMap(Map<String, Object?> map)
      : id = map[memoTemplateColumnId] as int,
        name = map[memoTemplateColumnName] as String,
        textBox = map[memoTemplateColumnTextBox] == 1,
        radioButtonList =
            map[memoTemplateColumnRadioButtonList].toString().split('\n'),
        pullDownList =
            map[memoTemplateColumnPullDownList].toString().split('\n');

  @override
  String toString() =>
      '$id, $name, $textBox, $radioButtonList, $pullDownList';

  // For Debug
  void dumpAllColumns() => print(this.toString());
}

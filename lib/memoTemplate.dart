const String memoTemplateColumnId = '_id';
const String memoTemplateColumnName = 'name';
const String memoTemplateColumnTextBox = 'text_box';
const String memoTemplateColumnRadioButtonLists = 'radio_button_lists';
const String memoTemplateColumnPullDownLists = 'pull_down_lists';

class MemoTemplate {
  int? id;
  String name;
  bool textBox;
  List<String> radioButtonLists;
  List<String> pullDownLists;

  MemoTemplate(
    this.name,
    this.textBox,
    this.radioButtonLists,
    this.pullDownLists,
  );

  Map<String, Object?> toMap() {
    var map = <String, Object>{
      memoTemplateColumnName: name,
      memoTemplateColumnTextBox: textBox == true ? 1 : 0,
      memoTemplateColumnRadioButtonLists: radioButtonLists.join('\n'),
      memoTemplateColumnPullDownLists: pullDownLists.join('\n'),
    };
    return map;
  }

  MemoTemplate.fromMap(Map<String, Object?> map)
      : id = map[memoTemplateColumnId] as int,
        name = map[memoTemplateColumnName] as String,
        textBox = map[memoTemplateColumnTextBox] == 1,
        radioButtonLists =
            map[memoTemplateColumnRadioButtonLists].toString().split('\n'),
        pullDownLists =
            map[memoTemplateColumnPullDownLists].toString().split('\n');

  @override
  String toString() =>
      '$id, $name, $textBox, $radioButtonLists, $pullDownLists';

  // For Debug
  void dumpAllColumns() => print(this.toString());
}

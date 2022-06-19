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

  @override
  String toString() =>
      '$id, $name, $textBox, $radioButtonLists, $pullDownLists';

  // For Debug
  void dumpAllColumns() => print(this.toString());
}

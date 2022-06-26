import 'package:flutter/material.dart';
import 'package:team14/views/common_widgets.dart';
import 'package:team14/views/detail_helper.dart';
import 'package:team14/models/memoTemplate.dart';

class TemplateDetailPage extends StatefulWidget {
  const TemplateDetailPage({Key? key, required this.memoTemplate})
      : super(key: key);

  final String title = 'テンプレート詳細';

  final MemoTemplate memoTemplate;

  @override
  State<TemplateDetailPage> createState() => _TemplateDetailPageState();
}

class _TemplateDetailPageState extends State<TemplateDetailPage> {
  Widget createListView({required list}) {
    List<Widget> widgets = [
      listItem('テンプレート名', list.name),
      listItem('テキストボックスの利用', list.textBox ? 'あり' : 'なし'),
    ];
    if (list.multipleSelectList.isNotEmpty) {
      widgets.addAll(
          getListWidget(list: list.multipleSelectList, leftName: 'チェックボックス'));
    } else {
      widgets.add(listItem('チェックボックスの利用', 'なし'));
    }
    if (list.singleSelectList.isNotEmpty) {
      widgets.addAll(
          getListWidget(list: list.singleSelectList, leftName: 'プルダウン'));
    } else {
      widgets.add(listItem('プルダウンの利用', 'なし'));
    }

    return ListView(children: widgets);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: 'メモ詳細', context: context),
      body: createListView(list: widget.memoTemplate),
      drawer: myDrawer(context),
    );
  }
}

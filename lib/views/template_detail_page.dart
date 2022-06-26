import 'package:flutter/material.dart';
import 'package:team14/views/common_widgets.dart';
import 'package:team14/views/detail_helper.dart';
import 'package:team14/models/memoTemplate.dart';
import 'package:team14/models/memoTemplateProvider.dart';

class TemplateDetailPage extends StatefulWidget {
  const TemplateDetailPage({Key? key, required this.id}) : super(key: key);

  final String title = 'テンプレート詳細';

  final int id;

  @override
  State<TemplateDetailPage> createState() => _TemplateDetailPageState();
}

class _TemplateDetailPageState extends State<TemplateDetailPage> {
  late MemoTemplateProvider mtp = MemoTemplateProvider();
  late Future<MemoTemplate?> memoTemplate;

  @override
  void initState() {
    super.initState();
    memoTemplate = mtp.selectMemoTemplate(widget.id);
  }

  Widget createListView({required list}){
    List<Widget> widgets = [
      listItem('テンプレート名', list.name),
      listItem(
          'テキストボックスの利用', list.textBox ? 'はい' : 'いいえ'),
    ];
    if (list.multipleSelectList.isNotEmpty){
      widgets.addAll(getListWidget(list: list.multipleSelectList, leftName: 'チェックボックス'));
    }
    if (list.singleSelectList.isNotEmpty){
      widgets.addAll(getListWidget(list: list.singleSelectList, leftName: 'プルダウン'));
    }
    return ListView(
        children: widgets
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: 'メモ詳細', context: context),
      body: FutureBuilder(
          future: memoTemplate,
          builder: (BuildContext context,
              AsyncSnapshot<MemoTemplate?> snapshot,) {
            if (snapshot.hasData) {
              return createListView(list: snapshot.data!);
            }
            else{
              return const Text('テンプレートが存在しません');
            }
          }
      ),
      drawer: myDrawer(context),);
  }
}

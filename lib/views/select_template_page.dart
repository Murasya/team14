import 'dart:async';

import 'package:flutter/material.dart';

import 'package:team14/views/common_widgets.dart';
import 'package:team14/views/list_helper.dart';
import 'package:team14/views/template_detail_page.dart';
import 'package:team14/models/memoTemplate.dart';
import 'package:team14/models/memoTemplateProvider.dart';
import 'package:team14/models/defaultTemplateProvider.dart';

class SelectTemplatePage extends StatefulWidget {
  const SelectTemplatePage({Key? key}) : super(key: key);

  @override
  State<SelectTemplatePage> createState() => _SelectTemplatePageState();
}

class _SelectTemplatePageState extends State<SelectTemplatePage> {
  late Future<List<MemoTemplate>> templateList;
  late MemoTemplateProvider mtp = MemoTemplateProvider();

  // テンプレid
  late DefaultTemplateProvider dtp = DefaultTemplateProvider();

  @override
  void initState() {
    super.initState();
    templateList = mtp.selectAll();
  }

  void onTapContent(MemoTemplate data) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return TemplateDetailPage(memoTemplate: data);
        },
      ),
    );
  }

  // Delete memo, update memoList
  Future<void> _deleteTemplate(int id) async {
    Map<int, String> warningDialogMap = {
      1: 'このテンプレートはデフォルトに登録されています',
      2: 'このテンプレートはメモで使われています',
    };
    int errorCode = 0;
    runZonedGuarded(() async {
      var defaultTemplate = await dtp.getDefaultTemplateId();
      if (id == defaultTemplate) {
        errorCode = 1;
        throw 'This template is registered as default';
      }
      await mtp.delete(id);
      setState(() {
        templateList = mtp.selectAll();
      });
    }, (e, s) {
      print('[Error] $e');

      String errorMsg =
      errorCode == 1 ? warningDialogMap[1]! : warningDialogMap[2]!;
      showDialog(
        context: context,
        builder: (_) {
          return WarningDialog(
            text: errorMsg,
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: 'テンプレート一覧', context: context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create_template_page');
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        padding: myPadding(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FutureBuilder(
                future: templateList,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<MemoTemplate>> snapshot,
                ) {
                  if (snapshot.data == null) {
                    // Fetching data from DB.
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.data!.isEmpty) {
                    // Nothing Template.
                    Future(() {
                      Navigator.pushNamed(context, '/create_template_page');
                    });
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    // Found Template.
                    if (snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              onTap: () {
                                onTapContent(snapshot.data!.elementAt(index));
                              },
                              leading: const Icon(Icons.square_outlined),
                              title: Text(snapshot.data![index].name),
                              trailing: IconButton(
                                icon: const Icon(Icons.info_outlined),
                                onPressed: () async {
                                  final action = await showDialog(
                                    context: context,
                                    builder: (_) {
                                      return const ActionDialog(
                                        uniqueAction: '登録',
                                      );
                                    },
                                  );
                                  if (action != null) {
                                    var defaultTemplate =
                                        await dtp.getDefaultTemplateId();
                                    if (action == '削除') {
                                      // 削除対象が登録済みでなければ削除OK
                                      _deleteTemplate(snapshot.data![index].id!);
                                    } else if (action == '登録') {
                                      defaultTemplate =
                                          snapshot.data![index].id!;
                                      dtp.setDefaultTemplateId(
                                          id: defaultTemplate);
                                    }
                                  } else {
                                    print('not touched delete!');
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: Text('メモテンプレートがまだ作成されていません'),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
      drawer: myDrawer(context),
    );
  }
}

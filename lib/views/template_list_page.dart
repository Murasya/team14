import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:team14/views/common_widgets.dart';
import 'package:team14/views/list_helper.dart';
import 'package:team14/views/template_detail_page.dart';
import 'package:team14/models/memoTemplate.dart';
import 'package:team14/models/memoTemplateProvider.dart';
import 'package:team14/models/defaultTemplateProvider.dart';

class TemplateListPage extends StatefulWidget {
  const TemplateListPage({Key? key}) : super(key: key);

  @override
  State<TemplateListPage> createState() => _TemplateListPageState();
}

class _TemplateListPageState extends State<TemplateListPage> {
  late Future<List<MemoTemplate>> templateList;
  int? defaultTemplateId;
  late MemoTemplateProvider mtp = MemoTemplateProvider();

  // テンプレid
  DefaultTemplateProvider dtp = DefaultTemplateProvider();

  Future<List<MemoTemplate>> initProcess() async {
    // fetch default template id and memo template data.
    defaultTemplateId = await dtp.getDefaultTemplateId();
    templateList = mtp.selectAll();

    return templateList;
  }

  @override
  void initState() {
    super.initState();
    initProcess();
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

  Future<void> _updateDefaultTemplateId(int id) async {
    await dtp.setDefaultTemplateId(id: id);
    setState(() {
      defaultTemplateId = id;
    });
    Fluttertoast.showToast(
      msg: 'テンプレートに登録しました！',
      gravity: ToastGravity.TOP,
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
      Fluttertoast.showToast(
        msg: 'テンプレートを削除しました',
        gravity: ToastGravity.TOP,
      );
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

  Color getBackGroundColor(int id) {
    const colorPalletNum = 5;
    late Color color;

    // like pastel
    switch (id % colorPalletNum) {
      case 0:
        color = const Color(0xFFFFBCA6);
        break;
      case 1:
        color = const Color(0xFFFF9E9E);
        break;
      case 2:
        color = const Color(0xFFFFF5CC);
        break;
      case 3:
        color = const Color(0xFFFFE0AB);
        break;
      case 4:
        color = const Color(0xFFEB8FA6);
        break;
      default:
        print('$id is invalid!');
        color = const Color(0xFF7F7F7F);
        break;
    }
    return color;
  }

  Widget activeCheckBoxIcon(int memoTemplateId) {
    if (defaultTemplateId == null || defaultTemplateId != memoTemplateId) {
      return const Icon(Icons.square_outlined);
    } else {
      return const Icon(Icons.check_box_outlined);
    }
  }

  TextStyle activeTextStyle(int memoTemplateId) {
    if (defaultTemplateId == null || defaultTemplateId != memoTemplateId) {
      return const TextStyle(fontWeight: FontWeight.normal);
    } else {
      return const TextStyle(fontWeight: FontWeight.bold);
    }
  }

  Widget memoTemplateCardWithGesture(MemoTemplate memoTemplate) {
    return GestureDetector(
      onTap: () {
        onTapContent(memoTemplate);
      },
      onLongPress: () => _updateDefaultTemplateId(memoTemplate.id!),
      child: Card(
        color: getBackGroundColor(memoTemplate.id!),
        shadowColor: Colors.indigo,
        child: ListTile(
          leading: activeCheckBoxIcon(memoTemplate.id!),
          title: Text(
            memoTemplate.name,
            style: activeTextStyle(memoTemplate.id!),
          ),
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
                if (action == '削除') {
                  // 削除対象が登録済みでなければ削除OK
                  _deleteTemplate(memoTemplate.id!);
                } else if (action == '登録') {
                  await _updateDefaultTemplateId(memoTemplate.id!);
                }
              } else {
                print('not touched delete!');
              }
            },
          ),
        ),
      ),
    );
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
                future: initProcess(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<MemoTemplate>> snapshot,
                ) {
                  if (snapshot.data == null) {
                    // Fetching data from DB.
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.data!.isNotEmpty) {
                    // Found Template.
                    return ListView(
                      children: [
                        for (MemoTemplate mt in snapshot.data!)
                          memoTemplateCardWithGesture(mt),
                      ],
                    );
                  } else {
                    // Nothing Template.
                    return const Center(
                      child: Text('メモテンプレートがまだ作成されていません'),
                    );
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

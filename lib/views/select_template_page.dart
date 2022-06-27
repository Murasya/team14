import 'package:flutter/material.dart';
import 'package:team14/views/common_widgets.dart';
import 'package:team14/views/list_helper.dart';
import 'package:team14/views/create_memo_page.dart';
import 'package:team14/models/memoTemplate.dart';
import 'package:team14/models/memoTemplateProvider.dart';

class SelectTemplatePage extends StatefulWidget {
  const SelectTemplatePage({Key? key}) : super(key: key);

  @override
  State<SelectTemplatePage> createState() => _SelectTemplatePageState();
}

class _SelectTemplatePageState extends State<SelectTemplatePage> {
  late Future<List<MemoTemplate>> templateList;
  late MemoTemplateProvider mtp = MemoTemplateProvider();

  @override
  void initState() {
    super.initState();
    templateList = mtp.selectAll();
  }

  Future<void> onTapContent(int index) async {
    var isCreateMemo = await showDialog(
      context: context,
      builder: (_) {
        return const CreateMemoDialog();
      },
    );
    if (isCreateMemo) {
      return Future(() {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return CreateMemoPage(templateMemoId: index);
            },
          ),
        );
      });
    }
  }

  // Delete memo, update memoList
  void deleteTemplate(int id) {
    setState(() {
      mtp.delete(id);
      templateList = mtp.selectAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: 'テンプレート選択', context: context),
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
                                onTapContent(
                                    snapshot.data!.elementAt(index).id!);
                              },
                              leading: const Icon(Icons.square_outlined),
                              title: Text(snapshot.data![index].name),
                              trailing: IconButton(
                                icon: const Icon(Icons.info_outlined),
                                onPressed: () async {
                                  // TODO: 編集・更新は未実装
                                  // 削除ポップアップ
                                  final isDelete = await showDialog(
                                    context: context,
                                    builder: (_) {
                                      return const DeleteDialog();
                                    },
                                  );
                                  if (isDelete != null) {
                                    deleteTemplate(snapshot.data![index].id!);
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

// メモ作成ダイアログ
class CreateMemoDialog extends StatelessWidget {
  const CreateMemoDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('このテンプレートでメモを作成しますか？'),
      actions: <Widget>[
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: const Text('いいえ'),
          ),
          onTap: () {
            Navigator.pop(context, false);
          },
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: const Text('はい'),
          ),
          onTap: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }
}

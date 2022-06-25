import 'package:flutter/material.dart';

import 'package:team14/models/memoTemplate.dart';
import 'package:team14/models/memoTemplateProvider.dart';
import 'package:team14/views/common_widgets.dart';

class SelectTemplatePage extends StatefulWidget {
  const SelectTemplatePage({Key? key}) : super(key: key);

  final String title = 'テンプレート選択';

  @override
  State<SelectTemplatePage> createState() => _SelectTemplatePageState();
}

class _SelectTemplatePageState extends State<SelectTemplatePage> {
  Future<List<MemoTemplate>>? templateList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    templateList = MemoTemplateProvider().selectAll();
  }

  // リスト更新
  void deleteTemplate(int id) {
    setState(() {
      MemoTemplateProvider().delete(id);
      templateList = MemoTemplateProvider().selectAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(widget.title),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO
          // メモテンプレ作成画面に遷移
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: FutureBuilder(
                future: templateList,
                builder: (BuildContext context,
                    AsyncSnapshot<List<MemoTemplate>> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text('テンプレートがありません'),
                    );
                  } else {
                    // DBにデータがある場合
                    if (snapshot.data!.isNotEmpty) {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              onTap: () async {
                                var isCreateMemo;
                                isCreateMemo = await showDialog(
                                  context: context,
                                  builder: (_) {
                                    return CreateMemoDialog();
                                  },
                                );
                                if (isCreateMemo != null) {
                                  if (isCreateMemo) {
                                    // TODO
                                    // メモ作成画面に遷移
                                  }
                                }
                              },
                              leading: const Icon(
                                Icons.square_outlined,
                              ),
                              title: Text(snapshot.data![index].name),
                              trailing: IconButton(
                                icon: const Icon(Icons.info_outlined),
                                onPressed: () async {
                                  // TODO
                                  // 削除ポップアップ、編集・更新は未実装
                                  var isDelete;
                                  isDelete = await showDialog(
                                    context: context,
                                    builder: (_) {
                                      return DeleteMemoTemplateDialog();
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

// メモ削除ダイアログ
class DeleteMemoTemplateDialog extends StatefulWidget {
  const DeleteMemoTemplateDialog({Key? key}) : super(key: key);

  @override
  State<DeleteMemoTemplateDialog> createState() =>
      _DeleteMemoTemplateDialogState();
}

class _DeleteMemoTemplateDialogState extends State<DeleteMemoTemplateDialog> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('アクション'),
      children: [
        Container(
          padding: const EdgeInsets.all(5.0),
          child: SimpleDialogOption(
            child: const Text('削除'),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        )
      ],
    );
  }
}

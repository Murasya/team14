import 'package:flutter/material.dart';

import 'package:team14/models/spotProvider.dart';
import 'package:team14/models/spot.dart';
import 'package:team14/views/common_widgets.dart';

class MemoListPage extends StatefulWidget {
  const MemoListPage({Key? key}) : super(key: key);
  final String title = 'テンプレート選択';
  @override
  State<MemoListPage> createState() => _MemoListPageState();
}

class _MemoListPageState extends State<MemoListPage> {
  Future<List<Spot>>? memoList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    memoList = SpotProvider().selectAll();
  }

  // リスト更新
  void deleteMemo(int id) {
    setState(() {
      SpotProvider().delete(id);
      memoList = SpotProvider().selectAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: widget.title, context: context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO
          // メモ作成画面に遷移
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
                future: memoList,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Spot>> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text('メモがありません'),
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
                                // TODO
                                // メモ詳細に遷移
                              },
                              leading: const Icon(
                                Icons.description,
                              ),
                              title: Text(snapshot.data![index].title),
                              trailing: IconButton(
                                icon: const Icon(Icons.info_outlined),
                                onPressed: () async {
                                  // 削除ポップアップ
                                  var isDelete;
                                  isDelete = await showDialog(
                                    context: context,
                                    builder: (_) {
                                      return DeleteMemoDialog();
                                    },
                                  );
                                  if (isDelete != null) {
                                    deleteMemo(snapshot.data![index].id!);
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: Text('メモがまだ作成されていません'),
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



// メモ削除ダイアログ
class DeleteMemoDialog extends StatefulWidget {
  const DeleteMemoDialog({Key? key}) : super(key: key);

  @override
  State<DeleteMemoDialog> createState() =>
      _DeleteMemoDialogState();
}

class _DeleteMemoDialogState extends State<DeleteMemoDialog> {
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

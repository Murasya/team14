import 'package:flutter/material.dart';
import 'package:team14/views/common_widgets.dart';
import 'package:team14/views/list_helper.dart';
import 'package:team14/models/spot.dart';
import 'package:team14/models/spotProvider.dart';

class MemoListPage extends StatefulWidget {
  const MemoListPage({Key? key}) : super(key: key);

  @override
  State<MemoListPage> createState() => _MemoListPageState();
}

class _MemoListPageState extends State<MemoListPage> {
  late Future<List<Spot>> memoList;
  late SpotProvider sp = SpotProvider();

  @override
  void initState() {
    super.initState();
    memoList = sp.selectAll();
  }

  void onTapContent() {
    // TODO
    // メモ詳細に遷移
  }

  // Delete memo, update memoList
  void deleteMemo(int id) {
    setState(() {
      sp.delete(id);
      memoList = sp.selectAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: 'メモ一覧', context: context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO
          // メモ作成画面に遷移
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
                future: memoList,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<List<Spot>> snapshot,
                ) {
                  if (snapshot.hasData == false) {
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
                              onTap: onTapContent,
                              leading: const Icon(Icons.description),
                              title: Text(snapshot.data![index].title),
                              trailing: IconButton(
                                icon: const Icon(Icons.info_outlined),
                                onPressed: () async {
                                  // 削除ポップアップ
                                  final isDelete = await showDialog(
                                    context: context,
                                    builder: (_) {
                                      return const DeleteDialog();
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
      drawer: myDrawer(context),
    );
  }
}

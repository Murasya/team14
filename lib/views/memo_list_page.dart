import 'package:flutter/material.dart';

import 'package:team14/views/common_widgets.dart';
import 'package:team14/views/list_helper.dart';
import 'package:team14/views/memo_detail_page.dart';
import 'package:team14/views/edit_memo_page.dart';
import 'package:team14/models/memoTemplate.dart';
import 'package:team14/models/memo.dart';
import 'package:team14/models/memoTemplateProvider.dart';
import 'package:team14/models/memoProvider.dart';

class MemoListPage extends StatefulWidget {
  const MemoListPage({Key? key}) : super(key: key);

  @override
  State<MemoListPage> createState() => _MemoListPageState();
}

class _MemoListPageState extends State<MemoListPage> {
  late Future<List<Memo>> memoList;
  late MemoProvider mp = MemoProvider();

  @override
  void initState() {
    super.initState();
    memoList = mp.selectAll();
  }

  Future<void> onTapContent({required Memo memo}) async {
    MemoTemplateProvider mtp = MemoTemplateProvider();
    MemoTemplate mt = (await mtp.selectMemoTemplate(memo.memoTemplateId))!;
    Future(() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return MemoDetailPage(memoTemplate: mt, memo: memo);
          },
        ),
      );
    });
  }

  // Delete memo, update memoList
  void deleteMemo(int id) {
    setState(() {
      mp.delete(id);
      memoList = mp.selectAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: 'メモ一覧', context: context),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // メモ作成画面に遷移
          Future(() {
            Navigator.pushNamed(context, '/create_memo_page');
          });
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
                  AsyncSnapshot<List<Memo>> snapshot,
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
                              onTap: () {
                                onTapContent(
                                    memo: snapshot.data!.elementAt(index));
                              },
                              leading: const Icon(Icons.description),
                              title: Text(snapshot.data![index].title),
                              trailing: IconButton(
                                icon: const Icon(Icons.info_outlined),
                                onPressed: () async {
                                  // アクションポップアップ
                                  final action = await showDialog(
                                    context: context,
                                    builder: (_) {
                                      return const ActionDialog(
                                        uniqueAction: '編集',
                                      );
                                    },
                                  );
                                  if (action != null) {
                                    // is削除
                                    if (action == '削除') {
                                      deleteMemo(snapshot.data![index].id!);
                                    } else if (action == '編集') {
                                      // is編集
                                      if (!mounted) return;
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return EditMemoPage(
                                                id: snapshot.data![index].id!);
                                          },
                                        ),
                                      );
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

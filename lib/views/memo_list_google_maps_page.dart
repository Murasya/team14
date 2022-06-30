import 'dart:async';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:team14/views/common_widgets.dart';
import 'package:team14/views/list_helper.dart';
import 'package:team14/views/memo_detail_page.dart';
import 'package:team14/views/edit_memo_page.dart';
import 'package:team14/models/memoTemplate.dart';
import 'package:team14/models/memo.dart';
import 'package:team14/models/memoTemplateProvider.dart';
import 'package:team14/models/memoProvider.dart';

class MemoListGoogleMapsPage extends StatefulWidget {
  const MemoListGoogleMapsPage({Key? key}) : super(key: key);

  @override
  State<MemoListGoogleMapsPage> createState() => _MemoListGoogleMapsPageState();
}

class _MemoListGoogleMapsPageState extends State<MemoListGoogleMapsPage> {
  late Future<List<Memo>> memoList;
  late MemoProvider mp = MemoProvider();
  late Set<Marker> markers;
  CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(35.6851793, 139.7506108),
    zoom: 0,
  );
  Completer<GoogleMapController> controller = Completer();

  @override
  void initState() {
    super.initState();
    memoList = mp.selectAll();
  }

  // マーカーの作成
  void getInitialMarkers({required List<Memo> memoList}) {
    markers = {};
    for (var memo in memoList) {
      var _marker = Marker(
        markerId: MarkerId(memo.updatedAt.toString()),
        position:
        LatLng(memo.gpsLatitude.toDouble(), memo.gpsLongitude.toDouble()),
      );
      markers.add(_marker);
    }
  }
  void getMarkers({required List<Memo> memoList}) {
    setState(() {
      markers = {};
      for (var memo in memoList) {
        var _marker = Marker(
          markerId: MarkerId(memo.updatedAt.toString()),
          position:
              LatLng(memo.gpsLatitude.toDouble(), memo.gpsLongitude.toDouble()),
        );
        markers.add(_marker);
      }
    });
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

  // GoogleMap
  Widget getGoogleMap() {
    return GoogleMap(
      mapType: MapType.normal,
      myLocationButtonEnabled: false,
      initialCameraPosition: initialCameraPosition,
      markers: markers,
      onMapCreated: controller.complete,
    );
  }

  // ListViewer、見ずらいので抜き出し
  Widget getMemoListViewer(snapshot) {
    return ListView.builder(
      itemCount: snapshot.data!.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            onTap: () {
              onTapContent(memo: snapshot.data!.elementAt(index));
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
                    getMarkers(memoList: snapshot.data!);
                  } else if (action == '編集') {
                    // is編集
                    if (!mounted) return;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return EditMemoPage(id: snapshot.data![index].id!);
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
                getInitialMarkers(memoList: snapshot.data!);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: getGoogleMap()),
                    Expanded(child: getMemoListViewer(snapshot)),
                  ],
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
      drawer: myDrawer(context),
    );
  }
}

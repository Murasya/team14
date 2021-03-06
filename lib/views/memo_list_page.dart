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

class MemoListPage extends StatefulWidget {
  const MemoListPage({Key? key}) : super(key: key);

  @override
  State<MemoListPage> createState() => _MemoListPageState();
}

class _MemoListPageState extends State<MemoListPage> {
  late Future<List<Memo>> memoList;
  final MemoProvider mp = MemoProvider();
  late Set<Marker> markers;
  GoogleMapController? mapController;
  final CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(35.6851793, 139.7506108), // Imperial Palace
    zoom: 14,
  );

  @override
  void initState() {
    super.initState();
    memoList = mp.selectAll();
  }

  void createMarkers({required List<Memo> memoList}) {
    markers = memoList
        .map((memo) => Marker(
              markerId: MarkerId(memo.id!.toString()),
              position: LatLng(
                memo.gpsLatitude.toDouble(),
                memo.gpsLongitude.toDouble(),
              ),
            ))
        .toSet();
  }

  Future<void> onTapContent({required Memo memo}) async {
    MemoTemplateProvider mtp = MemoTemplateProvider();
    MemoTemplate mt = (await mtp.selectMemoTemplate(memo.memoTemplateId))!;
    Future(() {
      Navigator.pop(context);
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

  void toEditView(int memoId) {
    Future(() {
      Navigator.pop(context);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return EditMemoPage(id: memoId);
          },
        ),
      );
    });
  }

  Widget memoCardWithGesture(Memo memo) {
    return GestureDetector(
      onTap: () {
        onTapContent(memo: memo);
      },
      onLongPress: () {
        mapController?.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(
                memo.gpsLatitude.toDouble(),
                memo.gpsLongitude.toDouble(),
              ),
              zoom: 14),
        ));
      },
      child: Card(
        child: ListTile(
          leading: IconButton(
            icon: const Icon(Icons.description),
            onPressed: () {
              toEditView(memo.id!);
            },
          ),
          title: Text(memo.title),
          trailing: IconButton(
            icon: const Icon(Icons.info_outlined),
            onPressed: () async {
              final action = await showDialog(
                context: context,
                builder: (_) {
                  return const ActionDialog(
                    uniqueAction: '??????',
                  );
                },
              );
              if (action != null) {
                if (action == '??????') {
                  // ????????????????????????????????????????????????OK
                  deleteMemo(memo.id!);
                } else if (action == '??????') {
                  toEditView(memo.id!);
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
      appBar: myAppBar(title: '????????????', context: context),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // ???????????????????????????
          Future(() {
            Navigator.pop(context);
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
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.data!.isNotEmpty) {
              // Found Template.
              createMarkers(memoList: snapshot.data!);
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      padding: myPadding(),
                      child: GoogleMap(
                        mapType: MapType.normal,
                        myLocationButtonEnabled: false,
                        initialCameraPosition: initialCameraPosition,
                        markers: markers,
                        onMapCreated: (controller) {
                          setState(() {
                            mapController = controller;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        for (Memo memo in snapshot.data!)
                          memoCardWithGesture(memo),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              // Nothing Template.
              return const Center(
                child: Text('????????????????????????????????????????????????????????????'),
              );
            }
          },
        ),
      ),
      drawer: myDrawer(context),
    );
  }
}

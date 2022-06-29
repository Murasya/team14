import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import 'package:team14/views/common_widgets.dart';
import 'package:team14/views/detail_helper.dart';
import 'package:team14/views/memo_detail_page.dart';
import 'package:team14/models/memoTemplate.dart';
import 'package:team14/models/memo.dart';

class MemoGoogleMapsPage extends StatefulWidget {
  const MemoGoogleMapsPage({
    Key? key,
    required this.memoTemplate,
    required this.memo,
  }) : super(key: key);

  final MemoTemplate memoTemplate;
  final Memo memo;

  @override
  State<MemoGoogleMapsPage> createState() => _MemoGoogleMapsPageState();
}

class _MemoGoogleMapsPageState extends State<MemoGoogleMapsPage> {
  @override
  Widget build(BuildContext context) {
    // map controller
    Completer<GoogleMapController> controller = Completer();

    // 初期位置
    final Position initialPosition = Position(
      latitude: widget.memo.gpsLatitude.toDouble(),
      longitude: widget.memo.gpsLongitude.toDouble(),
      timestamp: widget.memo.updatedAt,
      altitude: 0,
      accuracy: 0,
      heading: 0,
      floor: null,
      speed: 0,
      speedAccuracy: 0,
    );

    // 初期表示座標のMarkerを設定
    final initialMarkers = {
      Marker(
        markerId: MarkerId(initialPosition.timestamp.toString()),
        position: LatLng(initialPosition.latitude, initialPosition.longitude),
      ),
    };

    return Scaffold(
      appBar: myAppBar(title: 'メモ詳細', context: context),
      body: Container(
        padding: myPadding(),
        child: Column(children: [
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              myLocationButtonEnabled: false,
              initialCameraPosition: CameraPosition(
                target:
                    LatLng(initialPosition.latitude, initialPosition.longitude),
                zoom: 14.4746,
              ),
              markers: initialMarkers,
              onMapCreated: controller.complete,
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                listItem('タイトル', widget.memo.title),
                listItem('位置情報',
                    '${widget.memo.gpsLatitude}, ${widget.memo.gpsLongitude}'),
                // Includes data on precipitation up to one hour ahead.
                // for (var i = 0; i < widget.memo.rainfallList.length; i++)
                //   listItem(
                //       '降水量(${widget.memo.weatherObsDate.add(Duration(minutes: 60 ~/ (widget.memo.rainfallList.length - 1) * i))})',
                //       '${widget.memo.rainfallList.elementAt(i)}'),
                listItem('降水量', '${widget.memo.rainfallList.first}'),
                if (widget.memoTemplate.textBox)
                  listItem('テキスト', '${widget.memo.textBox}'),
                for (var i = 0;
                    i < widget.memoTemplate.multipleSelectList.length;
                    i++)
                  listItem(widget.memoTemplate.multipleSelectList.elementAt(i),
                      widget.memo.multipleSelectList![i] ? 'はい' : 'いいえ'),
                if (widget.memoTemplate.singleSelectList.isNotEmpty)
                  listItem(
                      widget.memoTemplate.singleSelectList.first,
                      widget.memoTemplate.singleSelectList
                          .elementAt(widget.memo.singleSelect!)),
              ],
            ),
          ),
        ]),
      ),
      drawer: myDrawer(context),
      floatingActionButton: IconButton(
        icon: const Icon(Icons.list),
        onPressed: () {
          Future(() {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return MemoDetailPage(
                      memoTemplate: widget.memoTemplate, memo: widget.memo);
                },
              ),
            );
          });
        },
      ),
    );
  }
}

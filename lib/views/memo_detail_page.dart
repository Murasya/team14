import 'package:flutter/material.dart';
import 'package:team14/views/common_widgets.dart';
import 'package:team14/views/detail_helper.dart';
import 'package:team14/models/memoTemplate.dart';
import 'package:team14/models/spot.dart';

class MemoDetailPage extends StatefulWidget {
  const MemoDetailPage({
    Key? key,
    required this.memoTemplate,
    required this.spot,
  }) : super(key: key);

  final MemoTemplate memoTemplate;
  final Spot spot;

  @override
  State<MemoDetailPage> createState() => _MemoDetailPageState();
}

class _MemoDetailPageState extends State<MemoDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: 'メモ詳細', context: context),
      body: ListView(
        children: [
          listItem('タイトル', widget.spot.title),
          listItem('位置情報',
              '${widget.spot.gpsLatitude}, ${widget.spot.gpsLongitude}'),
          // Includes data on precipitation up to one hour ahead.
          for (var i = 0; i < widget.spot.rainfallList.length; i++)
            listItem(
                '降水量(${widget.spot.weatherObsDate.add(Duration(minutes: 60 ~/ (widget.spot.rainfallList.length - 1) * i))})',
                '${widget.spot.rainfallList.elementAt(i)}'),
          if (widget.memoTemplate.textBox)
            listItem('テキスト', '${widget.spot.textBox}'),
          for (var i = 0;
              i < widget.memoTemplate.multipleSelectList.length;
              i++)
            listItem(widget.memoTemplate.multipleSelectList.elementAt(i),
                widget.spot.multipleSelectList![i] ? 'はい' : 'いいえ'),
          if (widget.memoTemplate.singleSelectList.isNotEmpty)
            listItem(
                widget.memoTemplate.singleSelectList.first,
                widget.memoTemplate.singleSelectList
                    .elementAt(widget.spot.singleSelect!)),
        ],
      ),
      drawer: myDrawer(context),
    );
  }
}

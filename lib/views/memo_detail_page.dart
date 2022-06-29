import 'package:flutter/material.dart';
import 'package:team14/views/common_widgets.dart';
import 'package:team14/views/detail_helper.dart';
import 'package:team14/views/memo_google_maps_page.dart';
import 'package:team14/models/memoTemplate.dart';
import 'package:team14/models/memo.dart';

class MemoDetailPage extends StatefulWidget {
  const MemoDetailPage({
    Key? key,
    required this.memoTemplate,
    required this.memo,
  }) : super(key: key);

  final MemoTemplate memoTemplate;
  final Memo memo;

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
          listItem('タイトル', widget.memo.title),
          listItem('位置情報',
              '${widget.memo.gpsLatitude}, ${widget.memo.gpsLongitude}'),
          // Includes data on precipitation up to one hour ahead.
          for (var i = 0; i < widget.memo.rainfallList.length; i++)
            listItem(
                '降水量(${widget.memo.weatherObsDate.add(Duration(minutes: 60 ~/ (widget.memo.rainfallList.length - 1) * i))})',
                '${widget.memo.rainfallList.elementAt(i)}'),
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
      drawer: myDrawer(context),
      floatingActionButton: IconButton(
        icon: const Icon(Icons.map),
        onPressed: () {
          Future(() {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return MemoGoogleMapsPage(memoTemplate: widget.memoTemplate, memo: widget.memo);
                },
              ),
            );
          });
        },
      ),
    );
  }
}

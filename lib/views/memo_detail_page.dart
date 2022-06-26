import 'package:flutter/material.dart';
import 'package:team14/views/common_widgets.dart';
import 'package:team14/views/detail_helper.dart';
import 'package:team14/models/memoTemplate.dart';
import 'package:team14/models/spot.dart';

class MemoDetailPage extends StatefulWidget {
  const MemoDetailPage({Key? key, required this.memoTemplate, required this.spot}) : super(key: key);

  final MemoTemplate memoTemplate;
  final Spot spot;

  @override
  State<MemoDetailPage> createState() => _MemoDetailPageState();
}

class _MemoDetailPageState extends State<MemoDetailPage> {
  // MemoTemplate mt = MemoTemplate(
  //     'template',
  //     true,
  //     {'駐輪しやすい', '受け取り待機時間なし', '店員の態度がいい'},
  //     {'オファー金額', '800~1000円', '1000~1200円'});
  // Spot spot = Spot("マクドナルド 石橋店", 21.0, 34.807805, 135.444553, 1, "近くにチェーン店がある",
  //     [true, true, true], 0, DateTime.now(), DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: 'メモ詳細', context: context),
      body: ListView(
        children: [
          listItem('タイトル', widget.spot.title),
          listItem('位置情報', '${widget.spot.gpsLatitude}, ${widget.spot.gpsLongitude}'),
          listItem('気温', '${widget.spot.temperature}'),
          if (widget.memoTemplate.textBox) listItem('テキスト', '${widget.spot.textBox}'),
          for (var i = 0; i < widget.memoTemplate.multipleSelectList.length; i++)
            listItem(widget.memoTemplate.multipleSelectList.elementAt(i),
                widget.spot.multipleSelectList![i] ? 'はい' : 'いいえ'),
          if (widget.memoTemplate.singleSelectList.isNotEmpty)
            listItem(widget.memoTemplate.singleSelectList.first,
                widget.memoTemplate.singleSelectList.elementAt(widget.spot.singleSelect! + 1)),
        ],
      ),
      drawer: myDrawer(context),
    );
  }
}

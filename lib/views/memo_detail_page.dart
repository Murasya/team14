import 'package:flutter/material.dart';
import 'package:team14/views/common_widgets.dart';

import 'package:team14/models/memoTemplate.dart';
import 'package:team14/models/spot.dart';

class MemoDetailPage extends StatefulWidget {
  const MemoDetailPage({Key? key}) : super(key: key);

  @override
  State<MemoDetailPage> createState() => _MemoDetailPageState();
}

class _MemoDetailPageState extends State<MemoDetailPage> {
  MemoTemplate mt = MemoTemplate(
      'template',
      true,
      {'駐輪しやすい', '受け取り待機時間なし', '店員の態度がいい'},
      {'オファー金額', '800~1000円', '1000~1200円'});
  Spot spot = Spot("マクドナルド 石橋店", 21.0, 34.807805, 135.444553, 1, "近くにチェーン店がある",
      [true, true, true], 0, DateTime.now(), DateTime.now());

  Widget listItem(String leftText, String rightText) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black12),
        ),
      ),
      padding: myPadding(),
      child: Row(
        children: [
          Expanded(
            child: Text(
              leftText,
              textAlign: TextAlign.left,
            ),
          ),
          Expanded(
            child: Text(
              rightText,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: 'メモ詳細', context: context),
      body: ListView(
        children: [
          listItem('タイトル', spot.title),
          listItem('位置情報', '${spot.gpsLatitude}, ${spot.gpsLongitude}'),
          listItem('気温', '${spot.temperature}'),
          if (mt.textBox) listItem('テキスト', '${spot.textBox}'),
          for (var i = 0; i < mt.multipleSelectList.length; i++)
            listItem(mt.multipleSelectList.elementAt(i),
                spot.multipleSelectList![i] ? 'はい' : 'いいえ'),
          if (mt.singleSelectList.isNotEmpty)
            listItem(mt.singleSelectList.first,
                mt.singleSelectList.elementAt(spot.singleSelect! + 1)),
        ],
      ),
      drawer: myDrawer(context),
    );
  }
}

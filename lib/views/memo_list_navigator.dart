import 'package:flutter/material.dart';

import 'package:team14/views/memo_list_page.dart';
import 'package:team14/views/memo_list_google_maps_page.dart';

class MemoListNavigator extends StatefulWidget {
  const MemoListNavigator({Key? key}) : super(key: key);

  @override
  State<MemoListNavigator> createState() => _MemoListNavigatorState();
}

class _MemoListNavigatorState extends State<MemoListNavigator> {
  // ナビゲータ用ボタン
  var pages = <Widget>[const MemoListPage(), const MemoListGoogleMapsPage()];

  // 選択インデックス
  var selectedIndex = 0;

  // ナビゲータボタンを押されたら
  void _onTapItem(int index) {
    setState(() {
      selectedIndex = index; //インデックスの更新
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'リスト表示',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'マップ表示',
          ),
        ],
        currentIndex: selectedIndex,
        onTap: _onTapItem,
      ),
    );
  }
}

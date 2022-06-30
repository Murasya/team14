import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:team14/models/memoTemplateProvider.dart';
import 'package:team14/models/memoProvider.dart';
import 'package:team14/utility/utility.dart';

Future<void> exportMemoWithinSameTemplate(BuildContext context) async {
  final memoTemplates = await MemoTemplateProvider().selectAll();

  // Nothing Template
  if (memoTemplates.isEmpty) {
    Fluttertoast.showToast(
      msg: 'テンプレートがありません',
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      toastLength: Toast.LENGTH_LONG,
    );
    return;
  }

  final action = await showDialog(
    context: context,
    builder: (_) {
      final dropdownList = memoTemplates
          .map((mt) => DropdownMenuItem(value: mt.id, child: Text(mt.name)))
          .toList();
      int selectedId = memoTemplates.first.id!;
      return SimpleDialog(
        title: const Text('テンプレートを選択'),
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                DropdownButtonFormField<int>(
                  autofocus: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: dropdownList,
                  value: selectedId,
                  onChanged: (value) => selectedId = value!,
                  enableFeedback: true,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                  ),
                  child: const Text('決定'),
                  onPressed: () => Navigator.pop(context, selectedId),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
  if (action != null) {
    MemoProvider mp = MemoProvider();
    final templateId = action;
    final memos = await mp.selectMemoWithinSameTemplate(templateId);
    shareAsCsv(memoTemplates: memoTemplates, memos: memos);
  }
}

PreferredSizeWidget myAppBar({required title, required context}) {
  return AppBar(
    automaticallyImplyLeading: false,
    flexibleSpace: Text(
      title,
      style: const TextStyle(fontSize: 30.0, color: Colors.white),
    ),
    leading: Builder(
      builder: (context) => IconButton(
        icon: const Icon(Icons.density_medium),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
    ),
    actions: [
      PopupMenuButton(itemBuilder: (context) {
        return [
          PopupMenuItem<int>(
            value: 0,
            child: Row(children: const <Widget>[
              Icon(
                Icons.download,
                color: Colors.grey,
              ),
              Text('メモを出力'),
            ]),
          ),
          PopupMenuItem<int>(
            value: 1,
            child: Row(children: const <Widget>[
              Icon(
                Icons.download,
                color: Colors.grey,
              ),
              Text('テンプレート単位でメモを出力'),
            ]),
          ),
        ];
      }, onSelected: (value) async {
        if (value == 0) {
          final memoTemplates = await MemoTemplateProvider().selectAll();
          final memos = await MemoProvider().selectAll();
          shareAsCsv(memoTemplates: memoTemplates, memos: memos);
        } else if (value == 1) {
          exportMemoWithinSameTemplate(context);
        }
      }),
    ],
  );
}

Widget myDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Text(
            'すごいメモ',
            style: TextStyle(
              fontSize: 24,
            ),
          ),
        ),
        ListTile(
          title: const Text('メモ一覧'),
          onTap: () {
            // Navigator.pushNamed(context, '/memo_list_page');
            Navigator.pushNamed(context, '/memo_list_navigator');
          },
        ),
        ListTile(
          title: const Text('テンプレート一覧'),
          onTap: () {
            Navigator.pushNamed(context, '/template_list_page');
          },
        ),
      ],
    ),
  );
}

EdgeInsetsGeometry myPadding() {
  return const EdgeInsets.all(20.0);
}

Widget myElevatedButton(
    {required String title, required VoidCallback onPressedCB}) {
  return Expanded(
    child: Align(
      alignment: Alignment.bottomCenter,
      child: ElevatedButton(
        onPressed: onPressedCB,
        style: ElevatedButton.styleFrom(
          fixedSize: const Size.fromWidth(double.maxFinite),
        ),
        child: Text(
          title,
        ),
      ),
    ),
  );
}

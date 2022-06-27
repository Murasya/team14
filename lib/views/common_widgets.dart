import 'package:flutter/material.dart';
import 'package:team14/models/spotProvider.dart';
import 'package:team14/views/memo_detail_page.dart';

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
              Text('CSVを出力'),
            ]),
          ),
        ];
      }, onSelected: (value) async {
        SpotProvider sp = SpotProvider();
        if (value == 0) {
          await sp.shareAsCsvFromDB();
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
            Navigator.pushNamed(context, '/memo_list_page');
          },
        ),
        ListTile(
          title: const Text('テンプレート一覧'),
          onTap: () {
            Navigator.pushNamed(context, '/select_template_page');
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

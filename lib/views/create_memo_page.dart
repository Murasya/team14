import 'package:flutter/material.dart';
import 'package:team14/views/common_widgets.dart';
import 'package:team14/models/spotProvider.dart';
import 'package:team14/models/memoTemplate.dart';
import 'package:team14/models/spot.dart';

class CreateMemoPage extends StatefulWidget {
  const CreateMemoPage({Key? key}) : super(key: key);

  @override
  State<CreateMemoPage> createState() => _CreateMemoPageState();
}

class _CreateMemoPageState extends State<CreateMemoPage> {
  SpotProvider sp = SpotProvider();
  final defaultSpotTitle = 'Memo';
  late MemoTemplate mt;
  late Spot spot;
  late TextEditingController titleController;
  late TextEditingController textBoxController;
  late List<DropdownMenuItem<int>> dropdownList;

  @override
  void initState() {
    super.initState();

    // Dummy data
    /// NOTE: If you get the information from db,
    /// you do not need the following code
    mt = MemoTemplate(
      'template',
      true,
      {'駐輪しやすい', '受け取り待機時間なし', '店員の態度がいい'},
      // {'オファー金額', '800~1000円', '1000~1200円'},
      {},
    );
    mt.id = 10;

    // Initial value of memo
    spot = Spot(
      defaultSpotTitle,
      0.0,
      0.0,
      0.0,
      mt.id!,
      mt.textBox ? '' : null,
      mt.multipleSelectList.isNotEmpty
          ? List.generate(mt.multipleSelectList.length, (_) => false)
          : null,
      mt.singleSelectList.isNotEmpty ? 1 : null,
      DateTime.now(),
      DateTime.now(),
    );

    titleController = TextEditingController(text: spot.title);
    textBoxController = TextEditingController();

    // Create drop down List
    int index = 1; // Corresponding to "mt.singleSelectList"'s index.
    dropdownList = mt.singleSelectList.isNotEmpty
        ? mt.singleSelectList
            .toList()
            .sublist(1) // Exclude title
            .map(
                (value) => DropdownMenuItem(value: index++, child: Text(value)))
            .toList()
        : [];
  }

  Future<void> _onSubmit() async {
    spot.title = titleController.text.isNotEmpty
        ? titleController.text
        : defaultSpotTitle;
    if (mt.textBox) spot.textBox = textBoxController.text;

    // TODO: get API info

    spot.createdAt = spot.updatedAt = DateTime.now();
    await sp.insert(spot);
  }

  Widget _toggleItem(int idx) {
    return SwitchListTile(
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(mt.multipleSelectList.elementAt(idx)),
      value: spot.multipleSelectList!.elementAt(idx),
      onChanged: (value) {
        setState(() {
          spot.multipleSelectList![idx] = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar("メモ作成"),
      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: TextField(
                controller: titleController,
                autofocus: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "タイトル",
                  hintText: 'Title',
                ),
              ),
            ),
            if (mt.textBox)
              TextField(
                controller: textBoxController,
                autofocus: true,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "テキスト",
                  hintText: 'Contents',
                ),
              ),
            for (int idx = 0; idx < mt.multipleSelectList.length; idx++)
              _toggleItem(idx),
            if (mt.singleSelectList.isNotEmpty)
              DropdownButtonFormField<int>(
                autofocus: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: mt.singleSelectList.first,
                ),
                items: dropdownList,
                value: spot.singleSelect,
                onChanged: (value) => {
                  setState(() {
                    spot.singleSelect = value as int;
                  }),
                },
              ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: _onSubmit,
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size.fromWidth(double.maxFinite),
                  ),
                  child: const Text(
                    '完了',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

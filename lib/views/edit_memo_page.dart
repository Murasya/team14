import 'package:flutter/material.dart';
import 'package:team14/views/memo_form_helper.dart';
import 'package:team14/models/spotProvider.dart';
import 'package:team14/models/memoTemplate.dart';
import 'package:team14/models/spot.dart';

class EditMemoPage extends StatefulWidget {
  const EditMemoPage({Key? key}) : super(key: key);

  @override
  State<EditMemoPage> createState() => _EditMemoPageState();
}

class _EditMemoPageState extends State<EditMemoPage> {
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

    // Dummy data
    /// NOTE: If you get the information from db,
    /// you do not need the following code
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
    spot.id = 30;

    titleController = TextEditingController(text: spot.title);
    textBoxController = TextEditingController();

    dropdownList = createDropdownList(mt.singleSelectList);
  }

  Future<void> _onSubmit() async {
    spot.title = titleController.text.isNotEmpty
        ? titleController.text
        : defaultSpotTitle;
    if (mt.textBox) spot.textBox = textBoxController.text;

    // TODO: get API info

    spot.updatedAt = DateTime.now();
    await sp.update(spot);
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

  void _onChangeSingleSelect(value) {
    setState(() {
      spot.singleSelect = value as int;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MemoFormHelper(
      pageTitle: "メモ編集",
      mt: mt,
      spot: spot,
      titleController: titleController,
      textBoxController: textBoxController,
      dropdownList: dropdownList,
      toggleWidget: _toggleItem,
      onChangedForSingleSelect: _onChangeSingleSelect,
      onSubmit: _onSubmit,
    );
  }
}

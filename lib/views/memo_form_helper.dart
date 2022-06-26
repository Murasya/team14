import 'package:flutter/material.dart';
import 'package:team14/views/common_widgets.dart';
import 'package:team14/models/memoTemplate.dart';
import 'package:team14/models/spot.dart';

class MemoFormHelper extends StatefulWidget {
  final String pageTitle;
  final Future<Map<String, dynamic>> connectDBProcessCB;
  final String defaultSpotTitle;
  final Function onSubmitToDB;

  const MemoFormHelper({
    Key? key,
    required this.pageTitle,
    required this.connectDBProcessCB,
    required this.defaultSpotTitle,
    required this.onSubmitToDB,
  }) : super(key: key);

  @override
  State<MemoFormHelper> createState() => _MemoFormHelperState();
}

class _MemoFormHelperState extends State<MemoFormHelper> {
  TextEditingController titleController = TextEditingController();
  TextEditingController textBoxController = TextEditingController();
  late List<DropdownMenuItem<int>> dropdownList;
  late MemoTemplate mt;
  late Spot spot;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
  }

  void _initializeAsyncValues(Map<String, dynamic> asyncValues) {
    if (isInitialized) return;
    isInitialized = true;
    mt = asyncValues['$MemoTemplate'];
    spot = asyncValues['$Spot'];
    titleController.text = spot.title;
    textBoxController.text = spot.textBox ?? '';

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

  void _onSubmit() {
    // Update Spot data.
    spot.title = titleController.text.isNotEmpty
        ? titleController.text
        : widget.defaultSpotTitle;
    if (mt.textBox) spot.textBox = textBoxController.text;

    widget.onSubmitToDB(spot);
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

  Widget _contentWidget() {
    return Column(
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
        myElevatedButton(title: '完了', onPressedCB: _onSubmit),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: widget.pageTitle, context: context),
      body: Container(
        padding: myPadding(),
        child: FutureBuilder(
          future: widget.connectDBProcessCB,
          builder: (BuildContext context,
              AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.data == null) {
              return const Center(child: CircularProgressIndicator());
            } else {
              _initializeAsyncValues(snapshot.data!);
              return _contentWidget();
            }
          },
        ),
      ),
      drawer: myDrawer(context),
    );
  }
}

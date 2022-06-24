import 'package:flutter/material.dart';
import 'package:team14/views/common_widgets.dart';
import 'package:team14/models/memoTemplate.dart';
import 'package:team14/models/spot.dart';

class MemoFormHelper extends StatefulWidget {
  final String pageTitle;
  final MemoTemplate mt;
  final Spot spot;
  final TextEditingController titleController;
  final TextEditingController textBoxController;
  final VoidCallback onSubmit;

  const MemoFormHelper({
    Key? key,
    required this.pageTitle,
    required this.mt,
    required this.spot,
    required this.titleController,
    required this.textBoxController,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<MemoFormHelper> createState() => _MemoFormHelperState();
}

class _MemoFormHelperState extends State<MemoFormHelper> {
  late List<DropdownMenuItem<int>> dropdownList;

  @override
  void initState() {
    super.initState();

    // Create drop down List
    int index = 1; // Corresponding to "mt.singleSelectList"'s index.
    dropdownList = widget.mt.singleSelectList.isNotEmpty
        ? widget.mt.singleSelectList
            .toList()
            .sublist(1) // Exclude title
            .map(
                (value) => DropdownMenuItem(value: index++, child: Text(value)))
            .toList()
        : [];
  }

  Widget _toggleItem(int idx) {
    return SwitchListTile(
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(widget.mt.multipleSelectList.elementAt(idx)),
      value: widget.spot.multipleSelectList!.elementAt(idx),
      onChanged: (value) {
        setState(() {
          widget.spot.multipleSelectList![idx] = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(widget.pageTitle),
      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: TextField(
                controller: widget.titleController,
                autofocus: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "タイトル",
                  hintText: 'Title',
                ),
              ),
            ),
            if (widget.mt.textBox)
              TextField(
                controller: widget.textBoxController,
                autofocus: true,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "テキスト",
                  hintText: 'Contents',
                ),
              ),
            for (int idx = 0; idx < widget.mt.multipleSelectList.length; idx++)
              _toggleItem(idx),
            if (widget.mt.singleSelectList.isNotEmpty)
              DropdownButtonFormField<int>(
                autofocus: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: widget.mt.singleSelectList.first,
                ),
                items: dropdownList,
                value: widget.spot.singleSelect,
                onChanged: (value) => {
                  setState(() {
                    widget.spot.singleSelect = value as int;
                  }),
                },
              ),
            myElevatedButton(title: '完了', onPressedCB: widget.onSubmit),
          ],
        ),
      ),
    );
  }
}

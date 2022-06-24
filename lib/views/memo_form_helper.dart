import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:team14/views/common_widgets.dart';
import 'package:team14/models/memoTemplate.dart';
import 'package:team14/models/spot.dart';

class MemoFormHelper extends StatelessWidget {
  final String pageTitle;
  final MemoTemplate mt;
  final Spot spot;
  final TextEditingController titleController;
  final TextEditingController textBoxController;
  final List<DropdownMenuItem<int>> dropdownList;
  final Function toggleWidget;
  final ValueChanged<int?> onChangedForSingleSelect;
  final VoidCallback onSubmit;

  const MemoFormHelper({
    Key? key,
    required this.pageTitle,
    required this.mt,
    required this.spot,
    required this.titleController,
    required this.textBoxController,
    required this.dropdownList,
    required this.toggleWidget,
    required this.onChangedForSingleSelect,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(pageTitle),
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
              toggleWidget(idx),
            if (mt.singleSelectList.isNotEmpty)
              DropdownButtonFormField<int>(
                autofocus: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: mt.singleSelectList.first,
                ),
                items: dropdownList,
                value: spot.singleSelect,
                onChanged: onChangedForSingleSelect,
              ),
            myElevatedButton(title: '完了', onPressedCB: onSubmit),
          ],
        ),
      ),
    );
  }
}

List<DropdownMenuItem<int>> createDropdownList(Set<String> singleSelectList) {
  int index = 1; // Corresponding to "mt.singleSelectList"'s index.
  return singleSelectList.isNotEmpty
      ? singleSelectList
          .toList()
          .sublist(1) // Exclude title
          .map((value) => DropdownMenuItem(value: index++, child: Text(value)))
          .toList()
      : [];
}

import 'package:flutter/material.dart';
import 'package:team14/views/common_widgets.dart';

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

List<Widget> getListWidget({required Set<dynamic> list, required String leftName}){
  List<Widget> widgets = [];
  for (var i = 0; i < list.length; i++){
    widgets.add(listItem(leftName+i.toString(), list.elementAt(i)));
  }
  return widgets;
}
import 'package:flutter/material.dart';

PreferredSizeWidget myAppBar(String title) {
  return AppBar(
    flexibleSpace: Text(
      title,
      style: const TextStyle(fontSize: 30.0, color: Colors.white),
    ),
  );
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

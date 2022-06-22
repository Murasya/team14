
import 'package:flutter/material.dart';

Widget myAppBar(String title) {
  return AppBar(
    flexibleSpace: Text(
      title,
      style: const TextStyle(fontSize: 30.0, color: Colors.white),
    ),
  );
}
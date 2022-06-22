import 'package:flutter/material.dart';

PreferredSizeWidget myAppBar(String title) {
  return AppBar(
    flexibleSpace: Text(
      title,
      style: const TextStyle(fontSize: 30.0, color: Colors.white),
    ),
  );
}

import 'package:flutter/material.dart';

// Delete Dialog
class DeleteDialog extends StatefulWidget {
  const DeleteDialog({Key? key}) : super(key: key);

  @override
  State<DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('アクション'),
      children: [
        Container(
          padding: const EdgeInsets.all(5.0),
          child: SimpleDialogOption(
            child: const Text('削除'),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ),
      ],
    );
  }
}

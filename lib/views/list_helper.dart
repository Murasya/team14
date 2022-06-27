import 'package:flutter/material.dart';

// Delete Dialog
class ActionDialog extends StatefulWidget {
  const ActionDialog({Key? key, required String this.uniqueAction}) : super(key: key);

  final String uniqueAction;

  @override
  State<ActionDialog> createState() => _ActionDialogState();
}

class _ActionDialogState extends State<ActionDialog> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('アクション'),
      children: [
        Container(
          padding: const EdgeInsets.all(5.0),
          child: SimpleDialogOption(
            child: Text(widget.uniqueAction),
            onPressed: () {
              Navigator.pop(context, widget.uniqueAction);
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(5.0),
          child: SimpleDialogOption(
            child: const Text('削除'),
            onPressed: () {
              Navigator.pop(context, '削除');
            },
          ),
        ),
      ],
    );
  }
}


// アラートダイアログ
class WarningDialog extends StatefulWidget {
  const WarningDialog({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  State<WarningDialog> createState() => _WarningDialogState();
}

class _WarningDialogState extends State<WarningDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.text),
      actions: <Widget>[
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: const Text('OK'),
          ),
          onTap: () {
            Navigator.pop(context, false);
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:team14/views/memo_form_helper.dart';
import 'package:team14/models/memoTemplateProvider.dart';
import 'package:team14/models/memoProvider.dart';
import 'package:team14/models/memoTemplate.dart';
import 'package:team14/models/memo.dart';

class EditMemoPage extends StatefulWidget {
  final int id;

  const EditMemoPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<EditMemoPage> createState() => _EditMemoPageState();
}

class _EditMemoPageState extends State<EditMemoPage> {
  MemoTemplateProvider mtp = MemoTemplateProvider();
  MemoProvider mp = MemoProvider();
  final defaultMemoTitle = 'Memo';

  Future<Map<String, dynamic>> _connectDBProcess() async {
    Memo? memo = await mp.selectMemo(widget.id);
    if (memo == null) {
      throw StateError('[${runtimeType.toString()}] Memo id is null!');
    }

    // Never null due to foreign key constraints.
    MemoTemplate mt = (await mtp.selectMemoTemplate(memo.memoTemplateId))!;

    return {'${mt.runtimeType}': mt, '${memo.runtimeType}': memo};
  }

  @override
  void initState() {
    super.initState();
    _connectDBProcess();
  }

  Future<void> _onSubmit(Memo memo) async {
    // The textBox, multipleSelectList, and singleSelect
    // have already been updated in the previous process.
    memo.updatedAt = DateTime.now();
    await mp.update(memo);
    Future(() {
      Navigator.pushNamed(context, '/memo_list_google_maps_page');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MemoFormHelper(
      pageTitle: "メモ編集",
      defaultMemoTitle: defaultMemoTitle,
      connectDBProcessCB: _connectDBProcess(),
      onSubmitToDB: _onSubmit,
    );
  }
}

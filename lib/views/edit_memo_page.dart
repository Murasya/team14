import 'package:flutter/material.dart';
import 'package:team14/views/memo_form_helper.dart';
import 'package:team14/models/memoTemplateProvider.dart';
import 'package:team14/models/spotProvider.dart';
import 'package:team14/models/memoTemplate.dart';
import 'package:team14/models/spot.dart';

class EditMemoPage extends StatefulWidget {
  const EditMemoPage({Key? key}) : super(key: key);

  @override
  State<EditMemoPage> createState() => _EditMemoPageState();
}

class _EditMemoPageState extends State<EditMemoPage> {
  MemoTemplateProvider mtp = MemoTemplateProvider();
  SpotProvider sp = SpotProvider();
  final defaultSpotTitle = 'Memo';

  Future<Map<String, dynamic>> _connectDBProcess() async {
    // Dummy data
    /// NOTE: Receive Memo id at screen transition.
    const int memoId = 1;
    Spot? spot = await sp.selectSpot(memoId);
    if (spot == null) {
      throw StateError('[${runtimeType.toString()}] Memo id is null!');
    }

    // Never null due to foreign key constraints.
    MemoTemplate mt = (await mtp.selectMemoTemplate(spot.memoTemplateId))!;

    return {'${mt.runtimeType}': mt, '${spot.runtimeType}': spot};
  }

  @override
  void initState() {
    super.initState();
    _connectDBProcess();
  }

  Future<void> _onSubmit(Spot spot) async {
    // The textBox, multipleSelectList, and singleSelect
    // have already been updated in the previous process.
    spot.updatedAt = DateTime.now();
    await sp.update(spot);
  }

  @override
  Widget build(BuildContext context) {
    return MemoFormHelper(
      pageTitle: "メモ編集",
      defaultSpotTitle: defaultSpotTitle,
      connectDBProcessCB: _connectDBProcess(),
      onSubmitToDB: _onSubmit,
    );
  }
}

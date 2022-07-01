import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:team14/views/memo_form_helper.dart';
import 'package:team14/models/defaultTemplateProvider.dart';
import 'package:team14/models/memoTemplateProvider.dart';
import 'package:team14/models/memoProvider.dart';
import 'package:team14/models/memoTemplate.dart';
import 'package:team14/models/memo.dart';
import 'package:team14/api/weather.dart';

class CreateMemoPage extends StatefulWidget {
  const CreateMemoPage({Key? key}) : super(key: key);

  @override
  State<CreateMemoPage> createState() => _CreateMemoPageState();
}

class _CreateMemoPageState extends State<CreateMemoPage> {
  MemoTemplateProvider mtp = MemoTemplateProvider();
  MemoProvider mp = MemoProvider();
  final defaultMemoTitle = 'Memo';

  Future<Map<String, dynamic>> _connectDBProcess() async {
    final int? templateMemoId =
        await DefaultTemplateProvider().getDefaultTemplateId();

    if (templateMemoId == null) {
      // NOTE: デフォルトのテンプレートidが登録されていない場合，
      // 'create_template_page'に遷移する必要がある.
      // 'memo_form_helper'のFutureBuilder内のifで，
      // 空のmapが渡されたときに遷移するような処理を構築している.
      return {};
    }

    MemoTemplate? mt = await mtp.selectMemoTemplate(templateMemoId);
    if (mt == null) {
      throw StateError('[${runtimeType.toString()}] Memo template id is null!');
    }

    // Initialize Memo
    Memo memo = Memo(
      defaultMemoTitle,
      DateTime.now(),
      [],
      0.0,
      0.0,
      mt.id!,
      mt.textBox ? '' : null,
      mt.multipleSelectList.isNotEmpty
          ? List.generate(mt.multipleSelectList.length, (_) => false)
          : null,
      mt.singleSelectList.isNotEmpty ? 1 : null,
      DateTime.now(),
      DateTime.now(),
    );

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
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final latitude = position.latitude;
      final longitude = position.longitude;
      print('$longitude,$latitude');

      // get API info
      await dotenv.load(fileName: '.env');
      final String appID = dotenv.get('Y_API');

      final jsonResponse = await getWeather(
        appId: appID,
        coordinates: '$longitude,$latitude',
        output: 'json',
        interval: 5,
      );

      memo.weatherObsDate = jsonResponse.weatherList.first.date;
      memo.rainfallList =
          jsonResponse.weatherList.map((e) => e.rainfall).toList();

      memo.gpsLatitude = latitude;
      memo.gpsLongitude = longitude;

      memo.createdAt = memo.updatedAt = DateTime.now();

      await mp.insert(memo);
      Future(() {
        Navigator.pushNamed(context, '/memo_list_google_maps_page');
      });
    } on Exception catch (e) {
      throw Exception('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MemoFormHelper(
      pageTitle: "メモ作成",
      defaultMemoTitle: defaultMemoTitle,
      connectDBProcessCB: _connectDBProcess(),
      onSubmitToDB: _onSubmit,
    );
  }
}

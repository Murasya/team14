import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:team14/views/memo_form_helper.dart';
import 'package:team14/models/memoTemplateProvider.dart';
import 'package:team14/models/spotProvider.dart';
import 'package:team14/models/memoTemplate.dart';
import 'package:team14/models/spot.dart';
import 'package:team14/api/weather.dart';

class CreateMemoPage extends StatefulWidget {
  final int templateMemoId;

  const CreateMemoPage({
    Key? key,
    required this.templateMemoId,
  }) : super(key: key);

  @override
  State<CreateMemoPage> createState() => _CreateMemoPageState();
}

class _CreateMemoPageState extends State<CreateMemoPage> {
  MemoTemplateProvider mtp = MemoTemplateProvider();
  SpotProvider sp = SpotProvider();
  final defaultSpotTitle = 'Memo';

  Future<Map<String, dynamic>> _connectDBProcess() async {
    MemoTemplate? mt = await mtp.selectMemoTemplate(widget.templateMemoId);
    if (mt == null) {
      throw StateError('[${runtimeType.toString()}] Memo template id is null!');
    }

    // Initialize Spot
    Spot spot = Spot(
      defaultSpotTitle,
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
    try {
      // TODO: get current location
      // This is dummy location
      const latitude = 32.789997;
      const longitude = 131.689920;

      // get API info
      await dotenv.load(fileName: '.env');
      final String appID = dotenv.get('Y_API');

      final jsonResponse = await getWeather(
        appId: appID,
        coordinates: '$longitude,$latitude',
        output: 'json',
        interval: 5,
      );

      spot.weatherObsDate = jsonResponse.weatherList.first.date;
      spot.rainfallList =
          jsonResponse.weatherList.map((e) => e.rainfall).toList();

      spot.gpsLatitude = latitude;
      spot.gpsLongitude = longitude;

      spot.createdAt = spot.updatedAt = DateTime.now();

      await sp.insert(spot);
      Future(() {
        Navigator.pushNamed(context, '/memo_list_page');
      });
    } on Exception catch (e) {
      throw Exception('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MemoFormHelper(
      pageTitle: "メモ作成",
      defaultSpotTitle: defaultSpotTitle,
      connectDBProcessCB: _connectDBProcess(),
      onSubmitToDB: _onSubmit,
    );
  }
}

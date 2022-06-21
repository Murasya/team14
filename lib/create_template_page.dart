import 'package:flutter/material.dart';

// debug class
class CreateTemplateDebug extends StatelessWidget {
  const CreateTemplateDebug({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Temaplate Debug',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CreateTemplatePage(),
    );
  }
}



// テンプレート作成
class CreateTemplatePage extends StatefulWidget {
  const CreateTemplatePage({Key? key}) : super(key: key);

  final String title = 'テンプレート作成';

  @override
  State<CreateTemplatePage> createState() => _CreateTemplatePageState();
}

class _CreateTemplatePageState extends State<CreateTemplatePage> {
  // 要素に対するチェックボックス用変数
  var _isTextField = false;
  var _isCheckBox = false;
  var _isDropdown = false;

  @override
  Widget build(BuildContext context) {
    // 画面サイズ、ボタンのサイズ決定で用いる
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('要素選択'),
            const Text('記録したい要素を選択してください'),
            SizedBox(
              width: size.width * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CheckboxListTile(
                    value: _isTextField,
                    title: const Text('テキスト'),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (bool? value) {
                      setState(() {
                        _isTextField = value!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    value: _isCheckBox,
                    title: const Text('チェックボックス'),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (bool? value) {
                      setState(() {
                        _isCheckBox = value!;
                      });
                    },
                  ),
                  CheckboxListTile(
                    value: _isDropdown,
                    title: const Text('プルダウン'),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (bool? value) {
                      setState(() {
                        _isDropdown = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    // TODO
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  fixedSize: Size(size.width * 0.9, 50),
                ),
                child: const Text('続ける'),
              )
            ),
          ],
        ),
      ),
    );
  }
}

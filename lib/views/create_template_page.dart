import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sqflite/sqflite.dart';

import 'package:team14/views/common_widgets.dart';
import 'package:team14/models/memoTemplate.dart';
import 'package:team14/models/memoTemplateProvider.dart';
import 'package:team14/views/common_widgets.dart';

// debug class
class CreateTemplateDebug extends StatelessWidget {
  const CreateTemplateDebug({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Create Template Debug',
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
  @override
  Widget build(BuildContext context) {
    return const ElementChoicePage();
  }
}

// 要素選択画面
class ElementChoicePage extends StatefulWidget {
  const ElementChoicePage({Key? key}) : super(key: key);

  final String title = 'テンプレート作成';

  @override
  State<ElementChoicePage> createState() => _ElementChoicePageState();
}

class _ElementChoicePageState extends State<ElementChoicePage> {
  // 要素に対するチェックボックス用変数
  var _isTextField = false;
  var _isCheckBox = false;
  var _isPullDown = false;

  @override
  Widget build(BuildContext context) {
    // 画面サイズ、ボタンのサイズ決定で用いる
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: myAppBar(title: widget.title, context: context),
      body: Container(
        padding: myPadding(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('要素選択'),
            const Text('記録したい要素を選択してください'),
            Column(
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
                  value: _isPullDown,
                  title: const Text('プルダウン'),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (bool? value) {
                    setState(() {
                      _isPullDown = value!;
                    });
                  },
                ),
              ],
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // チェックボックスからチェック
                      if (_isCheckBox == true) {
                        // CreateCheckBoxに遷移
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return CreateCheckBox(
                            isPullDown: _isPullDown,
                            isTextField: _isTextField,
                          );
                        }));
                      }
                      // 次にプルダウンをチェック
                      else if (_isPullDown == true) {
                        // CreateCheckBoxに遷移
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return CreatePullDown(
                            isCheckBox: _isCheckBox,
                            isTextField: _isTextField,
                          );
                        }));
                      }
                      // テキストフィールドだけだったら
                      else if (_isTextField == true) {
                        // テンプレート名入力画面に遷移
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return NamingTemplate(
                            isPullDown: _isPullDown,
                            isCheckBox: _isCheckBox,
                            isTextField: _isTextField,
                          );
                        }));
                      } else {
                        Fluttertoast.showToast(
                          msg: '少なくともどれか1つ選んでください',
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 3,
                          toastLength: Toast.LENGTH_LONG,
                        );
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    fixedSize: Size(size.width * 0.9, 50),
                  ),
                  child: const Text('続ける'),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: myDrawer(context),
    );
  }
}

// チェックボックスの作成
class CreateCheckBox extends StatefulWidget {
  final bool isTextField;

  final bool isPullDown;

  final String title = 'テンプレート作成';

  const CreateCheckBox(
      {Key? key, required this.isTextField, required this.isPullDown})
      : super(key: key);

  @override
  State<CreateCheckBox> createState() => _CreateCheckBoxState();
}

class _CreateCheckBoxState extends State<CreateCheckBox> {
  // TextField用コントローラ
  final checkBoxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // 画面サイズ、ボタンのサイズ決定で用いる
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: myAppBar(title: widget.title, context: context),
      body: Container(
        padding: myPadding(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('チェックボックス作成'),
            const Text('選択可能項目を行区切りで入力してください'),
            TextField(
              controller: checkBoxController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: '例:\nAAA\nBBB\nCCC',
              ),
              autofocus: true,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      var checkBoxValue = checkBoxController.value;
                      if (checkBoxValue.text == '') {
                        Fluttertoast.showToast(
                            msg: '入力されていない項目があります',
                            gravity: ToastGravity.CENTER);
                      } else {
                        if (widget.isPullDown == true) {
                          // CreatePullDownに遷移
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return CreatePullDown(
                              isCheckBox: true,
                              isTextField: widget.isTextField,
                              checkBoxValue: checkBoxValue,
                            );
                          }));
                        } else {
                          // テンプレート名入力画面に遷移
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return NamingTemplate(
                              isPullDown: widget.isPullDown,
                              isCheckBox: true,
                              isTextField: widget.isTextField,
                              checkBoxValue: checkBoxValue,
                            );
                          }));
                        }
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    fixedSize: Size(size.width * 0.9, 50),
                  ),
                  child: const Text('続ける'),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: myDrawer(context),
    );
  }
}

class CreatePullDown extends StatefulWidget {
  final bool isTextField;

  final bool isCheckBox;

  // null ok
  final TextEditingValue? checkBoxValue;

  final String title = 'テンプレート作成';

  const CreatePullDown({
    Key? key,
    required this.isTextField,
    required this.isCheckBox,
    this.checkBoxValue,
  }) : super(key: key);

  @override
  State<CreatePullDown> createState() => _CreatePullDownState();
}

class _CreatePullDownState extends State<CreatePullDown> {
  // プルダウン名用コントローラ
  final nameController = TextEditingController();

  // プルダウンリスト用コントローラ
  final pullDownController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // 画面サイズ、ボタンのサイズ決定で用いる
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: myAppBar(title: widget.title, context: context),
      body: Container(
        padding: myPadding(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('プルダウンリスト作成'),
            const Text('プルダウンリスト名を入力してください'),
            TextField(
              controller: nameController,
              autofocus: true,
            ),
            const Text('選択可能項目を行区切りで入力してください'),
            TextField(
              controller: pullDownController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: '例:\nAAA\nBBB\nCCC',
              ),
              autofocus: true,
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      var nameValue = nameController.value;
                      var pullDownValue = pullDownController.value;
                      if (nameValue.text == '' || pullDownValue.text == '') {
                        Fluttertoast.showToast(
                            msg: '入力されていない項目があります',
                            gravity: ToastGravity.CENTER);
                      } else {
                        // テンプレート名入力に遷移
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return NamingTemplate(
                            isPullDown: true,
                            isCheckBox: widget.isCheckBox,
                            isTextField: widget.isTextField,
                            checkBoxValue: widget.checkBoxValue,
                            nameValue: nameValue,
                            pullDownValue: pullDownValue,
                          );
                        }));
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    fixedSize: Size(size.width * 0.9, 50),
                  ),
                  child: const Text('続ける'),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: myDrawer(context),
    );
  }
}

// テンプレート名入力
class NamingTemplate extends StatefulWidget {
  final String title = 'テンプレート作成';

  // TextField?
  final bool isTextField;

  // CheckBox?
  final bool isCheckBox;

  // PullDown?
  final bool isPullDown;

  // values
  final TextEditingValue? checkBoxValue;
  final TextEditingValue? nameValue;
  final TextEditingValue? pullDownValue;

  const NamingTemplate({
    Key? key,
    required this.isTextField,
    required this.isCheckBox,
    required this.isPullDown,
    this.checkBoxValue,
    this.nameValue,
    this.pullDownValue,
  }) : super(key: key);

  @override
  State<NamingTemplate> createState() => _NamingTemplateState();
}

class _NamingTemplateState extends State<NamingTemplate> {
  var templateNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // 画面サイズ、ボタンのサイズ決定で用いる
    var size = MediaQuery.of(context).size;

    // 入力されたテキストの確認用デバッグ変数
    var checkBoxText = '';
    var nameText = '';
    var pullDownText = '';
    // var textMemo = widget.isTextField ? 'yes' : 'no'; // Not used
    Set<String> multipleSelectList = {};
    Set<String> singleSelectList = {};

    if (widget.checkBoxValue != null) {
      // 値の取得
      checkBoxText = widget.checkBoxValue!.text;
      // 複数改行の削除
      List<String> tempCheckBoxList = [];
      for (var element in checkBoxText.split('\n')) {
        if (element != '') {
          tempCheckBoxList.add(element);
        }
      }
      multipleSelectList = tempCheckBoxList.toSet();
    }

    if (widget.nameValue != null) {
      // 値の取得
      nameText = widget.nameValue!.text;
      pullDownText = widget.pullDownValue!.text;

      // 1つ目の要素は名前
      singleSelectList.add(nameText);
      // 2つ目以降は要素
      List<String> tempPullDownList = [];
      for (var element in pullDownText.split('\n')) {
        if (element != '') {
          tempPullDownList.add(element);
        }
      }
      singleSelectList.addAll(tempPullDownList.toSet());
    }

    return Scaffold(
      appBar: myAppBar(title: widget.title, context: context),
      body: Container(
        padding: myPadding(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('テンプレート名入力'),
            const Text('テンプレート名を入力してください'),
            TextField(
              controller: templateNameController,
              autofocus: true,
            ),
            Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () async {
                      // テンプレート作成完了、テンプレート一覧に遷移
                      var templateName = templateNameController.value.text;
                      if (templateName == '') {
                        Fluttertoast.showToast(msg: 'テンプレート名が入力されていません');
                      } else {
                        // MemoTemplateインスタンスの作成
                        MemoTemplate memoTemplate = MemoTemplate(
                          templateName,
                          widget.isTextField,
                          multipleSelectList,
                          singleSelectList,
                        );
                        try {
                          await MemoTemplateProvider().insert(memoTemplate);
                        } on DatabaseException catch (_) {
                          Fluttertoast.showToast(msg: '入力したテンプレート名はすでに使われています');
                        }
                        // TODO
                        // メモ一覧に遷移
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                      fixedSize: Size(size.width * 0.9, 50),
                    ),
                    child: const Text('続ける'),
                  )),
            ),
          ],
        ),
      ),
      drawer: myDrawer(context),
    );
  }
}

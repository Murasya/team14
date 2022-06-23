import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:team14/views/create_template_page.dart';

void main() {
  testWidgets('Create Template Page test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CreateTemplateDebug());

  });
}
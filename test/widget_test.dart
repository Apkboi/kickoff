import 'package:firebase_core_platform_interface/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kickoff/app.dart';
import 'package:kickoff/core/di/injection.dart';
import 'package:kickoff/core/firebase/firebase_config.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    setupFirebaseCoreMocks();
    await FirebaseConfig.initialize();
    await configureDependencies();
  });

  testWidgets('KickOff app starts', (WidgetTester tester) async {
    await tester.pumpWidget(const KickOffApp());
    await tester.pumpAndSettle();

    expect(find.byType(Scaffold), findsWidgets);
  });
}

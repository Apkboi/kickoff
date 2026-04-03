import 'package:flutter/material.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'core/firebase/firebase_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.initialize();
  await configureDependencies();
  runApp(const KickOffApp());
}

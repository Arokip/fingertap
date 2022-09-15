import 'package:fingertap/hive_constants.dart';
import 'package:fingertap/provider/game_mode_provider.dart';
import 'package:fingertap/screen/home_screen.dart';
import 'package:fingertap/screen/new_user_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.init((await getApplicationDocumentsDirectory()).path);
  await Hive.openBox('tap_game_box');
  await Firebase.initializeApp();
  final fingerCount = Hive.box(HiveConstants.tapGameBox).get(HiveConstants.fingerCount);
  if (fingerCount == null) Hive.box(HiveConstants.tapGameBox).put(HiveConstants.fingerCount, 4);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ChangeNotifierProvider<GameModeProvider>(
      create: (BuildContext context) => GameModeProvider(),
      builder: (context, child) {
        final userName = Hive.box(HiveConstants.tapGameBox).get(HiveConstants.userName);
        return MaterialApp(
          home: userName == null ? const NewUserScreen() : const HomeScreen(),
        );
      },
    );
  }
}

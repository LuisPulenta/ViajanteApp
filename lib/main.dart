import 'dart:io';

import 'package:viajanteapp/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:viajanteapp/screens/screens.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() {
  //Estas líneas son para que funcione el http con las direcciones https
  final context = SecurityContext.defaultContext;
  context.allowLegacyUnsafeRenegotiation = true;

  runApp(const MyApp());
}

//--------------------------------------------------------------------------
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

//--------------------------------------------------------------------------
class _MyAppState extends State<MyApp> {
//--------------------------- Pantalla ----------------------------------
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Viajante App',
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}

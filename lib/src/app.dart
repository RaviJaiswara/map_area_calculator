import 'package:flutter/material.dart';
import 'package:map_area_calculator/src/routes.dart';
import 'package:map_area_calculator/src/ui/splash_screnn.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: routes,
      theme: ThemeData.dark(),
      home: Scaffold(
        body: SplashScreen(),
      ),
    );
  }
}

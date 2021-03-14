import 'package:flutter/material.dart';
import 'package:map_area_calculator/src/ui/map_home.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  MapHome.id: (BuildContext context) => MapHome(),
};

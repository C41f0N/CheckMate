import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

final _myBox = Hive.box("THEME_DATA");

class AppTheme with ChangeNotifier {
  Map<String, MaterialColor> primarySwatchesDictionary = {
    'red': Colors.red,
    'yellow': Colors.yellow,
    'purple': Colors.purple,
    'blue': Colors.blue,
    'green': Colors.green,
    'pink': Colors.pink,
    'brown' : Colors.brown,
    'lightBlue' : Colors.lightBlue,
    'orange' : Colors.orange,
    'cyan' : Colors.cyan,
    'deepPurple': Colors.deepPurple,
    'indigo': Colors.indigo,
    'amber': Colors.amber,
    'line': Colors.lime,
    'blueGrey': Colors.blueGrey,
    'deepOrange': Colors.deepOrange,
    'teal': Colors.teal,
  };

  Map<MaterialColor, bool> colorDarkStatus = {
    Colors.red: false,
    Colors.yellow: true,
    Colors.purple: false,
    Colors.blue: false,
    Colors.green: false,
    Colors.pink: false,
    Colors.brown: false,
    Colors.lightBlue: true,
    Colors.orange: true,
    Colors.cyan: true,
    Colors.deepPurple: false,
    Colors.indigo: false,
    Colors.amber: true,
    Colors.lime: true,
    Colors.blueGrey: false,
    Colors.deepOrange: false,
    Colors.teal: false, 
  };


  MaterialColor getCurrentPrimarySwatch() {
    if (_myBox.containsKey("CURRENT_PRIMARY_SWATCH")) {
      String fetchedPrimarySwatchString = _myBox.get("CURRENT_PRIMARY_SWATCH");
      return primarySwatchesDictionary[fetchedPrimarySwatchString]!;
    } else {
      setPrimarySwatch(primarySwatchesDictionary["purple"]!);
      return primarySwatchesDictionary["purple"]!;
    }
  }

  void setPrimarySwatch(MaterialColor color) {
    String colorKey = primarySwatchesDictionary.keys.firstWhere((value) => primarySwatchesDictionary[value] == color);
    _myBox.put("CURRENT_PRIMARY_SWATCH", colorKey);
    notifyListeners();
  }

  List<MaterialColor> getColorSwatchOptions() {
    List<MaterialColor> colorSwatchOptions =  primarySwatchesDictionary.values.toList();
    return colorSwatchOptions;
  }

  bool isDark() {
    return colorDarkStatus[getCurrentPrimarySwatch()]!;
  }
}
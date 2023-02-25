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
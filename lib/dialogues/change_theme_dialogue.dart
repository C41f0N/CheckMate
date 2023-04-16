import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import '../config.dart';

class ChangeThemeDialogue extends StatelessWidget {
  const ChangeThemeDialogue({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "What are you\nfeeling like?",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 23,
          color: Colors.grey[200],
          fontWeight: FontWeight.w300,
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      content: MaterialColorPicker(
        selectedColor: currentTheme.getCurrentPrimarySwatch(),
        colors: currentTheme.getColorSwatchOptions(),
        allowShades: false,
        onMainColorChange: (color) {
          currentTheme.setPrimarySwatch(color as MaterialColor);
        },
      ),
    );
  }
}

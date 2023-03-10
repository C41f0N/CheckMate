import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

import '../config.dart';

class ChangeThemeDialogue extends StatelessWidget {
  const ChangeThemeDialogue({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Select Primary Color",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      content: SizedBox(
        height: 250,
        width: 200,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MaterialColorPicker(
              selectedColor: currentTheme.getCurrentPrimarySwatch(),
              colors: currentTheme.getColorSwatchOptions(),
              allowShades: false,
              onMainColorChange: (color) {
                currentTheme.setPrimarySwatch(color as MaterialColor);
              },
            ),
            const SizedBox(height: 20,),
            Text(
              "Tip: Refresh the list to see minor changes take effect.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 13,
              ),
            )
          ],
        ),
      ),
    );
  }
}

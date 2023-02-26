import 'package:flutter/material.dart';

import '../config.dart';

class UploadingDataIndicator extends StatelessWidget {
  const UploadingDataIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: 40,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(5),
          )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: currentTheme.isDark() ? Colors.black : Colors.white,
              )),
          const SizedBox(
            width: 10,
          ),
          Text("Uploading Data, Please Wait..",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: currentTheme.isDark() ? Colors.black : Colors.white,
              )),
        ],
      ),
    );
  }
}

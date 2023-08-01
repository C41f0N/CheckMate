import 'package:flutter/material.dart';
import 'package:check_mate/config.dart';

class NoInternetIndicator extends StatelessWidget {
  const NoInternetIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: 40,
      decoration: BoxDecoration(
          color: Colors.red[700], borderRadius: BorderRadius.circular(0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.signal_wifi_statusbar_connected_no_internet_4_rounded,
            color: currentTheme.isDark() ? Colors.black : Colors.white,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            "Couldn't connect, changes were not synced.",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: currentTheme.isDark() ? Colors.black : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

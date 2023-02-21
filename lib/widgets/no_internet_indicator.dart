import 'package:flutter/material.dart';

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
        children: const [
          Icon(
            Icons.signal_wifi_statusbar_connected_no_internet_4_rounded,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "Can't connect, changes wont be saved.",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

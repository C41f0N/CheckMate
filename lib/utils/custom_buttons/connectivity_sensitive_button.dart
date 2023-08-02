import 'package:flutter/material.dart';

class ConnectivitySensitiveButton extends StatelessWidget {
  const ConnectivitySensitiveButton(
      {super.key,
      required this.height,
      required this.width,
      required this.child,
      required this.onTap,
      required this.hasConnection});

  final double height;
  final double width;
  final Widget child;
  final bool hasConnection;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: hasConnection
              ? Theme.of(context).colorScheme.primary
              : Colors.red[900],
        ),
        alignment: Alignment.center,
        height: height,
        width: width,
        child: hasConnection
            ? child
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons
                      .signal_wifi_statusbar_connected_no_internet_4_rounded),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    "No Internet Connection :(",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
      ),
    );
  }
}

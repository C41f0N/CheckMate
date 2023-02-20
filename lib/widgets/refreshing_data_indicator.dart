import 'package:flutter/material.dart';

class RefreshingDataIndicator extends StatelessWidget {
  const RefreshingDataIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      height: 30,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withAlpha(200),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(5),
            bottomRight: Radius.circular(5),
          )),
      child: const Text("Refreshing Data, Please Wait.."),
    );
  }
}

import 'package:flutter/material.dart';

class RefreshingDataIndicator extends StatelessWidget {
  const RefreshingDataIndicator({super.key});

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
        children: const [
          SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.black,
              )),
          SizedBox(
            width: 10,
          ),
          Text("Refreshing Data, Please Wait..", style: TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

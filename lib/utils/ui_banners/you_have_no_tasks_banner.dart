import 'package:flutter/material.dart';

class YouHaveNoTasksBanner extends StatelessWidget {
  const YouHaveNoTasksBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
      clipBehavior: Clip.antiAlias,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.37,
        ),
        Text(
          "You have no tasks.",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.grey[200],
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          "Add some using the\nbutton below.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[200], fontSize: 12),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaLinkButton extends StatelessWidget {
  const SocialMediaLinkButton({super.key, required this.iconData, required this.link});
  final IconData iconData;
  final String link;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          final Uri url = Uri.parse(link);
          launchUrl(url, mode: LaunchMode.externalApplication);
        },
        icon: Icon(
          iconData,
          color: Colors.white,
          size: 30,
        ));
  }
}

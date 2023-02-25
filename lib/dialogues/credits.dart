import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/custom_buttons/social_media_link_button.dart';


class Credits extends StatelessWidget {
  const Credits({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Credits",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary, fontSize: 30),
      ),
      content: SizedBox(
        height: 280,
        child: Column(children: [
          const CircleAvatar(
            radius: 40,
            foregroundColor: Colors.red,
            backgroundImage: AssetImage('assets/credits/developer_photo.jpeg'),
          ),
          const SizedBox(height: 20),
          Text(
            "Hi there! This app is developed by me, Sarim Ahmed. Click the icons below if you want to check out more of my creations, or if you just want to get know me better :D",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[200]),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              SocialMediaLinkButton(
                iconData: FontAwesomeIcons.instagram,
                link: 'https://www.instagram.com/_sarimahmed_/',
              ),
              SocialMediaLinkButton(
                iconData: FontAwesomeIcons.github,
                link: 'https://github.com/thenoisyninga',
              ),
              SocialMediaLinkButton(
                iconData: FontAwesomeIcons.globe,
                link: 'https://sarimahmed.tech',
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
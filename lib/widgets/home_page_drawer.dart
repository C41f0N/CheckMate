import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../config.dart';
import '../data_ops/user_session_local_ops.dart';

class HomePageDrawer extends StatefulWidget {
  const HomePageDrawer({
    super.key,
    required this.logoutMethod,
    required this.showChangeThemeMethod,
    required this.changePasswordMethod,
    required this.showCreditsDialogMethod,
  });

  final Function() logoutMethod;
  final Function() showChangeThemeMethod;
  final Function() changePasswordMethod;
  final Function() showCreditsDialogMethod;

  @override
  State<HomePageDrawer> createState() => _HomePageDrawerState();
}

class _HomePageDrawerState extends State<HomePageDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Container(
              alignment: Alignment.bottomLeft,
              child: AutoSizeText(
                "${getSessionUsername().substring(0, 1).toUpperCase()}${getSessionUsername().substring(1)}'s To Do List",
                style: TextStyle(
                    color: currentTheme.isDark()
                        ? Colors.grey[900]
                        : Colors.grey[200],
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.color_lens,
                  color: currentTheme.isDark()
                      ? Colors.grey[900]
                      : Colors.grey[200],
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "Change Theme",
                  style: TextStyle(
                    color: currentTheme.isDark()
                        ? Colors.grey[900]
                        : Colors.grey[200],
                  ),
                ),
              ],
            ),
            onTap: widget.showChangeThemeMethod,
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.password,
                  color: currentTheme.isDark()
                      ? Colors.grey[900]
                      : Colors.grey[200],
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "Change Password",
                  style: TextStyle(
                    color: currentTheme.isDark()
                        ? Colors.grey[900]
                        : Colors.grey[200],
                  ),
                ),
              ],
            ),
            onTap: widget.changePasswordMethod,
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.logout,
                  color: currentTheme.isDark()
                      ? Colors.grey[900]
                      : Colors.grey[200],
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "Logout",
                  style: TextStyle(
                    color: currentTheme.isDark()
                        ? Colors.grey[900]
                        : Colors.grey[200],
                  ),
                ),
              ],
            ),
            onTap: widget.logoutMethod,
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.info,
                  color: currentTheme.isDark()
                      ? Colors.grey[900]
                      : Colors.grey[200],
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "Credits",
                  style: TextStyle(
                    color: currentTheme.isDark()
                        ? Colors.grey[900]
                        : Colors.grey[200],
                  ),
                ),
              ],
            ),
            onTap: widget.showCreditsDialogMethod,
          ),
        ],
      ),
    );
  }
}

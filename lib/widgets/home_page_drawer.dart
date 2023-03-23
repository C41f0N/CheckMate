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
    required this.deleteCheckedTasksMethod,
  });

  final Function() logoutMethod;
  final Function() showChangeThemeMethod;
  final Function() changePasswordMethod;
  final Function() showCreditsDialogMethod;
  final Function() deleteCheckedTasksMethod;

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
                // "${getSessionUsername().substring(0, 1).toUpperCase()}${getSessionUsername().substring(1)}'s Check List",
                "CheckMate",
                style: TextStyle(
                    color: currentTheme.isDark()
                        ? Colors.grey[900]
                        : Colors.grey[200],
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          DrawerButton(
            onTap: widget.deleteCheckedTasksMethod,
            label: "Remove Checked",
            iconData: Icons.remove_done,
          ),
          DrawerButton(
            onTap: widget.showChangeThemeMethod,
            label: "Change Theme",
            iconData: Icons.color_lens,
          ),
          DrawerButton(
            onTap: widget.changePasswordMethod,
            label: "Change Password",
            iconData: Icons.password,
          ),
          DrawerButton(
            onTap: widget.logoutMethod,
            label: "Logout",
            iconData: Icons.logout,
          ),
          DrawerButton(
            onTap: widget.showCreditsDialogMethod,
            label: "Credits",
            iconData: Icons.info,
          ),
        ],
      ),
    );
  }
}

class DrawerButton extends StatelessWidget {
  const DrawerButton(
      {super.key,
      required this.onTap,
      required this.label,
      required this.iconData});

  final String label;
  final IconData iconData;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            iconData,
            color: currentTheme.isDark() ? Colors.grey[900] : Colors.grey[200],
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            label,
            style: TextStyle(
              color:
                  currentTheme.isDark() ? Colors.grey[900] : Colors.grey[200],
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}

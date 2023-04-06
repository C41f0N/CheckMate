import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:sarims_todo_app/data_ops/user_session_local_ops.dart';
import '../config.dart';

class HomePageDrawer extends StatefulWidget {
  const HomePageDrawer({
    super.key,
    required this.logoutMethod,
    required this.showChangeThemeMethod,
    required this.changePasswordMethod,
    required this.showCreditsDialogMethod,
    required this.deleteCheckedTasksMethod,
    required this.showChangeCheckListDialogue,
  });

  final Function() logoutMethod;
  final Function() showChangeThemeMethod;
  final Function() changePasswordMethod;
  final Function() showCreditsDialogMethod;
  final Function() deleteCheckedTasksMethod;
  final Function() showChangeCheckListDialogue;

  @override
  State<HomePageDrawer> createState() => _HomePageDrawerState();
}

class _HomePageDrawerState extends State<HomePageDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.31,
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 8.0, 8.0, 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          // "${getSessionUsername().substring(0, 1).toUpperCase()}${getSessionUsername().substring(1)}'s Check List",
                          "CheckMate",
                          style: TextStyle(
                              color: currentTheme.isDark()
                                  ? Colors.grey[900]
                                  : Colors.grey[200],
                              fontSize: 45,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.person),
                            const SizedBox(width: 5),
                            Transform.translate(
                              offset: const Offset(0, 2),
                              child: Text(
                                "Logged in as ${getSessionUsername()}",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                  color: currentTheme.isDark()
                                      ? Colors.grey[900]
                                      : Colors.grey[200],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                // Divider(
                //   thickness: 2,
                //   color: Theme.of(context).primaryColor,
                // ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  height: 2,
                  color: Theme.of(context).primaryColor,
                ),
                DrawerButton(
                  onTap: widget.deleteCheckedTasksMethod,
                  label: "Remove Checked",
                  iconData: Icons.remove_done,
                ),
                DrawerButton(
                  onTap: widget.showChangeCheckListDialogue,
                  label: "Change Check List",
                  iconData: Icons.list_alt,
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
          ],
        ),
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
    return Column(
      children: [
        ListTile(
          tileColor: Theme.of(context).scaffoldBackgroundColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                iconData,
                color:
                    currentTheme.isDark() ? Colors.grey[900] : Colors.grey[200],
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                label,
                style: TextStyle(
                  color: currentTheme.isDark()
                      ? Colors.grey[900]
                      : Colors.grey[200],
                ),
              ),
            ],
          ),
          onTap: onTap,
        ),
        Container(
          height: 2,
          color: Theme.of(context).primaryColor,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:check_mate/data_ops/user_session_local_ops.dart';

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
      backgroundColor: Theme.of(context).colorScheme.background,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 8.0, 8.0, 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Transform.translate(
                          offset: const Offset(0, 6),
                          child: Container(
                              alignment: Alignment.bottomLeft,
                              height: 80,
                              width: 250,
                              child: Image.asset(
                                'assets/images/title/checkMateTitle.png',
                                color: Colors.grey[200],
                              )),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.person,
                              size: 25,
                              color: Colors.grey[200],
                            ),
                            const SizedBox(width: 5),
                            Transform.translate(
                              offset: const Offset(0, 0.5),
                              child: Text(
                                "Logged in as ${getSessionUsername()}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[200],
                                  // color: Colors.grey[200],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: Theme.of(context).primaryColor.withAlpha(150),
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
            SizedBox(
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 20,
                      child: Image.asset(
                        'assets/images/icon/icon(rounded).png',
                      ),
                    ),
                    Text(
                      "v0.0.1(beta)",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            )
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
          tileColor: Colors.transparent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                iconData,
                color: Colors.grey[200],
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.grey[200],
                ),
              ),
            ],
          ),
          onTap: onTap,
        ),
      ],
    );
  }
}

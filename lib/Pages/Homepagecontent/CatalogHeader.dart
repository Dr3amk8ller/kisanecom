import 'package:flutter/material.dart';
import 'package:untitled/Pages/theme.dart';
import 'package:untitled/Pages/mock_auth.dart';

import '../routes.dart';

class CatalogHeader extends StatelessWidget {
  const CatalogHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth >= 360 && screenWidth < 600;
    
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 8.0 : (isMediumScreen ? 12.0 : 20.0),
      ),
      child: Row(
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Kisan Basket",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    fontSize: isSmallScreen ? 20 : (isMediumScreen ? 24 : 28),
                    color: Theme.of(context).brightness == Brightness.light
                        ? MyTheme.tale
                        : Colors.white70,
                  ),
                ),
                Text(
                  "Top trending Products",
                  style: TextStyle(
                    fontSize: isSmallScreen ? 12 : (isMediumScreen ? 14 : 16),
                    color: Theme.of(context).brightness == Brightness.light
                        ? MyTheme.secondaryColorLight
                        : MyTheme.secondaryColorDark,
                    decoration: TextDecoration.overline,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: isSmallScreen ? 4 : 8),
          // Menu button
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: "Menu",
                color: Theme.of(context).brightness == Brightness.light
                    ? MyTheme.tale
                    : Colors.white,
              );
            },
          ),
          SizedBox(width: isSmallScreen ? 4 : 8),
          // Logout button
          isSmallScreen
              ? IconButton(
                  onPressed: () => logout(context),
                  icon: Icon(Icons.logout_sharp),
                  tooltip: "Logout",
                  color: Theme.of(context).brightness == Brightness.light
                      ? MyTheme.tale
                      : Colors.white,
                )
              : FilledButton.icon(
                  onPressed: () => logout(context),
                  icon: Icon(Icons.logout_sharp, size: isMediumScreen ? 16 : 18),
                  label: Text("Logout", style: TextStyle(fontSize: isMediumScreen ? 12 : 14)),
                ),
        ],
      ),
    );
  }

  void logout(BuildContext context) async {
    await MockAuth.signOut();
    Navigator.pushNamedAndRemoveUntil(
      context,
      MyRoutes.LoginPage,
      (route) => false,
    );
  }
}

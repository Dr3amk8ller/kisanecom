import 'package:flutter/material.dart';
import 'package:untitled/Pages/firebaseconst.dart';
import 'package:untitled/Pages/theme.dart';
import 'routes.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = currentUser;
    final displayName = user?.username ?? user?.email ?? "Guest";
    final displayEmail = user?.email ?? "No email";
    
    return Drawer(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? MyTheme.darkBluishColor
          : Colors.grey[900],
      child: ListView(
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? MyTheme.lightBluishColor
                  : Colors.grey[800],
            ),
            child: UserAccountsDrawerHeader(
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? MyTheme.lightBluishColor
                    : Colors.grey[800],
              ),
              accountName: Text(
                displayName,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              accountEmail: Text(
                displayEmail,
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.normal,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  displayName.isNotEmpty ? displayName[0].toUpperCase() : "G",
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.light
                        ? MyTheme.darkBluishColor
                        : Colors.grey[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.home_rounded,
              color: Colors.white,
              size: 28,
            ),
            title: const Text(
              "Home",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, MyRoutes.HomePage);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.shopping_cart_rounded,
              color: Colors.white,
              size: 28,
            ),
            title: const Text(
              "Cart",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, MyRoutes.CartPage);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.history_rounded,
              color: Colors.white,
              size: 28,
            ),
            title: const Text(
              "Order History",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, MyRoutes.OrderHistory);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 28,
            ),
            title: const Text(
              "Profile",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, MyRoutes.ProfilePage);
            },
          )
        ],
      ),
    );
  }
}

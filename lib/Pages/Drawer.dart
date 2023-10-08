import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Pages/theme.dart';

class MyDrawer extends StatelessWidget {
  final _imageUrl = "https://shorturl.at/uDH37";

  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.purple,
      child: ListView(
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: UserAccountsDrawerHeader(
              margin: EdgeInsets.zero,
              accountName: const Text(
                "Prince Meghani",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: const Text(
                "Princemeghani100@gmail.com",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(_imageUrl),
              ),
            ),
          ),
          const ListTile(
            leading: Icon(
              CupertinoIcons.home,
              color: Colors.white,
            ),
            title: Text("Home", style: TextStyle(color: Colors.white)),
          ),
          const ListTile(
            leading: Icon(
              CupertinoIcons.profile_circled,
              color: Colors.white,
            ),
            title: Text(
              "Profile",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:untitled/Pages/firebaseconst.dart';
import 'package:untitled/Pages/mock_auth.dart';
import 'package:untitled/Pages/routes.dart';
import 'package:untitled/Pages/theme.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = currentUser;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isMediumScreen = screenWidth >= 360 && screenWidth < 600;

    if (user == null) {
      return Scaffold(
        backgroundColor: context.canvasColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colors.black,
          elevation: 0,
          title: Text(
            "Profile",
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? MyTheme.tale
                  : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 20 : (isMediumScreen ? 22 : 24),
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.person_outline, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                "Please login to view profile",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    MyRoutes.LoginPage,
                    (route) => false,
                  );
                },
                child: Text("Go to Login"),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: context.canvasColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.black,
        elevation: 0,
        title: Text(
          "Profile",
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.light
                ? MyTheme.tale
                : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: isSmallScreen ? 20 : (isMediumScreen ? 22 : 24),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isSmallScreen ? 16 : (isMediumScreen ? 20 : 24)),
        child: Column(
          children: [
            // Profile Picture
            CircleAvatar(
              radius: isSmallScreen ? 50 : (isMediumScreen ? 60 : 70),
              backgroundColor: Theme.of(context).brightness == Brightness.light
                  ? MyTheme.darkBluishColor
                  : MyTheme.lightBluishColor,
              child: Text(
                (user.username ?? user.email ?? "G")[0].toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: isSmallScreen ? 40 : (isMediumScreen ? 50 : 60),
                ),
              ),
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),
            // Username
            Text(
              user.username ?? "No username",
              style: TextStyle(
                fontSize: isSmallScreen ? 20 : (isMediumScreen ? 24 : 28),
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.light
                    ? MyTheme.darkBluishColor
                    : MyTheme.lightBluishColor,
              ),
            ),
            SizedBox(height: 8),
            // Email
            Text(
              user.email ?? "No email",
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: isSmallScreen ? 24 : 32),
            // User Info Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Account Information",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildInfoRow(
                      context,
                      "User ID",
                      user.uid,
                      Icons.person,
                      isSmallScreen,
                    ),
                    Divider(),
                    _buildInfoRow(
                      context,
                      "Username",
                      user.username ?? "Not set",
                      Icons.alternate_email,
                      isSmallScreen,
                    ),
                    Divider(),
                    _buildInfoRow(
                      context,
                      "Email",
                      user.email ?? "Not set",
                      Icons.email,
                      isSmallScreen,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: isSmallScreen ? 24 : 32),
            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await MockAuth.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    MyRoutes.LoginPage,
                    (route) => false,
                  );
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(
                      vertical: isSmallScreen ? 14 : (isMediumScreen ? 16 : 18),
                    ),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                  elevation: MaterialStateProperty.all(2),
                ),
                child: Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : (isMediumScreen ? 18 : 20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    bool isSmallScreen,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: isSmallScreen ? 20 : 24,
            color: Theme.of(context).brightness == Brightness.light
                ? MyTheme.darkBluishColor
                : MyTheme.lightBluishColor,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 12 : 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


import 'package:file_picker/file_picker.dart';
// import 'package:firebase_core/firebase_core.dart'; // Commented out: Using mock auth
import 'package:flutter/material.dart';
import 'package:untitled/Pages/Cart.dart';
import 'package:untitled/Pages/SignUpPage.dart';
import 'package:untitled/Pages/hone_page.dart';
import 'package:untitled/Pages/login_page.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/Pages/routes.dart';
import 'package:untitled/Pages/store.dart';
import 'package:untitled/Pages/theme.dart';
import 'package:velocity_x/velocity_x.dart';

import 'Pages/Homepagecontent/PlaceOrder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FilePicker.platform = FilePicker.platform;
  // COMMENTED OUT: Firebase initialization - using mock authentication instead
  // await Firebase.initializeApp();
  runApp(VxState(store: MyStore(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: MyTheme.lightTheme(context),
      darkTheme: MyTheme.darkTheme(context),
      debugShowCheckedModeBanner: false,
      initialRoute: MyRoutes.LoginPage,
      routes: {
        ///": (context) => HomePage(),
        ///": (context) => HomePage(),
        "/": (context) => HomePage(),
        MyRoutes.HomePage: (context) => const HomePage(),
        MyRoutes.LoginPage: (context) => LoginPage(),
        MyRoutes.CartPage: (context) => const Cart(),
        MyRoutes.SignUpPage: (context) => SignUp(),
        MyRoutes.PlaceOrder: (context) => PlaceOrder(
              totalValue: 0,
              cartItems: [],
            )
      },
    );
  }
}

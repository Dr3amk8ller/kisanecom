import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Pages/firebaseconst.dart';
import 'package:untitled/Pages/routes.dart';
import 'package:untitled/Pages/theme.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  UserCredential? userCredential;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.canvasColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: "Signup"
            .text
            .bold
            .color(
              Theme.of(context).brightness == Brightness.light
                  ? MyTheme
                      .tale // Assuming you want 'MyTheme.tale' for light theme
                  : Colors.white,
            )
            .make(),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset("Assests/images/farmersmarket-1.png"),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Kisan Basket mai apka sawagat hai",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Theme.of(context).brightness == Brightness.light
                        ? MyTheme
                            .tale // Assuming you want 'MyTheme.tale' for light theme
                        : Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 32),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          hintText: "Enter Username",
                          labelText: "Username",
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return "Username Cannot be Empty";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: const InputDecoration(
                          hintText: "Enter Password",
                          labelText: "Password",
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return "Password cannot be empty";
                          } else if (value != null && value.length < 6) {
                            return "Password cannot be of length less than 6";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: "SignUp".text.bold.make(),
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? true) {
                    try {
                      // Firebase user registration
                      UserCredential firebaseUserCredential =
                          await auth.createUserWithEmailAndPassword(
                        email: emailController.text.toString(),
                        password: passwordController.text.toString(),
                      );

                      // Check if Firebase registration is successful
                      final user = firebaseUserCredential.user;
                      if (user != null) {
                        // Firebase user registration succeeded

                        // Make an API request to your Django backend for registration
                        bool djangoRegistrationSuccessful =
                            await registerUserInDjango(
                          user.uid,
                          passwordController.text.toString(),
                          // Pass other required user data to Django
                        );

                        if (djangoRegistrationSuccessful) {
                          // Django registration succeeded
                          // Navigate to the home page or perform any other action
                          Navigator.pushNamed(context, MyRoutes.LoginPage);
                        } else {
                          // Handle the case where Django registration failed
                        }
                      } else {
                        // Firebase user registration failed
                      }
                    } catch (error) {
                      // Handle errors from Firebase registration
                      print(error);
                    }
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> registerUserInDjango(
  String firebaseUid,
  String password,
  /* Add other user data here */
) async {
  final response = await http.post(
    Uri.parse(
        'http://10.0.2.2:8000/api/register/'), // Replace with your Django API endpoint
    body: {
      'username': firebaseUid,
      'password': password,

      // Include other user data here as needed
    },
  );

  if (response.statusCode == 201) {
    // User creation in Django succeeded
    return true;
  } else {
    // Handle the case where user creation in Django failed

    return false;
  }
}

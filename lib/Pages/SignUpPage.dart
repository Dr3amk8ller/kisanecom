// import 'package:firebase_auth/firebase_auth.dart'; // Commented out: Using mock auth
import 'package:flutter/material.dart';
import 'package:untitled/Pages/routes.dart';
import 'package:untitled/Pages/theme.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:untitled/Pages/mock_auth.dart';
// import 'package:http/http.dart' as http; // Commented out: Using mock data instead of API

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

  // UserCredential? userCredential; // Commented out: Using mock auth
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
                        autofocus: false,
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
                      // MOCK: Register using mock authentication
                      final result =
                          await MockAuth.createUserWithEmailAndPassword(
                        email: emailController.text.toString(),
                        password: passwordController.text.toString(),
                      );

                      if (result["success"] == true) {
                        // Registration succeeded
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  "Registration successful! Please login.")),
                        );
                        Navigator.pushNamed(context, MyRoutes.LoginPage);
                      } else {
                        // Show error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  result["error"] ?? "Registration failed")),
                        );
                      }

                      // COMMENTED OUT: Firebase authentication
                      /* UserCredential firebaseUserCredential =
                          await auth.createUserWithEmailAndPassword(
                        email: emailController.text.toString(),
                        password: passwordController.text.toString(),
                      );

                      final user = firebaseUserCredential.user;
                      if (user != null) {
                        bool djangoRegistrationSuccessful =
                            await mockRegisterUserInDjango(
                          user.uid,
                          passwordController.text.toString(),
                        );

                        if (djangoRegistrationSuccessful) {
                          Navigator.pushNamed(context, MyRoutes.LoginPage);
                        }
                      } */
                    } catch (error) {
                      // Handle errors
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: $error")),
                      );
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

// COMMENTED OUT: Django registration function (no longer needed with mock auth)

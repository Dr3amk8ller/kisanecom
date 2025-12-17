// import 'package:firebase_auth/firebase_auth.dart'; // Commented out: Using mock auth
import 'package:flutter/material.dart';
import 'package:untitled/Pages/routes.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:untitled/Pages/mock_auth.dart';
// import 'package:http/http.dart' as http; // Commented out: Using mock data instead of API

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    // TODO: implement dispose
    emailController.dispose();
    passwordController.dispose();
  }

  String name = "";
  bool changeButton = false;
  final _formKey = GlobalKey<FormState>();

  get isEmpty => null;
  
  // MOCK: Login using mock authentication (with username)
  Future<void> login() async {
    final result = await MockAuth.signInWithUsernameAndPassword(
      username: emailController.text.toString(),
      password: passwordController.text.toString(),
    );
    
    if (result["success"] == true) {
      Navigator.pushNamed(context, MyRoutes.HomePage);
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result["error"] ?? "Login failed")),
      );
    }
  }
  
  // COMMENTED OUT: Firebase login
  /* void login() {
    auth
        .signInWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())
        .then((value) => Navigator.pushNamed(context, MyRoutes.HomePage));
  } */

  moveToHome(BuildContext context) async {
    {
      if (_formKey.currentState?.validate() ?? true) {
        setState(() {
          changeButton = true;
        });
        await Future.delayed(const Duration(seconds: 1));
        login();
        setState(() {
          changeButton = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "Assests/images/294949024_460187556114448_3878388641743438730_n.jpg",
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              "Welcome $name",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                          hintText: "Enter Username", labelText: "Username"),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return "Username Cannot be Empty";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        name = value;

                        setState(() {});
                      },
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: const InputDecoration(
                          hintText: "Enter Password", labelText: "Password"),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return "Password cannot be empty";
                        } else if (value != null && value.length < 6) {
                          return "Password cannot be of length less than 6";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Material(
                      color: Colors.deepPurple,
                      borderRadius: changeButton
                          ? BorderRadiusDirectional.circular(5)
                          : BorderRadiusDirectional.circular(50),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(5),
                        onTap: () async {
                          if (_formKey.currentState?.validate() ?? true) {
                            setState(() {
                              changeButton = true;
                            });
                            await Future.delayed(const Duration(seconds: 1));

                            try {
                              // MOCK: Login using mock authentication (with username)
                              final result = await MockAuth.signInWithUsernameAndPassword(
                                username: emailController.text.toString(),
                                password: passwordController.text.toString(),
                              );

                              if (result["success"] == true) {
                                // Login succeeded
                                Navigator.pushNamed(context, MyRoutes.HomePage);
                              } else {
                                // Show error message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(result["error"] ?? "Login failed")),
                                );
                              }

                              // COMMENTED OUT: Firebase authentication
                              /* UserCredential firebaseUserCredential =
                                  await auth.signInWithEmailAndPassword(
                                      email: emailController.text.toString(),
                                      password: passwordController.text.toString());

                              final user = firebaseUserCredential.user;
                              if (user != null) {
                                bool djangoLoginSuccessful =
                                    await mockLoginUserInDjango(user.uid,
                                        passwordController.text.toString());

                                if (djangoLoginSuccessful) {
                                  Navigator.pushNamed(context, MyRoutes.HomePage);
                                }
                              } */
                            } catch (error) {
                              // Handle errors
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error: $error")),
                              );
                              print(error);
                            }

                            setState(() {
                              changeButton = false;
                            });
                          }
                        },
                        child: AnimatedContainer(
                          height: 40,
                          width: changeButton ? 50 : 150,
                          alignment: Alignment.center,
                          duration: const Duration(seconds: 1),
                          child: changeButton
                              ? const Icon(Icons.done)
                              : const Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          "Dont have an account ?"
                              .text
                              .bold
                              .color(Colors.brown)
                              .make(),
                          TextButton(
                              onPressed: moveToSignUp,
                              child: "SignUp".text.make())
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  moveToSignUp() async {
    await Navigator.pushNamed(context, MyRoutes.SignUpPage);
  }
}

// COMMENTED OUT: Django login function (no longer needed with mock auth)

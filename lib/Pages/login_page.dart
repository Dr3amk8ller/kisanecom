import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/Pages/routes.dart';
import 'package:untitled/Pages/theme.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:untitled/Pages/firebaseconst.dart';
import 'package:http/http.dart' as http;

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
  void login() {
    auth
        .signInWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())
        .then((value) => Navigator.pushNamed(context, MyRoutes.HomePage));
  }

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
    return Material(
      color: Theme.of(context).canvasColor,
      child: SingleChildScrollView(
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
                              // Firebase user login
                              UserCredential firebaseUserCredential =
                                  await auth.signInWithEmailAndPassword(
                                      email: emailController.text.toString(),
                                      password:
                                          passwordController.text.toString());

                              // Check if Firebase login is successful
                              final user = firebaseUserCredential.user;
                              if (user != null) {
                                // Firebase login succeeded

                                // Make an API request to your Django backend for login
                                bool djangoLoginSuccessful =
                                    await loginUserInDjango(user.uid,
                                        passwordController.text.toString()
                                        // Pass other required user data to Django
                                        );

                                if (djangoLoginSuccessful) {
                                  // Django login succeeded
                                  Navigator.pushNamed(
                                      context, MyRoutes.HomePage);
                                } else {
                                  // Handle the case where Django login failed
                                }
                              } else {
                                // Firebase login failed
                              }
                            } catch (error) {
                              // Handle errors from Firebase login
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

Future<bool> loginUserInDjango(
  String firebaseUid,
  String password,
  /* Add other user data here */
) async {
  final response = await http.post(
    Uri.parse(
        'http://10.0.2.2:8000/login'), // Replace with your Django API endpoint
    body: {
      'username': firebaseUid,
      'password': password
      // Include other user data here as needed
    },
  );

  if (response.statusCode == 200) {
    // User login in Django succeeded
    return true;
  } else {
    // Handle the case where user login in Django failed
    return false;
  }
}

// ignore_for_file: prefer_const_constructors, duplicate_ignore, use_build_context_synchronously, avoid_print, unused_local_variable

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hrapp/DatabaseManager/database_manager.dart';
import 'package:hrapp/Services/forgot_password.dart';
import 'package:hrapp/dashboard.dart';
import 'package:hrapp/RegistrationScreen.dart';
import 'package:hrapp/Services/authendication_service.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/login',
    routes: {
      '/login': (context) => LoginScreen(),
      '/register': (context) => RegistrationScreen(),
      '/dashboard': (context) => DashboardScreen(),
    },
  ));
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _key = GlobalKey<FormState>();

  final AuthenticationService _auth = AuthenticationService();
  List userProfilesList = [];
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/logo.png'),
                        ],
                      ),
                      SizedBox(height: 30),
                      // Hello again
                      Text(
                        'Welcome!',
                        style: GoogleFonts.montserrat(
                          fontSize: 52,
                        ),
                      ),

                      SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            // Email field
                            TextFormField(
                              controller: _emailController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Email cannot be empty';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.deepPurple),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                hintText: 'Email',
                                fillColor: Colors.grey[200],
                                filled: true,
                              ),
                            ),
                            SizedBox(height: 10),

                            // Password field
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Password cannot be empty';
                                } else {
                                  return null;
                                }
                              },
                              // ignore: prefer_const_constructors
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.deepPurple),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                hintText: 'Password',
                                fillColor: Colors.grey[200],
                                filled: true,
                              ),
                            ),
                            SizedBox(height: 10),

                            // Forgot password
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return ForgotPasswordPage();
                                        },
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 30),

                            // Login Button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurple,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 70, vertical: 15),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(50))),
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_key.currentState!.validate()) {
                                      signInUser();
                                    }
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 10),

                            // Register Now
                            TextButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Not registered?  ',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    'Sign up',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  CupertinoPageRoute(
                                    fullscreenDialog: true,
                                    builder: (context) => RegistrationScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
    // return Scaffold(
  }

  void signInUser() async {
    dynamic authResult = await _auth.loginUser(
        _emailController.text.trim(), _passwordController.text);
    if (authResult == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign in error. Please verify email and password'),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        },
      );
      dynamic role = await DatabaseManager().userRole(authResult.uid);
      _emailController.clear();
      _passwordController.clear();

      if (role == 'admin') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign in Successfully!'),
          ),
        );
        Navigator.pushNamed(context, '/dashboard');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign in Successfully!'),
          ),
        );
        Navigator.pushNamed(context, '/dashboard');
      }
    }
  }
}

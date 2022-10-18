import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('Password reset link sent! Check your Email'),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              e.message.toString(),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              'Enter Your Email and we will send a password reset link',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          const SizedBox(height: 20),
          // Email textfield
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: TextFormField(
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
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.deepPurple),
                  borderRadius: BorderRadius.circular(12),
                ),
                hintText: 'Email',
                fillColor: Colors.grey[200],
                filled: true,
              ),
            ),
          ),
          const SizedBox(height: 30),

          MaterialButton(
            onPressed: passwordReset,
            color: Colors.deepPurple,
            padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 15),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            child: const Text(
              'Reset Password',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}

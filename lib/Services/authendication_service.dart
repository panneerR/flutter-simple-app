// ignore_for_file: avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hrapp/DatabaseManager/database_manager.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

// registration with email and password

  Future createNewUser(
      String name,
      String email,
      String password,
      String dob,
      String empcode,
      String blood,
      String mobile,
      String position,
      String image) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      await DatabaseManager().createUserData(
          name, email, dob, empcode, blood, mobile, position, user!.uid, image);
      return user;
    } catch (e) {
      print(e.toString());
    }
  }

  // Future addUserDetails(String name, String email,
  //     String dob, int empid) async {
  //   await FirebaseFirestore.instance.collection('users').add({
  //     'name': name,
  //     'email': email,
  //     'emp_id': empid,
  //     'dob': dob,
  //   });
  // }

// sign with email and password

  Future loginUser(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      print(e.toString());
    }
  }

// signout

  Future signOut() async {
    try {
      return _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}

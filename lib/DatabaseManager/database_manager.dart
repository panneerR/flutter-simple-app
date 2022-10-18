// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseManager {
  final CollectionReference profileList =
      FirebaseFirestore.instance.collection('profileInfo');

  Future<void> createUserData(
      String name,
      String email,
      String dob,
      String empcode,
      String blood,
      String mobile,
      String position,
      String uid,
      String image) async {
    return await profileList.doc(uid).set({
      'name': name,
      'email': email,
      'dob': dob,
      'empcode': 'IWTS$empcode',
      'blood': blood,
      'mobile': mobile,
      'position': position,
      'uid': uid,
      'role': 'employee',
      'image': image
    });
  }

  Future updateUserList(
      String name, String dob, String blood, String mobile, String uid) async {
    try {
      return await profileList
          .doc(uid)
          .update({'name': name, 'dob': dob, 'blood': blood, 'mobile': mobile});
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future getUsersList(userId) async {
    List itemsList = [];
    dynamic role = await DatabaseManager().userRole(userId);
    if (role == 'admin') {
      try {
        await profileList.get().then((querySnapshot) {
          querySnapshot.docs.forEach((element) {
            itemsList.add(element.data);
          });
        });
        return itemsList;
      } catch (e) {
        print(e.toString());
        return null;
      }
    } else {
      try {
        await profileList
            .where("uid", isEqualTo: userId)
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((element) {
            itemsList.add(element.data);
          });
        });
        return itemsList;
      } catch (e) {
        print(e.toString());
        return null;
      }
    }
  }

  Future userRole(userid) async {
    var collection = FirebaseFirestore.instance.collection('profileInfo');
    var docSnapshot = await collection.doc(userid).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      var role = data?['role'];
      return role;
    }
  }
}

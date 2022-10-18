// ignore_for_file: file_names, avoid_print, prefer_const_constructors, sized_box_for_whitespace, use_build_context_synchronously, library_private_types_in_public_api, prefer_interpolation_to_compose_strings, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrapp/DatabaseManager/database_manager.dart';
import 'package:hrapp/Services/authendication_service.dart';
import 'package:hrapp/main.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AuthenticationService _auth = AuthenticationService();
  final CollectionReference profileList =
      FirebaseFirestore.instance.collection('profileInfo');
  final _key = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _bloodController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  List userProfilesList = [];
  String userID = "";
  String docId = "";

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
    fetchDatabaseList();
  }

  fetchUserInfo() async {
    User? getUser = FirebaseAuth.instance.currentUser;
    userID = getUser!.uid;
  }

  fetchDatabaseList() async {
    dynamic resultant = await DatabaseManager().getUsersList(userID);
    if (resultant == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to Retrieve!'),
        ),
      );
    } else {
      setState(() {
        userProfilesList = resultant;
      });
    }
  }

  updateData(String name, String dob, String blood, String mobile,
      String userID) async {
    await DatabaseManager().updateUserList(name, dob, blood, mobile, userID);
    fetchDatabaseList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        actions: [
          ElevatedButton(
            onPressed: () {
              openDialogueBox(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
            ),
            child: Icon(
              Icons.edit,
              color: Colors.white,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await _auth.signOut().then((result) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logged Out Successfully!'),
                  ),
                );
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => LoginScreen(),
                  ),
                );
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
            ),
            child: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Container(
        child: ListView.builder(
          itemCount: userProfilesList.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 50,
              shadowColor: Colors.black,
              color: Colors.deepPurple[400],
              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
              child: SizedBox(
                width: 350,
                height: 550,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 20.0),
                  child: Column(
                    children: [
                      docId = (userProfilesList[index]()['uid']),
                      CircleAvatar(
                        radius: 85.0,
                        backgroundColor: Colors.deepPurple,
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(userProfilesList[index]()['image']),
                          radius: 80.0,
                        ),
                      ),
                      const SizedBox(height: 25),
                      Text(
                        userProfilesList[index]()['name'],
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        userProfilesList[index]()['position'],
                        style: TextStyle(
                          fontSize: 23,
                          color: Colors.grey.shade300,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Text(
                            'Employee ID :      ' +
                                userProfilesList[index]()['empcode'].toString(),
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade300,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Date of Birth :      ' +
                                userProfilesList[index]()['dob'],
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade300,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Blood Group :      ' +
                                userProfilesList[index]()['blood'],
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade300,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Mobile           :      ' +
                                userProfilesList[index]()['mobile'],
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade300,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          openDialogueBox(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                        ),
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        label: Text('Edit'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.edit_note_rounded),
              title: Text('Edit Profile'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Apply Leave'),
            ),
            ListTile(
              leading: Icon(Icons.close_rounded),
              title: Text('Close'),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  openDialogueBox(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    color: Colors.white,
                    child: Form(
                      key: _key,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Register Here',
                            style: GoogleFonts.montserrat(
                              fontSize: 40,
                              color: Colors.black,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              children: [
                                // Name Field
                                TextFormField(
                                  controller: _nameController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Name cannot be empty';
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.deepPurple),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    hintText: 'Name',
                                    fillColor: Colors.grey[200],
                                    filled: true,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Date of Birth field
                                TextFormField(
                                  controller: _dobController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Date of Birth cannot be empty';
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.deepPurple),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    hintText: 'Select DOB',
                                    fillColor: Colors.grey[200],
                                    filled: true,
                                  ),
                                  readOnly:
                                      true, // when true user cannot edit text
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate:
                                          DateTime.now(), //get today's date
                                      firstDate: DateTime(1950),
                                      lastDate: DateTime(2099),
                                    );

                                    if (pickedDate != null) {
                                      String formattedDate =
                                          DateFormat('dd-MM-yyyy')
                                              .format(pickedDate);
                                      setState(() {
                                        _dobController.text =
                                            formattedDate; //set foratted date to TextField value.
                                      });
                                    }
                                  },
                                ),
                                const SizedBox(height: 10),

                                // Blood group Field
                                TextFormField(
                                  controller: _bloodController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Blood Group cannot be empty';
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.deepPurple),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    hintText: 'Blood Group',
                                    fillColor: Colors.grey[200],
                                    filled: true,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Mobile Field
                                TextFormField(
                                  controller: _mobileController,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Mobile No cannot be empty';
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.deepPurple),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    hintText: 'Mobile',
                                    fillColor: Colors.grey[200],
                                    filled: true,
                                  ),
                                ),
                                const SizedBox(height: 10),

                                // Signup button
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.deepPurple,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 40, vertical: 15),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50))),
                                      child: const Text(
                                        'Update',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      onPressed: () {
                                        submitAction(context);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    const SizedBox(width: 20.0),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 40, vertical: 15),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50))),
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                      onPressed: () {
                                        fetchDatabaseList();
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  submitAction(BuildContext context) {
    updateData(_nameController.text.trim(), _dobController.text.trim(),
        _bloodController.text.trim(), _mobileController.text.trim(), userID);
    _nameController.clear();
    _dobController.clear();
    _bloodController.clear();
    _mobileController.clear();
  }
}

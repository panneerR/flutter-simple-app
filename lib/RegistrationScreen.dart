// ignore_for_file: file_names, library_private_types_in_public_api, prefer_const_constructors, avoid_print, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hrapp/Services/authendication_service.dart';
import 'package:hrapp/main.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _key = GlobalKey<FormState>();
  String imageUrl = '';

  final AuthenticationService _auth = AuthenticationService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _conpassController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _empcodeController = TextEditingController();
  final TextEditingController _desigController = TextEditingController();
  final TextEditingController _bloodController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  void createUser() async {
    if (passwordConfirmed()) {
      dynamic result = await _auth.createNewUser(
        _nameController.text,
        _emailController.text.trim(),
        _passwordController.text.trim(),
        _dobController.text.trim(),
        _empcodeController.text.trim(),
        _bloodController.text.trim(),
        _mobileController.text.trim(),
        _desigController.text.trim(),
        imageUrl,
      );
      if (result == null) {
        print('Email is not valid');
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return Center(child: CircularProgressIndicator());
          },
        );
        print(result.toString());
        _nameController.clear();
        _passwordController.clear();
        _conpassController.clear();
        _emailController.clear();
        _dobController.clear();
        _empcodeController.clear();
        _bloodController.clear();
        _mobileController.clear();
        _desigController.clear();

        Navigator.of(context).push(
          CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (context) => LoginScreen(),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registered Successfully!'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password Mismatch!'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _conpassController.dispose();
    _nameController.dispose();
    _dobController.dispose();
    _empcodeController.dispose();
    _bloodController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() == _conpassController.text.trim()) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              color: Colors.white,
              child: Form(
                key: _key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Register Here',
                      style: GoogleFonts.montserrat(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 1.0, vertical: 15.0),
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
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.deepPurple),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              hintText: 'Name',
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 10.0),
                              fillColor: Colors.grey[200],
                              filled: true,
                            ),
                          ),
                          SizedBox(height: 5.0),

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
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                              fillColor: Colors.grey[200],
                              filled: true,
                            ),
                          ),
                          SizedBox(height: 5.0),

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
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.deepPurple),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              hintText: 'Select DOB',
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                              fillColor: Colors.grey[200],
                              filled: true,
                            ),
                            readOnly: true, // when true user cannot edit text
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(), //get today's date
                                firstDate: DateTime(1950),
                                lastDate: DateTime(2099),
                              );

                              if (pickedDate != null) {
                                String formattedDate =
                                    DateFormat('dd-MM-yyyy').format(pickedDate);
                                setState(() {
                                  _dobController.text =
                                      formattedDate; //set foratted date to TextField value.
                                });
                              }
                            },
                          ),
                          SizedBox(height: 5.0),

                          // Employee Code field
                          TextFormField(
                            controller: _empcodeController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Employee ID cannot be empty';
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
                              hintText: 'Employee ID',
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                              fillColor: Colors.grey[200],
                              filled: true,
                            ),
                          ),
                          SizedBox(height: 5.0),

                          // Blood group field
                          TextFormField(
                            controller: _bloodController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Blood group cannot be empty';
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
                              hintText: 'Blood Group',
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                              fillColor: Colors.grey[200],
                              filled: true,
                            ),
                          ),
                          SizedBox(height: 5.0),

                          // Mobile no field
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
                                borderSide: BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.deepPurple),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              hintText: 'Mobile',
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                              fillColor: Colors.grey[200],
                              filled: true,
                            ),
                          ),
                          SizedBox(height: 5.0),

                          // Position field
                          TextFormField(
                            controller: _desigController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Designation cannot be empty';
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
                              hintText: 'Designation',
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                              fillColor: Colors.grey[200],
                              filled: true,
                            ),
                          ),
                          SizedBox(height: 5.0),

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
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                              fillColor: Colors.grey[200],
                              filled: true,
                            ),
                          ),
                          SizedBox(height: 5.0),

                          // Confirm Password field
                          TextFormField(
                            controller: _conpassController,
                            obscureText: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Confirm Password cannot be empty';
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
                              hintText: 'Confirm Password',
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                              fillColor: Colors.grey[200],
                              filled: true,
                            ),
                          ),
                          SizedBox(height: 5.0),

                          // image upload section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Click to upload image'),
                              IconButton(
                                onPressed: () async {
                                  ImagePicker imagePicker = ImagePicker();
                                  XFile? file = await imagePicker.pickImage(
                                      source: ImageSource.gallery,
                                      maxHeight: 480,
                                      maxWidth: 480);
                                  if (file == null) return;

                                  String uniqueFileName = DateTime.now()
                                      .microsecondsSinceEpoch
                                      .toString();

                                  Reference referenceRoot =
                                      FirebaseStorage.instance.ref();
                                  Reference referenceDirImages =
                                      referenceRoot.child('profile_img');

                                  Reference referenceImageToUpload =
                                      referenceDirImages.child(uniqueFileName);
                                  try {
                                    await referenceImageToUpload
                                        .putFile(File(file.path));
                                    imageUrl = await referenceImageToUpload
                                        .getDownloadURL();
                                  } catch (error) {}
                                },
                                icon: Icon(Icons.camera_alt_rounded),
                              ),
                            ],
                          ),
                          Text(
                            '*Upload Image size should be lessthan 200kb only',
                            style: TextStyle(fontSize: 12.0, color: Colors.red),
                          ),
                          SizedBox(height: 20.0),

                          // Signup button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                  'Signup',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                onPressed: () {
                                  if (imageUrl.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('Please upload the image'),
                                      ),
                                    );
                                    return;
                                  } else {
                                    if (_key.currentState!.validate()) {
                                      createUser();
                                    }
                                  }
                                },
                              ),
                              SizedBox(width: 20.0),
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
  }
}

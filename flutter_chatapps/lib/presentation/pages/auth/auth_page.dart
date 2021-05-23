import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chatapps/presentation/widgets/auth/auth_form.dart';
import 'package:get/get.dart';

class AuthPage extends StatefulWidget {
  AuthPage({Key key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _auth = FirebaseAuth.instance;
  final _ref = FirebaseStorage.instance.ref();

  bool _isLoading = false;

  String imageUrl;

  _uploadImage(File image) async {
    final ref =
        _ref.child('user_image').child("${_auth.currentUser.uid}" + ".jpg");

    await ref.putFile(image).whenComplete(() => print('upload completed'));

    imageUrl = await ref.getDownloadURL();
  }

  void _submitFn(
    String email,
    String username,
    String password,
    bool isLogin,
    File image,
  ) async {
    UserCredential userCredential;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin == true) {
        userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        // Upload image to firebase storage
        await _uploadImage(image);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user.uid)
            .set({
          'email': email,
          'username': username,
          'imageUrl': imageUrl,
        });
      }
    } on PlatformException catch (e) {
      String message = 'An error occured something';

      if (e.message != null) {
        message = e.message;
      }

      await Flushbar(
        title: "Error",
        duration: Duration(seconds: 2),
        message: message,
        backgroundColor: Colors.pink,
      ).show(context);

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      await Flushbar(
        title: "Error",
        duration: Duration(seconds: 2),
        message: e.toString(),
        backgroundColor: Colors.pink,
      ).show(context);
      print("erorr message: ${e.toString()}");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: AuthForm(_submitFn, _isLoading),
      ),
    );
  }
}

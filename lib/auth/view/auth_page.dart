import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/auth/auth.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuth(String email, String username, String password, File? image,
      bool isLogin) async {
    UserCredential credentials;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        credentials = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        credentials = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final imagePath = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child('${credentials.user!.uid}.jpg');

        await imagePath.putFile(image!);
        final imageUrl = await imagePath.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(credentials.user!.uid)
            .set({
          'username': username,
          'email': email,
          'imageUrl': imageUrl,
        });
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message == null
            ? 'An error occurred. Check creds'
            : e.message.toString()),
        backgroundColor: Theme.of(context).errorColor,
      ));
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: AuthForm(_submitAuth, _isLoading),
    );
  }
}

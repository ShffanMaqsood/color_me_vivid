import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";

class AuthMethods{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //SignUp User or Register New User
  Future<String> signUpUser({

  required String email,
    required String password
}) async{
    String res = "Some Error Occured";
    try{
      if(email.isNotEmpty || password.isNotEmpty)
        {
          UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
          res = "Success";
        }
    }
    catch(err)
    {
      res = err.toString();
    }
    return res;
  }


  Future<String> loginUser({

    required String email,
    required String password
  }) async{
    String res = "Some Error Occured";
    try{
      if(email.isNotEmpty || password.isNotEmpty)
      {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "Success";
      }
    }
    catch(err)
    {
      res = err.toString();
    }
    return res;
  }

}
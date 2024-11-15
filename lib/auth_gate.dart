import 'package:chatkoko/homepage.dart';
import 'package:chatkoko/login_or_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class authgate extends StatelessWidget {
  const authgate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), 
      builder: (context,snapshot){

//user is loggedin
if(snapshot.hasData){
  return  homepage();
}




//user is not loggedin
else{
  return const registerorlogin();
}



      }
      ),
    );
  }
}
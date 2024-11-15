import 'package:chatkoko/auth_gate.dart';
import 'package:chatkoko/firebase_options.dart';
import 'package:chatkoko/themeprovider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
       options: DefaultFirebaseOptions.currentPlatform
    );
      runApp(
      ChangeNotifierProvider(create: (context)=> Themeprovider(),
      child: const MyApp(),
    )
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const authgate(),
      theme: Provider.of<Themeprovider>(context).themedata,
      
    );
  }
}
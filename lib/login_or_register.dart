import 'package:chatkoko/login_page.dart';
import 'package:chatkoko/register_page.dart';
import 'package:flutter/widgets.dart';

class registerorlogin extends StatefulWidget {
  const registerorlogin({super.key});

  @override
  State<registerorlogin> createState() => _registerorloginState();
}

class _registerorloginState extends State<registerorlogin> {

bool showLoginPage=true;

  void togglepages(){
    setState(() {
      showLoginPage=!showLoginPage;
    });
  }
  @override
  Widget build(BuildContext context) {
   if(showLoginPage){
    return loginpage(ontap: togglepages);
   }else{
    return registerpage(ontap: togglepages,);
   }
  }
}
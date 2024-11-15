import 'package:chatkoko/auth_service.dart';
import 'package:chatkoko/my_button.dart';
import 'package:chatkoko/textfield.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class registerpage extends StatelessWidget {

   final TextEditingController _emailcontroller=TextEditingController();
  final TextEditingController _passwordcontroller=TextEditingController();
   final TextEditingController _confirmcontroller=TextEditingController();
     final void Function()? ontap;
   registerpage({super.key, required this.ontap});

  void register(BuildContext context){
//get auh service;
final _auth=authservices();

//password match create user
if(_passwordcontroller.text==_confirmcontroller.text){
try{
  _auth.signupwithemailpassword(_emailcontroller.text,_passwordcontroller.text);

}catch  (e){
   showDialog(context: context, builder: (context)=>AlertDialog(
    title: Text(e.toString()),
  )
  );
}
}
//if password don't match=>show error to user
else{
   showDialog(context: context, builder: (context)=>const AlertDialog(
    title: Text("password dont match. try again!"),
  )
  );
}
  }
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                
                height: 170,
                width: 170,
          child:   Lottie.asset('assets/truck.json',fit: BoxFit.fill),

              ),
              // Icon(
              //   Icons.person,
              //   size: 60,
              //   color: Theme.of(context).colorScheme.primary,
              // ),
              // const SizedBox(height: 50,),
              Text("Let's create a account for you!",style: TextStyle(fontSize: 16,color: Theme.of(context).colorScheme.primary),),
              const SizedBox(height: 25,),
              textfield(
                hinttext: 'Email',
                obscuretext: false,
                controller: _emailcontroller,
              ),
              const SizedBox(height: 10,),
                textfield(
                  obscuretext: true,
                hinttext: 'Password',
                controller: _passwordcontroller,
              ),
                const SizedBox(height: 10,),
                textfield(
                  obscuretext: true,
                hinttext: 'confirm Password',
                controller: _confirmcontroller,
              ),
              const SizedBox(height: 25,),
          
              mybutton(
                text: 'register',
                onTap: ()=>register(context),
              ),
              const SizedBox(height: 25,),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("already have a account?",
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  GestureDetector(
               onTap: ontap,
                    child: Text(" Login now!",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),))
                ],
              )
          
            ],
          ),
        ),
      ),
    );
  }
}
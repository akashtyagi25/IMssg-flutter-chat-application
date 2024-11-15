// ignore_for_file: use_build_context_synchronously

import 'package:chatkoko/auth_service.dart';
import 'package:chatkoko/my_button.dart';
import 'package:chatkoko/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;

class loginpage extends StatefulWidget {
  final void Function()? ontap;
  loginpage({super.key, required this.ontap});

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  rive.StateMachineController? stateMachineController;

  // Input controller Rive
  FocusNode emailfocusnode = FocusNode();
  final TextEditingController _emailcontroller = TextEditingController();

  FocusNode passwordfocusnode = FocusNode();
  final TextEditingController _passwordcontroller = TextEditingController();

  
  bool isloading=false;
  rive.SMIInput<bool>? isChecking;
  rive.SMIInput<bool>? isHandsUp;
  rive.SMIInput<bool>? trigSuccess;
  rive.SMIInput<bool>? trigFail;
  rive.SMIInput<double>? numLook;

  @override
  void initState() {
    emailfocusnode.addListener(emailfocus);
    passwordfocusnode.addListener(passwordfocus);
    super.initState();
  }

  @override
  void dispose() {
    emailfocusnode.removeListener(emailfocus);
    passwordfocusnode.removeListener(passwordfocus);
    super.dispose();
  }

  void emailfocus() {
    isChecking?.change(emailfocusnode.hasFocus);
  }

  void passwordfocus() {
    if (passwordfocusnode.hasFocus) {
     isHandsUp?.change(true); // Hands up when password field is focused
    trigSuccess?.change(false);
    trigFail?.change(false);
     
    } else {
      isHandsUp?.change(false); // Hands down when focus is lost
      
    }
  }

  void login(BuildContext context) async {
    // Unfocus text fields when the user taps the login button
    FocusScope.of(context).unfocus();

    

    // Set loading state to true and show loading spinner
    setState(() {
     
      isloading=true;
   
    });

    // Auth servicel
    final authservice = authservices();

     

    try {
      // Attempt to sign in with email and password
      await authservice.signinwithemailpassword(
        _emailcontroller.text, _passwordcontroller.text);
        
   

   await Future.delayed(const Duration(seconds: 2));


    } on FirebaseAuthException catch (e) {
       setState(() {
      trigFail?.change(true);  // Sad teddy
      trigSuccess?.change(false);  // Disable happy teddy
    });

      // Handle specific FirebaseAuth errors
      if (e.code == 'network-request-failed') {
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            title: Text('Network Error'),
            content: Text('Please check your internet connection and try again.'),
          ),
        );
      } else if (e.code == 'user-not-found') {
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            title: Text('User Not Found'),
            content: Text('No user found with this email.'),
          ),
        );

    
      } else if (e.code == 'wrong-password') {
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            title: Text('Incorrect Password'),
            content: Text('The password you entered is incorrect.'),
          ),
        );
            // Add a delay so that the user can see the fail animation
      
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Login Failed'),
            content: Text(e.message ?? 'An unknown error occurred.'),
          ),
        );
      }

      
    } catch (e) {
      // Catch any other exceptions that aren't FirebaseAuthException
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(e.toString()),
        ),
      );
    } finally {
        
      if (mounted) {
      
        setState(() {
         isloading=false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
       backgroundColor: Theme.of(context).colorScheme.background,
      body: GestureDetector(
        // Unfocus text fields when tapping outside of them
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 150,
                  child: rive.RiveAnimation.asset(
                    "assets/rive/login.riv",
                    stateMachines:  ["Login Machine"],
                    onInit: (rive.Artboard artboard) {
                      stateMachineController = rive.StateMachineController.fromArtboard(
                        artboard, 
                        "Login Machine"
                      );
                      if (stateMachineController == null) return;
                      artboard.addController(stateMachineController!);
                      isChecking = stateMachineController?.findInput("isChecking");
                      isHandsUp = stateMachineController?.findInput("isHandsUp");
                      trigSuccess = stateMachineController?.findInput("trigSuccess");
                      trigFail = stateMachineController?.findInput("trigFail");
                      numLook = stateMachineController?.findInput("numLook");
                    },
                  ),
                ),
                textfield(
                  focusNode: emailfocusnode,
                  hinttext: 'Email',
                  obscuretext: false,
                  controller: _emailcontroller,
                  onChanged: (value) {
                    // Update eye movement based on input length
                    numLook?.change(value.length.toDouble());
                  },
                ),
                const SizedBox(height: 10),
                textfield(
                  focusNode: passwordfocusnode,
                  controller: _passwordcontroller,
                  obscuretext: true,
                  hinttext: 'Password',
                  onChanged: (value) {},
                ),
                const SizedBox(height: 25),
               // Show spinner if loading
                     mybutton(
                       text: 'Login',
                       isLoading: isloading,
                       loadingColor: Colors.white,
                        
                        onTap:isloading?null: () => login(context,),
                        
                        
                      ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not A Member?",
                      style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                    GestureDetector(
                      onTap: widget.ontap,
                      child: const Text(
                        " Register now!",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.all(35.0),
                  child: ElevatedButton(
                    onPressed: () => authservices().signinwithgoogle(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      minimumSize: const Size(70, 70),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/google.png", width: 50, height: 30),
                        const Text('Continue with Google'),
                      ],
                    ),
                  ),
                )
              ],
            ),
           ),
        ),
      ),
    );
  }
}

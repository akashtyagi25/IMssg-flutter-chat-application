import 'package:flutter/material.dart';

class textfield extends StatelessWidget{
  final String hinttext;
  final bool obscuretext;
  final TextEditingController controller;
  final FocusNode? focusNode; 
   final Function(String)? onChanged;

  const textfield({super.key,required this.hinttext,required this.obscuretext,required this.controller,this.focusNode,this.onChanged});
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:25.0),
      child: TextField(
        obscureText: obscuretext,
        controller: controller,
        focusNode: focusNode,
      
      decoration :InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
          borderRadius: BorderRadius.circular(10)
        ),
        focusedBorder:  OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                 borderRadius: BorderRadius.circular(10)
        ),
        fillColor: Theme.of(context).colorScheme.secondary,
        filled: true,
        hintText: hinttext,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        
      ),
      onChanged: onChanged,
      
      
      ),
    );
  }
  
  

}
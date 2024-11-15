import 'package:flutter/material.dart';

class mybutton extends StatelessWidget{
  final String text;
  final bool isLoading; // Add a parameter to control loading state
  final void Function()? onTap;
   final Color loadingColor; // Add loading color
  const mybutton({super.key,required this.text,required this.onTap,this.isLoading = false,this.loadingColor = Colors.white,});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
  return GestureDetector(
    onTap: isLoading?null:onTap,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade700,
        borderRadius: BorderRadius.circular(8)
      ),
      padding: EdgeInsets.all(25),
      margin: EdgeInsets.symmetric(horizontal: 25),
      child: Center(
          child: isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
                  ),
                )
              : Text(text, style: TextStyle(color: Colors.grey.shade300)), // Show text if not loading
        ),
      
    
    ),
  );
  }

}
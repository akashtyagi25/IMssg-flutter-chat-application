import 'package:flutter/material.dart';

class Usertile extends StatelessWidget {
  final String text;
  final void Function()? ontap;
  const Usertile({super.key,required this.ontap,required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius:BorderRadius.circular(12), 
        ),
        margin: EdgeInsets.symmetric(vertical: 5,horizontal: 25),
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            //icon
         const   Icon(Icons.person),
            //username
           const SizedBox(width: 20,),
              Text(text),

          ],
        ),
      ),
    );
  }
}
import 'package:chatkoko/blockeduserpae.dart';
import 'package:chatkoko/themeprovider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class settingspage extends StatelessWidget {
  const settingspage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(title: Text("settings"),
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.grey,
      elevation: 0,
      centerTitle: true,
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          children: [
            //dark mode
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12)
              ),
              margin:const  EdgeInsets.only(right: 25,left: 25,top: 10),
              padding: const EdgeInsets.only(left: 25,right: 25,top: 20,bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //dark mode
                  const Text("dark mode"),
                  //switch toggle
                  CupertinoSwitch(
                    value: Provider.of<Themeprovider>(context,listen: false).isdarkmode,
                    onChanged: (value) => 
                    Provider.of<Themeprovider>(context,listen: false).toggletheme(),
                    ), 
              
                  
              
                ],
              ),
            ),

//blockred users 
 Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12)
              ),
              margin:const  EdgeInsets.only(right: 25,left: 25,top: 10),
              padding: const EdgeInsets.only(left: 25,right: 25,top: 20,bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //dark mode
                  const Text("blocked users"),
                  //button to go to blocked page

                  IconButton(onPressed: ()=>Navigator.push(context,MaterialPageRoute(builder: (context)=> blockeduserspage(),)),
                   icon: Icon(Icons.arrow_forward_rounded,color: Theme.of(context).colorScheme.primary,))
                  
              
                ],
              ),
            ),
          ],
        ),
      ),
      
    );
  }
}
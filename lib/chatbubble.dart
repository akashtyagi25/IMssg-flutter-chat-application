import 'package:chatkoko/chat_service.dart';
import 'package:chatkoko/themeprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class chatbubble extends StatelessWidget {
  final String message;
  final bool isCurrentuser;
  final String messageid;
  final String userid;

  const chatbubble({
    super.key,
    required this.isCurrentuser,
    required this.message,
    required this.messageid,
    required this.userid
    });
    //show options
void _showoptions(BuildContext context,String messageid,String userid){
  showModalBottomSheet(context: context, builder:(context) {
    return SafeArea(child: Wrap(children: [



        //report message button

  ListTile(
    leading: const Icon(Icons.flag),
    title: Text('Report'),
    onTap: (){
      Navigator.pop(context);
      _reportcontent(context,messageid,userid);
    },
  ),

        //block user button
ListTile(
    leading: const Icon(Icons.block),
    title: Text('Block User'),
    onTap: (){
      Navigator.pop(context);
      _blockuser(context, userid);
    },
  ),


        //cancel button
ListTile(
    leading: const Icon(Icons.cancel),
    title: Text('Cancel'),
    onTap: ()=>Navigator.pop(context),

  ),

    ],));
  },);
}
 

//report message
void _reportcontent(BuildContext context,String messageid, String userid){
showDialog(context: context, builder: (context)=>AlertDialog(
  title: const Text("Report Message"),
  content: Text("Are you want to report this message?"),
  actions: [
    //cancel button
    TextButton(onPressed: (){Navigator.pop(context);}, child: const Text("Cancel")),
  
  //report button
      TextButton(onPressed: (){
        Chatservice().reportuser(messageid, userid);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text("Message Reported!") ));
        }, 
        child: const Text("Report")),

  
  ],
));
}

//block user
void _blockuser(BuildContext context, String userid){
showDialog(context: context, builder: (context)=>AlertDialog(
  title: const Text("Block User"),
  content: Text("Are you want to Block this User?"),
  actions: [
    //cancel button
    TextButton(onPressed: (){Navigator.pop(context);}, child: const Text("Cancel")),
  
  //block button
      TextButton(onPressed: (){
        //person block
        Chatservice().blockuser( userid);
        //dismiss dialog
        Navigator.pop(context);
        //dismiss page
        Navigator.pop(context);
        //let user know of result
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text("User blocked!") ));
        }, 
        child: const Text("block")),

  
  ],
));
}


  @override
  Widget build(BuildContext context) {

    //light vs dark mode for correct bubble colors
   bool isdarkmode=
                  Provider.of<Themeprovider>(context,listen: false).isdarkmode;
   
   
    return GestureDetector(
      onLongPress: () {
        
       if(!isCurrentuser){
            //show options
          _showoptions(context, messageid, userid);

        }
      },
      child: Container(
        decoration: BoxDecoration(
          color:isCurrentuser? (isdarkmode? Colors.green.shade600:Colors.green.shade500)
          :(isdarkmode? Colors.grey.shade800: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(15)
        ),
        padding:const EdgeInsets.all(13),
        margin:const EdgeInsets.symmetric(vertical: 3.5,horizontal: 25),
        child: Text(message,
        style: TextStyle(color:isCurrentuser? Colors.white:(isdarkmode? Colors.white:Colors.black),),
      )),
    );
  }
}
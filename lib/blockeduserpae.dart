import 'package:chatkoko/auth_service.dart';
import 'package:chatkoko/chat_service.dart';
import 'package:chatkoko/usertile.dart';
import 'package:flutter/material.dart';

class blockeduserspage extends StatelessWidget {


 blockeduserspage({super.key});
    //chat & auth service
  final Chatservice chatservice=Chatservice();
  final authservices auth_service=authservices();


//show confrm unblock box
void _showunblockbox(BuildContext context,String userid){
  showDialog(context: context, builder: (context)=>AlertDialog(
    title: const Text("Unblock user"),
    content: const Text("are you want to unblock user?"),
    actions: [
      //cancel button
  TextButton(onPressed: ()=>Navigator.pop(context), child: const Text("cANCEL") ),

      //unblock button

        TextButton(onPressed: (){
          chatservice.unblockuser(userid);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("user unblocked!")));
        }, child: const Text("unblock") )

    ],
  ) ,);
}


  @override
  Widget build(BuildContext context) {
// get current user id
String userid=auth_service.getcurrentuser()!.uid;



// ui
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar:  AppBar(
        title:const Text("blocked users",style: TextStyle(fontSize: 18),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [

        ],
      ),
      body: StreamBuilder<List<Map<String,dynamic>>>(stream: chatservice.getblockeduserstream(userid),
      builder: (context,snapshot){

        //errors
        if(snapshot.hasError){
          return const Center(child: Text("Error Loading...."),);

        }
        //loading
        if(snapshot.connectionState==ConnectionState.waiting){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final blockedusers=snapshot.data?? [];

        //no users
if(blockedusers.isEmpty){
  return const Center(child: Text("No Blocked users"),);
}


        //load complete
  return ListView.builder(
    itemCount: blockedusers.length,
    itemBuilder: (context,index){
final User=blockedusers[index];
return Usertile(
 text: User["email"],
 ontap: ()=>_showunblockbox(
  context, User['uid']
 ),);
  },);
      },
      ),
    );
  }
}
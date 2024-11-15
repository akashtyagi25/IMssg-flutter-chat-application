import 'package:chatkoko/auth_service.dart';
import 'package:chatkoko/chat_service.dart';
import 'package:chatkoko/chatpage.dart';
import 'package:chatkoko/drawer.dart';
import 'package:chatkoko/usertile.dart';
import 'package:flutter/material.dart';

class homepage extends StatefulWidget {
   homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  
  //chat & auth service
final Chatservice _chatservice=Chatservice();

final authservices _authservice=authservices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(title: const Text("home",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w400),),
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.grey,
      centerTitle: true,
      ),
      drawer: const drawer(),
      body: _builduserlist(),
    );
  }

  //build a list of users except for the current logged in user
  Widget _builduserlist(){
    return StreamBuilder(stream: _chatservice.getuserstreamexcludingblocked(),
     builder: (context,snapshot){
      //error
      if(snapshot.hasError){
        return const Center(child:  Text("error"));
      }

      //loading.....
    if(snapshot.connectionState==ConnectionState.waiting){
      return const Center(child:  Text("loading"));
    }


      //return list view
  
    return ListView(
      children: snapshot.data!.map<Widget>((userdata)=>_builduserlistitem(userdata,context)).toList(),
    );

     }
     );
  }

  //build individual list tile for user
  Widget _builduserlistitem(Map<String,dynamic>userdata,BuildContext context){
    //display all users except current user

   if(userdata["email"] != _authservice.getcurrentuser()!.email){
     return Usertile(
      text: userdata["email"],
      ontap: (){
        //tapped on a user go to chatpage
        Navigator.push(context, MaterialPageRoute(builder:(context) => Chatpage(
          receiveremail: userdata["email"],
          receiverid: userdata["uid"],
        ),));

      },
    );
   }else{
    return Container();
   }
  }
}
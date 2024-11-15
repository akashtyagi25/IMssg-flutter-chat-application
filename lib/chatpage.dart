import 'package:chatkoko/auth_service.dart';
import 'package:chatkoko/chat_service.dart';
import 'package:chatkoko/chatbubble.dart';
import 'package:chatkoko/textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chatpage extends StatefulWidget {
  final String receiveremail;
  final String receiverid;
    Chatpage({super.key,required this.receiveremail,required this.receiverid});

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
//text controller
final TextEditingController _messagecontroller=TextEditingController();

 //chat&auth service
 final Chatservice _chatservice=Chatservice();
 final authservices _authservice=authservices();


//for textfield focus
FocusNode myfocusnode=FocusNode();
@override
  void initState() {
    super.initState();

    //add listener to focus node
myfocusnode.addListener((){
  if(myfocusnode.hasFocus){
    //cause a delay so that the keyboard has a time to show up
    //then the amount of remaining space will be calculated
    //then scroll down
    Future.delayed(const Duration(milliseconds: 400),()=> scrolldown(),);
  }
});

//wait a bit for listener to be built then scroll down
Future.delayed(const Duration(milliseconds: 300),()=> scrolldown());

  }
  @override
  void dispose() {
    myfocusnode.dispose();
    _messagecontroller.dispose();
    super.dispose();
  }
  //scroll controller

  final ScrollController _scrollController=ScrollController();
  void scrolldown(){
     // Ensure that the scroll controller has clients
  if (_scrollController.hasClients) {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 400),
      curve: Curves.fastOutSlowIn,
    );
  }
  }


 //send message
 void sendmessage() async{
//if something is inside textfield
if(_messagecontroller.text.isNotEmpty){
  //send the message

  await _chatservice.sendmessage(widget.receiverid, _messagecontroller.text);


  //clear textcontroller
  _messagecontroller.clear();
}

scrolldown();

 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(title: Text(widget.receiveremail,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),),
      
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.grey,
      centerTitle: true,
      ),
      body: Column(
        children: [
          //display all messages
            Expanded(child: _buildmessagelist(),
            ),

          //user input
          _builduserinput(),

        ],
      ),
    );
  }

  //build message list
Widget _buildmessagelist(){
  String senderid=_authservice.getcurrentuser()!.uid;
  return StreamBuilder(
    stream: _chatservice.getmessage(widget.receiverid, senderid), 
  builder: (context,snapshot){
//errors
if(snapshot.hasError){
  return const Text("error");
}
 // Check if the snapshot has no data
      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const Center(child: Text("No messages available"));
      }

//loading
if(snapshot.connectionState==ConnectionState.waiting){
  return const Center(child:  Text("loading...."));
}

// Once the data is loaded, scroll to the bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrolldown();  // Scroll down after the frame is rendered
      });
//return list view
return ListView(
  controller: _scrollController,
  children: snapshot.data!.docs.map((doc)=> _buildmessageitem(doc)).toList(),


);


  });
}

//build message item
Widget _buildmessageitem(DocumentSnapshot doc){
Map<String,dynamic>data = doc.data() as Map<String,dynamic>;
//is current user

 bool isCurrentuser=data['senderid']==_authservice.getcurrentuser()!.uid;


//align message to the right if sender is the current state otherwise left
var alignment
            =isCurrentuser?Alignment.centerRight:Alignment.centerLeft;


return Container(
  alignment: alignment,
  child: Column(
    crossAxisAlignment: isCurrentuser?CrossAxisAlignment.end:CrossAxisAlignment.start,
    children: [
      chatbubble(isCurrentuser: isCurrentuser, message: data["message"],
      messageid: doc.id,
      userid: data["senderid"],
      )
    ],
  ));
}

//build message input
Widget _builduserinput(){
  return Padding(
    padding: const EdgeInsets.only(bottom: 35.0),
    child: Row(
      children: [
          //textfield take up most of the space
      Expanded(
        
        child: textfield(
          
        hinttext: "Type a Message", 
        obscuretext: false, 
        controller: _messagecontroller,
        focusNode: myfocusnode,
        )),
          //send button
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle
            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendmessage, 
              icon:  Icon(
                Icons.send,
                color: Colors.white,
              ),
              ),
          )
    
      ],
    ),
  );
}
}
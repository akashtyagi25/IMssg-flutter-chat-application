import 'package:chatkoko/messagemodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chatservice extends ChangeNotifier{
//get instance of firebase & auth
final FirebaseFirestore _firestore=FirebaseFirestore.instance;
final FirebaseAuth _auth=FirebaseAuth.instance;

//get all user stream

Stream<List<Map<String,dynamic>>> getuserstream(){
  return _firestore.collection("users").snapshots().map((snapshot){
return snapshot.docs
.where((doc)=>doc.data()['email']!= _auth.currentUser!.email)
.map((doc)=>doc.data()).toList();
  });
}

  // Other methods

  

//get all user stream except blocked user
Stream<List<Map<String,dynamic>>>getuserstreamexcludingblocked(){
  final currentuser=_auth.currentUser;

  return _firestore.collection('users').doc(currentuser!.uid).collection('blockedusers').snapshots().asyncMap((snapshot)async{

    // get bocked user id

final blockeduserid = snapshot.docs.map((doc)=>doc.id).toList();
  
  //get all users
  final usersnapshot=await _firestore.collection('users').get();

  //return as stream list excepted currentuser and blocked user
  return usersnapshot.docs.where((doc)=>doc.data()['email']!=currentuser.email && !blockeduserid.contains(doc.id)).map((doc)=> doc.data()).toList();

  }) ;

  
}


//send message
Future<void> sendmessage(String receverid,message)async{
  //get current user info
final String currentuserid=_auth.currentUser!.uid;
 final String currentuseremail=_auth.currentUser!.email!;
 final Timestamp timestamp=Timestamp.now();
  //create a new message
Message newmessage=Message(
  senderid: currentuserid,
   message: message, 
   receiverid: receverid,
    senderemail: currentuseremail, 
    timestamp: timestamp
    );
  //construct chat roomid for the 2 user(sorted to ensure uniqueness)

List<String> ids=[currentuserid,receverid];
ids.sort();//sort the id this ensure chatroom id is same for any 2 person
 String chatroomid=ids.join('_');
 
  //add new message to database
await _firestore.collection("chat_rooms").doc(chatroomid).collection("messages").add(newmessage.toMap());
}

//get message
Stream<QuerySnapshot>getmessage(String userid,otheruserid){
  //construct chatroom 2user
  List<String>ids = [userid,otheruserid];
  ids.sort();
  String chatroomid=ids.join('_');

  return _firestore.collection("chat_rooms").doc(chatroomid).collection("messages").orderBy("timestamp",descending: false).snapshots();

}

//report user
Future<void> reportuser(String messageid,String userid)async {
  final currentUser=_auth.currentUser;
  final report={
    'reportedby':currentUser!.uid,
    'messageid':messageid,
    'messageownerid':userid,
    'timestamp':FieldValue.serverTimestamp(),
  };

  await _firestore.collection("reports").add(report);
}


//block user
Future<void> blockuser(String userid)async{
  final currentUser=_auth.currentUser;
  await _firestore.collection('users')
  .doc(currentUser!.uid)
  .collection('blockedusers')
  .doc(userid)
  .set({});
  notifyListeners();
}




//unblock user
Future<void> unblockuser(String blockeduserid)async{
  final currentUser=_auth.currentUser;
  await _firestore.collection('users')
  .doc(currentUser!.uid)
  .collection('blockedusers')
  .doc(blockeduserid)
  .delete();
 
}


//get blocked user stream
Stream<List<Map<String,dynamic>>> getblockeduserstream(String userid){
  return _firestore.collection("users").doc(userid).collection('blockedusers').snapshots().asyncMap((snapshot) async{

//get list of blocked user list

   
    final blockeduserid=snapshot.docs.map((doc)=>doc.id).toList();
  
final userdocs=await Future.wait(

blockeduserid.map((id)=> _firestore.collection('users').doc(id).get()),
);

//return as a list
return userdocs.map((doc)=> doc.data()as Map<String,dynamic>).toList();

  });
}

  }


import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderid;
  final String senderemail;
  final String message;
  final String receiverid;
  final Timestamp timestamp;

  Message({
  required this.senderid,
  required this.message,
  required this.receiverid,
  required this.senderemail,
  required this.timestamp
});


//convrt into map
Map<String,dynamic> toMap(){
  return{
    'senderid':senderid,
    'senderemail':senderemail,
    'message': message,
    'receiverid':receiverid,
    'timestamp':timestamp
  };
}

}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class authservices{

//instance of auth & firestore
final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore=FirebaseFirestore.instance;

//get currentuser
User? getcurrentuser(){
  return _auth.currentUser;
}

//signin user in
Future <UserCredential> signinwithemailpassword(String email,password) async{
  try{
    UserCredential usercredential=await _auth.signInWithEmailAndPassword(email: email, password: password);

//save user info it doesnt exist
    _firestore.collection("users").doc(usercredential.user!.uid).set(
  {
    'uid': usercredential.user!.uid,
    'email': email,
  }
);


    return usercredential;
  }on FirebaseAuthException catch (e) {
    throw Exception(e.code);
  }
}

//signup
Future<UserCredential> signupwithemailpassword(String email,password)async{
  try{
    //create user
    UserCredential usercredential=await _auth.createUserWithEmailAndPassword(email: email, password: password);

//save user info in a separate doc
_firestore.collection("users").doc(usercredential.user!.uid).set(
  {
    'uid': usercredential.user!.uid,
    'email': email,
  }
);

    return usercredential;
  }on FirebaseAuthException catch (e){
    throw Exception(e.code);
  }
}

//signout
Future<void> signout() async{
  return await _auth.signOut();
}

//goggle sign in

signinwithgoogle() async{
  //begin interactive signin process
  final GoogleSignInAccount? guser=await GoogleSignIn().signIn();

  //cancel signin
if(guser==null) return;


  //obtain auth detail from request
  final GoogleSignInAuthentication gauth=await guser.authentication;

  //create a new credential for user
  final credential = GoogleAuthProvider.credential(
    accessToken: gauth.accessToken,
    idToken: gauth.idToken,
  );

  //finally sign in
  return await _auth.signInWithCredential(credential);




}

//errors


}
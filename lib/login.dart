import 'dart:html';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_prefererences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
    import 'home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState CreateState() => _LoginState();
}

  class _LoginState extends State<Login>{
  final GoogleSignIn googleSignIn=  new GoogleSignIn();
  final FirebaseAuth firebaseAuth= FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  SharedPreferences preferences ;
  bool loading= false;
  bool isLogedin = false;

  @override
  void initState(){
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async{
    setState((){
loading= true;
  });

preferences=await SharedPreferences.getInstance();
isLogedin= await googleSignIn.isSignedIn();
if(isLogedin){
  Navigator.pushReplacement(context,MaterialPageRoute(builder:(context) => Homepage()));
}
setState(() {
  loading= false;
});
  }

  Future handleSignIn() async{

    preferences=await SharedPreferences.getInstance();

    setState((){
      loading=true;
    });

    GoogleSignInAccount googleUser= await googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication=
      await googleUser.authentication;
    FirebaseUser firebaseUser=await firebaseAuth.signInWithGoogle(
      idToken: googleSignInAuthentication.idToken, 
      accessToken: googleSignInAuthentication.accessToken );

    if(firebaseUser != null){
      final QuerySnapshot result = await Firestore.instance
      .collection('users')
      .where('id',isEqualTo:firebaseUser.uid)
      .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;

      if(documents.length==0){
//        insert the user to our collection
      Firestore.instance
      .collection('users')
      .document(firebaseUser.uid)
      .setData({
        'id': firebaseUser.uid,
        'username': firebaseUser.displayName,
        'profilePicture': firebaseUser.photoUrl
      });

      await preferences.setString('id', firebaseUser.uid);
      await preferences.setString('username', firebaseUser.displayName);
      await preferences.setString('photoUrl', firebaseUser.displayName);
    }else{
      await preferences.setString('id', documents[0]['id']);
      await preferences.setString('username', documents[0]['username']);
      await preferences.setString('photoUrl', documents[0]['photoUrl']);
    }
    Fluttertoast.showToast(msg: 'Login was successful');
    setState(() {
      loading = false;
    });
    Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (contex) => HomePage()) );
  }else{
    Fluttertoast.showToast(msg: 'Login failed ');
  }
 }
  @override
Widget build(BuildContext context) {
    return Scaffold( 
      body: Stack(
        children: <Widget>[ 
          Image.asset(
            '',//image
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity,
          ), 
          //to do
          Container(
            color: Colors.black.withOpacity(0.2),
            width: double.infinity,
            height: double.infinity,
          ),

          Padding(
            padding: const EdgeInsets.only(top:200.0),
            child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Material(
                         borderRadius: BorderRadius.circular(10.0),
                         color: Colors.white.withOpacity(0.8),
                         elevation: 0.0,
                         child: Padding(
                           padding: const EdgeInsets.only(left:12.0),
                           child: TextFormField(
                             controller: _emailTextController,
                             decoration: InputDecoration(
                               hintText: 'Email',
                               icon: Icon(Icons.alternate_email),                                                
                             ),
                             validator: (value){
                               if(value.isEmpty){
                                 Pattern pattern =
                                  'gvgv' ; //pattern to do
                                 RegExp regex = new RegExp(pattern);
                                 if(!regex.hasMatch(value))
                                  return 'Please make sure your email address valid';
                                 else
                                  return null;
                               }
                             },
                           ),
                         ),
                       ),
                     ),

                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Material(
                         borderRadius: BorderRadius.circular(10.0),
                         color: Colors.white.withOpacity(0.8),
                         elevation: 0.0,
                         child: Padding(
                           padding: const EdgeInsets.only(left:12.0),
                           child: TextFormField(
                             controller: _passwordTextController,
                             decoration: InputDecoration(
                               hintText: 'Password',
                               icon: Icon(Icons.lock_outline),                                                
                             ),
                             validator: (value){
                               if(value.isEmpty){
                                 return 'This password field cannot be empty';
                               }else if(value.length<6){
                                 return 'The password has to be at least 6 characters long';
                               }
                               return null;
                             },                                                                              
                           ),
                         ),
                       ),
                     ),

                      Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Material(
                         borderRadius: BorderRadius.circular(20.0),
                         color: Colors.blue,
                         elevation: 0.0,
                         child: MaterialButton(onPressed: (){},
                         minWidth: MediaQuery.of(context).size.width,
                          child: Text('Login', textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),),
                        ),
                       ),
                     ),
                     Expanded(child: Container()),
                      Divider(color: Colors.white,),
                        Text('Other login in option',style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),),
                      Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Material(
                         borderRadius: BorderRadius.circular(20.0),
                         color: Colors.red,
                         elevation: 0.0,
                         child: MaterialButton(onPressed: (){
                           handleSignIn();
                         },
                         minWidth: MediaQuery.of(context).size.width,
                         child: Text('google', textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),),
                        ),
                       ),
                     )
                    ],
                )),
              ),
          ),
          
          Visibility(
            visible: loading ?? true,
            child: Center(
              child: Container(
                alignment: Alignment.center,
                color: Colors.white.withOpacity(0.9),
                child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              ),
            ),
          )
        ],
      ),    
    );
  }
}
// bottomNavigationBar: Container(
//          child: Padding(
//            padding: const EdgeInsets.only(
//              left:12.0, right:12.0, top:8.0, bottom: 8.0),
//            child: FlatButton(
//                color: Colors.red.shade900,
//                onPressed: (){
//                  
//                },
//               child: Text(
//                  'Sign in/ sign up with google',
//                   style: TextStyle(color: Colors.white),
//                   )),
//          ),
//      ),

 
                        
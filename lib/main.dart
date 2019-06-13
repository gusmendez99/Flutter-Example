/*import 'package:flutter/material.dart';
import 'LoginScreen.dart';
import 'SignUpScreen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new LoginScreen(),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:forestvillagegt_flutter/Screens/HomeScreen.dart';
import 'package:forestvillagegt_flutter/Screens/LoginScreen.dart';
import 'package:forestvillagegt_flutter/Screens/SignUpScreen.dart';
//import 'package:firebase_auth/firebase_auth.dart';
void main()=>runApp(FireAuth());

class FireAuth extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: "Firebase Auth",
      debugShowCheckedModeBanner: false,
theme: ThemeData(primarySwatch: Colors.blue),
      home:LoginPage(),
      routes: <String,WidgetBuilder>{
        "/userpage":(BuildContext context)=>new Page(),
        "/loginpage":(BuildContext context)=>new LoginPage(),
        "/signup":(BuildContext context)=>new SignUpPage()

      },
    );
  }
}

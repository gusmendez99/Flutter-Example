/*import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'custom/PasswordField.dart';
import 'model/PersonData.dart';
import 'HomeScreen.dart';
import 'SignUpScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State createState() {
    return new LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      new GlobalKey<FormFieldState<String>>();
  PersonData person = new PersonData();
  bool _autovalidate = false;
  bool _isLoading = false;

  /// Validate password field
  String _validatePassword(String value) {
    final FormFieldState<String> passwordField = _passwordFieldKey.currentState;
    if (passwordField.value == null || passwordField.value.isEmpty)
      return 'Please enter a password.';
    return null;
  }

  /// Validate email field
  String _validateEmail(String value) {
    if (value.isEmpty) return 'Email is required.';
    return null;
  }

  /// Sign in button click
  Widget signInButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: new BorderRadius.circular(30.0),
        shadowColor: Colors.deepOrangeAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          onPressed: () => _handleLoginSubmitted(),
          color: Colors.deepOrangeAccent,
          child: Text(
            'Sign In',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  /// Sign UP button click
  Widget signUpButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: new BorderRadius.circular(30.0),
        shadowColor: Colors.deepOrangeAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          onPressed: () => moveToSignUpScreen(),
          color: Colors.deepOrangeAccent,
          child: Text(
            'Sign Up',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  /// Sign in with Google button click
  Widget loginWithGoogleButton() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: new BorderRadius.circular(30.0),
        shadowColor: Colors.blueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 180.0,
          onPressed: () => _handleSignIn(),
          color: Colors.blue,
          child: Text(
            'Sign In With Google',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: new SafeArea(
        top: false,
        bottom: false,
        child: new Form(
          key: _formKey,
          autovalidate: _autovalidate,
          child: new SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                new SizedBox(
                  height: 60.0,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Image.asset(
                      'assets/flutter-logo.png',
                      height: 100.0,
                      width: 100.0,
                    ),
                    new Image.asset(
                      'assets/pluse-icon.png',
                      height: 100.0,
                      width: 100.0,
                    ),
                    new Image.asset(
                      'assets/firebase-logo.png',
                      height: 100.0,
                      width: 100.0,
                    )
                  ],
                ),
                new SizedBox(
                  height: 60.0,
                ),
                new TextFormField(
                  decoration: new InputDecoration(
                    border: new OutlineInputBorder(),
                    hintText: 'Enter your email address',
                    labelText: 'Email',
                    filled: true,
                  ),
                  validator: _validateEmail,
                  onSaved: (String vale) {
                    person.email = vale;
                  },
                  keyboardType: TextInputType.emailAddress,
                  enabled: !_isLoading,
                ),
                new SizedBox(
                  height: 20.0,
                ),
                new PasswordField(
                  fieldKey: _passwordFieldKey,
                  helperText: 'No more than 8 characters.',
                  labelText: 'Password',
                  onSaved: (String value) {
                    setState(() {
                      person.password = value;
                    });
                  },
                  validator: _validatePassword,
                ),
                new SizedBox(
                  height: 10.0,
                ),
                new Text(
                  "Forgot Password",
                  textAlign: TextAlign.end,
                  style: new TextStyle(
                    color: Colors.blueGrey,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.indigo,
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    signUpButton(),
                    signInButton(),
                  ],
                ),
                _isLoading
                    ? new Center(
                        child: new CircularProgressIndicator(
                        backgroundColor: Colors.teal,
                      ))
                    : new SizedBox(
                        height: 1.0,
                      ),
                new SizedBox(
                  height: 35.0,
                ),
                Container(
                  child: Center(child: loginWithGoogleButton()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = await _auth.signInWithCredential(credential);
    print("signed in " + user.displayName);    
    moveToHomeScreen(user);
    print("signed in " + user.photoUrl);
    return user;
  }

  void _handleLoginSubmitted() {
    final FormState form = _formKey.currentState;
    if (!form.validate()) {
      _autovalidate = true; // Start validating on every change.
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      setState(() {
        _isLoading = true;
      });
      UserAuth auth = new UserAuth();
      print(person.email);
      print("password " + person.password);
      auth.verifyUser(person).then((FirebaseUser user) {
        showInSnackBar('Login successfull.');
        setState(() {
          _isLoading = false;
        });
        moveToHomeScreen(user);
      }).catchError((e) {
        setState(() {
          _isLoading = false;
        });
        print(e);
        showInSnackBar(e);
      });
    }
  }

  void moveToHomeScreen(FirebaseUser user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen(user)),
    );
  }

  void moveToSignUpScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()),
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }
}
*/

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
class LoginPage extends StatefulWidget{
  @override
  _LoginPageSate createState()=>_LoginPageSate();
}
class _LoginPageSate extends State<LoginPage>{
	final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  String _email;
  String   _password;
  //google sign
  GoogleSignIn googleauth = new GoogleSignIn();
  final formkey=new GlobalKey<FormState>();
  checkFields(){
    final form=formkey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }



  loginUser(){
    if (checkFields()){
      FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password)
          .then((user){
        print("signed in as ${user.uid}");
        Navigator.of(context).pushReplacementNamed('/userpage');
      }).catchError((e){
        print(e);
      });
    }
  }

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = await _auth.signInWithCredential(credential);
    print("Signedin user ${user.displayName}");
	Navigator.of(context).pushReplacementNamed("/userpage");
    print("signed in " + user.photoUrl);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(

      appBar: AppBar(
        title: Image(image:AssetImage("images/flutter1.png",),height: 30.0,fit: BoxFit.fitHeight,),

        elevation: 0.0,

        centerTitle: true,
        backgroundColor: Colors.transparent,

      ),
      body:
      ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            height: 220.0,
            width: 110.0,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/monkey.gif'),
                    fit: BoxFit.cover),
              borderRadius: BorderRadius.only
                (
                  bottomLeft: Radius.circular(500.0),
                  bottomRight: Radius.circular(500.0)
              ),
           ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Center(
                  child: Form(
                    key: formkey,
                    child: Center(
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[

                          _input("required email",false,"Email",'Enter your Email',(value) => _email = value),
                          SizedBox(width: 20.0,height: 20.0,),
                          _input("required password",true,"Password",'Password',(value) => _password = value),
            new Padding(padding: EdgeInsets.all(8.0),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Row(
                          children: <Widget>[
                            Expanded(
                              child: OutlineButton(
                                child: Text("Login "),
                                onPressed: loginUser
                              ),
                              flex: 1,
                            ),
                            SizedBox(height: 18.0,width: 18.0,),
                           
                            SizedBox(height: 18.0,width: 18.0,),
                            Expanded(
                              flex: 1,
                              child: OutlineButton(
                                  //child: Text("login with google"),
                                 // child: ImageIcon(AssetImage("images/google1.png"),semanticLabel: "login",),
                                  child: Image(image: AssetImage("images/google1.png"),height:28.0,fit: BoxFit.fitHeight),
                                  onPressed: () => _handleSignIn()
								  ),
                            )

                          ],
                    ),
                    SizedBox(height: 15.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'New login with google?',
                          style: TextStyle(fontFamily: 'Montserrat'),
                        ),
                        SizedBox(width: 5.0),
                        InkWell(
                          child: Text(
                            'create new account',
                            style: TextStyle(
                                color: Colors.blue,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline),
                          ),
                        )
                      ],
                    ),
                    OutlineButton(
                        child: Text("signup"),
                        onPressed: (){
                          Navigator.of(context).pushNamed('/signup');
                        }),
                    OutlineButton(
                        child: Text("ui"),
                        onPressed: (){
                          Navigator.of(context).pushNamed('/userpage');
                        })
                  ],

                ),

              ),
            ),),

                        ],

                      ),
                    ),
                  )
              ),
            ),
          ),
        ],
      ) ,
    );
  }
  Widget _input(String validation,bool ,String label,String hint, save ){

    return new TextFormField(
      decoration: InputDecoration(
          hintText: hint,
          labelText: label,
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0)
          ),

      ),
      obscureText: bool,
      validator: (value)=>
      value.isEmpty ? validation: null,
      onSaved: save ,

    );

  }
  
}
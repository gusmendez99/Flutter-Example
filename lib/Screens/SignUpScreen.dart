/*import 'package:flutter/material.dart';
import 'custom/PasswordField.dart';
import 'model/PersonData.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State createState() {
    return new SignUpScreenState();
  }
}

class SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      new GlobalKey<FormFieldState<String>>();
  PersonData person = new PersonData();
  bool _autovalidate = false;
  bool _isLoading = false;

  String _validateName(String value) {
    if (value.isEmpty) return 'Name is required.';
    final RegExp nameExp = new RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

  String _validatePassword(String value) {
    final FormFieldState<String> passwordField = _passwordFieldKey.currentState;
    if (passwordField.value == null || passwordField.value.isEmpty)
      return 'Please enter a password.';
    if (passwordField.value != value) return 'The passwords don\'t match';
    return null;
  }

  String _validateEmail(String value) {
    if (value.isEmpty) return 'Email is required.';
    return null;
  }

  Widget button() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        borderRadius: new BorderRadius.circular(30.0),
        shadowColor: Colors.deepOrangeAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 100.0,
          onPressed: () => _handleSubmitted(),
          color: Colors.deepOrangeAccent,
          child: Text(
            'Sign Up',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: const Text('Sign Up'),
      ),
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
                new TextFormField(
                  decoration: new InputDecoration(
                    border: new OutlineInputBorder(),
                    hintText: 'What do people call you?',
                    labelText: 'Name',
                    filled: true,
                  ),
                  validator: _validateName,
                  onSaved: (String vale) {
                    person.name = vale;
                  },
                  enabled: !_isLoading,
                ),
                new SizedBox(
                  height: 20.0,
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
                  labelText: 'Password *',
                  onSaved: (String value) {
                    setState(() {
                      person.password = value;
                    });
                  },
                ),
                const SizedBox(height: 20.0),
                new TextFormField(
                  decoration: const InputDecoration(
                    border: const OutlineInputBorder(),
                    filled: true,
                    labelText: 'Re-type password',
                  ),
                  maxLength: 8,
                  obscureText: true,
                  validator: _validatePassword,
                  enabled: !_isLoading,
                ),
                new SizedBox(
                  height: 60.0,
                ),
                Container(
                  child: Center(child: button()),
                ),
                _isLoading
                    ? new Center(
                        child: new CircularProgressIndicator(
                        backgroundColor: Colors.teal,
                      ))
                    : new Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSubmitted() {
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
      print("password "+person.password);
      auth.createUser(person).then((FirebaseUser user) {
        showInSnackBar('Signup successfull.');
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
      }).catchError((e) {
        setState(() {
          _isLoading = false;
        });
        print(e);
        showInSnackBar(e);
      });
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }
}
*/

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class SignUpPage extends StatefulWidget{
  @override
  _SignupPageSate createState()=>_SignupPageSate();
}
class _SignupPageSate extends State<SignUpPage>{
  String _email;
  String   _password;
  final formkey=new GlobalKey<FormState>();
  checkFields(){
    final form=formkey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }



   createUser()async{
    if (checkFields()){
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password)
          .then((user){
        print('signed in as ${user.uid}');

        Navigator.of(context).pop();
        Navigator.of(context).pushNamed('/userpage');
      }).catchError((e){
        print(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(

      appBar: AppBar(
        title: Image(image:AssetImage("images/flutter1.png",),
          height: 30.0,
          fit: BoxFit.fitHeight,),
        elevation: 0.0,

        centerTitle: true,
        backgroundColor: Colors.black12,

      ),
      body:ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            height: 210.0,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('images/google2.gif'),
                    fit: BoxFit.contain),
                borderRadius: BorderRadius.only
                  (
                    bottomLeft: Radius.circular(500.0),
                    bottomRight: Radius.circular(500.0)
                )),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Center(
                  child: new Form(
                    key: formkey,
                    child: Center(
                      child: new ListView(
                        shrinkWrap: true,
                        children: <Widget>[

                         _input("required email",false,"Email",'Enter your Email',(value) => _email = value),
                          SizedBox(width: 20.0,height: 20.0,),
                          _input("required password",true,"Password",'Password',(value) => _password = value),

                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(left: 138.0,top: 8.0),
                              child: Row(
                                children: <Widget>[
                                  OutlineButton(
                                    child: Text("Register"),
                                    onPressed: createUser,
                                  ),
                                  SizedBox(height: 18.0,width: 18.0,),


                                ],
                              ),
                            ),
                          ),

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
import 'package:door/utils/Dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:door/Register.dart';
import 'package:door/service/UserService.dart';
import 'package:door/Home.dart';
import 'package:door/dto/AuthDTO.dart';

// Create a Form widget.
class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class LoginFormState extends State<LoginForm> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  AuthDTO user = new AuthDTO.noneContructor();

  Widget _formUI() {
    return new Column(
      children: <Widget>[
        new Padding(
          padding: EdgeInsets.only(top: 110.0),
        ),
        new TextFormField(
          validator: _validateEmail,
          onSaved: (val) {
            this.user.email = val;
          },
          decoration: new InputDecoration(
            hintText: "Email",
            hintStyle: TextStyle(fontSize: 16),
            prefixIcon: const Icon(Icons.email),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.solid,
              ),
            ),
          ),
        ),
        new Padding(padding: EdgeInsets.only(top:20.0)),
        new TextFormField(
          obscureText: true,
          autocorrect: false,
          enableSuggestions: false,
          validator: _validatePassword,
          onSaved: (val) {
            this.user.password = val;
          },
          decoration: new InputDecoration(
            hintText: "Password",
            hintStyle: TextStyle(fontSize: 16),
            prefixIcon: const Icon(Icons.https),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.solid,
              ),
            ),
          ),
        ),
        new Padding(padding: EdgeInsets.only(top:20.0)),
        new ButtonTheme(
            minWidth: double.infinity,
            height: 40.0,
            buttonColor: Colors.blueGrey,
            child: new  RaisedButton(
              onPressed: _sendForm,
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: new Text("Send", style: TextStyle(fontSize: 20),),
            )
        ),
        new ButtonTheme(
            minWidth: double.infinity,
            height: 40.0,
            buttonColor: Colors.grey,
            child: new  RaisedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterForm())
                );
              },
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              child: new Text("Register", style: TextStyle(fontSize: 20),),
            )
        ),
      ],
    );
  }

  String _validatePassword(String value) {
    if (value.length == 0) {
      return "The password is required";
    } else if (value.length < 1) {
      return "The password must be more than 8 characters";
    }
    return null;
  }


  String _validateEmail(String value) {
    String pattern = r'@';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid email";
    } else {
      return null;
    }
  }

  _sendForm() {
    Dialogs dialogs = new Dialogs(context, "Login:");
    if (_key.currentState.validate()) {
      _key.currentState.save();
      UserService userService = new UserService();
      Future<bool> res = userService.login(this.user);
      res.then((value) => {
        if(value){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home())
          )
        }else{
          dialogs.showResponseDialog(Future.value("Login or Password are wrong !"))
        }
      }).catchError((onError)=>{
        dialogs.showResponseDialog(Future.value(onError.toString()))
      });
    } else {
      dialogs.showResponseDialog(Future.value("Form are invalid, please adjust the information !"));
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: new Scaffold(
        appBar: new AppBar(
          title: Text("Login"),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Icon(
                    Icons.input,
                    size: 26.0,
                  ),
                )
            ),
          ],
        ),
        body: new SingleChildScrollView(
          child:new Container(
            alignment: AlignmentDirectional.center,
            margin: new EdgeInsets.all(15.0),
            child: new Center(
              child: new Form(
                key: _key,
                autovalidate: _validate,
                child: _formUI(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
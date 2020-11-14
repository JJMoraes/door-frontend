import 'package:door/service/UserService.dart';
import 'package:door/utils/Dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:door/Login.dart';
import 'package:door/dto/AuthDTO.dart';

// Create a Form widget.
class RegisterForm extends StatefulWidget {
  @override
  RegisterFormState createState() {
    return RegisterFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class RegisterFormState extends State<RegisterForm> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  AuthDTO _user = new AuthDTO.noneContructor();

  Widget _formUI() {
    return new Column(
      children: <Widget>[
        new TextFormField(
          keyboardType: TextInputType.text,
          validator: (val){
            if(val.length ==0) {
              return "The username is required";
            }
            return null;
          },
          onChanged: (val) {
            this._user.username = val;
          },
          decoration: new InputDecoration(
            hintText: "Username",
            hintStyle: TextStyle(fontSize: 16),
            prefixIcon: const Icon(Icons.person),
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
          validator: _validateEmail,
          onChanged: (val) {
            this._user.email = val;
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
          onChanged: (val) {
            this._user.password = val;
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
        new TextFormField(
          obscureText: true,
          autocorrect: false,
          enableSuggestions: false,
          validator: _validateRePassword,
          decoration: new InputDecoration(
            hintText: "Re-password",
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
        new TextFormField(
          autocorrect: false,
          enableSuggestions: false,
          validator: (val){
            if(val.length == 0) {
              return "The code is required";
            }
            return null;
          },
          onChanged: (val) {
            this._user.rfid= val;
          },
          decoration: new InputDecoration(
            hintText: "Code",
            hintStyle: TextStyle(fontSize: 16),
            prefixIcon: const Icon(Icons.code),
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
          buttonColor: Colors.black54,
          child: new  RaisedButton(
            onPressed: _sendForm,
            textColor: Colors.white,
            padding: const EdgeInsets.all(0.0),
            child: new Text("Send", style: TextStyle(fontSize: 20),),
          )
        ),
      ],
    );
  }

  String _validatePassword(String value) {
    if (value.length == 0) {
      return "The password is required";
    } else if (value.length < 8) {
      return "The password must be more than 8 characters";
    }
    return null;
  }

  String _validateRePassword(String value) {
    if (this._user.password != value){
      return "Passwords are differents";
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
    }
    return null;
  }

  _sendForm() {
    Dialogs dialogs = new Dialogs(context, "Register");
    if (_key.currentState.validate()) {
      _key.currentState.save();
      UserService userService = new UserService();
      Future<List> res = userService.register(this._user);
      res.then((value) =>{
        if(value==null){
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginForm())
          )
        }else{
          dialogs.showListResponseDialog(value)
        }
      }).catchError((onError)=>{
        dialogs.showResponseDialog(Future.value(onError.toString()))
      });
    }else {
      setState(() {
        _validate = true;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: new Scaffold(
        appBar: new AppBar(
          title: Text("Register"),
          leading: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginForm())
              );
            },
            child: Icon(
              Icons.arrow_back,  // add custom icons also
            ),
          ),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  child: Icon(
                    Icons.person_add,
                    size: 26.0,
                  ),
                )
            ),
          ],
        ),
        body: new SingleChildScrollView(
          child: new Container(
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
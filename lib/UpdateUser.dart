import 'package:door/dto/UserDTO.dart';
import 'package:door/service/UserService.dart';
import 'package:door/utils/Dialogs.dart';
import 'package:door/dto/AuthDTO.dart';
import 'package:door/utils/Exceptions.dart';
import 'package:flutter/material.dart';

class UpdateUser extends StatefulWidget{

  @override
  UpdateUserState createState(){
    return UpdateUserState();
  }
}

class UpdateUserState extends State<UpdateUser>{

  final UserService userService = new UserService();
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  Future<UserDTO> userModel;
  AuthDTO authUser;
  bool update = false;

  @override
  void initState(){
    super.initState();
    this.userModel = userService.getCurrentUser();
  }

  Widget _userData(){
    return new FutureBuilder<UserDTO>(
      future: this.userModel,
      builder: (context, snapshot){
        switch(snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return new Center(child: CircularProgressIndicator());
          default:
            if(snapshot.hasError){
              return Exceptions.build(context, snapshot.error);
            }else{
              this.authUser = new AuthDTO(snapshot.data.id, snapshot.data.username, snapshot.data.email, '', snapshot.data.rfid);
              return Column(
                children: <Widget>[
                  new TextFormField(
                    initialValue: snapshot.data.username,
                    keyboardType: TextInputType.text,
                    validator: (val){
                      if(val.length == 0) {
                        return "The username is required";
                      }
                      return null;
                    },
                    onChanged: (val) {
                      this.authUser.username = val;
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
                    initialValue: snapshot.data.email,
                    keyboardType: TextInputType.text,
                    validator:_validateEmail,
                    onChanged: (val) {
                      this.authUser.email = val;
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
                    initialValue: '',
                    enableSuggestions: false,
                    validator:_validatePassword,
                    onChanged: (val) async{
                      this.authUser.password = val;
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
                    initialValue: '',
                    autocorrect: false,
                    enableSuggestions: false,
                    validator:_validateRePassword,
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
                    initialValue: snapshot.data.rfid,
                    autocorrect: false,
                    enableSuggestions: false,
                    validator: (val){
                      if(val.length == 0) {
                      return "The code is required";
                      }
                      return null;
                    },
                    onChanged: (val) {
                      this.authUser.rfid = val;
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
        }
      },
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
    if (this.authUser.password != value){
      return "Passwords are different";
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

  _sendForm() async{
    Dialogs dialogs = new Dialogs(context, "Update User: ");
    if (_key.currentState.validate()) {
      _key.currentState.save();
      UserService userService = new UserService();
      // if(await dialogs.showAlertDialog("You will need a approve to be a member again, are you sure ?"))
      dialogs.showResponseDialog(userService.update(this.authUser));
      Navigator.pop(context);
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
          title: Text("Update"),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
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
                  Icons.create,
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
                child: _userData(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
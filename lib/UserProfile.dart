import 'package:door/dto/UserDTO.dart';
import 'package:door/service/UserService.dart';
import 'package:flutter/material.dart';
import 'package:door/utils/Dialogs.dart';

class UserProfile extends StatefulWidget{

  final UserDTO user;

  const UserProfile({Key key, this.user}):super(key:key);

  @override
  UserProfileState createState(){
    return UserProfileState(user);
  }
}

class UserProfileState extends State<UserProfile>{

  final UserService userService = new UserService();
  UserDTO user;
  String role;
  List<DropdownMenuItem<String>> items;

  UserProfileState(UserDTO user){
    this.user = user;
    this.role = user.role;
  }

  List<DropdownMenuItem<String>> _roles(){
    return <String>['ADMIN', 'MEMBER', "ASPIRANT"]
        .map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    Dialogs dialogs = new Dialogs(context, "User Profile");

    return MaterialApp(
      theme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      home: new Scaffold(
        appBar: new AppBar(
          leading: GestureDetector(
              child: Icon(Icons.arrow_back),
              onTap: () {
                Navigator.pop(context);
              },
          ),
          title: Text("User Profile"),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  child: Icon(
                    Icons.person,
                    size: 26.0,
                  ),
                )
            ),
          ],
        ),
        body: new Container(
          margin: new EdgeInsets.all(5.0),
          child: new Column(
            children: <Widget>[
              new Card(
                borderOnForeground: true,
                elevation: double.infinity,
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new ListTile(
                      leading: Icon(Icons.person),
                      title: Text(user.username),
                    ),
                    new ListTile(
                      leading: Icon(Icons.email),
                      title: Text(user.email),
                    ),
                    new ListTile(
                      leading: Icon(Icons.code),
                      title: Text(user.rfid),
                    ),
                    new ListTile(
                      leading: user.isActive?Icon(Icons.check):Icon(Icons.cancel),
                      title: user.isActive?Text("Active"):Text("Inactive"),
                    ),
                    new ListTile(
                      leading: Icon(Icons.perm_contact_calendar),
                      title: DropdownButton<String>(
                        value: role,
                        elevation: 16,
                        style: TextStyle(color: Colors.white),
                        disabledHint: Text(role),
                        underline: Container(
                          height: 2,
                          width: 2,
                          color: Colors.white,
                        ),
                        onChanged: (String newValue) {
                          setState(() {
                            role = newValue;
                          });
                        },
                        items: this.items
                      ),
                      trailing: (this.items == null)?
                      IconButton(onPressed: (){
                          setState((){
                            this.items = _roles();
                          });
                        },icon: Icon(Icons.create),
                      ):
                      IconButton(onPressed: () async{
                        if(await dialogs.showAlertDialog("Are you sure about that action ?")){
                          dialogs.showResponseDialog(userService.updateRole(user, role));
                          setState(() {
                            this.items = null;
                          });
                        }
                        },icon: Icon(Icons.check),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
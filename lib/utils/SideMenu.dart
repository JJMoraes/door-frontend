import 'package:flutter/material.dart';
import 'package:door/service/UserService.dart';
import 'package:door/Home.dart';
import 'package:door/Members.dart';
import 'package:door/Requests.dart';
import 'package:door/Admins.dart';
import 'package:door/Login.dart';

class SideMenu {

  static Future<Widget> build(BuildContext context) async {
    UserService userService = new UserService();

    if (await userService.isAdmin()) {
      return Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 100.0,
              child: DrawerHeader(
                  child: Text(await userService.getUsername(), style: TextStyle(color: Colors.white)),
                  decoration: BoxDecoration(
                      color: Colors.black
                  ),
                  margin: EdgeInsets.all(0.0),
                  padding: EdgeInsets.only(left: 20.0, top: 40.0)
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text('Home', style: TextStyle(fontSize: 18.0)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home())
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.perm_contact_calendar),
              title: Text('Members', style: TextStyle(fontSize: 18.0)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Members())
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_pin_circle),
              title: Text('Requests', style: TextStyle(fontSize: 18.0)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Requests())
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text('Admins', style: TextStyle(fontSize: 18.0)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Admins())
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: Text('Logout', style: TextStyle(fontSize: 18.0)),
              onTap: () async {
                userService.logout();
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginForm())
                );
              },
            ),
          ],
        ),
      );
    } else {
      return Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 100.0,
              child: DrawerHeader(
                  child: Text(await userService.getUsername(), style: TextStyle(color: Colors.white)),
                  decoration: BoxDecoration(
                      color: Colors.black
                  ),
                  margin: EdgeInsets.all(0.0),
                  padding: EdgeInsets.only(left: 20.0, top: 40.0)
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text('Home', style: TextStyle(fontSize: 18.0)),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home())
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: Text('Logout', style: TextStyle(fontSize: 18.0)),
              onTap: () async {
                userService.logout();
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginForm())
                );
              },
            ),
          ],
        ),
      );
    }
  }
}
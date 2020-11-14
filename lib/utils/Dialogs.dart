import 'package:flutter/material.dart';

class Dialogs{

  BuildContext context;
  String title;

  Dialogs(BuildContext context, String title){
    this.context = context;
    this.title = title;

  }

  showListResponseDialog(List errors){
    List<Widget> contentErrors = <Widget>[];
    for(var i=0; i<errors.length; i++){
      contentErrors.add(Text(errors[i]));
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(this.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: contentErrors,
          ),
          actions: [
            FlatButton(
              child: Text("Ok"),
              onPressed: ()=> {
                Navigator.pop(context)
              },
            )
          ],
        );
      },
    );
  }

  showResponseDialog(Future<String> message) async {

    String text = await message.then((value) => value).catchError((onError)=>onError.toString());

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(this.title),
          content: Text(text),
          actions: [
            FlatButton(
              child: Text("Ok"),
              onPressed: ()=>{
                Navigator.pop(context)
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> showAlertDialog(String message) async{

    bool response = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(this.title),
          content: Text(message),
          actions: [
            FlatButton(
              child: Text("Cancel"),
              onPressed: ()=>{
                Navigator.pop(context)
              },
            ),
            FlatButton(
              child: Text("Ok"),
              onPressed: ()=> {
                response = true,
                Navigator.pop(context),
              },
            )
          ],
        );
      },
    );
    return response;
  }


}
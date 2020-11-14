import 'dart:async';
import 'dart:io';

import 'package:door/dto/AuthDTO.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:door/dto/UserDTO.dart';

class UserService {

  final String urlUser = 'http://192.168.25.25:3000/users';
  final String urlAuth = 'http://192.168.25.25:3000/auth';

  Future<bool> login(AuthDTO user) async {
    var url = this.urlAuth + '/login';

    try{
       http.Response res = await http.post(url, body:{"email":user.email, "password":user.password}).timeout(Duration(seconds: 5));

       if(res.statusCode == 200){
         var jsonResponse = convert.jsonDecode(res.body);
         String token = jsonResponse['accessToken'];
         final storage = new FlutterSecureStorage();
         await storage.write(key: 'jwt', value: token);
         return true;
       }else{
         return false;
       }
    } on SocketException catch(_){
      throw ("You're offline, please connect to the Internet and try again");
    } on TimeoutException catch(_){
      throw ("Something is wrong with the server, try again later");
    }
  }

  Future<List> register(AuthDTO user) async {
    try{
      var url = this.urlAuth;
      http.Response res = await http.post(url, body:{"name":user.username,"email":user.email, "password":user.password, "rfid":user.rfid}).timeout(Duration(seconds: 5));
      if(res.statusCode == 201){
        return null;
      }else{
        var jsonResponse = convert.jsonDecode(res.body);
        List errors = jsonResponse['message'];
        return errors;
      }
    } on SocketException catch(_){
      throw ("You're offline, please connect to the Internet and try again");
    } on TimeoutException catch(_){
      throw ("Something is wrong with the server, try again later");
    }
  }

  Future<UserDTO> getCurrentUser() async {
    try{
      Map<String, dynamic> claims = await this.getClaims();
      var url = this.urlUser + '/'+ claims['id'].toString();
      http.Response res = await http.get(url, headers: {"AUTHORIZATION":'Bearer '+ await this.getToken()}).timeout(Duration(seconds: 5));
      if(res.statusCode == 200){
        return UserDTO.fromJson(convert.jsonDecode(res.body));
      }else{
        throw ("Failed to get current User");
      }
    } on SocketException catch(_){
      throw ("You're offline, please connect to the Internet and try again");
    } on TimeoutException catch(_){
      throw ("Something is wrong with the server, try again later");
    }
  }

  Future<List<UserDTO>> getAdmins() async {
    try{
      http.Response res = await http.get(this.urlUser + '/admin', headers: {"AUTHORIZATION":'Bearer '+ await this.getToken()}).timeout(Duration(seconds: 5));
      if(res.statusCode == 200){
        List<UserDTO> listUserDTO = [];
        List list = convert.jsonDecode(res.body);
        list.forEach((element) {
          listUserDTO.add(UserDTO.fromJson(element));
        });
        return listUserDTO;
      }else{
        throw ("Failed to get current User");
      }
    } on SocketException catch(_){
      throw ("You're offline, please connect to the Internet and try again");
    } on TimeoutException catch(_){
      throw ("Something is wrong with the server, try again later");
    }
  }

  Future<List<UserDTO>> getRequests() async {
    try{
      http.Response res = await http.get(this.urlUser + '/requests', headers: {"AUTHORIZATION":'Bearer '+ await this.getToken()}).timeout(Duration(seconds: 5));
      if(res.statusCode == 200){
        List<UserDTO> listUserDTO = [];
        List list = convert.jsonDecode(res.body);
        list.forEach((element) {
          listUserDTO.add(UserDTO.fromJson(element));
        });
        return listUserDTO;
      }else{
        throw ("Failed to get requests");
      }
    } on SocketException catch(_){
      throw ("You're offline, please connect to the Internet and try again");
    } on TimeoutException catch(_){
      throw ("Something is wrong with the server, try again later");
    }
  }

  Future<List<UserDTO>> getMembers() async {
    try {
      http.Response res = await http.get(this.urlUser + '/members',
          headers: {"AUTHORIZATION": 'Bearer ' + await this.getToken()})
          .timeout(Duration(seconds: 5));
      if (res.statusCode == 200) {
        List<UserDTO> listUserDTO = [];
        List list = convert.jsonDecode(res.body);
        list.forEach((element) {
          listUserDTO.add(UserDTO.fromJson(element));
        });
        return listUserDTO;
      } else {
        throw ("Failed to get members");
      }
    } on SocketException catch(_){
      throw ("You're offline, please connect to the Internet and try again");
    } on TimeoutException catch(_){
      throw ("Something is wrong with the server, try again later");
    }
  }

  Future<String> update(AuthDTO user) async{
    try{
      String url = this.urlUser + '/' + user.id;
      http.Response res = await http.put(url, headers: {"AUTHORIZATION":'Bearer '+ await this.getToken()}, body: {"name":user.username, "email":user.email, "password":user.password, "rfid":user.rfid}).timeout(Duration(seconds: 5));
      if(res.statusCode == 200){
        return "User updated with sucess !!";
      }
      throw ("An error ocurred !");
    } on SocketException catch(_){
      throw ("You're offline, please connect to the Internet and try again");
    } on TimeoutException catch(_){
      throw ("Something is wrong with the server, try again later");
    }
  }

  Future<String> updateRole(UserDTO user, String role) async{
    try {
      String url = this.urlUser + '/roles/' + user.id.toString();
      http.Response res = await http.patch(
          url, headers: {"AUTHORIZATION": 'Bearer ' + await this.getToken()},
          body: {"role": role}).timeout(Duration(seconds: 5));
      if (res.statusCode == 200) {
        return "Role updated with sucess !!";
      }
      throw ("An error ocurred !");
    } on SocketException catch(_){
      throw ("You're offline, please connect to the Internet and try again");
    } on TimeoutException catch(_){
      throw ("Something is wrong with the server, try again later");
    }
  }

  Future<String> delete(UserDTO user) async{
    try{
      String url = this.urlUser + '/' + user.id.toString();
      http.Response res = await http.delete(url, headers: {"AUTHORIZATION":'Bearer '+ await this.getToken()}).timeout(Duration(seconds: 5));
      if(res.statusCode == 200){
        return "User deleted with sucess !!";
      }
      throw ("An error ocurred !");
    } on SocketException catch(_){
      throw ("You're offline, please connect to the Internet and try again");
    } on TimeoutException catch(_){
      throw ("Something is wrong with the server, try again later");
    }
  }

  Future<String> updateStatus(UserDTO user, bool status) async{
    try{
      String url = this.urlUser + (status?'/deactivate/':'/activate/') + user.id.toString();
      http.Response res = await http.patch(url, headers: {"AUTHORIZATION":'Bearer '+ await this.getToken()}).timeout(Duration(seconds: 5));
      if(res.statusCode == 200){
        return "Status updated with sucess !!";
      }
      throw ("An error ocurred !");
    } on SocketException catch(_){
      throw ("You're offline, please connect to the Internet and try again");
    } on TimeoutException catch(_){
      throw ("Something is wrong with the server, try again later");
    }
  }

  Future<String> approve(UserDTO user) async{
    try{
      String url = this.urlUser + '/' + user.id.toString();
      http.Response res = await http.patch(url, headers: {"AUTHORIZATION":'Bearer '+ await this.getToken()}).timeout(Duration(seconds: 5));
      if(res.statusCode == 200){
        return "User approved with sucess !!";
      }
      throw ("An error ocurred !");
    } on SocketException catch(_){
      throw ("You're offline, please connect to the Internet and try again");
    } on TimeoutException catch(_){
      throw ("Something is wrong with the server, try again later");
    }
  }

  void logout() async {
    final storage = new FlutterSecureStorage();
    await storage.delete(key: 'jwt');
  }

  Future<bool> isAdmin() async{
    String role = await getRole();
    return role == 'ADMIN';
  }

  Future<String> getUsername() async{
    Map<String, dynamic> claims = await this.getClaims();
    return claims['username'];
  }

  Future<String> getRole() async {
    Map<String, dynamic> claims = await this.getClaims();
    return claims['role'];
  }

  Future<Map<String, dynamic>> getClaims() async{
    Map<String, dynamic> claims;
    String jwt = await this.getToken();
    claims = JwtDecoder.decode(jwt);
    return claims;
  }

  Future<bool> hasToken() async {
    String token = await this.getToken();
    return !(token == null);
  }

  Future<String> getToken() async{
    final storage = new FlutterSecureStorage();
    var jwt = storage.read(key: 'jwt');
    String token;
    await jwt.then((value) => {
      if(value != null){
        token = value
      }else{
        token = null
      }
    });
    return token;
  }
}
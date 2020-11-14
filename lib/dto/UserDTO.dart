
import 'package:door/dto/AuthDTO.dart';

class UserDTO{

  final String id;
  final String username;
  final String email;
  final String rfid;
  final String role;
  final bool isActive;

  UserDTO({this.id, this.username, this.email, this.rfid, this.role, this.isActive});

  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
        id: json['id'].toString(),
        username: json['username'],
        email: json['email'],
        rfid:json['rfid'],
        role:json['role'],
        isActive: json['isActive']
    );
  }

  Map<String, dynamic> toJson() => {
      'id':id,
      'username':username,
      'email':email,
      'rfid':rfid,
      'role':role
  };

  AuthDTO toAuth(){
    AuthDTO auth = new AuthDTO.noneContructor();
    auth.username = this.username;
    auth.email = this.email;
    auth.password = '';
    auth.rfid = this.rfid;
    return auth;
  }
}
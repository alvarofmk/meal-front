class RegisterRequest {
  String username;
  String password;
  String verifyPassword;
  String email;
  String name;

  RegisterRequest(
      {required this.username,
      required this.password,
      required this.verifyPassword,
      required this.email,
      required this.name});

  /*RegisterRequest.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    verifyPassword = json['verifyPassword'];
    email = json['email'];
    name = json['name'];
  }*/

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['password'] = password;
    data['verifyPassword'] = verifyPassword;
    data['email'] = email;
    data['name'] = name;
    return data;
  }
}

class RegisterResponse {
  String? id;
  String? username;
  String? nombre;
  String? email;
  List<String>? roles;
  String? createdAt;

  RegisterResponse(
      {this.id,
      this.username,
      this.nombre,
      this.email,
      this.roles,
      this.createdAt});

  RegisterResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    nombre = json['nombre'];
    email = json['email'];
    roles = json['roles'].cast<String>();
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['nombre'] = this.nombre;
    data['email'] = this.email;
    data['roles'] = this.roles;
    data['createdAt'] = this.createdAt;
    return data;
  }
}

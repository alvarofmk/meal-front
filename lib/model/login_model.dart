class LoginRequest {
  String? username;
  String? password;

  LoginRequest({this.username, this.password});

  LoginRequest.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['password'] = password;
    return data;
  }
}

class LoginResponse {
  String? id;
  String? username;
  String? nombre;
  String? createdAt;
  String? token;

  LoginResponse(
      {this.id, this.username, this.nombre, this.createdAt, this.token});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    nombre = json['nombre'];
    createdAt = json['createdAt'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['nombre'] = this.nombre;
    data['createdAt'] = this.createdAt;
    data['token'] = this.token;
    return data;
  }
}

class User {
  final String name;
  final String email;
  final String accessToken;

  User({required this.name, required this.email, required this.accessToken});

  @override
  String toString() => 'User { name: $name, email: $email}';
}

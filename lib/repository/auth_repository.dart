import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../model/login_model.dart';
import '../model/register_model.dart';
import '../rest_client/rest_client.dart';

@Order(-1)
@singleton
class AuthenticationRepository {
  late RestClient _client;

  AuthenticationRepository() {
    _client = GetIt.I.get<RestClient>();
    //_client = RestClient();
  }

  Future<LoginResponse> doLogin(String username, String password) async {
    String url = "/auth/login";

    var jsonResponse = await _client.post(
        url, LoginRequest(username: username, password: password));
    return LoginResponse.fromJson(jsonDecode(jsonResponse));
  }

  Future<RegisterResponse> registerClient(String username, String password,
      String verifyPassword, String email, String name) async {
    String url = "/auth/register";

    var jsonResponse = await _client.post(
        url,
        RegisterRequest(
            username: username,
            password: password,
            email: email,
            name: name,
            verifyPassword: verifyPassword));
    return RegisterResponse.fromJson(jsonDecode(jsonResponse));
  }

  Future<RegisterResponse> registerOwner(String username, String password,
      String verifyPassword, String email, String name) async {
    String url = "/auth/register/owner";

    var jsonResponse = await _client.post(
        url,
        RegisterRequest(
            username: username,
            password: password,
            email: email,
            name: name,
            verifyPassword: verifyPassword));
    return RegisterResponse.fromJson(jsonDecode(jsonResponse));
  }
}

import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../model/login_model.dart';
import '../repository/auth_repository.dart';
import 'localstorage_service.dart';

abstract class AuthenticationService {
  Future<User?> getCurrentUser();
  Future<User?> signInWithUsernameAndPassword(String username, String password);
  Future<void> signOut();
}

@Order(2)
@singleton
class JwtAuthenticationService extends AuthenticationService {
  late AuthenticationRepository _authenticationRepository;
  late LocalStorageService _localStorageService;

  JwtAuthenticationService() {
    _authenticationRepository = GetIt.I.get<AuthenticationRepository>();
    GetIt.I
        .getAsync<LocalStorageService>()
        .then((value) => _localStorageService = value);
  }

  @override
  Future<User?> getCurrentUser() async {
    String? loggedUser = _localStorageService.getFromDisk("user");
    if (loggedUser != null) {
      var user = LoginResponse.fromJson(jsonDecode(loggedUser));
      return User(
          email: user.username ?? "",
          name: user.nombre ?? "",
          accessToken: user.token ?? "",
          roles: user.roles ?? List.empty());
    }
    return null;
  }

  @override
  Future<User> signInWithUsernameAndPassword(
      String username, String password) async {
    LoginResponse response =
        await _authenticationRepository.doLogin(username, password);
    await _localStorageService.saveToDisk(
        'user', jsonEncode(response.toJson()));
    return User(
        email: response.username ?? "",
        name: response.nombre ?? "",
        accessToken: response.token ?? "",
        roles: response.roles ?? List.empty());
  }

  @override
  Future<void> signOut() async {
    await _localStorageService.deleteFromDisk("user");
  }
}

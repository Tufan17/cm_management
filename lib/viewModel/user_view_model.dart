import 'package:flutter/material.dart';
import '../const/locator.dart';
import '../model/user_model.dart';
import '../repository/user_repository.dart';
import '../services/auth_base.dart';
import '../services/auth_service.dart';

enum ViewState { Idle, Busy }

class UserViewModel with ChangeNotifier implements AuthBase {
  UserRepository _userRepository = locator<UserRepository>();
  AuthService authService = AuthService();

  UserModel get userModel => _userModel;

  UserModel _userModel;

  @override
  Future<UserModel> login(String mail, String pass) async {
    try {
      _userModel = await authService.login(mail, pass);
      return _userModel;
    } catch (e) {
      print("ViewModel signInWithMailAndPass() hatası: " + e.toString());
      throw e;
    }
  }

  @override
  Future register(String email, String password, String passwordConfirmation,
      String firstName, String lastName) {
    // TODO: implement register
    throw UnimplementedError();
  }
}

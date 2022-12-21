import '../const/locator.dart';
import '../model/user_model.dart';
import '../services/auth_base.dart';
import '../services/auth_service.dart';
import '../viewModel/user_view_model.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  AuthService authService = locator<AuthService>();
  AppMode appMode = AppMode.RELEASE;

  @override
  Future<UserModel> login(String mail, String pass) async {
    UserViewModel userViewModel = UserViewModel();

    if (appMode == AppMode.DEBUG) {
      return null;
    } else {
      UserModel userModel = await userViewModel.login(mail, pass);
      return userModel;
    }
  }

  @override
  Future register(String email, String password, String passwordConfirmation,
      String firstName, String lastName) {
    // TODO: implement register
    throw UnimplementedError();
  }
}

import 'dart:convert';
import 'dart:developer' as d;
import 'package:http/http.dart' as http;
import '../const/api_const.dart';
import '../model/user_model.dart';
import 'auth_base.dart';

class AuthService implements AuthBase {
  UserModel userModel = UserModel();

  @override
  Future login(String email, String pass) async {
    final response = await http.post(
      Uri.parse('$companyUrl/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'email': email, 'password': pass}),
    );

    loginCookie = response.headers["set-cookie"].split(";")[0].toString();

    var userJson = jsonDecode(response.body)["user"];

    UserModel userModelObject = UserModel.fromMap(userJson);
    userModel.name = userModelObject.name;
    userModel.last_name = userModelObject.last_name;
    userModel.email = userModelObject.email;
    userModel.id = userModelObject.id;
    print(userModelObject.toString() + " *********");

    if (response.statusCode == 200) {
      return userModel;
    } else {
      d.log(userJson["message"]);
      return null;
    }
  }

  @override
  Future<dynamic> register(
    String email,
    String password,
    String passwordConfirmation,
    String firstName,
    String lastName,
  ) async {
    final response = await http.post(
      Uri.parse('$companyUrl/api/usercreateapi'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode({
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'first_name': firstName,
        'last_name': lastName
      }),
    );
    loginCookie = response.headers["set-cookie"].toString();
    if (response.statusCode == 200) {
      Map<String, dynamic> _readingValuesMap = json.decode(response.body);
      UserModel _userModelObject = UserModel.fromMap(_readingValuesMap);

      return response.statusCode;
    } else {
      return response.statusCode;
    }
  }
}

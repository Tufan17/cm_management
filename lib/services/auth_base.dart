abstract class AuthBase {
  Future login(String email, String password); //Kullanıcı giriş

  Future<dynamic> register(
      String email,
      String password,
      String passwordConfirmation,
      String firstName,
      String lastName,
      ); //Kullanıcı kaydolma
}
// ignore_for_file: non_constant_identifier_names

class UserModel {
  String email;
  String name;
  String last_name;
  int id;

  UserModel({this.name, this.email, this.last_name, this.id});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'last_name': last_name,
      'id': id,
    };
  }

  UserModel.fromMap(Map<String, dynamic> map)
      : email = map['email'],
        name = map['name'],
        last_name = map['last_name'],
        id = map['id'];

  @override
  String toString() {
    return 'UserModel\n email: $email\n name: $name\n last_name:$last_name\n id:$id';
  }
}

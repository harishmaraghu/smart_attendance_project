class LoginModel {
  final String Username;
  final String Password;

  LoginModel({required this.Username, required this.Password});

  Map<String, dynamic> toJson() {
    return {
      'Username': Username,
      'Password': Password,
    };
  }
}

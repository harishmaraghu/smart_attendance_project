import '../datasources/login_remote_datasource.dart';
import '../models/login_model.dart';

class LoginRepository {
  final LoginRemoteDataSource remoteDataSource;

  LoginRepository({required this.remoteDataSource});

  Future<Map<String, dynamic>> login(String Username, String Password) {
    final model = LoginModel(Username: Username, Password: Password);
    return remoteDataSource.login(model);
  }
}

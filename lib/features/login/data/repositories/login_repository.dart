import '../datasources/login_remote_datasource.dart';
import '../models/login_model.dart';

class LoginRepository {
  final LoginRemoteDataSource remoteDataSource;

  LoginRepository({required this.remoteDataSource});

  Future<Map<String, dynamic>> login(String username, String password) {
    final model = LoginModel(username: username, password: password);
    return remoteDataSource.login(model);
  }
}

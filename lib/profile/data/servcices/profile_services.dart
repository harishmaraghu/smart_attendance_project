import 'package:dio/dio.dart';
import 'package:smart_attendance_project/profile/models/profilemodels.dart';
// import 'package:smart_attendance_project/features/profile/models/profilemodels.dart';

class ProfileApiService {
  static const String baseUrl = 'https://exx5b0hsfc.execute-api.ap-south-1.amazonaws.com/default/Profile';
  static late Dio _dio;

  static void initializeDio() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: Duration(seconds: 30),
        receiveTimeout: Duration(seconds: 30),
        sendTimeout: Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    // Add interceptors for logging (optional)
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (object) => print(object),
      ),
    );
  }

  static Future<ProfileModel?> getProfile(String userId, String username) async {
    try {
      // Initialize Dio if not already done
      if (!_isDioInitialized()) {
        initializeDio();
      }

      final response = await _dio.get(
        baseUrl,
        queryParameters: {
          'userId': userId,
          'username': username,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        return ProfileModel.fromJson(data);
      } else {
        print('Failed to load profile: ${response.statusCode}');
        return null;
      }
    } on DioException catch (dioError) {
      print('Dio error fetching profile: ${dioError.message}');
      _handleDioError(dioError);
      return null;
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
    }
  }

  static bool _isDioInitialized() {
    try {
      return _dio.options != null;
    } catch (e) {
      return false;
    }
  }

  static void _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        print('Connection timeout');
        break;
      case DioExceptionType.sendTimeout:
        print('Send timeout');
        break;
      case DioExceptionType.receiveTimeout:
        print('Receive timeout');
        break;
      case DioExceptionType.badResponse:
        print('Bad response: ${error.response?.statusCode}');
        break;
      case DioExceptionType.cancel:
        print('Request cancelled');
        break;
      case DioExceptionType.connectionError:
        print('Connection error');
        break;
      case DioExceptionType.unknown:
        print('Unknown error: ${error.message}');
        break;
      case DioExceptionType.badCertificate:
        print('Bad certificate error');
        break;
    }
  }

}

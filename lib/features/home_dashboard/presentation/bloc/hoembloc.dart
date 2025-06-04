// user_data_bloc.dart
import 'package:amplify_flutter/amplify_flutter.dart' hide Emitter;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/shared_prefsHelper.dart';
import 'hoemevent.dart';
import 'hoemstate.dart';

class UserDataBloc extends Bloc<UserDataEvent, UserDataState> {
  UserDataBloc() : super(UserDataInitial()) {
    on<LoadUserDataEvent>(_onLoadUserData);
    on<ClearUserDataEvent>(_onClearUserData);
  }

  Future<void> _onLoadUserData(
      LoadUserDataEvent event,
      Emitter<UserDataState> emit,
      ) async {
    try {
      emit(UserDataLoading());

      // Load all user data concurrently for better performance
      final results = await Future.wait([
        SharedPrefsHelper.getUsername(),
        SharedPrefsHelper.getUserImageUrl(),
        SharedPrefsHelper.getUserCategory(),
        SharedPrefsHelper.getUserId(),
      ]);

      emit(UserDataLoaded(
        username: results[0] as String,
        userImageUrl: results[1] as String?,
        userCategory: results[2] as String?,
        userId: results[3] as String?,
      ));
    } catch (e) {
      emit(UserDataError('Error loading user data: $e'));
    }
  }

  Future<void> _onClearUserData(
      ClearUserDataEvent event,
      Emitter<UserDataState> emit,
      ) async {
    try {
      emit(UserDataLoading());
      await SharedPrefsHelper.clearUserData();
      emit(UserDataInitial());
    } catch (e) {
      emit(UserDataError('Error clearing user data: $e'));
    }
  }
}
///////////////completed home pahe top navbar ///////////////////


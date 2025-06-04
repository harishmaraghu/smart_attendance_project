// user_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/shared_prefsHelper.dart';
import 'attendance_event.dart';
import 'attendance_state.dart';


class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<LoadUsernameEvent>(_onLoadUsername);
  }

  Future<void> _onLoadUsername(
      LoadUsernameEvent event, Emitter<UserState> emit) async {
    final username = await SharedPrefsHelper.getUsername();
    final Userid = await SharedPrefsHelper.getUserId() ?? '';

    emit(UsernameLoaded(username,Userid));
  }
}

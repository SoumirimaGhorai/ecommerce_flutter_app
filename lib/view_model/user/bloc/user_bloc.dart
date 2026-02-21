import 'package:bloc/bloc.dart';
import 'package:e_commarce_project/view_model/user/bloc/user_event.dart';
import 'package:e_commarce_project/view_model/user/bloc/user_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constant.dart';
import '../../../../core/constants/app_url.dart';
import '../../../../data/helper/api_helper.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  ApiHelper apiHelper;

  UserBloc({required this.apiHelper}) : super(UserInitialState()) {
    on<UserRegisterEvent>((event, emit) async {
      emit(UserLoadingState());

      try {
        dynamic data = await apiHelper.postAPI(
          url: AppUrls.register_url,
          isAuth: true,
          mBodyParams: {
            "name": event.name,
            "mobile_number": event.mobNo,
            "email": event.email,
            "password": event.pass,
          },
        );

        if (data["status"]) {
          emit(UserSuccessState());
        } else {
          emit(UserFailureState(errorMsg: data["message"]));
        }
      } catch (e) {
        emit(UserFailureState(errorMsg: e.toString()));
      }
    });

    on<UserLoginEvent>((event, emit) async {
      emit(UserLoadingState());

      try {
        dynamic data = await apiHelper.postAPI(
          url: AppUrls.login_url,
          isAuth: true,
          mBodyParams: {"email": event.email, "password": event.pass},
        );

        if (data["status"]) {
          emit(UserSuccessState());

          ///prefs
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString(AppConstants.PREF_USER_TOKEN, data["tokan"]);
        } else {
          emit(UserFailureState(errorMsg: data["message"]));
        }
      } catch (e) {
        emit(UserFailureState(errorMsg: e.toString()));
      }
    });
  }
}
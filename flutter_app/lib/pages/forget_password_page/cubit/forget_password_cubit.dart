import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:login_system/pages/forget_password_page/cubit/forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState>{
  ForgetPasswordCubit() : super(ForgetPasswordInitial());


}
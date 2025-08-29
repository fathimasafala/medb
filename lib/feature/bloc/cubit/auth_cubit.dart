import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medb/feature/models/user_model.dart';
import '../../services/auth_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;
  AuthCubit(this.authService) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final response = await authService.login(email, password);
      emit(AuthSuccess(response));
    } catch (e) {
      emit(AuthFailure(e.toString()));
   
    }
  }
  Future<void> register(Map<String, dynamic> body) async {
    emit(AuthLoading());
    try {
      final data = await authService.register(body);
      final msg = data['message'] ?? 'Registered successfully';
      emit(RegisterSuccess(msg));
    } catch (e) {
      emit(AuthFailure(e.toString().replaceAll('Exception: ', '')));
    
    }
  }
    Future<void> logout() async {
    emit(AuthLoading());
    try {
      final message = await authService.logout();
      emit(LogoutSuccess(message));
    } catch (e) {
      emit(LogoutFailure(e.toString()));
    }
  }

}

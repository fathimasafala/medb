import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medb/config/dio_interceptor.dart';
import 'package:medb/feature/bloc/cubit/auth_cubit.dart';
import 'package:medb/feature/models/user_model.dart';
import 'package:medb/feature/screens/home_screen.dart';
import 'package:medb/feature/screens/login_screen.dart';
import 'package:medb/feature/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadTokensFromStorage();

  final prefs = await SharedPreferences.getInstance();
  final accessToken = prefs.getString('accessToken');
  final userJson = prefs.getString('userDetails');
  final menuJson = prefs.getString('menuData');
  LoginResponse? loginResponse;
  if (accessToken != null && userJson != null && menuJson != null) {
    try {
      final userDetails = UserDetails.fromJson(jsonDecode(userJson));
      final menuData = (jsonDecode(menuJson) as List)
          .map((e) => Module.fromJson(e))
          .toList();

      loginResponse = LoginResponse(
        accessToken: accessToken,
        userDetails: userDetails,
        menuData: menuData,
      );
    } catch (e) {
      debugPrint('Error parsing stored login data: $e');
    }
  }
  runApp(MyApp(loginResponse: loginResponse));
}

class MyApp extends StatelessWidget {
  final LoginResponse? loginResponse;

  const MyApp({super.key, this.loginResponse});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(AuthService()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: loginResponse != null
            ? HomeScreen(response: loginResponse!)
            : const LoginScreen(),
      ),
    );
  }
}

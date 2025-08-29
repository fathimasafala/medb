import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:medb/config/dio_interceptor.dart';
import 'package:medb/feature/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<LoginResponse> login(String email, String password) async {
    final res = await api.post('/auth/login', data: {
      "email": email,
      "password": password,
    });

    final loginResponse = LoginResponse.fromJson(res.data);

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("accessToken", loginResponse.accessToken);

    final userJson = jsonEncode(res.data['userDetails']);
    await prefs.setString("userDetails", userJson);
    final menuJson = jsonEncode(res.data['menuData']);
    await prefs.setString("menuData", menuJson);
    final refreshToken = res.data['refreshToken'];
    if (refreshToken != null) {
      await prefs.setString("refreshToken", refreshToken);
    }

    return loginResponse;
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> body) async {
    try {
      final response = await api.post('/auth/register', data: body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception("Something went wrong");
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data["message"] ?? e.message ?? "Unknown error",
      );
    }
  }

  Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      clearMemoryTokens();
      final response = await api.post('/auth/logout');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Logout error: $e");
      return false;
    }
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:medb/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? _accessToken;
String? refreshToken;

final Dio _dio = Dio(
  BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    baseUrl: Config.baseUrl,
    receiveDataWhenStatusError: true,
  ),
)..interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_accessToken != null) {
          options.headers['Authorization'] = "Bearer $_accessToken";
        }
        options.extra['withCredentials'] = true;
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        final requestOptions = e.requestOptions;

        if (e.response?.statusCode == 401 &&
            requestOptions.extra['retry'] != true) {
          final refreshed = await _refreshAccessToken();

          if (refreshed) {
            requestOptions.extra['retry'] = true;
            final retryResponse = await _dio.fetch(requestOptions);
            return handler.resolve(retryResponse);
          }
        }

        return handler.next(e);
      },
    ),
  );

Dio get api => _dio;
void clearMemoryTokens() {
  _accessToken = null;
  refreshToken = null;
}

Future<void> saveTokens(String access, String? refresh) async {
  _accessToken = access;
  refreshToken = refresh;

  final prefs = await SharedPreferences.getInstance();
  await prefs.setString("accessToken", access);
  if (refresh != null) {
    await prefs.setString("refreshToken", refresh);
  }

  await prefs.remove('userDetails');
  await prefs.remove('menuData');
}


Future<void> clearTokens() async {
  _accessToken = null;

  final prefs = await SharedPreferences.getInstance();
  await prefs.remove("accessToken");
}

Future<void> loadTokensFromStorage() async {
  final prefs = await SharedPreferences.getInstance();
  _accessToken = prefs.getString("accessToken");
  refreshToken = prefs.getString("refreshToken");
  
}
Future<bool> _refreshAccessToken() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final storedRefreshToken = prefs.getString("refreshToken");

    debugPrint("Stored refresh token: $storedRefreshToken");

    if (storedRefreshToken == null) {
      debugPrint("No refresh token found in storage.");
      return false;
    }

    final response = await Dio().post(
      'https://testapi.medb.co.in/api/auth/refreshToken',
      data: {'refreshToken': storedRefreshToken},
      options: Options(
        headers: {'Content-Type': 'application/json'},
      ),
    );

    if (response.statusCode == 200 &&
        response.data['accessToken'] != null &&
        response.data['refreshToken'] != null) {

      final newAccessToken = response.data['accessToken'];
      final newRefreshToken = response.data['refreshToken'];

      await saveTokens(newAccessToken, newRefreshToken);

      debugPrint("Token refreshed successfully.");
      return true;
    } else {
      debugPrint("Failed to refresh token: ${response.statusCode}");
      return false;
    }
  } catch (e) {
    debugPrint("Token refresh failed: $e");
    return false;
  }
}


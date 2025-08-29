// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medb/feature/models/user_model.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _debugCheckStorage();
    _checkLoginStatus();
  }

  Future<void> _debugCheckStorage() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    debugPrint('--- SharedPreferences keys ---');
    for (var key in keys) {
      debugPrint('--- SharedPreferences keys ---');
      ('$key => ${prefs.get(key)}');
    }
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('userDetails');
    final menuJson = prefs.getString('menuData');
    final accessToken = prefs.getString('accessToken');

    if (accessToken != null) {
      try {
        final userDetails = UserDetails.fromJson(jsonDecode(userJson!));
        final menuData = (jsonDecode(menuJson!) as List)
            .map((e) => Module.fromJson(e))
            .toList();

        final loginResponse = LoginResponse(
          accessToken: accessToken, 
          userDetails: userDetails,
          menuData: menuData,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(response: loginResponse),
          ),
        );
        return;
      } catch (e) {
        debugPrint("Parsing error: $e");
      }
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

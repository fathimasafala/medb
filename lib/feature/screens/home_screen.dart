// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cubit/auth_cubit.dart';
import '../models/user_model.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  final LoginResponse? response;
  const HomeScreen({super.key, this.response});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final user = widget.response?.userDetails;
    final menu = widget.response?.menuData;

    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 140,
            color: const Color.fromARGB(255, 240, 249, 250),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Image.asset(
                  'assets/images/logo.png',
                  height: 50,
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            const Icon(Icons.person),
                            Text(
                              "${user?.firstName} ${user?.lastName}",
                              style: const TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      ),
                      const Divider(),
                      if (menu != null)
                        ...menu.first.menus.map((m) => _buildMenuItem(
                              m.menuIcon,
                              m.menuName,
                            )),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text("Version 1.6.1"),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(Icons.notifications_none),
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 35,
                        width: 35,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey.shade300,
                          child: Text(
                            user?.firstName?[0] ?? "",
                            style: const TextStyle(color: Colors.black,fontSize: 15),
                          ),
                        ),
                      ),
                       const SizedBox(width: 5),
                      BlocConsumer<AuthCubit, AuthState>(
                        listener: (context, state) {
                          if (state is LogoutSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message.toString())),
                            );
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()),
                              (route) => false,
                            );
                          } else if (state is LogoutFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.error.toString())),
                            );
                          }
                        },
                        builder: (context, state) {
                          return TextButton(
                            onPressed: () {
                              context.read<AuthCubit>().logout();
                            },
                            child: const Text("Logout"),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/logo.png', height: 100),
                    const Text(
                      "Welcome to MedB!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "We're glad to have you here. MedB is your trusted platform for healthcare needs — all in one place.",
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Use the menu on the left to get started.",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String icon, String title) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: SizedBox(
              height: 20,
              width: 20,
              child: Image.network(
                icon,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_not_supported, size: 18);
                },
              ),
            ),
          ),
          Text(
            title,
            style: const TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }
}

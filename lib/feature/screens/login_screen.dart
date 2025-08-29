import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medb/feature/bloc/cubit/auth_cubit.dart';
import 'package:medb/feature/screens/home_screen.dart';
import 'package:medb/feature/screens/register_screen.dart';

import '../widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailC = TextEditingController(text: "fathimasafalapt@gmail.com");
  final _pwC = TextEditingController(text: "Password123");
  final _formKey = GlobalKey<FormState>();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 100,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  "Welcome Back!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                CustomTextField(
                  controller: _emailC,
                  hintText: 'Email',
                  focusNode: _emailFocus,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_passwordFocus);
                  },
                  prefixIcon: Icons.email_outlined,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return "Email is required";
                    }
                    final emailRegex =
                        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');
                    if (!emailRegex.hasMatch(v)) return "Enter a valid email";
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                    controller: _pwC,
                    hintText: 'Password',
                    prefixIcon: Icons.lock_outline,
                    obscureText: true,
                    suffixIcon: const Icon(Icons.visibility),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return "Password is required";
                      }
                      if (v.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                    focusNode: _passwordFocus,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).unfocus();
                    }),
                const SizedBox(height: 8),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      "Forgot Password",
                      style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is AuthSuccess) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HomeScreen(response: state.response),
                        ),
                      );
                    } else if (state is AuthFailure) {
                      debugPrint(state.error.toString());
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Invalid email or password!")),
                      );
                    }
                  },
                  builder: (context, state) {
                    return SizedBox(
                      width: 330,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) return;
                          context.read<AuthCubit>().login(
                                _emailC.text.trim(),
                                _pwC.text.trim(),
                              );
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Or Divider
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text("Or"),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 20),

                SizedBox(
                  height: 50,
                  width: 330,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      side: const BorderSide(
                          color: Colors.deepPurple, width: 0.8),
                    ),
                    child: const Text(
                      "OTP login? Click here",
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                OutlinedButton.icon(
                  onPressed: () {},
                  icon: Image.asset(
                    'assets/images/google_logo.png',
                    height: 20,
                  ),
                  label: const Text(
                    "Sign in with Google",
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    side: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegistrationScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Trouble logging in? ",
                      style: TextStyle(fontSize: 12),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegistrationScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Click Here",
                        style:
                            TextStyle(color: Colors.deepPurple, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

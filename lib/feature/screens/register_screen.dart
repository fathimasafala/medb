import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medb/feature/bloc/cubit/auth_cubit.dart';
import 'package:medb/feature/screens/login_screen.dart';
import 'package:medb/feature/services/auth_service.dart';

import '../widgets/custom_textfield.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameCtrl = TextEditingController();
  final _middleNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _middleNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _contactCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  final _firstNameFocus = FocusNode();
  final _middleNameFocus = FocusNode();

  final _lastNameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _contactNoFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthCubit>().register({
      "firstName": _firstNameCtrl.text.trim(),
      "middleName": _middleNameCtrl.text.trim(),
      "lastName": _lastNameCtrl.text.trim(),
      "email": _emailCtrl.text.trim(),
      "contactNo": _contactCtrl.text.trim(),
      "password": _passwordCtrl.text,
      "confirmPassword": _confirmPasswordCtrl.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(AuthService()),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is RegisterSuccess) {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Success"),
                    content: Text(
                      "${state.message} Please verify your email before logging in.",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text("OK"),
                      )
                    ],
                  ),
                );
              } else if (state is AuthFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Image.asset('assets/images/logo.png', height: 60),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          padding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 20),
                        ),
                        icon: Image.asset('assets/images/google_logo.png',
                            height: 20),
                        label: const Text(
                          "Sign up with Google",
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {},
                      ),
                      const SizedBox(height: 16),
                      const Text("-Or-"),
                      const SizedBox(height: 16),
                      const Text(
                        "Create an Account",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 24),
                      CustomTextField(
                        controller: _firstNameCtrl,
                        hintText: "First Name*",
                        focusNode: _firstNameFocus,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_middleNameFocus);
                        },
                        prefixIcon: Icons.person,
                        validator: (v) => v == null || v.trim().isEmpty
                            ? "First name is required"
                            : null,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _middleNameCtrl,
                              hintText: "Middle Name",
                              prefixIcon: Icons.person_outline,
                              focusNode: _middleNameFocus,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_lastNameFocus);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              controller: _lastNameCtrl,
                              hintText: "Last Name*",
                              focusNode: _lastNameFocus,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_emailFocus);
                              },
                              prefixIcon: Icons.person,
                              validator: (v) => v == null || v.trim().isEmpty
                                  ? "Last name is required"
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: _emailCtrl,
                        hintText: "Email*",
                        focusNode: _emailFocus,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_contactNoFocus);
                        },
                        prefixIcon: Icons.email,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return "Email is required";
                          }
                          final emailRegex =
                              RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');
                          if (!emailRegex.hasMatch(v)) {
                            return "Enter a valid email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: _contactCtrl,
                        hintText: "Contact Number*",
                        focusNode: _contactNoFocus,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_passwordFocus);
                        },
                        prefixIcon: Icons.phone,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return "Phone number is required";
                          }
                          if (!RegExp(r'^\d{10}$').hasMatch(v)) {
                            return "Enter a 10-digit number";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: _passwordCtrl,
                        hintText: "Password*",
                        focusNode: _passwordFocus,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_confirmPasswordFocus);
                        },
                        prefixIcon: Icons.lock,
                        obscureText: true,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return "Password is required";
                          }
                          if (v.length < 6) {
                            return "Password must be at least 6 characters";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        controller: _confirmPasswordCtrl,
                        hintText: "Confirm Password*",
                        focusNode: _confirmPasswordFocus,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).unfocus();
                        },
                        prefixIcon: Icons.lock_outline,
                        obscureText: true,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return "Confirm your password";
                          }
                          if (v != _passwordCtrl.text) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      state is AuthLoading
                          ? const CircularProgressIndicator()
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  backgroundColor: const Color(0xFF8B5CF6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                                onPressed: () => _submit(context),
                                child: const Text(
                                  "Register",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()),
                              );
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:messageapp/core/constants/app_constants.dart';

import '../../../../../components/CustomButton/custom_button.dart';
import '../../../../../components/CustomTextField/CustomTextfield.dart';
import '../../../../../core/constants/asset_constants.dart';
import '../../providers/login_providers.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isChecked = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<LoginState>(loginControllerProvider, (previous, next) {
      if (next is RegisterSuccess) {
        context.push(AppPaths.emailVerification, extra: next.email);
      } else if (next is LoginFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.message),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    });

    final loginState = ref.watch(loginControllerProvider);
    final isLoading = loginState is LoginLoading;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8FBF0),
              Color(0xFFF4FDF9),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset(
                "assets/images/Ellipse 86.png",
                width: 200,
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),
                        Center(
                          child: Image.asset(
                            Assets.shopreal_icon,
                            height: 100,
                            width: 89,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 35),
                        const Text(
                          "Registration",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 24),
                        CustomTextField(
                          controller: _nameController,
                          labelText: "Full Name",
                          hintText: "Shuvo",
                          filColor: Colors.white,
                          enabled: !isLoading,
                          borderColor: const Color(0xFF1E293B),
                        ),
                        const SizedBox(height: 14),
                        CustomTextField(
                          controller: _emailController,
                          hintText: "Email Address",
                          isEmail: true,
                          keyboardType: TextInputType.emailAddress,
                          filColor: Colors.white,
                          enabled: !isLoading,
                          borderColor: const Color(0xFFE2E8F0),
                        ),
                        const SizedBox(height: 14),
                        CustomTextField(
                          controller: _passwordController,
                          hintText: "Password",
                          isPassword: true,
                          filColor: Colors.white,
                          enabled: !isLoading,
                          borderColor: const Color(0xFFE2E8F0),
                        ),
                        const SizedBox(height: 14),
                        CustomTextField(
                          controller: _confirmPasswordController,
                          hintText: "Confirm Password",
                          isPassword: true,
                          filColor: Colors.white,
                          enabled: !isLoading,
                          borderColor: const Color(0xFFE2E8F0),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please confirm your password";
                            }
                            if (value != _passwordController.text) {
                              return "Passwords do not match";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: _isChecked,
                                activeColor: const Color(0xFF10B981),
                                side: const BorderSide(
                                  color: Color(0xFF64748B),
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                onChanged: isLoading
                                    ? null
                                    : (value) {
                                        setState(() {
                                          _isChecked = value ?? false;
                                        });
                                      },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: RichText(
                                text: const TextSpan(
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF64748B),
                                    height: 1.4,
                                  ),
                                  children: [
                                    TextSpan(text: "I acknowledge the "),
                                    TextSpan(
                                      text: "Terms of Service",
                                      style: TextStyle(
                                        color: Color(0xFF38BDF8),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextSpan(text: " and "),
                                    TextSpan(
                                      text: "Privacy Protocol",
                                      style: TextStyle(
                                        color: Color(0xFF38BDF8),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    TextSpan(text: "."),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        CustomButton(
                          text: isLoading ? "Creating..." : "Create Account",
                          onTap: isLoading
                              ? null
                              : () {
                                  if (!_isChecked) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please accept Terms of Service to continue.',
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  if (_formKey.currentState!.validate()) {
                                    ref
                                        .read(loginControllerProvider.notifier)
                                        .register(
                                          email: _emailController.text.trim(),
                                          password:
                                              _passwordController.text.trim(),
                                          name: _nameController.text.trim(),
                                        );
                                  }
                                },
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF64748B),
                              ),
                              children: [
                                const TextSpan(
                                  text: "Already have an account? ",
                                ),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: GestureDetector(
                                    onTap: () => context.pop(),
                                    child: const Text(
                                      "Sign In",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

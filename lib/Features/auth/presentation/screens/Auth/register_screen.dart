import 'package:flutter/material.dart';
import '../../../../../components/CustomButton/custom_button.dart';
import '../../../../../components/CustomTextField/CustomTextfield.dart';
import '../../../../../core/constants/asset_constants.dart';
import '../../core/constants/asset_constants.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
            // Background Decorative Ellipse (Top Right)
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset(
                "assets/images/Ellipse 86.png",
                width: 200,
                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
              ),
            ),

            // Main Scrollable Body
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

                        // App Logo Center
                        Center(
                          child: Image.asset(
                            Assets.shopreal_icon,
                            height: 100,
                            width: 89,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 35),

                        // Title Text
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
                            borderColor: const Color(0xFF1E293B), // Darker active border as shown
                          ),

                        const SizedBox(height: 14),

                         CustomTextField(
                            controller: _emailController,
                            hintText: "Email Address",
                            isEmail: true,
                            keyboardType: TextInputType.emailAddress,
                            filColor: Colors.white,
                            borderColor: const Color(0xFFE2E8F0),
                          ),

                        const SizedBox(height: 14),

                        // 3. Password Field
                       CustomTextField(
                            controller: _passwordController,
                            hintText: "Password",
                            isPassword: true,
                            filColor: Colors.white,
                            borderColor: const Color(0xFFE2E8F0),
                          ),

                        const SizedBox(height: 14),

                        // 4. Confirm Password Field
                       CustomTextField(
                            controller: _confirmPasswordController,
                            hintText: "Confirm Password",
                            isPassword: true,
                            filColor: Colors.white,
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

                        // Terms & Privacy Checkbox Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: _isChecked,
                                activeColor: const Color(0xFF10B981),
                                side: const BorderSide(color: Color(0xFF64748B), width: 1.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                onChanged: (value) {
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
                                      style: TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.w500),
                                    ),
                                    TextSpan(text: " and "),
                                    TextSpan(
                                      text: "Privacy Protocol",
                                      style: TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.w500),
                                    ),
                                    TextSpan(text: "."),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Create Account Button
                        CustomButton(
                          text: "Create Account",
                          onTap: () {
                            // Login
                          },
                        ),

                        const SizedBox(height: 24),

                        // Navigation back to Sign In
                        Center(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF64748B),
                              ),
                              children: [
                                const TextSpan(text: "Already have an account? "),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context); // Go back to login
                                    },
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
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:messageapp/core/constants/app_constants.dart';

import '../../../../../components/CustomButton/custom_button.dart';
import '../../../../../components/CustomTextField/CustomTextfield.dart';
import '../../../../../core/constants/asset_constants.dart';
import '../../providers/login_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<LoginState>(loginControllerProvider, (previous, next) {
      if (next is LoginSuccess) {
        context.go(AppPaths.bottom_manu);
      } else if (next is LoginNeedsVerification) {
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

    debugPrint("CustomTextField build");
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8FBF0),
              // Adjusted slightly to match the mint green gradient in the image
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
                width: 200, // Adjust size as needed
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),
            ),

            // Main Content
            SafeArea(
              child: SingleChildScrollView(
                physics: Theme.of(context).platform == TargetPlatform.iOS
                    ? const BouncingScrollPhysics()
                    : const ClampingScrollPhysics(),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),

                        // App Logo Center
                        Center(
                          child: Image.asset(
                            Assets.shopreal_icon,
                            height: 100,
                            width: 89,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Title Text
                        const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1E293B), // Dark Navy/Charcoal
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Subtitle Text
                        const Text(
                          "Enter your credentials to access your\nsecure instance",
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF64748B), // Muted Grey/Blue
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Section Divider Label
                        const Text(
                          "Or continue with email address",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Email Field (using your CustomTextField)
                        CustomTextField(
                          controller: _emailController,
                          hintText: "Email",
                          isEmail: true,
                          enabled: !isLoading,
                          keyboardType: TextInputType.emailAddress,
                          filColor: Colors.white,
                          // Solid white background as in image
                          borderColor: const Color(
                            0xFFE2E8F0,
                          ), // Subtle light border
                        ),
                        const SizedBox(height: 14),

                        // Password Field (using your CustomTextField)
                        CustomTextField(
                          controller: _passwordController,
                          hintText: "Password",
                          isPassword: true,
                          filColor: Colors.white,
                          enabled: !isLoading,
                          borderColor: const Color(0xFFE2E8F0),
                        ),

                        const SizedBox(height: 20),

                        // Sign In Button
                        CustomButton(
                          text: isLoading ? "Signing In..." : "Sign In",
                          onTap: isLoading
                              ? null // disable tap during load
                              : () {
                            if (_formKey.currentState!.validate()) {
                              ref.read(loginControllerProvider.notifier).login(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 24),

                        // "or" Divider Text
                        const Center(
                          child: Text(
                            "or",
                            style: TextStyle(
                              color: Color(0xFF333337),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Social Buttons (Google & Apple)
                        Row(
                          children: [
                            Expanded(
                              child: _buildSocialButton(
                                label: "Google",
                                iconPath: "assets/icons/google.svg",
                                onTap: isLoading
                                    ? () {}
                                    : () {
                                        ref
                                            .read(loginControllerProvider.notifier)
                                            .signWithGoogle();
                                      },
                              ),
                            ),
                            if (Theme.of(context).platform ==
                                    TargetPlatform.iOS ||
                                Theme.of(context).platform ==
                                    TargetPlatform.macOS) ...[
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildSocialButton(
                                  label: "Apple ID",
                                  iconPath: "assets/icons/apple.svg",
                                  onTap: isLoading
                                      ? () {}
                                      : () {
                                          ref
                                              .read(loginControllerProvider
                                                  .notifier)
                                              .signInWithApple();
                                        },
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 32),

                        // Register Section
                        Center(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF64748B),
                              ),
                              children: [
                                const TextSpan(text: "Don’t have an account? "),
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: GestureDetector(
                                    onTap: () {
                                      context.push(AppPaths.register);
                                      },
                                    child: const Text(
                                      "Sign Up",
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
                        const SizedBox(height: 40),

                        // Footer Policy Links
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildFooterLink("Privacy Policy", onTap: () {}),
                            _buildFooterLink("Terms of Service", onTap: () {}),
                            _buildFooterLink("Help Center", onTap: () {}),
                          ],
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

  // Social Button Helper Method
  Widget _buildSocialButton({
    required String label,
    required String iconPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
          ), // Light border lines
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Dummy Icon fallback if asset missing
            SvgPicture.asset(
              iconPath,
              height: 20,
              width: 20,
              errorBuilder: (context, error, stackTrace) => Icon(
                label == "Google" ? Icons.g_mobiledata : Icons.apple,
                size: 24,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF1E293B),
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Footer Link Helper Method
  Widget _buildFooterLink(String label, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF64748B),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

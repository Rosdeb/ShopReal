import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:messageapp/components/CustomButton/custom_button.dart';
import 'package:messageapp/components/CustomTextField/CustomTextfield.dart';
import 'package:messageapp/components/RoundBackButton.dart';

import '../../providers/change_password_provider.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _savePassword() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final oldPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();

    if (oldPassword == newPassword) {
      _showMessage('New password must be different from the current password.');
      return;
    }

    await ref.read(changePasswordControllerProvider.notifier).changePassword(
          oldPassword: oldPassword,
          newPassword: newPassword,
        );
  }

  void _showMessage(String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? const Color(0xFF10B981) : Colors.redAccent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ChangePasswordState>(changePasswordControllerProvider,
        (previous, next) {
      if (next is ChangePasswordSuccess) {
        _showMessage('Password updated successfully.', success: true);
        context.pop();
      } else if (next is ChangePasswordFailure) {
        _showMessage(next.error.message);
      }
    });

    final state = ref.watch(changePasswordControllerProvider);
    final isLoading = state is ChangePasswordLoading;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFD7F8E3),
              Color(0xFFF3FAF5),
              Color(0xFFF7FCF8),
            ],
            stops: [0.0, 0.4, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: RoundBackButton(onTap: () => context.pop()),
                      ),
                      const Text(
                        'Password & Security',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Update your password to keep your account secure.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 28),
                  CustomTextField(
                    controller: _currentPasswordController,
                    hintText: 'Current Password',
                    isPassword: true,
                    enabled: !isLoading,
                    filColor: Colors.white,
                    borderColor: const Color(0xFFE2E8F0),
                    contentPaddingHorizontal: 16,
                    contentPaddingVertical: 18,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _newPasswordController,
                    hintText: 'New Password',
                    isPassword: true,
                    enabled: !isLoading,
                    filColor: Colors.white,
                    borderColor: const Color(0xFFE2E8F0),
                    contentPaddingHorizontal: 16,
                    contentPaddingVertical: 18,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter new password';
                      }
                      if (value.trim().length < 6) {
                        return 'New password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _confirmPasswordController,
                    hintText: 'Confirm New Password',
                    isPassword: true,
                    enabled: !isLoading,
                    filColor: Colors.white,
                    borderColor: const Color(0xFFE2E8F0),
                    contentPaddingHorizontal: 16,
                    contentPaddingVertical: 18,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm new password';
                      }
                      if (value.trim() !=
                          _newPasswordController.text.trim()) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const Spacer(),
                  CustomButton(
                    text: 'Save Password',
                    loading: isLoading,
                    onTap: isLoading ? null : _savePassword,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

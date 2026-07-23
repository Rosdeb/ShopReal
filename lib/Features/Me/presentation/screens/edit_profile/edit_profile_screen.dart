import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messageapp/components/AppText/appText.dart';
import 'package:messageapp/components/RoundBackButton.dart';
import 'package:messageapp/core/utils/app_colour.dart';

import '../../providers/profile_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  String? _localAvatarPath;
  bool _hydrated = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (file == null) return;
    setState(() => _localAvatarPath = file.path);
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name is required.')),
      );
      return;
    }

    await ref.read(profileUpdateControllerProvider.notifier).updateProfile(
          name: name,
          avatarPath: _localAvatarPath,
        );
  }

  ImageProvider? _avatarProvider(String? networkAvatar) {
    if (_localAvatarPath != null) {
      return FileImage(File(_localAvatarPath!));
    }
    if (networkAvatar != null && networkAvatar.isNotEmpty) {
      return NetworkImage(networkAvatar);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ProfileUpdateState>(profileUpdateControllerProvider,
        (previous, next) {
      if (next is ProfileUpdateSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully.'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
        context.pop();
      } else if (next is ProfileUpdateFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.message),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    });

    final profileAsync = ref.watch(profileFutureProvider);
    final updateState = ref.watch(profileUpdateControllerProvider);
    final isSaving = updateState is ProfileUpdateLoading;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF8FFF9), Color(0xFFF0FDF4)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: Image.asset(
                'assets/images/Ellipse 86.png',
                errorBuilder: (context, error, stackTrace) =>
                    const SizedBox.shrink(),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        RoundBackButton(onTap: () => context.pop()),
                        const Expanded(
                          child: Center(
                            child: AppText(
                              'Personal Information',
                              style: TextStyle(
                                color: Color(0xFF1E293B),
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: isSaving ? null : _save,
                          child: isSaving
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primary,
                                  ),
                                )
                              : const Text(
                                  'Save',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: profileAsync.when(
                      loading: () => const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                      error: (err, _) => Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const AppText(
                              'Failed to load profile',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () =>
                                  ref.refresh(profileFutureProvider),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                      data: (profile) {
                        if (!_hydrated) {
                          _nameController.text = profile.name;
                          _emailController.text = profile.email;
                          _hydrated = true;
                        }
                        final avatar = _avatarProvider(profile.avatar);
                        return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              const SizedBox(height: 24),
                              Center(
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundColor: AppColors.background_s2,
                                      backgroundImage: avatar,
                                      onBackgroundImageError: avatar != null
                                          ? (error, stackTrace) {}
                                          : null,
                                      child: avatar == null
                                          ? const Icon(
                                              CupertinoIcons.person_fill,
                                              size: 40,
                                              color: Colors.white,
                                            )
                                          : null,
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: GestureDetector(
                                        onTap: isSaving ? null : _pickAvatar,
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: const BoxDecoration(
                                            color: AppColors.primary,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            CupertinoIcons.camera_fill,
                                            color: AppColors.textWhite,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextButton(
                                onPressed: isSaving ? null : _pickAvatar,
                                child: const Text(
                                  'Change Profile Photo',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: const Color(0xFFF1F5F9),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.Black.withValues(
                                        alpha: 0.08,
                                      ),
                                      blurRadius: 2,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    _buildInputField(
                                      label: 'Name',
                                      controller: _nameController,
                                      enabled: !isSaving,
                                    ),
                                    _buildDivider(),
                                    _buildInputField(
                                      label: 'Email',
                                      controller: _emailController,
                                      enabled: false,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(
                                    'Avatar uploads support jpg, png, gif, webp, and heic.',
                                    style: TextStyle(
                                      color: Color(0xFF64748B),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF1E293B),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              enabled: enabled,
              style: TextStyle(
                color: enabled
                    ? const Color(0xFF1E293B)
                    : const Color(0xFF64748B),
                fontSize: 16,
              ),
              decoration: const InputDecoration(
                fillColor: Colors.transparent,
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.only(left: 16),
      child: Divider(
        height: 1,
        thickness: 0.5,
        color: Color(0xFFF1F5F9),
      ),
    );
  }
}

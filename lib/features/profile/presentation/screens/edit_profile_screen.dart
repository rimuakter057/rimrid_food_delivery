import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/app_app_bar.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_network_image.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../auth/providers/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onSave() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      await authProvider.updateProfile(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
      );
      if (mounted) {
        context.showSnackBar('Profile updated successfully!');
        context.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(title: AppStrings.editProfile),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Center(
                child: Stack(
                  children: [
                    AppNetworkImage(
                      imageUrl: user?.avatarUrl ?? '',
                      width: 100,
                      height: 100,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => context.showSnackBar('Change photo clicked (Mock)'),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt_rounded, color: AppColors.textWhite, size: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              AppTextField(
                label: AppStrings.fullName,
                controller: _nameController,
                validator: (v) => AppValidators.required(v, AppStrings.fullName),
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: AppStrings.email,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: AppValidators.email,
              ),
              const SizedBox(height: 16),
              AppTextField(
                label: AppStrings.phone,
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: AppValidators.phone,
              ),
              const SizedBox(height: 40),
              AppButton(
                text: AppStrings.saveChanges,
                onPressed: _onSave,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

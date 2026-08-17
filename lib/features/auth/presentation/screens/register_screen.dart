import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/app_app_bar.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _agreeTerms = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister() async {
    if (_formKey.currentState!.validate()) {
      if (!_agreeTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please accept terms & conditions')),
        );
        return;
      }

      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
      );

      if (success && mounted) {
        context.go('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(title: AppStrings.registerTitle),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.registerSubtitle,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),
                AppTextField(
                  label: AppStrings.fullName,
                  hint: AppStrings.fullNameHint,
                  controller: _nameController,
                  prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.iconGrey, size: 20),
                  validator: (v) => AppValidators.required(v, AppStrings.fullName),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: AppStrings.email,
                  hint: AppStrings.emailHint,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined, color: AppColors.iconGrey, size: 20),
                  validator: AppValidators.email,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: AppStrings.phone,
                  hint: AppStrings.phoneHint,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.iconGrey, size: 20),
                  validator: AppValidators.phone,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: AppStrings.password,
                  hint: AppStrings.passwordHint,
                  controller: _passwordController,
                  isPassword: true,
                  prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.iconGrey, size: 20),
                  validator: AppValidators.password,
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: AppStrings.confirmPassword,
                  hint: AppStrings.confirmPasswordHint,
                  controller: _confirmPasswordController,
                  isPassword: true,
                  prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.iconGrey, size: 20),
                  validator: (v) => AppValidators.confirmPassword(v, _passwordController.text),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _agreeTerms,
                        activeColor: AppColors.primary,
                        onChanged: (val) {
                          setState(() {
                            _agreeTerms = val ?? false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        AppStrings.agreeTerms,
                        style: AppTextStyles.bodySmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                AppButton(
                  text: AppStrings.register,
                  onPressed: _onRegister,
                  isLoading: authProvider.isLoading,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(AppStrings.alreadyHaveAccount, style: AppTextStyles.bodyMedium),
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Text(
                        AppStrings.login,
                        style: AppTextStyles.smallLabel.copyWith(color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

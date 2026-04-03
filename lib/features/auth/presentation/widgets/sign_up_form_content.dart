import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive.dart';
import '../controllers/auth_bloc.dart';
import '../controllers/auth_event.dart';
import '../controllers/auth_state.dart';
import 'auth_branding_header.dart';
import 'auth_footer_legal.dart';
import 'auth_input_field.dart';
import 'auth_primary_button.dart';

class SignUpFormContent extends StatelessWidget {
  const SignUpFormContent({
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.onToggleObscure,
    super.key,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final VoidCallback onToggleObscure;

  void _submit(BuildContext context) {
    context.read<AuthBloc>().add(
          SignUpWithEmailRequested(
            email: emailController.text,
            password: passwordController.text,
            displayName: nameController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (p, c) =>
          c is AuthLoading || c is AuthLoaded || c is AuthFailure,
      builder: (context, state) {
        final loading = state is AuthLoading;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthBrandingHeader(
              headline: 'Join the Elite',
              subtitle:
                  'Unlock real-time analytics and stadium-grade data engines '
                  'for your professional career.',
              compact: Responsive.isMobile(context),
            ),
            const SizedBox(height: AppSpacing.xl),
            AuthInputField(
              label: 'FULL NAME',
              hint: 'Cristiano Ronaldo',
              icon: Icons.person,
              controller: nameController,
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: AppSpacing.md),
            AuthInputField(
              label: 'EMAIL ADDRESS',
              hint: 'pro@kickoff.com',
              icon: Icons.alternate_email,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: AppSpacing.md),
            AuthInputField(
              label: 'PASSWORD',
              hint: '••••••••',
              icon: Icons.lock,
              controller: passwordController,
              obscureText: obscurePassword,
              suffix: IconButton(
                onPressed: onToggleObscure,
                icon: Icon(
                  obscurePassword ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.authSubtleForeground,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            AuthPrimaryButton(
              label: loading ? 'Creating…' : 'CREATE ACCOUNT',
              trailingIcon: Icons.arrow_forward,
              onPressed: loading ? null : () => _submit(context),
            ),
            const SizedBox(height: AppSpacing.xl),
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Text(
                    'Already a member? ',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.authSubtleForeground,
                        ),
                  ),
                  GestureDetector(
                    onTap: loading ? null : () => context.go(AppRoutes.signIn),
                    child: Text(
                      'Sign In here.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.authPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            const AuthFooterLegal(),
          ],
        );
      },
    );
  }
}

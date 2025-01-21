import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/core/services/firebase_auth_service.dart';
import 'package:flutter_onjung_v1/features/onboarding_auth/widgets/local_validator.dart';
import 'package:flutter_onjung_v1/features/onboarding_auth/widgets/network_validator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/custom_text_form_field.dart';

class EmailSignUpScreen extends ConsumerStatefulWidget {
  const EmailSignUpScreen({super.key});

  @override
  ConsumerState<EmailSignUpScreen> createState() => _EmailSignUpScreenState();
}

class _EmailSignUpScreenState extends ConsumerState<EmailSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('이메일로 회원가입'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomTextFormField(
                    name: 'email',
                    controller: _emailController,
                    label: '이메일',
                    hint: 'example@email.com',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => LocalValidatorHelper.validateEmail(
                      value,
                      'ko',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    name: 'password',
                    controller: _passwordController,
                    label: '비밀번호',
                    hint: '8자 이상 입력해주세요',
                    obscureText: true,
                    validator: (value) => LocalValidatorHelper.validatePassword(
                      value,
                      'ko',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    name: 'confirmPassword',
                    controller: _confirmPasswordController,
                    label: '비밀번호 확인',
                    hint: '비밀번호를 한번 더 입력해주세요',
                    obscureText: true,
                    validator: (value) =>
                        LocalValidatorHelper.validateConfirmPassword(
                      value,
                      _passwordController.text,
                      'ko',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              '회원가입',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/email-signin');
                    },
                    child: const Text('이미 계정이 있으신가요? 로그인'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final authService = ref.read(authServiceProvider);

        // 이메일 중복 체크
        final emailError = await NetworkValidatorHelper.checkEmailDuplicate(
          _emailController.text,
          'ko',
        );

        if (emailError != null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(emailError)),
            );
          }
          return;
        }

        final userCredential = await authService.signUpWithEmail(
          _emailController.text,
          _passwordController.text,
        );

        if (userCredential != null && mounted) {
          Navigator.pushReplacementNamed(context, '/profile-setup');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('회원가입에 실패했습니다. 다시 시도해주세요.'),
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

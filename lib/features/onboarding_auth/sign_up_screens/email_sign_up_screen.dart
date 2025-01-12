import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/core/auth_services/firebase_auth_service.dart';
import 'package:flutter_onjung_v1/core/config/app_router.dart';
import 'package:flutter_onjung_v1/features/onboarding_auth/widgets/local_validator.dart';
import 'package:flutter_onjung_v1/features/onboarding_auth/widgets/network_validator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
  final bool _isLoading = false;
  bool _isEmailChecked = false;

  void _showLoadingOverlay(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void _hideLoadingOverlay(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('회원가입 성공'),
          content: const Text('회원가입이 완료되었습니다.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go(AppRoute.profileSetup.path);
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _checkEmail() async {
    if (_isEmailChecked) return true;

    try {
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
        return false;
      }
      _isEmailChecked = true;
      return true;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('이메일 중복 확인 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.')),
        );
      }
      return false;
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    if (mounted) {
      _showLoadingOverlay(context);
    }

    try {
      // 이메일 중복 체크
      final isEmailValid = await _checkEmail();
      if (!isEmailValid) {
        if (mounted) {
          _hideLoadingOverlay(context);
        }
        return;
      }

      final authService = ref.read(authServiceProvider);
      final userCredential = await authService.signUpWithEmail(
        _emailController.text,
        _passwordController.text,
      );

      if (userCredential != null && mounted) {
        _hideLoadingOverlay(context);
        _showSuccessDialog(context);
      }
    } catch (e) {
      if (mounted) {
        _hideLoadingOverlay(context);
        String errorMessage = '회원가입에 실패했습니다.';
        if (e is FirebaseAuthException) {
          switch (e.code) {
            case 'email-already-in-use':
              errorMessage = '이미 사용 중인 이메일입니다.';
              _isEmailChecked = false; // 이메일 재확인 필요
              break;
            case 'weak-password':
              errorMessage = '비밀번호가 너무 약합니다.';
              break;
            case 'invalid-email':
              errorMessage = '유효하지 않은 이메일 형식입니다.';
              break;
            case 'too-many-requests':
              errorMessage = '너무 많은 요청이 발생했습니다. 잠시 후 다시 시도해주세요.';
              break;
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
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
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: CustomTextFormField(
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
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: CustomTextFormField(
                      name: 'password',
                      controller: _passwordController,
                      label: '비밀번호',
                      hint: '8자 이상 입력해주세요',
                      obscureText: true,
                      validator: (value) =>
                          LocalValidatorHelper.validatePassword(
                        value,
                        'ko',
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: CustomTextFormField(
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
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        '회원가입',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      context.replace(AppRoute.emailSignin.path);
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

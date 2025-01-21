import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/core/config/app_router.dart';
import 'package:flutter_onjung_v1/core/services/firebase_auth_service.dart';
import 'package:flutter_onjung_v1/features/onboarding_auth/widgets/local_validator.dart';
import 'package:flutter_onjung_v1/features/onboarding_auth/widgets/network_validator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/custom_text_form_field.dart';

class EmailSignInScreen extends ConsumerStatefulWidget {
  const EmailSignInScreen({super.key});

  @override
  ConsumerState<EmailSignInScreen> createState() => _EmailSignInScreenState();
}

class _EmailSignInScreenState extends ConsumerState<EmailSignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('이메일로 로그인'),
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
                    hint: '비밀번호를 입력해주세요',
                    obscureText: true,
                    validator: (value) => LocalValidatorHelper.validatePassword(
                      value,
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
                              '로그인',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      context.go(AppRoute.emailSignup.name);
                      // AppRoute.emailSignup.path는 '/email-signup' 경로를 나타냄
                    },
                    child: const Text('계정이 없으신가요? 회원가입'),
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

        final passwordError = await NetworkValidatorHelper.verifyPassword(
          _emailController.text,
          _passwordController.text,
          'ko',
        );

        if (passwordError != null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(passwordError)),
            );
          }
          return;
        }

        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );

          if (mounted) {
            Navigator.pushReplacementNamed(context, '/main');
          }
        } on FirebaseAuthException catch (e) {
          String message = '로그인에 실패했습니다.';
          if (e.code == 'user-not-found') {
            message = '존재하지 않는 이메일입니다.';
          } else if (e.code == 'wrong-password') {
            message = '잘못된 비밀번호입니다.';
          }
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('로그인 중 오류가 발생했습니다.')),
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
    super.dispose();
  }
}

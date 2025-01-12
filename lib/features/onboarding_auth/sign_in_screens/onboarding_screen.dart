import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/core/config/app_router.dart';
import 'package:flutter_onjung_v1/features/onboarding_auth/sign_in_screens/login_options_dialog.dart';
import 'package:flutter_onjung_v1/features/onboarding_auth/sign_up_screens/terms_and_conditions_dialog.dart';
import 'package:flutter_onjung_v1/features/onboarding_auth/widgets/onboarding_view_widget.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: OnboardingViewWidget(),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16)),
                              ),
                              builder: (context) => const LoginOptionsDialog(),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[800],
                            minimumSize: const Size(double.infinity, 48),
                          ),
                          child: const Text("로그인"),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16)),
                              ),
                              builder: (context) =>
                                  const TermsAndConditionsDialog(),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            minimumSize: const Size(double.infinity, 48),
                          ),
                          child: const Text(
                            "회원가입",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    // 계정 찾기 로직
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "계정이 기억나지 않나요? ",
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: "계정찾기",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
            Positioned(
              top: 22,
              right: 22,
              child: GestureDetector(
                onTap: () {
                  debugPrint('🚀 OnboardingScreen: Navigating to /main/home');
                  context.goNamed(AppRoute.homeTab.name); // 둘러보기 동작 수행
                },
                child: Text(
                  '둘러보기',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    decoration: TextDecoration.none, // 기본 스타일 설정
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

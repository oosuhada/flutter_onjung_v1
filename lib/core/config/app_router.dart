import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/features/address_tab/screens/address_tab_screen.dart';
import 'package:flutter_onjung_v1/features/address_tab/screens/member_detail_screen.dart';
import 'package:flutter_onjung_v1/features/calendar_tab/screens/calendar_tab_screen.dart';
import 'package:flutter_onjung_v1/features/home_tab/home_tab_screens/home_tab_screen.dart';
import 'package:flutter_onjung_v1/features/home_tab/home_tab_screens/my_onjung_screen.dart';
import 'package:flutter_onjung_v1/features/home_tab/home_tab_screens/onjung_statistics_screen.dart';
import 'package:flutter_onjung_v1/features/home_tab/input_screens/amount_input_screen.dart';
import 'package:flutter_onjung_v1/features/onboarding_auth/screens/loading_screen.dart';
import 'package:flutter_onjung_v1/features/onboarding_auth/screens/login_options_dialog.dart';
import 'package:flutter_onjung_v1/features/onboarding_auth/screens/onboarding_screen.dart';
import 'package:flutter_onjung_v1/features/onboarding_auth/screens/signup_screen.dart';
import 'package:flutter_onjung_v1/features/onboarding_auth/screens/terms_and_conditions_dialog.dart';
import 'package:flutter_onjung_v1/features/onjung_tab/screens/onjung_tab_screen.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  loading('/'),
  onboarding('/onboarding'),
  login('/login'),
  terms('/terms'),
  signup('/signup'),
  home('/home'),
  myOnjung('/myOnjung'),
  onjungStatistics('/onjungStatistics'),
  address('/address'),
  calendar('/calendar'),
  onjung('/onjung'),
  amountInput('/amountInput'),
  memberDetail('/memberDetail');

  final String path;
  const AppRoute(this.path);
}

// 라우터 설정
final goRouter = GoRouter(
  initialLocation: AppRoute.loading.path,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRoute.loading.path,
      name: AppRoute.loading.name,
      builder: (context, state) {
        debugPrint('🚀 LoadingScreen으로 이동 - state: $state');
        return const LoadingScreen();
      },
    ),
    GoRoute(
      path: AppRoute.onboarding.path,
      name: AppRoute.onboarding.name,
      builder: (context, state) {
        debugPrint('🚀 OnboardingScreen으로 이동 - state: $state');
        return const OnboardingScreen();
      },
    ),
    GoRoute(
      path: AppRoute.login.path,
      name: AppRoute.login.name,
      builder: (context, state) {
        debugPrint('🚀 LoginScreen으로 이동 - state: $state');
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: AppRoute.terms.path,
      name: AppRoute.terms.name,
      builder: (context, state) {
        debugPrint('🚀 TermsAndConditionsDialog로 이동 - state: $state');
        return const TermsAndConditionsDialog();
      },
    ),
    GoRoute(
      path: AppRoute.signup.path,
      name: AppRoute.signup.name,
      builder: (context, state) {
        debugPrint('🚀 SignUpScreen으로 이동 - state: $state');
        return const SignUpScreen();
      },
    ),
    GoRoute(
      path: AppRoute.home.path,
      name: AppRoute.home.name,
      builder: (context, state) => const HomeTabScreen(),
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const HomeTabScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: AppRoute.myOnjung.path,
      name: AppRoute.myOnjung.name,
      builder: (context, state) {
        debugPrint('🚀 MyOnjungScreen으로 이동 - state: $state');
        return const MyOnjungScreen();
      },
    ),
    GoRoute(
      path: AppRoute.onjungStatistics.path,
      name: AppRoute.onjungStatistics.name,
      builder: (context, state) {
        debugPrint('🚀 OnjungStatisticsScreen으로 이동 - state: $state');
        return OnjungStatisticsScreen();
      },
    ),
    GoRoute(
      path: AppRoute.address.path,
      name: AppRoute.address.name,
      builder: (context, state) => const AddressTabScreen(),
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const AddressTabScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: AppRoute.calendar.path,
      name: AppRoute.calendar.name,
      builder: (context, state) => const CalendarTabScreen(),
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const CalendarTabScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: AppRoute.onjung.path,
      name: AppRoute.onjung.name,
      builder: (context, state) => const OnjungTabScreen(),
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const OnjungTabScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: AppRoute.amountInput.path,
      name: AppRoute.amountInput.name,
      builder: (context, state) {
        debugPrint('🚀 AmountInputScreen으로 이동 - state: $state');
        return const AmountInputScreen();
      },
    ),
    GoRoute(
      path: AppRoute.memberDetail.path, // '/members/:id'
      name: AppRoute.memberDetail.name, // 'member-detail'
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        debugPrint('🚀 MemberDetailScreen으로 이동 - state: $state');
        return MemberDetailScreen();
      },
    ),
  ],
);

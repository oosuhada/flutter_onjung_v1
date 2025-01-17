// lib/core/routes/app_router.dart
import 'package:flutter_onjung_v1/features/address_tab/screens/address_tab_screen.dart';
import 'package:flutter_onjung_v1/features/calendar_tab/screens/calendar_tab_screen.dart';
import 'package:flutter_onjung_v1/features/home_tab/home_tab_screens/home_tab_screen.dart';
import 'package:flutter_onjung_v1/features/home_tab/home_tab_screens/my_onjung_screen.dart';
import 'package:flutter_onjung_v1/features/home_tab/home_tab_screens/onjung_statistics_screen.dart';
import 'package:flutter_onjung_v1/features/main_screen.dart';
import 'package:flutter_onjung_v1/features/onboarding_auth/screens/loading_screen.dart';
import 'package:flutter_onjung_v1/features/onboarding_auth/screens/login_options_dialog.dart';
import 'package:flutter_onjung_v1/features/onboarding_auth/screens/onboarding_screen.dart';
import 'package:flutter_onjung_v1/features/onboarding_auth/screens/signup_screen.dart';
import 'package:flutter_onjung_v1/features/onboarding_auth/screens/terms_and_conditions_dialog.dart';
import 'package:flutter_onjung_v1/features/onjung_tab/screens/onjung_tab_screen.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  loading,
  onboarding,
  login,
  terms,
  signup,
  main,
  //홈탭
  home,
  myOnjung, // 나의 온정
  onjungStatistics, // 온정 평균
  //주소록탭
  address,
  //캘린더탭
  calendar,
  //온정탭
  onjung,
}

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: AppRoute.loading.name,
      builder: (context, state) => const LoadingScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      name: AppRoute.onboarding.name,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      name: AppRoute.login.name,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/terms',
      name: AppRoute.terms.name,
      builder: (context, state) => const TermsAndConditionsDialog(),
    ),
    GoRoute(
      path: '/signup',
      name: AppRoute.signup.name,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: '/main',
      name: AppRoute.main.name,
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      path: '/home',
      name: AppRoute.home.name,
      builder: (context, state) => const HomeTabScreen(),
    ),
    GoRoute(
      path: '/myOnjung',
      name: AppRoute.myOnjung.name,
      builder: (context, state) => const MyOnjungScreen(),
    ),
    GoRoute(
      path: '/onjungStatistics',
      name: AppRoute.onjungStatistics.name,
      builder: (context, state) => OnjungStatisticsScreen(),
    ),
    // 새로운 탭 라우트들 추가
    GoRoute(
      path: '/address',
      name: AppRoute.address.name,
      builder: (context, state) => const AddressTabScreen(),
    ),
    GoRoute(
      path: '/calendar',
      name: AppRoute.calendar.name,
      builder: (context, state) => const CalendarTabScreen(),
    ),
    GoRoute(
      path: '/onjung',
      name: AppRoute.onjung.name,
      builder: (context, state) => const OnjungTabScreen(),
    ),
  ],
);

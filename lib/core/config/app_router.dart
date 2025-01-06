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
  loading('/'),
  onboarding('/onboarding'),
  login('/login'),
  terms('/terms'),
  signup('/signup'),
  main('/main'),
  home('/main/home'),
  myOnjung('/main/myOnjung'),
  onjungStatistics('/main/onjungStatistics'),
  address('/main/address'),
  calendar('/main/calendar'),
  onjung('/main/onjung');

  final String path; // 경로 정보를 저장
  const AppRoute(this.path);
}

final goRouter = GoRouter(
  initialLocation: AppRoute.loading.path, // 로딩 화면으로 초기 경로 설정
  routes: [
    GoRoute(
      path: AppRoute.loading.path,
      name: AppRoute.loading.name,
      builder: (context, state) => const LoadingScreen(),
    ),
    GoRoute(
      path: AppRoute.onboarding.path,
      name: AppRoute.onboarding.name,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoute.login.path,
      name: AppRoute.login.name,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoute.terms.path,
      name: AppRoute.terms.name,
      builder: (context, state) => const TermsAndConditionsDialog(),
    ),
    GoRoute(
      path: AppRoute.signup.path,
      name: AppRoute.signup.name,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: AppRoute.main.path,
      name: AppRoute.main.name,
      builder: (context, state) {
        // 전달받은 extra에서 initialIndex를 추출
        final initialIndex = state.extra is Map<String, dynamic>
            ? (state.extra as Map<String, dynamic>)['initialIndex'] as int? ?? 0
            : 0;

        return MainScreen(initialIndex: initialIndex);
      },
      routes: [
        GoRoute(
          path: AppRoute.home.path.replaceFirst('/main', ''), // 상대 경로 사용
          name: AppRoute.home.name,
          builder: (context, state) => const HomeTabScreen(),
        ),
        GoRoute(
          path: AppRoute.myOnjung.path.replaceFirst('/main', ''),
          name: AppRoute.myOnjung.name,
          builder: (context, state) => const MyOnjungScreen(),
        ),
        GoRoute(
          path: AppRoute.onjungStatistics.path.replaceFirst('/main', ''),
          name: AppRoute.onjungStatistics.name,
          builder: (context, state) => OnjungStatisticsScreen(),
        ),
        GoRoute(
          path: AppRoute.address.path.replaceFirst('/main', ''),
          name: AppRoute.address.name,
          builder: (context, state) => const AddressTabScreen(),
        ),
        GoRoute(
          path: AppRoute.calendar.path.replaceFirst('/main', ''),
          name: AppRoute.calendar.name,
          builder: (context, state) => const CalendarTabScreen(),
        ),
        GoRoute(
          path: AppRoute.onjung.path.replaceFirst('/main', ''),
          name: AppRoute.onjung.name,
          builder: (context, state) => const OnjungTabScreen(),
        ),
      ],
    ),
  ],
);

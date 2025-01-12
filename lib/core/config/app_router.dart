import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/features/address_tab/detailed_screens/member_detail_screen.dart';
import 'package:flutter_onjung_v1/features/address_tab/main_screens/address_tab_screen.dart';
import 'package:flutter_onjung_v1/features/calendar_tab/screens/calendar_tab_screen.dart';
import 'package:flutter_onjung_v1/features/home_tab/home_tab_screens/home_onjung_summary_screen.dart.dart';
import 'package:flutter_onjung_v1/features/home_tab/home_tab_screens/home_tab_screen.dart';
import 'package:flutter_onjung_v1/features/home_tab/home_tab_screens/onjung_statistics_screen.dart';
import 'package:flutter_onjung_v1/features/home_tab/input_screens/amount_input_screen.dart';
import 'package:flutter_onjung_v1/features/my_onjung_tab/screens/create_event_type_screen.dart';
import 'package:flutter_onjung_v1/features/my_onjung_tab/screens/event_details_screen.dart';
import 'package:flutter_onjung_v1/features/my_onjung_tab/screens/guest_management_screen.dart';
import 'package:flutter_onjung_v1/features/my_onjung_tab/screens/my_onjung_tab_screen.dart';
import 'package:flutter_onjung_v1/features/my_onjung_tab/screens/visitor_log_screen.dart';
import 'package:flutter_onjung_v1/features/onboarding_auth/sign_in_screens/email_sign_in_screen.dart';
import 'package:flutter_onjung_v1/features/onboarding_auth/sign_in_screens/loading_screen.dart';
import 'package:flutter_onjung_v1/features/onboarding_auth/sign_in_screens/login_options_dialog.dart';
import 'package:flutter_onjung_v1/features/onboarding_auth/sign_in_screens/onboarding_screen.dart';
import 'package:flutter_onjung_v1/features/onboarding_auth/sign_up_screens/email_sign_up_screen.dart';
import 'package:flutter_onjung_v1/features/onboarding_auth/sign_up_screens/signup_screen.dart';
import 'package:flutter_onjung_v1/features/onboarding_auth/sign_up_screens/terms_and_conditions_dialog.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  loading('/'),
  authOnboarding('/authOnboarding'),
  authLogin('/authLogin'),
  authTerms('/authTerms'),
  authSignup('/authSignup'),
  emailSignup('/emailSignup'),
  emailSignin('/emailSignin'),
  homeTab('/homeTab'),
  homeOnjungSummary('/homeOnjungSummary'),
  homeOnjungStatistics('/homeOnjungStatistics'),
  addressTab('/addressTab'),
  addressMemberDetail('/addressMemberDetail'),
  calendarTab('/calendarTab'),
  onjungTab('/onjungTab'),
  onjungCreate('/onjungCreate'),
  onjungEvent('/onjungEvent/:id'),
  onjungGuests('/onjungGuests'),
  onjungVisitorLog('/onjungVisitorLog'),
  amountInput('/amountInput');

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
      path: AppRoute.authOnboarding.path,
      name: AppRoute.authOnboarding.name,
      builder: (context, state) {
        debugPrint('🚀 OnboardingScreen으로 이동 - state: $state');
        return const OnboardingScreen();
      },
    ),
    GoRoute(
      path: AppRoute.authLogin.path,
      name: AppRoute.authLogin.name,
      builder: (context, state) {
        debugPrint('🚀 LoginScreen으로 이동 - state: $state');
        return const LoginScreen();
      },
    ),
    GoRoute(
      path: AppRoute.authTerms.path,
      name: AppRoute.authTerms.name,
      builder: (context, state) {
        debugPrint('🚀 TermsAndConditionsDialog로 이동 - state: $state');
        return const TermsAndConditionsDialog();
      },
    ),
    GoRoute(
      path: AppRoute.authSignup.path,
      name: AppRoute.authSignup.name,
      builder: (context, state) {
        debugPrint('🚀 SignUpScreen으로 이동 - state: $state');
        return const SignUpScreen();
      },
    ),
    GoRoute(
      path: AppRoute.emailSignup.path,
      name: AppRoute.emailSignup.name,
      builder: (context, state) {
        debugPrint('🚀 EmailSignUpScreen으로 이동 - state: $state');
        return const EmailSignUpScreen();
      },
    ),
    GoRoute(
      path: AppRoute.emailSignin.path,
      name: AppRoute.emailSignin.name,
      builder: (context, state) {
        debugPrint('🚀 EmailSignUpScreen으로 이동 - state: $state');
        return const EmailSignInScreen();
      },
    ),
    GoRoute(
      path: AppRoute.homeTab.path,
      name: AppRoute.homeTab.name,
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
      path: AppRoute.homeOnjungSummary.path,
      name: AppRoute.homeOnjungSummary.name,
      builder: (context, state) {
        debugPrint('🚀 HomeOnjungSummary로 이동 - state: $state');
        return const HomeOnjungSummaryScreen();
      },
    ),
    GoRoute(
      path: AppRoute.homeOnjungStatistics.path,
      name: AppRoute.homeOnjungStatistics.name,
      builder: (context, state) {
        debugPrint('🚀 HomeOnjungStatistics로 이동 - state: $state');
        return OnjungStatisticsScreen();
      },
    ),
    GoRoute(
      path: AppRoute.addressTab.path,
      name: AppRoute.addressTab.name,
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
      path: AppRoute.calendarTab.path,
      name: AppRoute.calendarTab.name,
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
      path: AppRoute.onjungTab.path,
      name: AppRoute.onjungTab.name,
      builder: (context, state) {
        debugPrint('🚀 OnjungTabScreen으로 이동 - state: $state');
        return MyOnjungTabScreen();
      },
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
      path: AppRoute.addressMemberDetail.path,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;

        if (extra == null) {
          return Scaffold(
            body: Center(child: Text('No data provided for Member Detail')),
          );
        }

        final counterpartId = extra['counterpartId'] as String;
        final transactions = extra['transactions'] as List;

        return MemberDetailScreen(
          counterpartId: counterpartId,
          transactions: transactions,
        );
      },
    ),
    GoRoute(
      path: AppRoute.onjungCreate.path,
      name: AppRoute.onjungCreate.name,
      builder: (context, state) => const CreateEventTypeScreen(),
    ),
    GoRoute(
      path: '/onjungEvent/:eventId', // URL에 :eventId로 변경
      name: AppRoute.onjungEvent.name,
      builder: (context, state) {
        final eventId = state.pathParameters['eventId']; // eventId 가져오기
        if (eventId == null) {
          throw Exception('Event ID is required');
        }
        return EventDetailsScreen(eventId: eventId);
      },
    ),
    GoRoute(
      path: '/onjungGuests/:eventId', // GuestManagementScreen에 eventId 전달
      name: AppRoute.onjungGuests.name,
      builder: (context, state) {
        final eventId = state.pathParameters['eventId']; // eventId 가져오기
        if (eventId == null) {
          throw Exception('Event ID is required');
        }
        return GuestManagementScreen(eventId: eventId);
      },
    ),
    GoRoute(
      path: '/onjungVisitorLog/:eventId', // VisitorLogScreen에 eventId 전달
      name: AppRoute.onjungVisitorLog.name,
      builder: (context, state) {
        final eventId = state.pathParameters['eventId']; // eventId 가져오기
        if (eventId == null) {
          throw Exception('Event ID is required');
        }
        return VisitorLogScreen(eventId: eventId);
      },
    ),
  ],
);

// lib/core/config/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // 공통으로 사용할 따뜻한 흰색 정의
  static const Color warmWhite = Color.fromARGB(255, 254, 248, 245);

  // 라이트 테마 1 - 메인 화면용 (따뜻한 배경, 강한 대비)
  static ThemeData lightTheme1() {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: warmWhite,
      primaryColor: Colors.black87,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.black87,
        primary: Colors.black87,
        secondary: Colors.orange, // 포인트 컬러 설정
        surface: warmWhite,
        background: warmWhite,
        onSurfaceVariant: Colors.grey[200]!,
        tertiary: Colors.orange, // 추가 포인트 컬러
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: warmWhite,
        foregroundColor: Colors.black87, // 아이콘 및 텍스트 색상
        elevation: 0, // 그림자 제거
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        displayMedium: TextStyle(
          fontSize: 24,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color.fromARGB(255, 245, 240, 238),
        selectedColor: Colors.orange.withOpacity(0.2), // 포인트 컬러 사용
        labelStyle: TextStyle(color: Colors.grey[800]),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.orange.withOpacity(0.3); // 눌린 상태 배경색
            } else if (states.contains(MaterialState.disabled)) {
              return Colors.grey[100]; // 비활성화 상태 배경색
            }
            return Colors.orange; // 기본 배경색
          }),
          overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.orange.withOpacity(0.1); // 눌린 상태 오버레이 색상
            } else if (states.contains(MaterialState.hovered)) {
              return Colors.orange.withOpacity(0.05); // 호버 상태 오버레이 색상
            }
            return null; // 기본 상태
          }),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          fixedSize: MaterialStateProperty.all(const Size(350, 48)),
          textStyle: MaterialStateProperty.all(
            const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.orange, // 텍스트 버튼의 포인트 색상
          padding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 12), // 여백 최소화
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // 모서리 둥글게
          ),
          minimumSize: const Size(0, 48), // 최소 크기 설정
          maximumSize: const Size(200, 48), // 최대 크기 설정 (가로 길이 제한)
        ),
      ),
    );
  }

  // 다크 테마 1 - 메인 화면용 (진한 배경, 강한 대비)
  static ThemeData darkTheme1() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      primaryColor: warmWhite,
      colorScheme: ColorScheme.fromSeed(
        seedColor: warmWhite,
        brightness: Brightness.dark,
        primary: warmWhite,
        surface: Colors.black,
        secondary: Colors.orange, // 포인트 컬러 설정
        onSurfaceVariant: Colors.grey[800]!,
        tertiary: Colors.orange, // 추가 포인트 컬러
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white, // 아이콘 및 텍스트 색상
        elevation: 0, // 그림자 제거
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: warmWhite,
        ),
        displayMedium: TextStyle(
          fontSize: 24,
          color: warmWhite,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: warmWhite.withOpacity(0.8),
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: warmWhite.withOpacity(0.8),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey[800],
        selectedColor: Colors.orange.withOpacity(0.2), // 포인트 컬러 사용
        labelStyle: TextStyle(color: Colors.grey[300]),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.orange.withOpacity(0.3); // 눌린 상태 배경색
            } else if (states.contains(MaterialState.disabled)) {
              return Colors.grey[900]; // 비활성화 상태 배경색
            }
            return Colors.orange; // 기본 배경색
          }),
          overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.orange.withOpacity(0.1); // 눌린 상태 오버레이 색상
            } else if (states.contains(MaterialState.hovered)) {
              return Colors.orange.withOpacity(0.05); // 호버 상태 오버레이 색상
            }
            return null;
          }),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          fixedSize: MaterialStateProperty.all(const Size(350, 48)),
          textStyle: MaterialStateProperty.all(
            const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.orange, // 텍스트 버튼의 포인트 색상
          padding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 12), // 여백 최소화
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // 모서리 둥글게
          ),
          minimumSize: const Size(0, 48), // 최소 크기 설정
          maximumSize: const Size(200, 48), // 최대 크기 설정 (가로 길이 제한)
        ),
      ),
    );
  }
}

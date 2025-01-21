import 'package:flutter/material.dart';

class AppTheme {
  static const Color warmWhite = Color.fromARGB(255, 254, 248, 245);

  // Pretendard 폰트를 사용하는 TextTheme 정의
  static TextTheme _buildTextTheme(Color textColor) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textColor,
        fontFamily: 'Pretendard',
      ),
      displayMedium: TextStyle(
        fontSize: 24,
        color: textColor,
        fontWeight: FontWeight.w500,
        fontFamily: 'Pretendard',
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: textColor,
        fontFamily: 'Pretendard',
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: Colors.grey,
        fontFamily: 'Pretendard',
      ),
    );
  }

  static ThemeData lightTheme1() {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: warmWhite,
      primaryColor: Colors.black87,
      fontFamily: 'Pretendard', // 기본 폰트 설정
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.black87,
        primary: Colors.black87,
        secondary: Colors.orange,
        surface: warmWhite,
        onSurfaceVariant: Colors.grey[200]!,
        tertiary: Colors.orange,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: warmWhite,
        foregroundColor: Colors.black87,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      textTheme: _buildTextTheme(Colors.grey.shade800),
      chipTheme: ChipThemeData(
        backgroundColor: const Color.fromARGB(255, 245, 240, 238),
        selectedColor: Colors.orange.withAlpha(51),
        labelStyle: TextStyle(
          color: Colors.grey[800],
          fontFamily: 'Pretendard',
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.orange),
          overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.pressed)) {
              return Colors.orange.withAlpha(26);
            } else if (states.contains(WidgetState.hovered)) {
              return Colors.orange.withAlpha(13);
            }
            return null;
          }),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          fixedSize: const WidgetStatePropertyAll(Size(350, 48)),
          textStyle: const WidgetStatePropertyAll(
            TextStyle(
              fontFamily: 'Pretendard',
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.orange,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          minimumSize: const Size(0, 48),
          maximumSize: const Size(200, 48),
          textStyle: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  static ThemeData darkTheme1() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      primaryColor: warmWhite,
      fontFamily: 'Pretendard', // 기본 폰트 설정
      colorScheme: ColorScheme.fromSeed(
        seedColor: warmWhite,
        brightness: Brightness.dark,
        primary: warmWhite,
        surface: Colors.black,
        secondary: Colors.orange,
        onSurfaceVariant: Colors.grey[800]!,
        tertiary: Colors.orange,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      textTheme: _buildTextTheme(Colors.grey),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey[800],
        selectedColor: Colors.orange.withAlpha(51),
        labelStyle: TextStyle(
          color: Colors.grey[300],
          fontFamily: 'Pretendard',
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.orange),
          overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.pressed)) {
              return Colors.orange.withAlpha(26);
            } else if (states.contains(WidgetState.hovered)) {
              return Colors.orange.withAlpha(13);
            }
            return null;
          }),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          fixedSize: const WidgetStatePropertyAll(Size(350, 48)),
          textStyle: const WidgetStatePropertyAll(
            TextStyle(
              fontFamily: 'Pretendard',
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: Colors.orange,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          minimumSize: const Size(0, 48),
          maximumSize: const Size(200, 48),
          textStyle: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class LocalValidatorHelper {
  // 공통 필드 검증 메서드
  static String? validateField({
    required String? value,
    required String languageCode,
    required String emptyErrorMessage,
    required bool Function(String) validationFn,
    required String invalidErrorMessage,
    String fieldName = 'Field', // 기본값 추가
  }) {
    if (value == null || value.isEmpty) {
      debugPrint('Validation Failed: $fieldName is empty');
      return emptyErrorMessage;
    }
    if (!validationFn(value)) {
      debugPrint(
          'Validation Failed: Invalid $fieldName format - Value: $value');
      return invalidErrorMessage;
    }
    debugPrint('Validation Passed: $fieldName is valid');
    return null;
  }

  // 실시간 이메일, 비밀번호 검증 로직
  static bool isEmailContainsAtSymbol(String email) {
    final result = email.contains('@');
    debugPrint('Email contains @ symbol: $result');
    return result;
  }

  static bool isPasswordAtLeastSixCharacters(String password) {
    final result = password.length >= 6;
    debugPrint('Password length >= 6: $result (length: ${password.length})');
    return result;
  }

  // 고급 이메일, 비밀번호 검증 로직
  static bool isEmailValid(String email) {
    final result = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email);
    debugPrint('Email validation result: $result for email: $email');
    return result;
  }

  static bool isPasswordValid(String password) {
    final result =
        RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@\$!%*#?&])[A-Za-z\d@\$!%*#?&]')
            .hasMatch(password);
    debugPrint('Password meets complex criteria: $result');
    return result;
  }

  static bool isPasswordComplex(String password) {
    final hasLength = password.length >= 6;
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(password);
    final hasDigit = RegExp(r'\d').hasMatch(password);

    debugPrint('Password complexity check:');
    debugPrint('- Length >= 6: $hasLength (${password.length})');
    debugPrint('- Contains letter: $hasLetter');
    debugPrint('- Contains digit: $hasDigit');

    return hasLength && hasLetter && hasDigit;
  }

  static bool isNicknameValid(String nickname) {
    final result = RegExp(r'^[a-zA-Z가-힣0-9]{2,10}$').hasMatch(nickname);
    debugPrint('Nickname validation result: $result for nickname: $nickname');
    return result;
  }

  static bool isPhoneValid(String phone) {
    final result = RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(phone);
    debugPrint('Phone validation result: $result for phone: $phone');
    return result;
  }

  // 이메일, 비밀번호 최종 검증 메서드
  static String? validateEmail(String? value, String languageCode) {
    return validateField(
      value: value,
      languageCode: languageCode,
      emptyErrorMessage: '이메일을 입력해주세요.',
      invalidErrorMessage: '유효하지 않은 이메일 형식입니다.',
      validationFn: isEmailValid,
      fieldName: 'Email',
    );
  }

  static String? validatePassword(String? value, String languageCode) {
    return validateField(
      value: value,
      languageCode: languageCode,
      emptyErrorMessage: '비밀번호를 입력해주세요.',
      invalidErrorMessage: '비밀번호는 영문, 숫자를 포함하여 6자 이상이어야 합니다.',
      validationFn: isPasswordComplex,
      fieldName: 'Password',
    );
  }

  static String? validatePasswordLength(String? value, String languageCode) {
    return validateField(
      value: value,
      languageCode: languageCode,
      emptyErrorMessage: '비밀번호를 입력해주세요.',
      invalidErrorMessage: '비밀번호는 최소 6자 이상이어야 합니다.',
      validationFn: (password) => password.length >= 6,
      fieldName: 'Password length',
    );
  }

  static String? validateConfirmPassword(
    String? confirmPassword,
    String? originalPassword,
    String languageCode,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      debugPrint('Validation Failed: Confirm password is empty');
      return '비밀번호를 확인해주세요.';
    }
    if (confirmPassword != originalPassword) {
      debugPrint('Validation Failed: Passwords do not match');
      debugPrint('Original password length: ${originalPassword?.length}');
      debugPrint('Confirm password length: ${confirmPassword.length}');
      return '비밀번호가 일치하지 않습니다.';
    }
    debugPrint('Validation Passed: Passwords match');
    return null;
  }

  // 전화번호 인증 관련 검증 로직
  static bool isNumericOnly(String value) {
    final result = RegExp(r'^\d+$').hasMatch(value);
    debugPrint('Numeric only validation: $result for value: $value');
    return result;
  }

  static bool isVerificationCodeValid(String code) {
    final result = code.length == 6 && RegExp(r'^\d{6}$').hasMatch(code);
    debugPrint(
        'Verification code validation: $result for code length: ${code.length}');
    return result;
  }

  static String? validateVerificationCode(String? value, String languageCode) {
    if (value == null || value.isEmpty) {
      debugPrint('Validation Failed: Verification code is empty');
      return '인증번호를 입력해주세요.';
    }
    if (!isNumericOnly(value)) {
      debugPrint('Validation Failed: Verification code is not numeric');
      return '올바르지 않은 인증번호 형식입니다.';
    }
    if (value != "000000") {
      debugPrint('Validation Failed: Verification code does not match');
      return '인증번호가 일치하지 않습니다.';
    }
    debugPrint('Validation Passed: Verification code is valid');
    return null;
  }

  static String? validatePhone(String? value, String languageCode) {
    return validateField(
      value: value,
      languageCode: languageCode,
      emptyErrorMessage: '전화번호를 입력해주세요.',
      invalidErrorMessage: '올바르지 않은 전화번호 형식입니다.',
      validationFn: isPhoneValid,
      fieldName: 'Phone',
    );
  }

  // 닉네임 검증 로직
  static String? validateNickname(String? value, String languageCode) {
    return validateField(
      value: value,
      languageCode: languageCode,
      emptyErrorMessage: '닉네임을 입력해주세요.',
      invalidErrorMessage: '닉네임은 2~10자의 영문, 숫자, 한글로 입력해주세요.',
      validationFn: isNicknameValid,
      fieldName: 'Nickname',
    );
  }
}

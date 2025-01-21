import 'package:flutter/material.dart';

class LocalValidatorHelper {
  // 공통 필드 검증 메서드
  static String? validateField({
    required String? value,
    required String languageCode,
    required String emptyErrorMessage,
    required bool Function(String) validationFn,
    required String invalidErrorMessage,
  }) {
    if (value == null || value.isEmpty) {
      debugPrint('Validation Failed: Field is empty');
      return emptyErrorMessage;
    }
    if (!validationFn(value)) {
      debugPrint('Validation Failed: Invalid field format');
      return invalidErrorMessage;
    }
    return null;
  }

  // 실시간 이메일, 비밀번호 검증 로직
  static bool isEmailContainsAtSymbol(String email) {
    return email.contains('@');
  }

  static bool isPasswordAtLeastSixCharacters(String password) {
    return password.length >= 6;
  }

  // 고급 이메일, 비밀번호 검증 로직
  static bool isEmailValid(String email) {
    return RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email);
  }

  static bool isPasswordValid(String password) {
    return RegExp(
            r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@\$!%*#?&])[A-Za-z\d@\$!%*#?&]')
        .hasMatch(password);
  }

  static bool isPasswordComplex(String password) {
    return password.length >= 6 &&
        RegExp(r'[A-Za-z]').hasMatch(password) &&
        RegExp(r'\d').hasMatch(password);
  }

  static bool isNicknameValid(String nickname) {
    return RegExp(r'^[a-zA-Z가-힣0-9]{2,10}$').hasMatch(nickname);
  }

  static bool isPhoneValid(String phone) {
    return RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(phone);
  }

  // 이메일, 비밀번호 최종 검증 메서드
  static String? validateEmail(String? value, String languageCode) {
    return validateField(
      value: value,
      languageCode: languageCode,
      emptyErrorMessage: '이메일을 입력해주세요.',
      invalidErrorMessage: '유효하지 않은 이메일 형식입니다.',
      validationFn: isEmailValid,
    );
  }

  static String? validatePassword(String? value, String languageCode) {
    return validateField(
      value: value,
      languageCode: languageCode,
      emptyErrorMessage: '비밀번호를 입력해주세요.',
      invalidErrorMessage: '비밀번호는 영문, 숫자를 포함하여 6자 이상이어야 합니다.',
      validationFn: isPasswordComplex,
    );
  }

  static String? validatePasswordLength(String? value, String languageCode) {
    return validateField(
      value: value,
      languageCode: languageCode,
      emptyErrorMessage: '비밀번호를 입력해주세요.',
      invalidErrorMessage: '비밀번호는 최소 6자 이상이어야 합니다.',
      validationFn: (password) => password.length >= 6,
    );
  }

  static String? validateConfirmPassword(
    String? confirmPassword,
    String? originalPassword,
    String languageCode,
  ) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return '비밀번호를 확인해주세요.';
    }
    if (confirmPassword != originalPassword) {
      return '비밀번호가 일치하지 않습니다.';
    }
    return null;
  }

  // 전화번호 인증 관련 검증 로직
  static bool isNumericOnly(String value) {
    return RegExp(r'^\d+$').hasMatch(value);
  }

  static bool isVerificationCodeValid(String code) {
    return code.length == 6 && RegExp(r'^\d{6}$').hasMatch(code);
  }

  static String? validateVerificationCode(String? value, String languageCode) {
    if (value == null || value.isEmpty) {
      return '인증번호를 입력해주세요.';
    }
    if (!isNumericOnly(value)) {
      return '올바르지 않은 인증번호 형식입니다.';
    }
    if (value != "000000") {
      return '인증번호가 일치하지 않습니다.';
    }
    return null;
  }

  static String? validatePhone(String? value, String languageCode) {
    return validateField(
      value: value,
      languageCode: languageCode,
      emptyErrorMessage: '전화번호를 입력해주세요.',
      invalidErrorMessage: '올바르지 않은 전화번호 형식입니다.',
      validationFn: isPhoneValid,
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
    );
  }
}

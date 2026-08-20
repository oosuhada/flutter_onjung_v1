import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 텍스트 폼 필드의 기본적인 상태 관리를 위한 열거형
enum ValidationState { valid, invalid, validating, initial }

class CustomTextFormField extends StatefulWidget {
  // 필수 파라미터들
  final String name; // 폼 필드의 고유 이름
  final TextEditingController controller; // 텍스트 입력 컨트롤러

  // 선택적 파라미터들
  final String? label; // 상단 라벨 텍스트
  final String? hint; // 힌트 텍스트
  final String? helperText; // 도움말 텍스트
  final ValueChanged<String?>? onChanged; // 값 변경 콜백
  final String? Function(String?)? validator; // 유효성 검사 함수
  final TextInputType keyboardType; // 키보드 타입
  final Widget? suffixIcon; // 오른쪽 아이콘
  final bool obscureText; // 텍스트 숨김 여부 (비밀번호용)
  final FocusNode? focusNode; // 포커스 노드
  final TextInputAction? textInputAction; // 키보드 액션 버튼 타입
  final VoidCallback? onEditingComplete; // 편집 완료 콜백
  final List<TextInputFormatter>? inputFormatters; // 입력 형식 지정
  final AutovalidateMode autovalidateMode; // 자동 유효성 검사 모드

  const CustomTextFormField({
    super.key,
    required this.name,
    required this.controller,
    this.label,
    this.hint,
    this.helperText,
    this.onChanged,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.obscureText = false,
    this.focusNode,
    this.textInputAction,
    this.onEditingComplete,
    this.inputFormatters,
    this.autovalidateMode = AutovalidateMode.disabled,
  });

  @override
  CustomTextFormFieldState createState() => CustomTextFormFieldState();
}

class CustomTextFormFieldState extends State<CustomTextFormField>
    with SingleTickerProviderStateMixin {
  // 상태 관리 변수들
  final ValueNotifier<ValidationState> _validationState =
      ValueNotifier(ValidationState.initial); // 유효성 검사 상태
  Timer? _debounceTimer; // 입력 지연 타이머
  String? _errorText; // 에러 메시지
  bool _isTyping = false; // 타이핑 중인지 여부
  bool _obscureText = true; // 비밀번호 숨김 상태

  // 애니메이션 관련 변수들
  late final AnimationController _animationController; // 애니메이션 컨트롤러
  late final Animation<double> _shakeAnimation; // 흔들기 애니메이션

  // 레이아웃 상수
  static const double _maxWidth = 400.0; // 최대 너비
  static const double _minWidth = 200.0; // 최소 너비
  static const double _defaultHeight = 56.0; // 기본 높이

  @override
  void initState() {
    super.initState();
    // 흔들기 애니메이션 초기화
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: -10, end: 10)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_animationController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reset();
        }
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _validationState.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  // 텍스트 입력 처리 함수
  void _handleFieldChange(String? value) {
    _isTyping = true; // 타이핑 시작

    void performValidation() {
      if (!mounted) return;

      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 1500), () {
        if (!mounted) return;

        setState(() {
          _isTyping = false; // 타이핑 종료

          // 유효성 검사 수행
          final validationError = widget.validator?.call(value);
          _validationState.value = validationError == null
              ? ValidationState.valid
              : ValidationState.invalid;
          _errorText = validationError;

          // 유효성 검사 실패시 흔들기 애니메이션 실행
          if (_validationState.value == ValidationState.invalid && !_isTyping) {
            _animationController.forward();
          }
        });
      });
    }

    if (widget.autovalidateMode == AutovalidateMode.always) {
      performValidation();
    } else if (widget.autovalidateMode == AutovalidateMode.onUserInteraction) {
      _debounceTimer?.cancel();
      _debounceTimer =
          Timer(const Duration(milliseconds: 1500), performValidation);
    }

    widget.onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    // 화면 너비 계산
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = 30.0;
    final contentWidth = screenWidth - (horizontalPadding * 2);

    return ValueListenableBuilder<ValidationState>(
      valueListenable: _validationState,
      builder: (context, state, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: contentWidth > _maxWidth ? _maxWidth : contentWidth,
              minWidth: _minWidth,
              minHeight: _defaultHeight,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 라벨 표시
                if (widget.label != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(widget.label!,
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                // 텍스트 입력 필드
                TextFormField(
                  controller: widget.controller,
                  keyboardType: widget.keyboardType,
                  obscureText: widget.obscureText &&
                      _obscureText, // 수정: obscureText 상태와 연동
                  focusNode: widget.focusNode,
                  textInputAction: widget.textInputAction,
                  onEditingComplete: widget.onEditingComplete,
                  inputFormatters: widget.inputFormatters,
                  autovalidateMode: widget.autovalidateMode,
                  decoration: InputDecoration(
                    hintText: widget.hint,
                    helperText: widget.helperText,
                    suffixIcon: widget.obscureText // 수정: 비밀번호 필드일 경우 토글 버튼 추가
                        ? IconButton(
                            icon: Icon(_obscureText
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () =>
                                setState(() => _obscureText = !_obscureText),
                          )
                        : widget.suffixIcon,
                    errorText: _errorText,
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  onChanged: (value) {
                    widget.onChanged?.call(value);
                    _validationState.value = ValidationState.validating;
                    _handleFieldChange(value);
                  },
                  validator: widget.validator,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

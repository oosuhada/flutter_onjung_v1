import 'package:flutter/material.dart';

class OnboardingViewWidget extends StatefulWidget {
  const OnboardingViewWidget({super.key});

  @override
  State<OnboardingViewWidget> createState() => _OnboardingViewWidgetState();
}

class _OnboardingViewWidgetState extends State<OnboardingViewWidget> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              _buildPage(
                'assets/onboarding1.png',
                '반가워요! 온정과 함께 시작해볼까요?',
                '경조사비, 이제 더 쉽고 편리하게 관리해요',
              ),
              _buildPage(
                'assets/onboarding2.png',
                'AI가 읽어주는 똑똑한 장부',
                '장부를 찍으면 온정이 알아서 해드립니다',
              ),
              _buildPage(
                'assets/onboarding3.png',
                '한눈에 보는 나의 경조사비 현황',
                '통계와 분석으로 체계적인 관리가 가능해요',
              ),
              _buildPage(
                'assets/onboarding4.png',
                '지출을 계획하고 절약하세요',
                '경조사 비용을 효과적으로 관리하세요',
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              width: _currentIndex == index ? 12.0 : 8.0,
              height: 8.0,
              decoration: BoxDecoration(
                color: _currentIndex == index
                    ? Colors.grey.shade700
                    : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(4.0),
              ),
            );
          }),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPage(String imagePath, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: 200,
          ),
          const SizedBox(height: 32),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey
                  : Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey
                  : Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }
}

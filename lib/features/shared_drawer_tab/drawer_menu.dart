// right_drawer_menu.dart
import 'package:flutter/material.dart';
import 'package:flutter_onjung_v1/features/shared_drawer_tab/app_version_page.dart';
import 'package:flutter_onjung_v1/features/shared_drawer_tab/event_guide_page.dart';
import 'package:flutter_onjung_v1/features/shared_drawer_tab/export_data_page.dart';
import 'package:flutter_onjung_v1/features/shared_drawer_tab/feedback_page.dart';
import 'package:flutter_onjung_v1/features/shared_drawer_tab/privacy_policy_page.dart';
import 'package:flutter_onjung_v1/features/shared_drawer_tab/profile_edit_page.dart';
import 'package:flutter_onjung_v1/features/shared_drawer_tab/settings_page.dart';
import 'package:flutter_onjung_v1/features/shared_drawer_tab/voting_page.dart';

class RightDrawerMenu extends StatelessWidget {
  const RightDrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        bottomLeft: Radius.circular(20),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.67, // 화면의 2/3 크기
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    // 로고 추가 부분
                    Align(
                      alignment: Alignment.topLeft, // 좌측 상단 정렬
                      child: Image.asset(
                        Theme.of(context).brightness == Brightness.dark
                            ? 'assets/logo/onjung_logo_clear_white.png' // 다크 테마일 때 로고 이미지 경로
                            : 'assets/logo/onjung_logo_clear_dark.png', // 라이트 테마일 때 로고 이미지 경로
                        width: 130, // 원하는 너비로 조정
                        height: 60, // 원하는 높이로 조정
                        fit: BoxFit.contain, // 이미지를 컨테이너에 맞게 조정
                      ),
                    ),
                    SizedBox(
                      height: 20,
                      child: DrawerHeader(
                        decoration: const BoxDecoration(),
                        child: null,
                      ),
                    ),
                    const SizedBox(height: 16), // 로고와 메뉴 항목 사이의 간격

                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileEditPage(),
                          ),
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          '내 정보 수정',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildMenuItem(
                      title: '데이터 내보내기',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ExportDataPage(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      title: '투표하기',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const VotingPage(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      title: '경조사 길라잡이',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EventGuidePage(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      title: '개인정보 처리방침',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PrivacyPolicyPage(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      title: '로그아웃',
                      onTap: () {
                        Navigator.pop(context);
                        // TODO: 로그아웃 로직 구현
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('로그아웃'),
                            content: const Text('정말 로그아웃 하시겠습니까?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('취소'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // TODO: 실제 로그아웃 처리
                                  Navigator.pop(context);
                                },
                                child: const Text('확인'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      title: '회원탈퇴',
                      onTap: () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('회원탈퇴'),
                            content: const Text('정말 탈퇴하시겠습니까?\n모든 데이터가 삭제됩니다.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('취소'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // TODO: 실제 회원탈퇴 처리
                                  Navigator.pop(context);
                                },
                                child: const Text('확인'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      title: '앱 버전 정보',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AppVersionPage(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      title: '피드백 보내기',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FeedbackPage(),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      title: '환경설정',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class VisitorLogDrawerMenuScreen extends StatelessWidget {
  const VisitorLogDrawerMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('방문록 메뉴'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        children: [
          _buildMenuItem(
            context,
            label: '수기 방명록 찍어서 올리기 (OCR/사진)',
            icon: Icons.camera_alt,
            onPressed: () {},
          ),
          _buildMenuItem(
            context,
            label: '엑셀파일 업로드하기',
            icon: Icons.upload_file,
            onPressed: () {},
          ),
          _buildMenuItem(
            context,
            label: '엑셀파일 내려받기',
            icon: Icons.download,
            onPressed: () {},
          ),
          _buildMenuItem(
            context,
            label: '수동 입력하기',
            icon: Icons.edit,
            onPressed: () {},
          ),
          _buildMenuItem(
            context,
            label: '단체 메시지 전달',
            icon: Icons.message,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Icon(icon, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

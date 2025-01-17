import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.orange,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'ONJUNG',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '검색어를 입력해주세요',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('내 정보 수정'),
            onTap: () {
              // TODO: 내 정보 수정 로직
            },
          ),
          ListTile(
            leading: Icon(Icons.file_upload),
            title: Text('데이터 내보내기'),
            onTap: () {
              // TODO: 데이터 내보내기 로직
            },
          ),
          ListTile(
            leading: Icon(Icons.poll),
            title: Text('투표하기'),
            onTap: () {
              // TODO: 투표하기 로직
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('로그아웃'),
            onTap: () {
              // TODO: 로그아웃 로직
            },
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('회원탈퇴'),
            onTap: () {
              // TODO: 회원탈퇴 로직
            },
          ),
        ],
      ),
    );
  }
}

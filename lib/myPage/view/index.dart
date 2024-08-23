import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundBlue,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: backgroundBlue,
        surfaceTintColor: backgroundBlue,
        title: Text('마이페이지', style: body2()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            _buildSectionTitle('내 정보'),
            const SizedBox(height: 12),
            _buildUserInfo('이름', '김복실'),
            _buildUserInfo('카카오 ID', 'kakaoID@gmail.com'),
            const SizedBox(height: 24),
            _buildSectionTitle('조합 명'),
            const SizedBox(height: 12),
            _buildSelectableItem('구룡포 수협', onPressed: () {}),
            const SizedBox(height: 24),
            _buildSectionTitle('주요 어종'),
            const SizedBox(height: 12),
            _buildSelectableItem('갈치', isRemovable: true, onPressed: () {}),
            const SizedBox(height: 8),
            _buildSelectableItem('고등어', isRemovable: true, onPressed: () {}),
            const SizedBox(height: 24),
            _buildSectionTitle('주요 어법'),
            const SizedBox(height: 12),
            _buildSelectableItem('외끌이대형저인망', isRemovable: true, onPressed: () {}),
            const SizedBox(height: 24),
            _buildSectionTitle('주요 조업 위치'),
            const SizedBox(height: 12),
            _buildSelectableItem('서해 앞바다', onPressed: () {}, hasLocationIcon: true),
            const SizedBox(height: 24),
            _buildSectionTitle('내 정보'),
            const SizedBox(height: 12),
            _buildSimpleItem('개인정보 처리방침', onPressed: () {}),
            const SizedBox(height: 8.0),
            _buildSimpleItem('서비스 이용약관', onPressed: () {}),
            const SizedBox(height: 8.0),
            _buildSimpleItem('위치정보 서비스 이용약관', onPressed: () {}),
            const SizedBox(height: 24),
            _buildSectionTitle('계정'),
            const SizedBox(height: 12),
            _buildSimpleItem('로그아웃', onPressed: () {}),
            const SizedBox(height: 8.0),
            _buildSimpleItem('탈퇴하기', onPressed: () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: header4(),
    );
  }

  Widget _buildUserInfo(String label, String info) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(info, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildSelectableItem(String title,
      {bool isRemovable = false, bool hasLocationIcon = false, required VoidCallback onPressed}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
          left: BorderSide(color: Colors.grey.shade300),
          right: BorderSide(color: Colors.grey.shade300),
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          Expanded(child: Text(title, style: body1())),
          if (hasLocationIcon) const Icon(Icons.location_on, color: Colors.grey),
          if (isRemovable)
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: onPressed,
            )
          else
            TextButton(
              onPressed: onPressed,
              child: const Text('수정하기', style: TextStyle(color: Colors.blue)),
            ),
        ],
      ),
    );
  }

  Widget _buildSimpleItem(String title, {required VoidCallback onPressed}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(title, style: body1()),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
        onTap: onPressed,
      ),
    );
  }
}

import 'package:fish_note/myPage/view/my_page_affiliation.dart';
import 'package:fish_note/myPage/view/my_page_location.dart';
import 'package:fish_note/myPage/view/my_page_species.dart';
import 'package:fish_note/myPage/view/my_page_technique.dart';
import 'package:fish_note/myPage/view/my_page_withdrawal.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import '../components/logout_dialog.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return buildLogoutDialog(context);
      },
    );
  }

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
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: gray1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('내 정보'),
                  const SizedBox(height: 12),
                  _buildUserInfo('이름', '김복실'),
                  const SizedBox(height: 8),
                  _buildUserInfo('카카오 ID', 'kakaoID@gmail.com'),
                  const SizedBox(height: 12),
                  const Divider(color: gray1),
                  const SizedBox(height: 12),
                  _buildSectionTitle('조합 명'),
                  const SizedBox(height: 12),
                  _buildSelectableItem('구룡포 수협',
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const MyPageAffiliation()))),
                  const SizedBox(height: 12),
                  const Divider(color: gray1),
                  const SizedBox(height: 12),
                  _buildSectionTitle('주요 어종'),
                  const SizedBox(height: 12),
                  _buildSelectableItem('갈치', isRemovable: true, onPressed: () {}),
                  const SizedBox(height: 8),
                  _buildSelectableItem('고등어', isRemovable: true, onPressed: () {}),
                  const SizedBox(height: 8),
                  _buildSelectableItem('어종 추가하기',
                      isAdd: true,
                      onPressed: () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => const MyPageSpecies()))),
                  const SizedBox(height: 12),
                  const Divider(color: gray1),
                  const SizedBox(height: 12),
                  _buildSectionTitle('주요 어법'),
                  const SizedBox(height: 12),
                  _buildSelectableItem('외끌이대형저인망', isRemovable: true, onPressed: () {}),
                  const SizedBox(height: 8),
                  _buildSelectableItem('어법 추가하기',
                      isAdd: true,
                      onPressed: () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => const MyPageTechnique()))),
                  const SizedBox(height: 12),
                  const Divider(color: gray1),
                  const SizedBox(height: 12),
                  _buildSectionTitle('주요 조업 위치'),
                  const SizedBox(height: 12),
                  _buildSelectableItem('서해 앞바다',
                      onPressed: () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => const MyPageLocation())),
                      hasLocationIcon: true),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: backgroundWhite,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: gray1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('약관 정보'),
                  const SizedBox(height: 12),
                  _buildSimpleItem('개인정보 처리방침', onPressed: () {}),
                  const Divider(color: gray1),
                  _buildSimpleItem('서비스 이용약관', onPressed: () {}),
                  const Divider(color: gray1),
                  _buildSimpleItem('위치정보 서비스 이용약관', onPressed: () {}),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: backgroundWhite,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: gray1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('계정'),
                  const SizedBox(height: 12),
                  _buildSimpleItem('로그아웃', onPressed: () => _showLogoutDialog(context)),
                  const Divider(color: gray1),
                  _buildSimpleItem('탈퇴하기',
                      onPressed: () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => const MyPageWithdrawal()))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: header4());
  }

  Widget _buildUserInfo(String label, String info) {
    return Row(
      children: [
        SizedBox(width: 70, child: Text(label, style: body3(gray5))),
        Text(info, style: body1()),
      ],
    );
  }

  Widget _buildSelectableItem(String title,
      {bool isRemovable = false,
      bool hasLocationIcon = false,
      bool isAdd = false,
      required VoidCallback onPressed}) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: const Border(
          top: BorderSide(color: gray3),
          left: BorderSide(color: gray3),
          right: BorderSide(color: gray3),
          bottom: BorderSide(color: gray3),
        ),
      ),
      child: Row(
        children: [
          Expanded(child: Text(title, style: isAdd ? body2(gray4) : body1())),
          if (hasLocationIcon)
            IconButton(
              icon: const Icon(Icons.location_on, color: textBlack),
              onPressed: onPressed,
            ),
          if (isRemovable)
            IconButton(
              icon: const Icon(Icons.close, color: textBlack),
              onPressed: onPressed,
            )
          else if (isAdd)
            IconButton(
              onPressed: onPressed,
              icon: const Icon(Icons.add_circle_outline, color: gray4),
            )
          else if (!hasLocationIcon)
            TextButton(
              onPressed: onPressed,
              child: Text('수정하기', style: body2(primaryBlue500)),
            ),
        ],
      ),
    );
  }

  Widget _buildSimpleItem(String title, {required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(title, style: body1()),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16.0, color: gray7),
        onTap: onPressed,
      ),
    );
  }
}

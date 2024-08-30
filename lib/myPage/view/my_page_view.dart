import 'package:fish_note/login/model/login_model_provider.dart';
import 'package:fish_note/myPage/view/my_page_affiliation.dart';
import 'package:fish_note/myPage/view/my_page_location.dart';
import 'package:fish_note/myPage/view/my_page_species.dart';
import 'package:fish_note/myPage/view/my_page_technique.dart';
import 'package:fish_note/myPage/view/my_page_withdrawal.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../signUp/model/user_information_provider.dart';
import '../components/logout_dialog.dart';

class MyPageView extends StatelessWidget {
  const MyPageView({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return buildLogoutDialog(context);
      },
    );
  }

  Future<void> _launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final userInformationProvider = Provider.of<UserInformationProvider>(context);
    final loginModelProvider = Provider.of<LoginModelProvider>(context);

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
                  _buildUserInfo('이름', loginModelProvider.name),
                  const SizedBox(height: 8),
                  _buildUserInfo('카카오 ID', loginModelProvider.kakaoId),
                  const SizedBox(height: 12),
                  const Divider(color: gray1),
                  const SizedBox(height: 12),
                  _buildSectionTitle('조합 명'),
                  const SizedBox(height: 12),
                  _buildSelectableItem(userInformationProvider.affiliation,
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => const MyPageAffiliation()))),
                  const SizedBox(height: 12),
                  const Divider(color: gray1),
                  const SizedBox(height: 12),
                  _buildSectionTitle('주요 어종'),
                  const SizedBox(height: 12),
                  ...userInformationProvider.species.map((item) => _buildSelectableItem(item,
                      isRemovable: true,
                      onPressed: () =>
                          userInformationProvider.removeSpecies(item, loginModelProvider.kakaoId))),
                  _buildAddItem('어종 추가하기',
                      onPressed: () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => const MyPageSpecies()))),
                  const SizedBox(height: 12),
                  const Divider(color: gray1),
                  const SizedBox(height: 12),
                  _buildSectionTitle('주요 어법'),
                  const SizedBox(height: 12),
                  ...userInformationProvider.technique.map((item) => _buildSelectableItem(item,
                      isRemovable: true,
                      onPressed: () => userInformationProvider.removeTechnique(
                          item, loginModelProvider.kakaoId))),
                  _buildAddItem('어법 추가하기',
                      onPressed: () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => const MyPageTechnique()))),
                  const SizedBox(height: 12),
                  const Divider(color: gray1),
                  const SizedBox(height: 12),
                  _buildSectionTitle('주요 조업 위치'),
                  const SizedBox(height: 12),
                  _buildSelectableItem(userInformationProvider.location.name,
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
                  _buildSimpleItem('서비스 이용약관',
                      onPressed: () => _launchURL(Uri.parse(
                          'https://docs.google.com/document/d/1zfLtufAEKG5JRNrn9b_EuJyxWO8jpw3EIrd2f5bDNEs/edit?usp=sharing'))),
                  const Divider(color: gray1),
                  _buildSimpleItem('개인정보 처리방침',
                      onPressed: () => _launchURL(Uri.parse(
                          'https://docs.google.com/document/d/1PGIXls8ln1CyTLeGe67UePsapXoZfefWrbeYZn-eMKU/edit?usp=sharing'))),
                  const Divider(color: gray1),
                  _buildSimpleItem('위치정보 서비스 이용약관',
                      onPressed: () => _launchURL(Uri.parse(
                          'https://docs.google.com/document/d/1gDxCWqtUtuxF6DIqRmqCzBnFjCt7NPtqWwT-pLVA7cA/edit?usp=sharing'))),
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
      {bool isRemovable = false, bool hasLocationIcon = false, required VoidCallback onPressed}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.only(left: 16, right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: gray3),
      ),
      child: Row(
        children: [
          Expanded(child: Text(title, style: body1())),
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
          else if (!hasLocationIcon)
            TextButton(
              onPressed: onPressed,
              child: Text('수정하기', style: body2(primaryBlue500)),
            ),
        ],
      ),
    );
  }

  Widget _buildAddItem(String title, {required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: gray3),
        ),
        child: Row(
          children: [
            Expanded(child: Text(title, style: body2(gray4))),
            const Icon(Icons.add_circle_outline, color: gray4, size: 24),
          ],
        ),
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

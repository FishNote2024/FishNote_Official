import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../theme/colors.dart';
import '../../theme/font.dart';

class NetWaitCard extends StatefulWidget {
  const NetWaitCard({super.key});

  @override
  State<NetWaitCard> createState() => _NetWaitCardState();
}

class _NetWaitCardState extends State<NetWaitCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 57,
      child: OutlinedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          backgroundColor: primaryBlue500,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        child: Row(
          children: [
            Text('10 일 전', style: header4(Colors.white)),
            const Spacer(),
            Text("하얀부표", style: body1(Colors.white)),
            SizedBox(width: 7),
            SvgPicture.asset('assets/icons/whiteArrow.svg'),
          ],
        ),
      ),
    );
  }
}

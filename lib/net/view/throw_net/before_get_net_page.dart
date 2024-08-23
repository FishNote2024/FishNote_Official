import 'package:fish_note/net/view/throw_net/add_throw_net_page.dart';
import 'package:fish_note/signUp/components/next_button.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:flutter/material.dart';

class BeforeGetNetPage extends StatefulWidget {
  const BeforeGetNetPage({super.key});

  @override
  State<BeforeGetNetPage> createState() => _BeforeGetNetPageState();
}

class _BeforeGetNetPageState extends State<BeforeGetNetPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("hello"),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: OutlinedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddThrowNetPage()),
            );
          },
          child: Text("기록하기", style: header1B(Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue500,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class GetNetNote extends StatefulWidget {
  const GetNetNote({super.key, required this.onNext});
  final VoidCallback onNext;

  @override
  State<GetNetNote> createState() => _GetNetNoteState();
}

class _GetNetNoteState extends State<GetNetNote> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

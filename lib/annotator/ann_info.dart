import 'package:flutter/material.dart';

class AnnInfo extends StatefulWidget {
  const AnnInfo({super.key});

  @override
  State<AnnInfo> createState() => _AnnInfoState();
}

class _AnnInfoState extends State<AnnInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(192, 255, 210, 1),
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text('Annotation Info'),
      ),
      body: const Center(child: Text('Annotation Info')),
    );
  }
}

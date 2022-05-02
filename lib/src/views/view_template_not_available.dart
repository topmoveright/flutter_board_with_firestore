import 'package:flutter/material.dart';

class ViewTemplateNotAvailable extends StatelessWidget {
  const ViewTemplateNotAvailable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alert'),
      ),
      body: const Center(
        child: Text('This device not available!'),
      ),
    );
  }
}

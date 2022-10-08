import 'package:flutter/material.dart';

class BodyWidget extends StatelessWidget {
  const BodyWidget({
    required this.onMenuPressed,
    super.key,
  });

  final void Function() onMenuPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: IconButton(
          icon: const Icon(
            Icons.menu_outlined,
            size: 28,
          ),
          onPressed: onMenuPressed,
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 5),
        itemBuilder: (c, i) => const Card(
          margin: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
        ),
        itemExtent: 200,
        itemCount: 5,
      ),
    );
  }
}

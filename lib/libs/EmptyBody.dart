import 'package:flutter/material.dart';

class EmptyBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Тут пусто 😔',
        style: const TextStyle(fontSize: 26.0, color: Colors.grey),
      ),
    );
  }
}

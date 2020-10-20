import 'package:flutter/material.dart';

class FocusSwitcher {
  final List<FocusNode> _focusNodes;

  FocusSwitcher(int length)
      : _focusNodes =
            List.generate(length, (_) => FocusNode(), growable: false);

  FocusNode getAt(int index) => _focusNodes[index];

  void nextFocusNode(BuildContext context, int currentIndex) {
    if (currentIndex + 1 < _focusNodes.length) {
      _focusNodes[currentIndex].unfocus();
      FocusScope.of(context).requestFocus(_focusNodes[currentIndex + 1]);
    }
  }
}

// instruction
// https://medium.com/flutterpub/flutter-keyboard-actions-and-next-focus-field-3260dc4c694

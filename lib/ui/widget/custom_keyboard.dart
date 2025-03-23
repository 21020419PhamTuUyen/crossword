import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomKeyboard extends StatefulWidget {
  const CustomKeyboard({super.key, this.onTextInput, this.onBackSpace});

  final onTextInput;
  final onBackSpace;

  @override
  State<CustomKeyboard> createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.h,
      color: Colors.grey,
      child: Column(
        children: [
          buildRowOne(),
          buildRowTwo(),
          buildRowThree(),
        ],
      ),
    );
  }

  Expanded buildRowOne() {
    List<String> keys = ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'];
    return Expanded(
      child: Row(
        children: keys.map((key) {
          return TextKey(
            text: key,
            onTextInput: widget.onTextInput,
          );
        }).toList(),
      ),
    );
  }

  Expanded buildRowTwo() {
    List<String> keys = ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ''];

    return Expanded(
      child: Row(
        children: keys.map((key) {
          return TextKey(
            text: key,
            onTextInput: widget.onTextInput,
          );
        }).toList(),
      ),
    );
  }

  Expanded buildRowThree() {
    List<String> keys = ['', 'Z', 'X', 'C', 'V', 'B', 'N', 'M'];

    return Expanded(
      child: Row(
        children: [
          ...keys.map((key) {
            return TextKey(
              text: key,
              onTextInput: widget.onTextInput,
            );
          }),
          BackSpaceKey(
            flex: 2,
            onBackSpace: widget.onBackSpace,
          ),
        ],
      ),
    );
  }
}

class TextKey extends StatefulWidget {
  const TextKey({super.key, required this.text, this.onTextInput, this.flex = 1});

  final String text;
  final onTextInput;
  final int flex;

  @override
  State<TextKey> createState() => _TextKeyState();
}

class _TextKeyState extends State<TextKey> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.flex,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Material(
          color: Colors.grey.shade300,
          child: InkWell(
            onTap: () {
              widget.onTextInput(widget.text);
            },
            child: Center(child: Text(widget.text.toUpperCase())),
          ),
        ),
      ),
    );
  }
}

class BackSpaceKey extends StatefulWidget {
  const BackSpaceKey({super.key, this.flex = 1, this.onBackSpace});

  final onBackSpace;
  final int flex;

  @override
  State<BackSpaceKey> createState() => _BackSpaceKeyState();
}

class _BackSpaceKeyState extends State<BackSpaceKey> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.flex,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Material(
          color: Colors.grey.shade300,
          child: InkWell(
            onTap: () {
              widget.onBackSpace();
            },
            child: const Center(
              child: Icon(Icons.backspace),
            ),
          ),
        ),
      ),
    );
  }
}

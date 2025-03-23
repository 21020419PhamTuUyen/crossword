import 'dart:ui';

import 'package:flutter/material.dart';

import '../../res/images.dart';

class Background extends StatefulWidget {
  const Background({super.key});

  @override
  State<Background> createState() => _Background();
}

class _Background extends State<Background> {


    @override
    Widget build(BuildContext context) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            AppImages.BACKGROUND,
            fit: BoxFit.cover,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Colors.white.withOpacity(0.5), // Màu đen với độ mờ 50%
            ),
          ),
        ],
      );
  }
}
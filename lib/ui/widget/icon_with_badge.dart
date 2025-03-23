import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IconWithBadge extends StatelessWidget {
  final String imagePath;
  final int badgeCount;
  final VoidCallback onPressed;

  IconWithBadge({
    required this.imagePath,
    required this.badgeCount,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: Image.asset(
            imagePath,
            height: 30.h,
            width: 30.w,
          ),
          onPressed: onPressed,
        ),
        if (badgeCount > 0)
          Positioned(
            bottom: 4,
            right:4,
            child: Container(
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: BoxConstraints(
                minWidth: 15.w,
                minHeight: 15.w,
              ),
              child: Center(
                child: Text(
                  '$badgeCount',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
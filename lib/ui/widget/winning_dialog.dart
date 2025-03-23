import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../routes.dart';
import '../../utils/time_counter.dart';

class WinningDialog extends StatefulWidget {
  final int seconds;
  final bool hasNextStage;

  const WinningDialog(
      {super.key, required this.seconds, required this.hasNextStage});

  @override
  State<WinningDialog> createState() => _WinningDialogState();
}

class _WinningDialogState extends State<WinningDialog> {


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
        side: const BorderSide(color: Colors.black, width: 3),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                AppLocalizations.of(context)!.winning,
                style: TextStyle(fontSize: 20.sp, color: Colors.black),
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.yellow, size: 70.w),
                Icon(Icons.star, color: Colors.yellow, size: 70.w),
                Icon(Icons.star, color: Colors.yellow, size: 70.w),
              ],
            ),
            SizedBox(height: 20.h),
            Text(
              "${AppLocalizations.of(context)!.time}: ${formatTime(widget.seconds)}",
              style: TextStyle(fontSize: 16.sp, color: Colors.black),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, Routes.selectStageScreen, (route) => false);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.back_to_list,
                    style: TextStyle(fontSize: 16.sp, color: Colors.black),
                  ),
                ),
                widget.hasNextStage
                    ? TextButton(
                        onPressed: () {
                          Navigator.pop(context, "2");
                        },
                        child: Text(
                          AppLocalizations.of(context)!.next,
                          style:
                              TextStyle(fontSize: 16.sp, color: Colors.black),
                        ),
                      )
                    : SizedBox(
                        width: 16.w,
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

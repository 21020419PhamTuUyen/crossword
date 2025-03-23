import 'package:flutter/material.dart';
import '/localizations.dart';
import '/ui/widget/widget.dart';
import '/utils/common.dart';

class CustomTextLabel extends StatelessWidget {
  final dynamic title;
  final double? fontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign textAlign;
  final int maxLines;
  final double? fontHeight;
  final bool formatCurrency;

  const CustomTextLabel(this.title,
      {Key? key,
      this.fontSize,
      this.fontWeight = FontWeight.normal,
      this.color = Colors.black,
      this.textAlign = TextAlign.start,
      this.maxLines = 50,
      this.fontHeight,
      this.formatCurrency = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO custom font fontFamily
    return LocaleWidget(
      builder: (Language? locale) {
        return Text(
          (formatCurrency
                  ? Common.formatPrice(title ?? "")
                  : locale?.getText(title?.toString() ?? "").trim() ?? title?.toString().trim()) ??
              "",
          textAlign: textAlign,
          overflow: TextOverflow.ellipsis,
          maxLines: maxLines,
          style: TextStyle(
              height: fontHeight ?? 22.27 / 19, fontSize: fontSize ?? 14, fontWeight: fontWeight, color: color),
        );
      },
    );
  }
}

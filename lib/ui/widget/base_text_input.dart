import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/constants.dart';
import '/localizations.dart';
import '/res/colors.dart';
import '/utils/common.dart';
import 'package:intl/intl.dart';

import 'custom_text_label.dart';

typedef CustomTextFieldValidator<T> = String? Function(String value);

class CustomTextInput extends StatefulWidget {
  final onSubmitted;
  final TextInputType keyboardType;
  final String title;
  final TextStyle? titleStyle;
  final int maxLines;
  final TextInputAction? textInputAction;
  final Function? getTextFieldValue;
  final int minLines;
  final bool? obscureText;
  final Function? changeFocus;
  final String hintText;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final initData;
  final double? width;
  final double? heightTextInput;
  final double? fontSize;
  final TextEditingController? textController;

  final FontWeight? fontWeight;
  final TextAlign? align;
  final bool enabled;
  final Color colorBgTextField;
  final Color colorBgTextFieldDisable;
  final hideUnderline;
  final formatNumber;
  final Color colorText;
  final int maxLength;
  final bool formatPercent;
  final bool formatDecimal;
  final bool enableBorder;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool isPasswordTF;
  final bool isDateTimeTF;
  final bool isRequired;
  final bool isElevation;
  final bool formatCurrency;
  final CustomTextFieldValidator? validator;
  final Function? onTapTextField;
  final bool autoFocus;
  final DateTime? firstDate;
  final DateTime? lastDate;

  CustomTextInput(
      {Key? key,
      this.getTextFieldValue,
      this.onSubmitted,
      this.keyboardType = TextInputType.text,
      this.title = "",
      this.maxLines = 1,
      this.textInputAction,
      this.minLines = 1,
      this.obscureText,
      this.changeFocus,
      this.hintText = "",
      this.margin,
      this.padding,
      this.initData,
      this.titleStyle,
      this.width,
      this.heightTextInput,
      this.textController,
      this.fontWeight,
      this.align,
      this.enabled = true,
      this.hideUnderline = false,
      this.colorText = Colors.black,
      this.maxLength = TextField.noMaxLength,
      this.formatPercent = false,
      this.formatDecimal = false,
      this.enableBorder = false,
      this.suffixIcon,
      this.prefixIcon,
      this.isPasswordTF = false,
      this.isDateTimeTF = false,
      this.isRequired = false,
      this.isElevation = false,
      this.colorBgTextField = AppColors.white,
      this.colorBgTextFieldDisable = AppColors.disable,
      this.formatCurrency = false,
      this.formatNumber = false,
      this.validator,
      this.onTapTextField,
      this.autoFocus = false,
      this.firstDate,
      this.fontSize,
      this.lastDate})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TextFieldState();
  }
}

class TextFieldState extends State<CustomTextInput> {
  bool _showText = true;
  late List<TextInputFormatter> inputFormatters;
  String errorText = '';
  late TextEditingController textController;
  DateTime? firstDate;
  DateTime? lastDate;

  @override
  void initState() {
    firstDate = widget.firstDate;
    lastDate = widget.lastDate;
    super.initState();
    textController = widget.textController ?? TextEditingController();
    if (widget.initData != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        textController.text =
            widget.formatCurrency ? Common.formatPrice(widget.initData, showPrefix: false) : widget.initData.toString();
      });
    }
    if (widget.formatNumber || widget.formatCurrency || widget.formatPercent) {
      inputFormatters = [NumericTextFormatter(widget.formatCurrency, widget.formatPercent)];
    } else if (widget.formatDecimal) {
      inputFormatters = [DecimalTextInputFormatter(decimalRange: 5)];
    } else {
      inputFormatters = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: widget.height ?? double.infinity,
      width: widget.width ?? double.infinity,
      margin: widget.margin ?? EdgeInsets.zero,
      child: Wrap(
        children: [
          (widget.isElevation == false)
              ? Container(
                  padding: EdgeInsets.only(bottom: 5),
                  child: CustomTextLabel(
                    widget.title,
                    color: AppColors.ff828282,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                )
              : Container(),
          Container(
            height: widget.heightTextInput,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: widget.enabled ? widget.colorBgTextField : widget.colorBgTextFieldDisable,
                borderRadius: BorderRadius.circular(widget.enabled ? 5 : 0)),
            child: Stack(
              children: [
                TextField(
                  inputFormatters: inputFormatters,
                  maxLength: widget.maxLength,
                  cursorColor: AppColors.base_color,
                  autofocus: widget.autoFocus,
                  enabled: widget.enabled,
                  textAlign: widget.align ?? TextAlign.start,
                  textAlignVertical: TextAlignVertical.center,
                  style: TextStyle(
                      color: widget.colorText,
                      fontSize: widget.fontSize ?? 15,
                      fontWeight: widget.fontWeight ?? FontWeight.w400),
                  decoration: InputDecoration(
                      counterText: "",
                      suffixIcon: (widget.isPasswordTF == true)
                          ? IconButton(
                              icon: Icon(!_showText ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                              onPressed: () {
                                setState(() {
                                  _showText = !_showText;
                                });
                              },
                            )
                          : (widget.isDateTimeTF == true)
                              ? IconButton(
                                  onPressed: () {
                                    chooseDay(context);
                                  },
                                  icon: Icon(
                                    Icons.calendar_today,
                                    size: 15,
                                  ))
                              : (widget.onTapTextField != null)
                                  ? IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        size: 15,
                                      ))
                                  : widget.suffixIcon,
                      prefixIcon: widget.prefixIcon,
                      focusColor: Colors.white,
                      border: InputBorder.none,
                      suffixIconConstraints: BoxConstraints(maxHeight: 35),
                      prefixIconConstraints: BoxConstraints(maxHeight: 35),
                      disabledBorder: widget.hideUnderline
                          ? (widget.enableBorder
                              ? const OutlineInputBorder(borderSide: BorderSide(color: AppColors.border))
                              : InputBorder.none)
                          : const UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.base_color_border_textfield, width: 1),
                            ),
                      focusedBorder: widget.hideUnderline
                          ? (widget.enableBorder
                              ? OutlineInputBorder(borderSide: BorderSide(color: AppColors.border))
                              : InputBorder.none)
                          : const UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.base_color, width: 1),
                            ),
                      enabledBorder: widget.hideUnderline
                          ? (widget.enableBorder
                              ? OutlineInputBorder(borderSide: BorderSide(color: AppColors.border))
                              : InputBorder.none)
                          : const UnderlineInputBorder(
                              borderSide: BorderSide(color: AppColors.base_color_border_textfield, width: 1),
                            ),
                      hintStyle: TextStyle(color: AppColors.ffBDBDBD, fontWeight: FontWeight.w400, fontSize: 15),
                      hintText: Language.of(context)?.getText.call(widget.hintText),
                      isDense: true,
                      // and add this line
                      contentPadding: widget.padding ??
                          EdgeInsets.symmetric(horizontal: widget.hideUnderline == false ? 0 : 10, vertical: 10)),
                  controller: textController,
                  obscureText: widget.obscureText == null ? _showText : widget.obscureText!,
                  keyboardType: widget.formatCurrency ? TextInputType.number : widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  onSubmitted: widget.onSubmitted,
                  onEditingComplete: () => FocusScope.of(context).nextFocus(),
                  maxLines: widget.maxLines,
                  minLines: widget.minLines,
                  onTap: () {
                    if (textController.text == '0') {
                      textController.selection =
                          TextSelection.fromPosition(TextPosition(offset: textController.text.length));
                    }
                  },
                  onChanged: (String _text) {
                    _validate();
                    String currentText = _text.trim();
                    widget.getTextFieldValue?.call(currentText);
                  },
                ),
                if (widget.isDateTimeTF)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: InkWell(
                      onTap: () {
                        if (this.widget.enabled) chooseDay(context);
                      },
                      child: Container(),
                    ),
                  ),
                widget.onTapTextField != null
                    ? Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: InkWell(
                          onTap: () {
                            if (this.widget.enabled) widget.onTapTextField?.call();
                          },
                          child: Container(),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          errorText.isNotEmpty
              ? Container(
                  margin: EdgeInsets.only(top: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.error,
                        size: 13,
                        color: Colors.red,
                      ),
                      SizedBox(width: 2),
                      Expanded(
                        child: CustomTextLabel(
                          errorText,
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  String getText(DateTime dateTime) {
    return Common.datetimeToSting(dateTime);
  }

  Future chooseDay(BuildContext context) async {
    DateTime initDate = Common.parserDate(value, format: FormatDate.dayMonthYear) ?? DateTime.now();
    DateTime firstDate = this.firstDate ?? DateTime(DateTime.now().year - 50);
    DateTime lastDate = this.lastDate ?? DateTime(DateTime.now().year + 50);
    if (initDate.isBefore(firstDate)) {
      initDate = firstDate;
    }
    if (initDate.isAfter(lastDate)) {
      initDate = lastDate;
    }

    var newDate =
        await showDatePicker(context: context, initialDate: initDate, firstDate: firstDate, lastDate: lastDate);
    if (newDate == null) return;
    textController.text = getText(newDate);
    widget.getTextFieldValue?.call(value);
  }

  bool get isValid => _validate();

  String get value => textController.text.trim();

  bool _validate() {
    if (widget.validator != null) {
      String _text = textController.text.trim();
      String? validate = widget.validator!.call(_text);
      setState(() {
        this.errorText = validate ?? "";
      });
      return this.errorText.isEmpty;
    }
    return true;
  }
}

class NumericTextFormatter extends TextInputFormatter {
  final bool isFormatCurrency;
  final bool isFormatPercent;

  NumericTextFormatter(this.isFormatCurrency, this.isFormatPercent);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text.compareTo(oldValue.text) != 0) {
      if (oldValue.text == '0' && newValue.text == '00') {
        return oldValue;
      }

      if (oldValue.text.length < newValue.text.length) {
        String s = newValue.text.substring(newValue.selection.baseOffset - 1, newValue.selection.baseOffset);
        if (!RegExp("^[0-9]").hasMatch(s)) return oldValue;
      }

      if (isFormatPercent) {
        if ((oldValue.text == "100" && newValue.text.length > 3) ||
            '.'.allMatches(newValue.text).length > 1 ||
            double.parse(newValue.text) > 100 ||
            newValue.text[0] == "." ||
            (newValue.text.length > 1 && newValue.text[0] == "0" && newValue.text[1] != ".") ||
            newValue.text.split(".").length > 1 && newValue.text.split(".")[1].length > 2) {
          return oldValue;
        } else {
          return newValue;
        }
      }

      final int selectionIndexFromTheRight = newValue.text.length - newValue.selection.end;
      final f = isFormatCurrency ? NumberFormat("#,###") : NumberFormat('#');
      final number = int.parse(newValue.text.replaceAll(f.symbols.GROUP_SEP, ''));
      final newString = f.format(number);
      return TextEditingValue(
        text: newString,
        selection: TextSelection.collapsed(offset: newString.length - selectionIndexFromTheRight),
      );
    } else {
      return oldValue;
    }
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange}) : assert(decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    if (newValue.text.contains(' '))
      return TextEditingValue(
        text: oldValue.text,
        selection: oldValue.selection,
        composing: TextRange.empty,
      );

    if (oldValue.text == '0') {
      truncated = newValue.text.replaceFirst('0', '');
      if (!RegExp("^[0-9]").hasMatch(truncated)) {
        truncated = newValue.text;
      } else {
        newSelection = newValue.selection.copyWith(
          baseOffset: 1,
          extentOffset: 1,
        );
      }
      return TextEditingValue(
        text: truncated,
        selection: newSelection,
        composing: TextRange.empty,
      );
    }

    if (truncated.length > oldValue.text.length && newValue.text.substring(0, 1) == '0' && oldValue.text.length > 1) {
      if (!(newValue.text.length > 2 && newValue.text.substring(0, 2) == '0.')) {
        truncated = oldValue.text;
        newSelection = oldValue.selection;
        return TextEditingValue(
          text: truncated,
          selection: newSelection,
          composing: TextRange.empty,
        );
      }
    }

    String value = newValue.text;
    if (value.contains(".") && value.substring(value.indexOf(".") + 1).length > decimalRange) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    } else if (value == ".") {
      truncated = "0.";

      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(truncated.length, truncated.length + 1),
        extentOffset: math.min(truncated.length, truncated.length + 1),
      );
    }

    return TextEditingValue(
      text: truncated,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}

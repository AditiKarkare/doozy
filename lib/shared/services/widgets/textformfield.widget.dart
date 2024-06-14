import 'package:doozy/shared/core/repositries/provider.dart';
import 'package:doozy/shared/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

Widget roundedTextFormField(BuildContext context,
    {bool enabled = true,
    autovalidateMode,
    // double? borderRadius,
    bool readOnly = false,
    InputDecoration? decoration,
    bool setBorderColorRed = false,
    TextStyle? hintstyle,
    bool obscureText = false,
    TextInputType? keyboardType = TextInputType.text,
    TextInputAction? textInputAction = TextInputAction.next,
    Widget? prefix,
    Widget? suffixIcon,
    Widget? suffix,
    TextEditingController? controller,
    void Function()? onEditingComplete,
    void Function(String? value)? onChanged,
    void Function()? onTap,
    void Function(String? value)? onSaved,
    void Function(String? value)? onFieldSubmitted,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int? maxLength,
    int? maxLines,
    String? labelText,
    String? hintText,
    double? cursorHeight,
    double? width,
    String? initialValue,
    Color? fillColor,
    bool? filled = true,
    FocusNode? focusNode,
    EdgeInsetsGeometry? contentPadding,
    bool isRequired = false,
    double? borderRadius}) {
  return SizedBox(
    width: width,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 15,
        ),
        Visibility(
            visible: labelText != null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text.rich(TextSpan(
                  text: labelText,
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                  children: <InlineSpan>[
                    TextSpan(
                      text: isRequired ? '*' : "",
                      style: TextStyle(color: Utils.redColor, fontSize: 16.sp),
                    )
                  ],
                )),
                const SizedBox(
                  height: 10,
                )
              ],
            )),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            boxShadow: [Utils.commonBoxShadow],
          ),
          child: TextFormField(
            cursorColor: Theme.of(context).primaryColor,
            cursorHeight: cursorHeight,
            autofocus: true,
            keyboardType: keyboardType,
            focusNode: focusNode,

            decoration: InputDecoration(
                contentPadding: contentPadding ??
                    EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.w),
                errorStyle: TextStyle(fontSize: 10.sp),
                labelStyle: const TextStyle(color: Colors.grey),
                counterText: "",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(borderRadius ?? 100.r)),
                    borderSide: const BorderSide(
                        width: 0, style: BorderStyle.solid, color: Colors.red)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                        Radius.circular(borderRadius ?? 100.r)),
                    borderSide: const BorderSide(
                        width: 1,
                        style: BorderStyle.solid,
                        color: Colors.black)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: setBorderColorRed ? Colors.red : Colors.black,
                        width: 1.w),
                    borderRadius: BorderRadius.all(
                        Radius.circular(borderRadius ?? 100.r))),
                hintText: hintText,
                hintStyle: hintstyle ??
                    TextStyle(
                        color: setBorderColorRed
                            ? Colors.red
                            : const Color(0xff8f9bb3),
                        fontSize: 14.sp),
                prefixIcon: prefix,
                filled: filled,
                fillColor: fillColor ?? Colors.white,
                suffixIcon: suffixIcon,
                suffixStyle: const TextStyle(color: Color(0xff90c03e))),

            onChanged: onChanged,
            // --- validate + control
            controller: controller,
            validator: validator,
            textInputAction: textInputAction,
            readOnly: readOnly,
            //-------------------
            enabled: enabled,
            obscureText:
                Utils.isNullEmptyOrFalse(obscureText) ? false : obscureText,
            onEditingComplete: onEditingComplete,
            onSaved: onSaved,
            onTap: onTap,
            initialValue: initialValue,
            inputFormatters: inputFormatters,
            onFieldSubmitted: onFieldSubmitted,

            maxLength: maxLength,
            maxLines: maxLines,
          ),
        ),
      ],
    ),
  );
}

//
Widget upiIdroundedTextFormField(BuildContext context,
    {bool enabled = true,
    autovalidateMode,
    // double? borderRadius,
    bool readOnly = false,
    InputDecoration? decoration,
    bool setBorderColorRed = false,
    TextStyle? hintstyle,
    bool obscureText = false,
    TextInputType? keyboardType = TextInputType.text,
    TextInputAction? textInputAction = TextInputAction.next,
    Widget? prefix,
    Widget? suffixIcon,
    Widget? suffix,
    TextEditingController? controller,
    void Function()? onEditingComplete,
    void Function(String? value)? onChanged,
    void Function()? onTap,
    void Function(String? value)? onSaved,
    void Function(String? value)? onFieldSubmitted,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int? maxLength,
    int? maxLines,
    String? labelText,
    String? hintText,
    double? cursorHeight,
    double? width,
    String? initialValue,
    Color? fillColor,
    bool? filled = true,
    FocusNode? focusNode,
    EdgeInsetsGeometry? contentPadding,
    bool isRequired = false,
    double? borderRadius}) {
  return Consumer<ManualProductProvider>(builder: (context, manPro, child) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 15,
          ),
          Visibility(
              visible: labelText != null,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text.rich(TextSpan(
                    text: labelText,
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                    children: <InlineSpan>[
                      TextSpan(
                        text: isRequired ? '*' : "",
                        style:
                            TextStyle(color: Utils.redColor, fontSize: 16.sp),
                      )
                    ],
                  )),
                  const SizedBox(
                    height: 10,
                  )
                ],
              )),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              boxShadow: [Utils.commonBoxShadow],
            ),
            child: TextFormField(
              cursorColor: Theme.of(context).primaryColor,
              cursorHeight: cursorHeight,
              autofocus: true,
              keyboardType: keyboardType,
              focusNode: focusNode,

              decoration: InputDecoration(
                  contentPadding: contentPadding ??
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.w),
                  errorStyle: TextStyle(fontSize: 10.sp),
                  labelStyle: const TextStyle(color: Colors.grey),
                  counterText: "",
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(borderRadius ?? 100.r)),
                      borderSide: BorderSide(
                          width: 1,
                          style: BorderStyle.solid,
                          color: manPro.isUpiValid == false
                              ? manPro.upiColor
                              : Colors.transparent)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(borderRadius ?? 100.r)),
                      borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.solid,
                          color: manPro.isUpiValid == false
                              ? manPro.upiColor
                              : Colors.transparent)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(borderRadius ?? 100.r)),
                      borderSide: BorderSide(
                          width: 1,
                          style: BorderStyle.solid,
                          color: manPro.isUpiValid == false
                              ? manPro.upiColor
                              : Colors.transparent)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: manPro.isUpiValid == false ? manPro.upiColor : Colors.transparent,
                          width: 1.w),
                      borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 100.r))),
                  hintText: hintText,
                  hintStyle: hintstyle ?? TextStyle(color: setBorderColorRed ? Colors.red : const Color(0xff8f9bb3), fontSize: 14.sp),
                  prefixIcon: prefix,
                  filled: filled,
                  fillColor: fillColor ?? Colors.white,
                  suffixIcon: suffixIcon,
                  suffixStyle: const TextStyle(color: Color(0xff90c03e))),

              onChanged: onChanged,
              // --- validate + control
              controller: controller,
              validator: validator,
              textInputAction: textInputAction,
              readOnly: readOnly,
              //-------------------
              enabled: enabled,
              obscureText:
                  Utils.isNullEmptyOrFalse(obscureText) ? false : obscureText,
              onEditingComplete: onEditingComplete,
              onSaved: onSaved,
              onTap: onTap,
              initialValue: initialValue,
              inputFormatters: inputFormatters,
              onFieldSubmitted: onFieldSubmitted,

              maxLength: maxLength,
              maxLines: maxLines,
            ),
          ),
        ],
      ),
    );
  });
}

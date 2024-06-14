import 'package:auto_size_text/auto_size_text.dart';
import 'package:doozy/shared/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'argon.btn.dart';
import 'dart:async';

// ignore: depend_on_referenced_packages

class AnimateBtn extends StatelessWidget {
  final String text;
  final Color? btnColor;
  final bool isNormalBtn;
  final bool isEnabled;
  double? height;
  final Widget? icon;

  final Function(
          Function startLoading, Function stopLoading, ButtonState btnState)
      function;

  AnimateBtn(
      {super.key,
      required this.text,
      required this.function,
      this.btnColor,
      this.height,
      this.isEnabled = true,
      this.isNormalBtn = true,
      this.icon});

  Future<void> share() async {}

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ArgonButton(
      elevation: 0,
      // width: width,
      roundLoadingShape: false,

      width: MediaQuery.of(context).size.width * 0.4,

      height: height ?? 40.h,
      color: isEnabled ? btnColor ?? Utils.primaryGreenColor : Utils.greyColor,
      borderRadius: 100.r,
      onTap: isEnabled ? function : (startLoading, stopLoading, btnState) {},
      loader: Container(
        padding: EdgeInsets.all(10.w),
        child: const SpinKitDoubleBounce(
          color: Colors.white,
          // size: 10,
        ),
      ),
      child: isNormalBtn
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                    visible: icon != null,
                    child: Row(
                      children: [
                        icon ?? const SizedBox.shrink(),
                        SizedBox(width: 8.w)
                      ],
                    )),
                Text(
                  text,
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      // fontFamily: "Typo Round",
                      color: Colors.white),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.w),
                    child: AutoSizeText(
                      text,
                      presetFontSizes: const [17, 16, 15, 14, 13, 12, 11, 10],
                      maxLines: 1,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                          // fontFamily: "Typo Round",
                          color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  width: 8.w,
                ),
                GestureDetector(
                  onTap: share,
                  child: SvgPicture.asset(
                    "assets/svg/chat_out.svg",
                    width: 20.w,
                    height: 20.w,
                    color: Colors.white,
                  ),
                )
              ],
            ),
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBarShared {
  static AppBar appBarStyle(BuildContext context, String title,
      {bool showLeading = true,
      List<Widget>? action,
      bool? showFilter,
      Function()? onCalenadarIconPress,
      PreferredSizeWidget? bottom,
      double? toolbarHeight,
      Widget? titleWidget,
      FontWeight? fontWeight,
      bool centerTitle = true,
      Color titleColor = Colors.black,
      Function()? backClickFn}) {
    return AppBar(
      centerTitle: centerTitle,
      titleSpacing: 0.0,
      automaticallyImplyLeading: false,
      elevation: 4,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.white,
      actions: action,
      toolbarHeight: toolbarHeight,
      title: titleWidget ??
          Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: 18,
              fontWeight: fontWeight,
            ),
          ),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      leading: showLeading
          ? InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: backClickFn ??
                  () {
                    Navigator.pop(context);
                  },
              child: Padding(
                  padding: EdgeInsets.all(11.w),
                  child: const Icon(Icons.arrow_back)
                  // Image.asset(
                  //   "assets/png/backbtn.png",
                  //   color: Utils.primaryGreenColor,
                  // )

                  ))
          : null,
      bottom: bottom,
    );
  }
}

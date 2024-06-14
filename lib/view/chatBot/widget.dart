import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget chatTile({
  Key? key,
  required Widget child,
}) {
  return Container(
    margin: EdgeInsets.only(left: 20, right: 20, bottom: 8.h),
    child: Align(
      alignment: Alignment.topLeft,
      child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20)),
            color: Colors.white,
          ),
          child: child),
    ),
  );
}

Widget userChatTile({required Widget child}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 8.h),
        child: Align(
          alignment: Alignment.topLeft,
          child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20)),
                color: Colors.white,
              ),
              child: child),
        ),
      ),
    ],
  );
}

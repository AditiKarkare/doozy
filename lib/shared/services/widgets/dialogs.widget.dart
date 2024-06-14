import 'package:doozy/shared/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<Widget?> okDialog(BuildContext context, String message,
    {Function()? onPressed}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.r))),
          title: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: const AssetImage("assets/png/chotuAI.png"),
                  height: 50.w,
                  width: 150.0,
                  fit: BoxFit.fill,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, bottom: 15.0),
                  child: Text(
                    message,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp),
                    textAlign: TextAlign.center,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    if (onPressed != null) {
                      onPressed();
                    }
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.w, vertical: 15.w),
                    decoration: BoxDecoration(
                        color: Utils.primaryGreenColor,
                        borderRadius: BorderRadius.circular(16.r)),
                    child: Text(
                      "Okay",
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

confirmDialog(BuildContext context, String message, Function()? callback,
    String confirm, String back) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: Center(
          child: Column(
            children: <Widget>[
              const Image(
                image: AssetImage("assets/png/chotuAI.png"),
                height: 90.0,
                width: 150.0,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text(
                  message.toString(),
                  style: const TextStyle(
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.normal,
                      fontSize: 16.0),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Flexible(
                    child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                    Utils.primaryPinkColor)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              back,
                              style: const TextStyle(color: Colors.white),
                            ))),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Flexible(
                    child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(
                                    Utils.primaryGreenColor)),
                            onPressed: callback,
                            child: Text(confirm,
                                style: const TextStyle(color: Colors.white)))),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

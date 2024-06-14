import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomToast extends StatefulWidget {
  final String message;

  const CustomToast({super.key, required this.message});

  @override
  _CustomToastState createState() => _CustomToastState();
}

class _CustomToastState extends State<CustomToast>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
    Future.delayed(const Duration(seconds: 2), () {
      _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.w),
          alignment: Alignment.center,
          child: Row(
            children: [
              SvgPicture.asset(
                "assets/svg/chotuAi.svg",
                width: 40.w,
              ),
              SizedBox(
                width: 10.w,
              ),
              Flexible(
                child: Text(
                  widget.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

void showToast(BuildContext context, String message) {
  Widget toast = CustomToast(message: message);
  OverlayEntry entry = OverlayEntry(
    builder: (BuildContext context) => Positioned(
      bottom: MediaQuery.of(context).size.height * 0.1,
      left: MediaQuery.of(context).size.width * 0.1,
      right: MediaQuery.of(context).size.width * 0.1,
      child: toast,
    ),
  );
  Overlay.of(context).insert(entry);
  Future.delayed(const Duration(seconds: 8), () {
    entry.remove();
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManualTextCardWidget extends StatelessWidget {
  final String text;
  const ManualTextCardWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.w),
      child: Text(text),
    );
  }
}

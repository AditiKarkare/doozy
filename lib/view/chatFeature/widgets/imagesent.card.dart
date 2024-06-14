import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';

class ImageSentCardWidget extends StatefulWidget {
  final String imageLink;
  const ImageSentCardWidget({super.key, required this.imageLink});

  @override
  State<ImageSentCardWidget> createState() => _ImageSentCardWidgetState();
}

class _ImageSentCardWidgetState extends State<ImageSentCardWidget> {
  TextEditingController img = TextEditingController();

  setData() {
    img.text = widget.imageLink;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    Uint8List bytes = base64Decode(img.text);
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: PhotoView(
                imageProvider: MemoryImage(bytes),
                backgroundDecoration:
                    const BoxDecoration(color: Colors.transparent),
              ),
            ),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Image.memory(
            bytes,
            height: 150.h,
            // width: 200.w,
          ),
        ),
      ),
    );
  }
}

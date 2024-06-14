import 'dart:convert';
import 'dart:typed_data';
import 'package:doozy/view/chatFeature/widgets/viewPdf.page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PdfSentCardWidget extends StatefulWidget {
  final String pdfLink;
  const PdfSentCardWidget({super.key, required this.pdfLink});

  @override
  State<PdfSentCardWidget> createState() => _PdfSentCardWidgetState();
}

class _PdfSentCardWidgetState extends State<PdfSentCardWidget> {
  String path = "";
  // Future<File> createFileFromBase64(String base64Str) async {
  //   final decodedBytes = base64.decode(base64Str);
  //   final directory = await getApplicationDocumentsDirectory();
  //   final file = File('${directory.path}/temp.pdf');
  //   await file.writeAsBytes(decodedBytes);
  //   return file;
  // }
  Future<Uint8List> createFileFromBase64(String base64Str) async {
    final decodedBytes = base64.decode(base64Str);
    return decodedBytes;
    // final directory = await getApplicationDocumentsDirectory();
    // final file = File('${directory.path}/temp.pdf');
    // await file.writeAsBytes(decodedBytes);
    // return file;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        Uint8List decodedBytes = await createFileFromBase64(widget.pdfLink);
        setState(() {});

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ViewPdfPageWidget(decodedBytes: decodedBytes)));
      },
      child: Padding(
          padding: EdgeInsets.all(10.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/png/pdf.png",
                width: 30.w,
                height: 30.w,
              ),
              SizedBox(
                width: 5.w,
              ),
              const Text("View")
            ],
          )),
    );
  }
}

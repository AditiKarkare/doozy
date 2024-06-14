import 'dart:typed_data';
import 'package:doozy/shared/services/widgets/appbar.widget.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewPdfPageWidget extends StatefulWidget {
  // final String path;
  final Uint8List decodedBytes;
  const ViewPdfPageWidget({super.key, required this.decodedBytes});

  @override
  State<ViewPdfPageWidget> createState() => _ViewPdfPageWidgetState();
}

class _ViewPdfPageWidgetState extends State<ViewPdfPageWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarShared.appBarStyle(context, ""),
        body: SfPdfViewer.memory(widget.decodedBytes));
  }
}

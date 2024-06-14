import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

class Utils {
  //Colors
  static Color redColor = const Color(0xffE72929);
  static Color greyColor = Colors.grey;
  static Color subtitleColor = const Color(0xff717171);
  static Color linkColor = const Color(0xff3A008A);
  static Color primaryPinkColor = const Color(0xffE03D9A);
  static Color primaryGreenColor = const Color(0xff45C654);
  static BoxShadow commonBoxShadow = const BoxShadow(
      color: Color(0x3C9E9E9E),
      blurRadius: 9,
      spreadRadius: 2,
      offset: Offset(0, 2));
  static BoxShadow commonBoxShadow1 = const BoxShadow(
      color: Color.fromARGB(255, 70, 81, 80),
      offset: Offset(0, 2),
      blurRadius: 10,
      spreadRadius: 2);
  static BoxShadow commonBoxShadow2 = const BoxShadow(
      color: Color(0x2AC7C1C1),
      blurRadius: 9,
      spreadRadius: 2,
      offset: Offset(0, 6));

  static String? firebaseToken = '';

  static bool isNullEmptyOrFalse(Object? o) {
    return o == null ||
        o == "0.0" ||
        o == "0" ||
        o == 0 ||
        false == o ||
        "" == o ||
        "null" == o ||
        "false" == o;
  }

  static bool isNotNullEmptyOrFalse(Object? o) {
    return !isNullEmptyOrFalse(o);
  }

  static Future<DateTime?> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now().add(const Duration(hours: 24)),
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now().add(const Duration(hours: 24)),
        lastDate: DateTime(2101));
    return picked;
  }

  static Future<TimeOfDay?> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (ctx, child) {
          return MediaQuery(
              data: MediaQuery.of(ctx).copyWith(alwaysUse24HourFormat: false),
              child: child!);
        });

    return picked;
  }

  //
  static String numberFormatter(double value) {
    double value0 = value;
    String finalValue = value0.toString();

    return finalValue;
  }

  static formatTimeStamp(String format, String time) {
    if (time != "") {
      return DateFormat.jm().format(DateTime.parse(time).toLocal()).toString();
    } else {
      return "N/A";
    }
  }

  static formatdateStamp(String format, String time) {
    if (time != "") {
      return DateFormat(format).format(DateTime.parse(time)).toString();
    } else {
      return "N/A";
    }
  }

  static Widget networkImage(
      {required String imageUrl,
      String notFoundImg =
          "https://png.pngtree.com/png-vector/20190820/ourmid/pngtree-no-image-vector-illustration-isolated-png-image_1694547.jpg",
      BoxFit fit = BoxFit.cover,
      Widget? errorWidget,
      double? width,
      double? height}) {
    return CachedNetworkImage(
        fit: fit,
        httpHeaders: getTokenHeaders(),
        imageUrl: isNotNullEmptyOrFalse(imageUrl) ? imageUrl : notFoundImg,
        errorWidget: (context, url, error) => Image.asset(
              "assets/image/squareLogo.png",
              width: 48,
              height: 48,
              fit: BoxFit.cover,
            ),
        // imageBuilder: (context, imageProvider) {},
        placeholder: (context, url) => Center(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).primaryColor,
                ))),
        height: height,
        width: width);
    // : Image.asset(
    //     "assets/images/error/Group 2088.png",
    //     height: height,
    //     width: width,
    //     fit: fit,
    //   );
  }

  static Widget networkImageNoCached(
      {required String? imageUrl,
      BoxFit fit = BoxFit.cover,
      String notFoundImg =
          "https://png.pngtree.com/png-vector/20190820/ourmid/pngtree-no-image-vector-illustration-isolated-png-image_1694547.jpg",
      Widget? errorWidget,
      double? width,
      double? height}) {
    return Image.network(
      imageUrl ?? notFoundImg,
      headers: getTokenHeaders(),
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          decoration: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          width: 200,
          height: 200,
          child: Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
      errorBuilder: (context, object, stackTrace) {
        return Material(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          clipBehavior: Clip.hardEdge,
          child: errorWidget ??
              Image.asset(
                'assets/png/noFound.png',
                // width: 100,
                // height: 200,
                fit: BoxFit.cover,
              ),
        );
      },
      width: width,
      height: height,
      fit: fit,
    );
  }

  static Future<String> downloadPath() async {
    Directory? downloadsDirectory;
    String downloadsPath = "";
    if (Platform.isAndroid) {
      downloadsDirectory = Directory('/storage/emulated/0/Download/doozy');
    } else if (Platform.isIOS) {
      Directory downloadIos = await getApplicationSupportDirectory();
      downloadsDirectory = Directory("${downloadIos.path}/doozy");
    }

    if (downloadsDirectory != null && !await downloadsDirectory.exists()) {
      await downloadsDirectory.create(recursive: true);
    }
    if (downloadsDirectory != null) {
      downloadsPath = downloadsDirectory.path;
    }
    return downloadsPath;
  }

  hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  showKeyboard(BuildContext context, FocusNode? node) {
    FocusScope.of(context).requestFocus(node);
  }

  static int registerIndex = 1;

  // static Moment moment = Moment.now();

  static int? userId;

  //--Oodle profile type
  static int profiletype = 0;
  //

  // ---- chat
  static List<String> imageAllowed = ["jpg", "jpeg", "png"];
  static List<String> documentAllowed = ["doc", "docx", "pdf"];

  static bool loggedIn = false;

  // static UserModels? userModels;

  //------
  static String privacyPolicy = "https://castingmunch.com/privacy-policy.php";
  static String tnc = "https://castingmunch.com/terms.php";
  static String refundPolicy = "https://castingmunch.com/refund-policy.php";
  static String aboutUs = "https://castingmunch.com/index.php#about";
  static String faq = "https://cloudage.co.in/cgs-app-faq/";
  static String? token = "";

  //--------
  static String sirNumber = "918793385422";
  //
  static int level = 0;
  //
  static Map<String, String> getTokenHeaders() {
    Map<String, String> headers = {};
    headers['Authorization'] = "Bearer $token";
    // headers['content-type'] = contentType;
    return headers;
  }

  //
}

class ListOfFiltersAndSort {
  List<int> skills = [];
  List<int> levels = [];
  List<int> status = [];
  List<int> interviewDateSort = [];
  List<int> interviewTimeSort = [];
  List<int> levelSort = [];
}

class PageResponseModel<P> {
  List<P>? data;
  int? total;
  int? count;
  int? page;
  int? pageCount;
}

// -- CUSTOM PARAMS--

//
class ApiResponse1 {
  int? responseCode;
  String? message;
}

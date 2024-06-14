// ignore_for_file: use_build_context_synchronously

import 'package:doozy/shared/core/repositries/provider.dart';
import 'package:doozy/shared/services/textInputFormatters.dart';
import 'package:doozy/shared/utils/constants.dart';
import 'package:doozy/shared/services/widgets/animateBtn.widget.dart';
import 'package:doozy/shared/services/widgets/appbar.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:provider/provider.dart';

class OtpPage extends StatefulWidget {
  final String phoneNumber;
  const OtpPage({super.key, required this.phoneNumber});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  GlobalKey<FormState> key = GlobalKey<FormState>();
  TextEditingController pinController = TextEditingController();
  FocusNode focusNode = FocusNode();
  String obscurePhoneNum = "";
  setObscureNum() async {
    obscurePhoneNum = await obscurePhoneNumber(widget.phoneNumber);
    setState(() {});
  }

  @override
  void initState() {
    setObscureNum();
    super.initState();
  }

  @override
  void dispose() {
    pinController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProvider>(builder: (context, pro, child) {
      return pro.appLangLoading == true
          ? Scaffold(
              body: (pro.appLangCode == "en"
                  ? Center(child: englishLoading())
                  : pro.appLangCode == "mr"
                      ? Center(child: marathiLoading())
                      : Center(child: hindiLoading())))
          : (Scaffold(
              appBar: AppBarShared.appBarStyle(context, "", showLeading: false),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pro.appTlLanguage.isNotEmpty
                          ? pro.appTlLanguage[32]
                          : "Verify OTP",
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w500),
                    ),
                    Row(
                      children: [
                        Text(
                          pro.appTlLanguage.isNotEmpty
                              ? "${pro.appTlLanguage[32]} $obscurePhoneNum"
                              : "Enter the OTP sent to $obscurePhoneNum",
                          style: TextStyle(
                              fontSize: 12.sp, color: Utils.subtitleColor),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            pro.appTlLanguage.isNotEmpty
                                ? pro.appTlLanguage[34]
                                : "Edit Number",
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: Utils.linkColor,
                                decoration: TextDecoration.underline),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: PinCodeTextField(
                        maxLength: 6,
                        pinBoxWidth: 45,
                        pinBoxHeight: 45,
                        controller: pinController,
                        pinBoxBorderWidth: 0.8,
                        pinBoxRadius: 10,
                        focusNode: focusNode,
                        pinTextStyle: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                        defaultBorderColor: Colors.black,
                        pinBoxColor: Colors.white,
                        highlight: true,
                        hasTextBorderColor: Colors.grey,
                        pinBoxOuterPadding:
                            const EdgeInsets.symmetric(horizontal: 5),
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    ),
                    AnimateBtn(
                      text: pro.appTlLanguage.isNotEmpty
                          ? pro.appTlLanguage[32]
                          : "Verify OTP",
                      function: (startLoading, stopLoading, btnState) async {
                        pro.verifyOtpFunc(
                            token: pinController.text,
                            phone: widget.phoneNumber,
                            context: context,
                            startLoading: startLoading,
                            stopLoading: stopLoading);
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          pro.appTlLanguage.isNotEmpty
                              ? pro.appTlLanguage[35]
                              : "Didn't receive the OTP?",
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.w500),
                        ),
                        TextButton(
                          onPressed: () {
                            pro.resendOtpEventFunc(phone: widget.phoneNumber);
                          },
                          child: Text(
                            pro.appTlLanguage.isNotEmpty
                                ? pro.appTlLanguage[36]
                                : "Resend",
                            style: TextStyle(
                                fontSize: 13.sp,
                                color: Utils.linkColor,
                                decoration: TextDecoration.underline),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ));
    });
  }
}

Widget englishLoading() {
  return Image.asset("assets/json/englishLoader.gif");
}

Widget marathiLoading() {
  return Image.asset("assets/json/marathiLoader.gif");
}

Widget hindiLoading() {
  return Image.asset("assets/json/hindiLoader.gif");
}

import 'package:doozy/main.dart';
import 'package:doozy/shared/core/repositries/provider.dart';
import 'package:doozy/shared/services/textInputFormatters.dart';
import 'package:doozy/shared/utils/constants.dart';
import 'package:doozy/shared/services/widgets/animateBtn.widget.dart';
import 'package:doozy/shared/services/widgets/customToast.widget.dart';
import 'package:doozy/view/authentication/otp.page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> key = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  PhoneNumber? phoneNumber;
  FocusNode? _focusNode;

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProvider>(builder: (context, pro, child) {
      return pro.appLangLoading == true
          ? Scaffold(
              body: (pro.appLangCode == "en"
                  ? englishLoading()
                  : pro.appLangCode == "mr"
                      ? marathiLoading()
                      : hindiLoading()))
          : (Scaffold(
              body: Column(
                children: [
                  Image.asset(
                    "assets/png/login.png",
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.45,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: IntlPhoneField(
                      flagsButtonMargin:
                          const EdgeInsets.symmetric(horizontal: 30),
                      focusNode: _focusNode,
                      showDropdownIcon: false,
                      style: TextStyle(fontSize: 17.sp),
                      dropdownTextStyle: TextStyle(fontSize: 17.sp),
                      autofocus: true,
                      validator: (phoneNumber) {
                        if (phoneNumber!.number.isEmpty) {
                          return "Please enter number.";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        hintText: pro.appTlLanguage.isNotEmpty
                            ? pro.appTlLanguage[26]
                            : 'Enter number',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(5)),
                      ),
                      initialCountryCode: 'IN',
                      controller: phoneController,
                      inputFormatters: [TextInputFormatters.onlyDigits],
                      onChanged: (phone) {
                        phoneNumber = phone;
                        if (phone.isValidNumber() == true) {
                          _focusNode?.unfocus();
                        }
                      },
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimateBtn(
                    text: pro.appTlLanguage.isNotEmpty
                        ? pro.appTlLanguage[37]
                        : "Continue",
                    function: (startLoading, stopLoading, btnState) async {
                      if (phoneController.text != "") {
                        startLoading();

                        try {
                          await supabase.auth.signInWithOtp(
                              phone: "+91${phoneController.text}");
                          stopLoading();
                          Navigator.pushNamed(context, "/otpPage",
                              arguments: phoneController.text);
                        } catch (e) {
                          stopLoading();
                          print(e);
                        }
                      } else {
                        stopLoading();
                        pro.appTlLanguage.isNotEmpty
                            ? showToast(context, pro.appTlLanguage[43])
                            : showToast(context, "Enter phone number");
                      }
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text.rich(TextSpan(children: [
                    TextSpan(
                      text: pro.appTlLanguage.isNotEmpty
                          ? "${pro.appTlLanguage[27]} "
                          : "By clicking you agree  ",
                    ),
                    TextSpan(
                        text: pro.appTlLanguage.isNotEmpty
                            ? pro.appTlLanguage[28]
                            : "Privacy Policy",
                        style: TextStyle(
                            color: Utils.linkColor,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline)),
                    TextSpan(
                      text: pro.appTlLanguage.isNotEmpty
                          ? " ${pro.appTlLanguage[29]} "
                          : "  &  ",
                    ),
                    TextSpan(
                        text: pro.appTlLanguage.isNotEmpty
                            ? pro.appTlLanguage[30]
                            : "Terms and Conditions",
                        style: TextStyle(
                            color: Utils.linkColor,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline)),
                  ])),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        pro.appTlLanguage.isNotEmpty
                            ? pro.appTlLanguage[31]
                            : "Made in Bharat with ",
                        style: TextStyle(color: Utils.subtitleColor),
                      ),
                      const Text("♥"),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ));
    });
  }
}

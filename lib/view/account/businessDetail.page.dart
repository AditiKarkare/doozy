import 'package:doozy/shared/core/models/message.model.dart';
import 'package:doozy/shared/core/models/messageData.model.dart';
import 'package:doozy/shared/core/others/dataFormates.dart';
import 'package:doozy/shared/core/repositries/provider.dart';
import 'package:doozy/shared/services/validators.dart';
import 'package:doozy/shared/services/widgets/animateBtn.widget.dart';
import 'package:doozy/shared/services/widgets/appbar.widget.dart';
import 'package:doozy/shared/services/widgets/customToast.widget.dart';
import 'package:doozy/shared/services/widgets/staticDropdown.widget.dart';
import 'package:doozy/shared/services/widgets/textformfield.widget.dart';
import 'package:doozy/shared/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class BusinessDetailPage extends StatefulWidget {
  const BusinessDetailPage({super.key});

  @override
  State<BusinessDetailPage> createState() => _BusinessDetailPageState();
}

class _BusinessDetailPageState extends State<BusinessDetailPage> {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  ScrollController scrollController = ScrollController();
  TextEditingController currentLocCont = TextEditingController();
  TextEditingController businessNameCont = TextEditingController();
  TextEditingController phoneNumCont = TextEditingController();
  TextEditingController whatsappNumCont = TextEditingController();
  TextEditingController upiIdCont = TextEditingController();
  String langName = "";
  String applangName = "";
  String langCode = "";
  List<String> languageNameList = [];
  FocusNode focusNode = FocusNode();
  List langMapData = [];

  setControllerData() {
    businessNameCont.text = CoreDataFormates.userModel.businessName ?? "";
    currentLocCont.text = CoreDataFormates.userModel.businessAddress ?? "";
    phoneNumCont.text = CoreDataFormates.userModel.phone?.substring(2) ?? "";
    whatsappNumCont.text =
        CoreDataFormates.userModel.whatsappNo?.substring(2) ??
            CoreDataFormates.userModel.phone?.substring(2) ??
            "";
    upiIdCont.text = CoreDataFormates.userModel.upi ?? "";
    setState(() {});
  }

  setData() async {
    GlobalProvider pro = Provider.of<GlobalProvider>(context, listen: false);
    languageNameList = [];
    langMapData = [];
    for (var element in pro.appsettingList) {
      for (var supportedLang in element.supportedLangs ?? []) {
        languageNameList.add(supportedLang.name);
      }

      langMapData.add(element.toJson());
    }
    langName = CoreDataFormates.userModel.lang ?? languageNameList[0];
    setState(() {});
  }

  Future<String> findLangCode() async {
    for (var element in langMapData) {
      for (var item in element["supported_langs"]) {
        if (item["name"] == applangName) {
          return item["tl_code"];
        }
      }
    }
    setState(() {});
    return "";
  }

  Future<String> findAudioLangCode() async {
    for (var element in langMapData) {
      for (var item in element["supported_langs"]) {
        if (item["name"] == langName) {
          return item["code"];
        }
      }
    }
    setState(() {});
    return "";
  }

  findLangCodeName() async {
    GlobalProvider pro = Provider.of<GlobalProvider>(context, listen: false);
    for (var element in langMapData) {
      for (var item in element["supported_langs"]) {
        if (item["tl_code"] == pro.appLangCode) {
          applangName = item["name"];
        }
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    setData();
    findLangCodeName();

    setControllerData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProvider>(builder: (context, pro, child) {
      return pro.appLangLoading == true
          ? Scaffold(
              body: languageNameList.indexOf(applangName) == 0
                  ? englishLoading()
                  : languageNameList.indexOf(applangName) == 1
                      ? hindiLoading()
                      : marathiLoading(),
            )
          : Scaffold(
              appBar: AppBarShared.appBarStyle(
                  context,
                  pro.appTlLanguage.isNotEmpty
                      ? pro.appTlLanguage[4]
                      : "Business Details"),
              resizeToAvoidBottomInset: false,
              body: pro.appLangLoading == true
                  ? Image.asset("assets/json/englishLoader.gif")
                  : Stack(
                      children: [
                        Container(
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      "assets/png/bg.png",
                                    )))),
                        SingleChildScrollView(
                          controller: scrollController,
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Form(
                            key: globalKey,
                            child: Column(
                              children: [
                                roundedTextFormField(
                                  context,
                                  labelText: pro.appTlLanguage.isNotEmpty
                                      ? pro.appTlLanguage[18]
                                      : "Add Shop Location",
                                  hintText: pro.isBusinessLocLoading == true
                                      ? "Please wait fetching data.."
                                      : "Tap here to capture your current location",
                                  controller: pro.busniessAddress.text != ""
                                      ? pro.busniessAddress
                                      : currentLocCont,
                                  readOnly: true,
                                  maxLines: 1,
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      pro.fetchCurrentLocationEvent();
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w),
                                      child: pro.isBusinessLocLoading == true
                                          ? SvgPicture.asset(
                                              "assets/svg/loadingTrack.svg")
                                          : SvgPicture.asset(
                                              "assets/svg/trackLoc.svg"),
                                    ),
                                  ),
                                ),
                                roundedTextFormField(
                                  context,
                                  labelText: pro.appTlLanguage.isNotEmpty
                                      ? pro.appTlLanguage[19]
                                      : "Business Name",
                                  hintText: pro.appTlLanguage.isNotEmpty
                                      ? pro.appTlLanguage[49]
                                      : "Type here...",
                                  maxLines: 1,
                                  controller: businessNameCont,
                                  textInputAction: TextInputAction.done,
                                  prefix: const Icon(Icons.storefront),
                                ),
                                roundedTextFormField(context,
                                    fillColor: Colors.white,
                                    labelText: pro.appTlLanguage.isNotEmpty
                                        ? pro.appTlLanguage[20]
                                        : "Phone Number",
                                    controller: phoneNumCont,
                                    readOnly: true,
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.number,
                                    hintText: pro.appTlLanguage.isNotEmpty
                                        ? pro.appTlLanguage[49]
                                        : "Type here...",
                                    prefix: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.call),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          Text(
                                            "+ 91",
                                            style: TextStyle(fontSize: 14.sp),
                                          )
                                        ],
                                      ),
                                    )),
                                roundedTextFormField(
                                  context,
                                  fillColor: Colors.white,
                                  readOnly: true,
                                  labelText: pro.appTlLanguage.isNotEmpty
                                      ? pro.appTlLanguage[21]
                                      : "Whatsapp Number",
                                  controller: whatsappNumCont,
                                  textInputAction: TextInputAction.done,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  validator: (p0) =>
                                      AppValidators.validatePhoneNum(p0),
                                  keyboardType: TextInputType.number,
                                  focusNode: focusNode,
                                  hintText: pro.appTlLanguage.isNotEmpty
                                      ? pro.appTlLanguage[49]
                                      : "Type here...",
                                  prefix: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/svg/whatsap.svg",
                                          width: 20.w,
                                          color: Colors.black,
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Text(
                                          "+ 91",
                                          style: TextStyle(fontSize: 14.sp),
                                        )
                                      ],
                                    ),
                                  ),
                                  onChanged: (value) async {
                                    whatsappNumCont.text = value!;
                                    if (value.length == 10) {
                                      focusNode.addListener(focusNode.unfocus);
                                      scrollController.animateTo(
                                        scrollController
                                            .position.minScrollExtent,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      );

                                      Utils().hideKeyboard(context);
                                    }

                                    setState(() {});
                                  },
                                ),
                                roundedTextFormField(context,
                                    fillColor: Colors.white,
                                    labelText: pro.appTlLanguage.isNotEmpty
                                        ? pro.appTlLanguage[22]
                                        : "UPI ID",
                                    hintText: pro.appTlLanguage.isNotEmpty
                                        ? pro.appTlLanguage[49]
                                        : "Type here...",
                                    controller: upiIdCont,
                                    validator: (p0) =>
                                        AppValidators.validateUPI(p0, "UPI ID"),
                                    textInputAction: TextInputAction.done,
                                    prefix: Padding(
                                      padding: EdgeInsets.all(10.w),
                                      child: Image.asset(
                                        "assets/png/upi.png",
                                        width: 6.w,
                                        height: 6.w,
                                      ),
                                    ),
                                    onTap: () {
                                      scrollController.animateTo(
                                        scrollController
                                            .position.maxScrollExtent,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                    onFieldSubmitted: (value) {
                                      scrollController.animateTo(
                                        scrollController
                                            .position.minScrollExtent,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      );
                                    }),
                                const SizedBox(
                                  height: 10,
                                ),
                                staticDropDown(
                                  context,
                                  prefix: Padding(
                                    padding: EdgeInsets.all(12.w),
                                    child: SvgPicture.asset(
                                      "assets/svg/lang.svg",
                                    ),
                                  ),
                                  labelText: pro.appTlLanguage.isNotEmpty
                                      ? pro.appTlLanguage[23]
                                      : "Select audio languagae",
                                  dropdownvalue: langName,
                                  list: languageNameList,
                                  onCallBack: (p0) async {
                                    langName = p0!;
                                    setState(() {});
                                    String code = await findAudioLangCode();
                                    setState(() {});
                                    await pro.setAudioLangCodeFunc(
                                        code: code, langName: langName);
                                  },
                                ),
                                staticDropDown(
                                  context,
                                  prefix: Padding(
                                    padding: EdgeInsets.all(12.w),
                                    child: SvgPicture.asset(
                                      "assets/svg/lang.svg",
                                    ),
                                  ),
                                  labelText: pro.appTlLanguage.isNotEmpty
                                      ? pro.appTlLanguage[24]
                                      : "Select app language ",
                                  dropdownvalue: applangName,
                                  list: languageNameList,
                                  onCallBack: (p0) async {
                                    applangName = p0!;
                                    setState(() {});
                                    String code = await findLangCode();

                                    setState(() {});
                                    await pro.setAppLangCodeFunc(code);
                                  },
                                ),
                                // SizedBox(
                                //   height: 200.h,
                                // )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
              bottomNavigationBar: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 15.h,
                  ),
                  AnimateBtn(
                    text: pro.appTlLanguage.isNotEmpty
                        ? pro.appTlLanguage[25]
                        : "Done",
                    function: (startLoading, stopLoading, btnState) async {
                      if (globalKey.currentState!.validate()) {
                        startLoading();
                        Map data = {
                          "business_name": businessNameCont.text == ""
                              ? null
                              : businessNameCont.text,
                          "business_address": pro.busniessAddress.text != ""
                              ? pro.busniessAddress.text
                              : currentLocCont.text,
                          // "phone": whatsappNumCont.text == ""
                          //     ? null
                          //     : "91${whatsappNumCont.text}",
                          "upi": upiIdCont.text == "" ? null : upiIdCont.text,
                          "lang": langName,
                          "app_lang": pro.appLangCode,
                          "audio_code": pro.audioCode
                        };

                        pro.updateUserDataEvent("profiles", data);

                        if (langName != CoreDataFormates.userModel.lang) {
                          await pro.addBusinessDataToChatFunc(
                              salesMessageModel: SalesMessageModel(
                                  messageType: 0,
                                  widgetType: 4,
                                  messageDataModel: MessageDataModel(
                                      manualMsg: pro.appTlLanguage.isNotEmpty
                                          ? "${pro.appTlLanguage[75]} $langName"
                                          : "You switched audio language to $langName")));
                        }

                        await pro.clearTLLanguage();
                        pro.appLangCode == "hi"
                            ? await pro.addChangedDataToTLLangList(
                                CoreDataFormates.hindiAppLang)
                            : pro.appLangCode == "mr"
                                ? await pro.addChangedDataToTLLangList(
                                    CoreDataFormates.marathiAppLang)
                                : await pro.addChangedDataToTLLangList(
                                    CoreDataFormates.appLanguageList);

                        await pro.changeAppLanguageFunc(context);
                        if (pro.appLangCode == "hi") {
                          pro.emptyTLInvFilterList();
                          for (var element
                              in CoreDataFormates.filterListHindi) {
                            pro.addDataToTLInvFilter(element);
                          }
                        } else if (pro.appLangCode == "mr") {
                          pro.emptyTLInvFilterList();
                          for (var element
                              in CoreDataFormates.filterListMarathi) {
                            pro.addDataToTLInvFilter(element);
                          }
                        } else {
                          pro.emptyTLInvFilterList();
                          for (var element in CoreDataFormates.filterList) {
                            pro.addDataToTLInvFilter(element);
                          }
                        }

                        pro.appLangLoading == false
                            ? showToast(context, "Details Updated Sucessfully")
                            : null;
                        Utils().hideKeyboard(context);
                        Navigator.pop(context);
                        pro.appTlLanguage.isNotEmpty
                            ? showToast(context, pro.appTlLanguage[40])
                            : showToast(context, "Details Updated Sucessfully");

                        stopLoading();
                      }
                    },
                  ),
                  SizedBox(
                    height: 15.h,
                  )
                ],
              ),
            );
    });
  }

  Widget englishLoading() {
    return Center(child: Image.asset("assets/json/englishLoader.gif"));
  }

  Widget marathiLoading() {
    return Center(child: Image.asset("assets/json/marathiLoader.gif"));
  }

  Widget hindiLoading() {
    return Center(child: Image.asset("assets/json/hindiLoader.gif"));
  }
}

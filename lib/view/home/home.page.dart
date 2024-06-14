// ignore_for_file: unnecessary_type_check, use_build_context_synchronously

import 'package:doozy/shared/core/repositries/provider.dart';
import 'package:doozy/shared/utils/constants.dart';
import 'package:doozy/shared/services/widgets/appbar.widget.dart';
import 'package:doozy/shared/services/widgets/customToast.widget.dart';
import 'package:doozy/shared/services/widgets/textformfield.widget.dart';
import 'package:doozy/view/authentication/otp.page.dart';
import 'package:doozy/view/chatBot/chat.page.dart';
import 'package:doozy/view/account/drawer.page.dart';
import 'package:doozy/view/chatBot/widget.dart';
import 'package:doozy/view/chatFeature/inventoryChat.page.dart/inventoryChat.page.dart';
import 'package:doozy/view/chatFeature/salesChat/chatSetup.page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // setController();
    // setData();
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Consumer2<GlobalProvider, ManualProductProvider>(
          builder: (context, pro, manPro, child) {
        return pro.appLangLoading == true
            ? Scaffold(
                body: (pro.appLangCode == "en"
                    ? Center(child: englishLoading())
                    : pro.appLangCode == "mr"
                        ? Center(child: marathiLoading())
                        : Center(child: hindiLoading())))
            : (Scaffold(
                key: scaffoldkey,
                drawer: const MyDrawer(),
                appBar: AppBarShared.appBarStyle(context, "",
                    showLeading: false,
                    toolbarHeight: 130,
                    titleWidget: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child:
                                    SvgPicture.asset("assets/svg/chotuAi.svg")),
                            Row(
                              children: [
                                Switch(
                                  value: pro.toggleState == 1 ? false : true,
                                  onChanged: pro.allowSwitchingTab == false
                                      ? (value) {
                                          // pro.tabController?.animateTo(
                                          //     pro.tabController!.previousIndex);
                                          showToast(context,
                                              "Please wait data loading");
                                        }
                                      : (value) {
                                          controller.animateTo(
                                              value == false ? 1 : 0);
                                          pro.changeToggleState(
                                              value == false ? 1 : 0);
                                        },
                                  activeColor: Utils.primaryGreenColor,
                                  inactiveThumbColor: Utils.primaryPinkColor,
                                ),
                                IconButton(
                                    onPressed: pro.useFeature == false
                                        ? () {
                                            showToast(
                                                context,
                                                pro.appTlLanguage.isNotEmpty
                                                    ? pro.appTlLanguage[79]
                                                    : "Malik, Kindly follow the instructions to start using me");
                                          }
                                        : () => scaffoldkey.currentState
                                            ?.openDrawer(),
                                    icon: const Icon(Icons.menu))
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TabBar(
                            controller: controller,
                            onTap: pro.allowSwitchingTab == false
                                ? (value) {
                                    controller.index = pro.toggleState;
                                    setState(() {});
                                    showToast(
                                        context,
                                        pro.appTlLanguage.isNotEmpty
                                            ? pro.appTlLanguage[56]
                                            : "Please wait data loading");
                                  }
                                : (value) {
                                    print(value);
                                    pro.changeToggleState(value);
                                  },
                            labelPadding:
                                EdgeInsets.symmetric(horizontal: 10.w),
                            dividerColor: Colors.transparent,
                            labelStyle: const TextStyle(color: Colors.black),
                            indicator: BoxDecoration(
                                color: pro.toggleState == 1
                                    ? Utils.primaryPinkColor
                                    : Utils.primaryGreenColor,
                                boxShadow: [Utils.commonBoxShadow],
                                borderRadius: BorderRadius.circular(12)),
                            tabs: [
                              Tab(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40),
                                  child: Text(
                                    pro.appTlLanguage.isNotEmpty
                                        ? pro.appTlLanguage[0]
                                        : "SALES",
                                    style: TextStyle(
                                        color: pro.toggleState == 1
                                            ? Colors.black
                                            : Colors.white,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              Tab(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Text(
                                    pro.appTlLanguage.isNotEmpty
                                        ? pro.appTlLanguage[1]
                                        : "INVENTORY",
                                    style: TextStyle(
                                        color: pro.toggleState == 1
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                            ]),
                      ],
                    )),
                body: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          opacity: 0.3,
                          image: AssetImage(
                            "assets/png/bg.png",
                          ))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: pro.useFeature == false
                            ? const NewChatBotPage()
                            : (pro.toggleState == 0
                                ? const ChatSetupPage()
                                : const InventoryChatPage()),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          pro.isLoading == true
                              ? chatTile(
                                  child: Padding(
                                  padding: EdgeInsets.all(10.w),
                                  child: Text(pro.appTlLanguage.isNotEmpty
                                      ? pro.appTlLanguage[76]
                                      : "Kindly wait Malik🙏🏻"),
                                ))
                              : const SizedBox.shrink(),
                          const ButtomNavBarWidget(),
                        ],
                      )
                    ],
                  ),
                ),
              ));
      }),
    );
  }
}

class ButtomNavBarWidget extends StatefulWidget {
  const ButtomNavBarWidget({super.key});

  @override
  State<ButtomNavBarWidget> createState() => _ButtomNavBarWidgetState();
}

class _ButtomNavBarWidgetState extends State<ButtomNavBarWidget> {
  FocusNode manualNode = FocusNode();
  TextEditingController manualProductCont = TextEditingController();
  TextEditingController gtinCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer2<GlobalProvider, ManualProductProvider>(
        builder: (context, pro, manPro, child) {
      return pro.appLangLoading == true
          ? const SizedBox.shrink()
          : (Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                          child: Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: roundedTextFormField(context,
                            textInputAction: TextInputAction.done,
                            controller: manualProductCont,
                            enabled: pro.useFeature,
                            focusNode: manualNode,
                            borderRadius: 100,
                            hintText: pro.appTlLanguage.isNotEmpty
                                ? pro.appTlLanguage[49]
                                : "Type here..",
                            hintstyle: TextStyle(fontSize: 12.sp),
                            onTap: () async {
                          await pro.scrollListFunc(pro.salesChatScrollCont);
                          await pro.scrollListFunc(pro.invChatScrollCont);
                          Future.delayed(const Duration(milliseconds: 500))
                              .then((value) async {
                            await pro.scrollListFunc(pro.salesChatScrollCont);
                            await pro.scrollListFunc(pro.invChatScrollCont);
                          });
                        },
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    onPressed: pro.useFeature == true
                                        ? () => pro.sendOcrFunc(context)
                                        : () => showToast(
                                            context, "Please enter shop name"),
                                    icon: const Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.black,
                                      size: 30,
                                    )),
                              ],
                            ),
                            onChanged: pro.useFeature == true
                                ? ((value) {
                                    RegExp eanRegExp = RegExp(r'^\d{13}$');

                                    if (eanRegExp
                                        .hasMatch(manualProductCont.text)) {
                                      pro.sendGTINFunc(
                                          context, manualProductCont.text);
                                      manualProductCont.text = "";
                                    }
                                    if (value != "") {
                                      manPro.changeManualEditorBtnState(1);
                                    }
                                    if (manualProductCont.text == "" &&
                                        gtinCont.text == "") {
                                      manPro.changeManualEditorBtnState(0);
                                    }
                                  })
                                : (value) {
                                    pro.appTlLanguage.isNotEmpty
                                        ? showToast(
                                            context, pro.appTlLanguage[47])
                                        : showToast(
                                            context, "Please enter shop name");
                                  }),
                      )),
                      SizedBox(
                        width: 10.w,
                      ),
                      pro.useFeature == true
                          ? (manPro.manualEditorBtnState == 0
                              ? ((pro.toggleState == 0
                                  ? (pro.salesRecording == true
                                      ? GestureDetector(
                                          onTap: () async {
                                            await pro
                                                .changeAllowSwitchingTabFunc(
                                                    false);
                                            await pro.changeSalesRecordingState(
                                                false);
                                            await pro.stopRecordingEvent(
                                                context, false);
                                          },
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 2.h),
                                            child: SvgPicture.asset(
                                              "assets/svg/pause.svg",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () async {
                                            await pro.changeSalesRecordingState(
                                                true);
                                            await pro
                                                .microPhoneTapEventFunc(true);
                                          },
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 2.h),
                                            child: SvgPicture.asset(
                                              "assets/svg/mic.svg",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ))
                                  : (pro.inventoryRecording == true
                                      ? GestureDetector(
                                          onTap: () async {
                                            await pro
                                                .changeAllowSwitchingTabFunc(
                                                    false);
                                            await pro
                                                .changeInventoryRecordingState(
                                                    false);
                                            await pro.stopRecordingEvent(
                                                context, false);
                                          },
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 2.h),
                                            child: SvgPicture.asset(
                                              "assets/svg/pause.svg",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () async {
                                            await pro
                                                .changeInventoryRecordingState(
                                                    true);
                                            await pro
                                                .microPhoneTapEventFunc(true);
                                          },
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 2.h),
                                            child: SvgPicture.asset(
                                              "assets/svg/mic.svg",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ))))
                              : IconButton(
                                  padding: const EdgeInsets.all(0),
                                  onPressed: () async {
                                    RegExp eanRegExp = RegExp(r'^\d{13}$');

                                    if (eanRegExp
                                        .hasMatch(manualProductCont.text)) {
                                      pro.sendGTINFunc(
                                          context, manualProductCont.text);
                                    } else {
                                      pro.sendManualFunc(
                                          context, manualProductCont.text);
                                    }

                                    manPro.changeManualEditorBtnState(0);
                                    manualProductCont.text = "";
                                    manualNode.unfocus();
                                    setState(() {});
                                  },
                                  icon: SvgPicture.asset(
                                      "assets/svg/sendBtn.svg")))
                          : GestureDetector(
                              onTap: () {
                                pro.appTlLanguage.isNotEmpty
                                    ? showToast(context, pro.appTlLanguage[48])
                                    : showToast(context,
                                        "Please complete guidelines first to enable features");
                              },
                              child: SvgPicture.asset(
                                  "assets/svg/disabledMic.svg"))
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ));
    });
  }
}

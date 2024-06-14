import 'dart:async';
import 'package:doozy/shared/core/models/message.entity.dart';
import 'package:doozy/shared/core/others/dataFormates.dart';
import 'package:doozy/shared/core/repositries/provider.dart';
import 'package:doozy/shared/services/validators.dart';
import 'package:doozy/shared/utils/constants.dart';
import 'package:doozy/shared/services/widgets/customToast.widget.dart';
import 'package:doozy/shared/services/widgets/textformfield.widget.dart';
import 'package:doozy/shared/services/widgets/videoplayer.widget.dart';
import 'package:doozy/view/chatBot/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

final FocusNode businesNameNode = FocusNode();
final FocusNode upiIdNode = FocusNode();
final FocusNode reEnterIdNode = FocusNode();

class NewChatBotPage extends StatefulWidget {
  const NewChatBotPage({super.key});

  @override
  State<NewChatBotPage> createState() => _NewChatBotPageState();
}

class _NewChatBotPageState extends State<NewChatBotPage> {
  Timer? _timer;
  GlobalKey<FormState> key = GlobalKey<FormState>();
  ScrollController botChatListCont = ScrollController();
  TextEditingController upiIdCont = TextEditingController();
  TextEditingController reEnterupiIdCont = TextEditingController();
  TextEditingController shopNameCont = TextEditingController();

  String loadingLang = "English";
  // String selectedLanguageCode = "";
  bool shopDoneBtn = false;
  bool yesSureBtn = false;
  bool notRnBtn = false;
  bool upiDoneBtn = false;
  bool ytvideo = false;
  bool underStoodBtn = false;
  bool assistantBtn = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProvider>(
      builder: (context, pro, child) {
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            pro.scrollListFunc(botChatListCont);
            Future.delayed(Duration(milliseconds: 900)).then((v) {
              pro.scrollListFunc(botChatListCont);
            });
          });
        }
        return (pro.isChatBotLoading == true && loadingLang == "English")
            ? englishLoading()
            : (pro.isChatBotLoading == true && loadingLang == "Hindi")
                ? hindiLoading()
                : (pro.isChatBotLoading == true && loadingLang == "Marathi")
                    ? marathiLoading()
                    : Form(
                        key: key,
                        child: ListView(
                            controller: botChatListCont,
                            shrinkWrap: true,
                            children: [
                              chatTile(
                                child: ListTile(
                                  leading: const Icon(Icons.person),
                                  title: Text(pro.translatedText.isNotEmpty
                                      ? (pro.translatedText[0])
                                      : "Welcome to Chotu"),
                                  subtitle:
                                      // Text(DateTime.now().toString()),
                                      Text(Utils.formatTimeStamp("HH:mm a",
                                          DateTime.now().toString())),
                                  titleAlignment: ListTileTitleAlignment.top,
                                ),
                              ),
                              chatTile(
                                child: ListTile(
                                  leading: const Icon(Icons.person),
                                  titleAlignment: ListTileTitleAlignment.top,
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(pro.translatedText.isNotEmpty
                                          ? (pro.translatedText[1])
                                          : "Kindly choose your preferred language"),
                                      ListView.builder(
                                        itemCount: pro.appsettingList[0]
                                                .supportedLangs?.length ??
                                            0,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) =>
                                            ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStatePropertyAll(
                                                      pro.chatbotSelectedLangIndex ==
                                                              index
                                                          ? const Color(
                                                              0xffFFFFFF)
                                                          : null),
                                              side: WidgetStatePropertyAll(BorderSide(
                                                  width: 2,
                                                  color:
                                                      pro.chatbotSelectedLangIndex ==
                                                              index
                                                          ? Utils.linkColor
                                                          : Colors
                                                              .transparent))),
                                          onPressed: () async {
                                            pro.setchatbotSelectedLangIndexFunc(
                                                index);
                                            loadingLang = pro
                                                    .appsettingList[0]
                                                    .supportedLangs?[index]
                                                    .name ??
                                                "";

                                            setState(() {});
                                            pro.setAppLangCodeFunc(pro
                                                    .appsettingList[0]
                                                    .supportedLangs?[index]
                                                    .translateCode ??
                                                "en");

                                            pro.addIndexFunc(0);
                                            Utils().hideKeyboard(context);
                                            pro.showNextMessageEventFunc(
                                                MessageModel(
                                                    messageIndex: 0,
                                                    messageList:
                                                        CoreDataFormates
                                                            .chatMessages,
                                                    code: pro
                                                        .appsettingList[0]
                                                        .supportedLangs?[index]
                                                        .translateCode),
                                                context);
                                          },
                                          child: Text(
                                            pro
                                                    .appsettingList[0]
                                                    .supportedLangs?[index]
                                                    .name ??
                                                "",
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  subtitle: Text(Utils.formatTimeStamp(
                                      "HH:mm a", DateTime.now().toString())),
                                ),
                              ),
                              Column(
                                children: [
                                  pro.messageIndexList.contains(0)
                                      ? chatTile(
                                          child: ListTile(
                                          leading: const Icon(Icons.person),
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(pro.translatedText[13] ??
                                                  "Your Chhotu is here to serve you, please tell me the name of your shop"),
                                              roundedTextFormField(
                                                context,
                                                textInputAction:
                                                    TextInputAction.done,
                                                focusNode: businesNameNode,
                                                onTap: () {
                                                  pro.scrollListFunc(
                                                      botChatListCont);
                                                },
                                                hintText:
                                                    pro.translatedText[6] ??
                                                        "Type here..",
                                                controller: shopNameCont,
                                                validator: (p0) =>
                                                    AppValidators.anyString(
                                                        p0, "shop name"),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                          WidgetStatePropertyAll(
                                                              shopDoneBtn ==
                                                                      true
                                                                  ? const Color(
                                                                      0xffFFFFFF)
                                                                  : null),
                                                      side: WidgetStatePropertyAll(
                                                          BorderSide(
                                                              width: 2,
                                                              color: shopDoneBtn ==
                                                                      true
                                                                  ? Utils
                                                                      .linkColor
                                                                  : Colors
                                                                      .transparent))),
                                                  onPressed: () {
                                                    // Utils()
                                                    //     .hideKeyboard(context);
                                                    if (key.currentState!
                                                        .validate()) {
                                                      shopDoneBtn = true;
                                                      pro.updateChatBotUserDataEventFunc(
                                                          "profiles",
                                                          "business_name",
                                                          shopNameCont.text);

                                                      pro.addIndexFunc(1);

                                                      pro.showNextMessageEventFunc(
                                                          MessageModel(
                                                              messageIndex: 1,
                                                              messageList:
                                                                  CoreDataFormates
                                                                      .chatMessages,
                                                              code: pro
                                                                  .appLangCode),
                                                          context);

                                                      pro.appTlLanguage
                                                              .isNotEmpty
                                                          ? showToast(
                                                              context,
                                                              pro.appTlLanguage[
                                                                  44])
                                                          : showToast(context,
                                                              "Shop name updated Sucessfully");
                                                    } else {}
                                                  },
                                                  child: Text(
                                                      pro.translatedText[14] ??
                                                          "Done?")),
                                            ],
                                          ),
                                          subtitle: Text(Utils.formatTimeStamp(
                                              "HH:mm a",
                                              DateTime.now().toString())),
                                          titleAlignment:
                                              ListTileTitleAlignment.top,
                                        ))
                                      : const SizedBox.shrink(),
                                  pro.messageIndexList.contains(1)
                                      ? chatTile(
                                          child: ListTile(
                                          leading: const Icon(Icons.person),
                                          title: Column(
                                            children: [
                                              Text(pro.translatedText[2] ??
                                                  "Could you please provide your UPI ID so that we can prepare a QR code for the bill amount, making transactions easier for you and your customers?"),
                                              Row(
                                                children: [
                                                  ElevatedButton(
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              WidgetStatePropertyAll(
                                                                  yesSureBtn ==
                                                                          true
                                                                      ? const Color(
                                                                          0xffFFFFFF)
                                                                      : null),
                                                          side: WidgetStatePropertyAll(BorderSide(
                                                              width: 2,
                                                              color: yesSureBtn ==
                                                                      true
                                                                  ? Utils
                                                                      .linkColor
                                                                  : Colors
                                                                      .transparent))),
                                                      onPressed: () async {
                                                        yesSureBtn = true;
                                                        notRnBtn = false;
                                                        setState(() {});
                                                        await pro
                                                            .addIndexFunc(2);
                                                        await pro
                                                            .deleteIndexFunc(3);
                                                        await pro
                                                            .deleteIndexFunc(5);
                                                        await pro
                                                            .deleteIndexFunc(4);
                                                        await pro
                                                            .deleteIndexFunc(6);
                                                        await pro
                                                            .deleteIndexFunc(7);
                                                        await Future.delayed(
                                                                Duration(
                                                                    seconds: 1))
                                                            .then((onValue) {
                                                          FocusScope.of(context)
                                                              .requestFocus(
                                                                  upiIdNode);

                                                          pro.scrollListFunc(
                                                              botChatListCont);
                                                        });
                                                      },
                                                      child: Text(
                                                          pro.translatedText[
                                                                  3] ??
                                                              "Yes Sure!")),
                                                  const SizedBox(
                                                    width: 20,
                                                  ),
                                                  ElevatedButton(
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              WidgetStatePropertyAll(
                                                                  notRnBtn ==
                                                                          true
                                                                      ? const Color(
                                                                          0xffFFFFFF)
                                                                      : null),
                                                          side: WidgetStatePropertyAll(BorderSide(
                                                              width: 2,
                                                              color: notRnBtn ==
                                                                      true
                                                                  ? Utils
                                                                      .linkColor
                                                                  : Colors
                                                                      .transparent))),
                                                      onPressed: () {
                                                        notRnBtn = true;
                                                        yesSureBtn = false;

                                                        pro.addIndexFunc(4);
                                                        pro.deleteIndexFunc(2);
                                                        pro.deleteIndexFunc(5);

                                                        // pro.showNextMessageEventFunc(
                                                        //     MessageModel(
                                                        //         messageIndex:
                                                        //             3,
                                                        //         messageList: CoreDataFormates
                                                        //             .chatMessages,
                                                        //         code:
                                                        //             pro.appLangCode),
                                                        //     context);
                                                      },
                                                      child: Text(
                                                          pro.translatedText[
                                                                  4] ??
                                                              "Not right now")),
                                                ],
                                              ),
                                            ],
                                          ),
                                          subtitle: Text(Utils.formatTimeStamp(
                                              "HH:mm a",
                                              DateTime.now().toString())),
                                          titleAlignment:
                                              ListTileTitleAlignment.top,
                                        ))
                                      : const SizedBox.shrink(),
                                  pro.messageIndexList.contains(2)
                                      ? Consumer<ManualProductProvider>(
                                          builder: (context, manPro, child) {
                                          return chatTile(
                                              child: ListTile(
                                            leading: const Icon(Icons.person),
                                            title: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(pro.translatedText[5] ??
                                                    "Please use below textfield to enter UPI Id"),
                                                upiIdroundedTextFormField(
                                                  context,
                                                  focusNode: upiIdNode,
                                                  onTap: () {
                                                    pro.scrollListFunc(
                                                        botChatListCont);
                                                    Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    500))
                                                        .then((onValue) {
                                                      pro.scrollListFunc(
                                                          botChatListCont);
                                                    });
                                                  },
                                                  hintText: pro
                                                          .translatedText[19] ??
                                                      "Enter UPI ID here...",
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  controller: upiIdCont,
                                                  onFieldSubmitted: (value) {
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            reEnterIdNode);
                                                  },
                                                  validator: (p0) =>
                                                      AppValidators.validateUPI(
                                                          p0, "UPI ID"),
                                                ),
                                                upiIdroundedTextFormField(
                                                  context,
                                                  focusNode: reEnterIdNode,
                                                  onTap: () {
                                                    pro.scrollListFunc(
                                                        botChatListCont);
                                                    Future.delayed(
                                                            const Duration(
                                                                milliseconds:
                                                                    500))
                                                        .then((onValue) {
                                                      pro.scrollListFunc(
                                                          botChatListCont);
                                                    });
                                                  },
                                                  hintText: pro
                                                          .translatedText[17] ??
                                                      "Re-enter UPI ID here...",
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  controller: reEnterupiIdCont,
                                                  validator: (p0) =>
                                                      AppValidators.validateUPI(
                                                          p0, "UPI ID"),
                                                  onChanged: (value) {
                                                    if (upiIdCont.text ==
                                                        reEnterupiIdCont.text) {
                                                      manPro
                                                          .changeisUpiValidFunc(
                                                              true);
                                                    } else {
                                                      manPro
                                                          .changeisUpiValidFunc(
                                                              false);
                                                    }
                                                  },
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                ElevatedButton(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            WidgetStatePropertyAll(
                                                                upiDoneBtn ==
                                                                        true
                                                                    ? const Color(
                                                                        0xffFFFFFF)
                                                                    : null),
                                                        side: WidgetStatePropertyAll(
                                                            BorderSide(
                                                                width: 2,
                                                                color: upiDoneBtn ==
                                                                        true
                                                                    ? Utils
                                                                        .linkColor
                                                                    : Colors
                                                                        .transparent))),
                                                    onPressed: () async {
                                                      Utils().hideKeyboard(
                                                          context);
                                                      if (key.currentState!
                                                              .validate() &&
                                                          upiIdCont.text ==
                                                              reEnterupiIdCont
                                                                  .text) {
                                                        manPro
                                                            .changeisUpiValidFunc(
                                                                true);
                                                        manPro.timer?.cancel();
                                                        upiDoneBtn = true;

                                                        pro.updateChatBotUserDataEventFunc(
                                                            "profiles",
                                                            "upi",
                                                            upiIdCont.text);

                                                        pro.addIndexFunc(4);

                                                        pro.showNextMessageEventFunc(
                                                            MessageModel(
                                                                messageIndex: 4,
                                                                messageList:
                                                                    CoreDataFormates
                                                                        .chatMessages,
                                                                code: pro
                                                                    .appLangCode),
                                                            context);

                                                        pro.appTlLanguage
                                                                .isNotEmpty
                                                            ? showToast(
                                                                context,
                                                                pro.appTlLanguage[
                                                                    45])
                                                            : showToast(context,
                                                                "UPI ID updated Sucessfully");
                                                      } else {
                                                        await manPro
                                                            .changeisUpiValidFunc(
                                                                false);
                                                        await manPro
                                                            .changeBotUPIIdColorFunc();
                                                        pro.appTlLanguage
                                                                .isNotEmpty
                                                            ? showToast(
                                                                context,
                                                                pro.appTlLanguage[
                                                                    77])
                                                            : showToast(context,
                                                                "Both UPI ID should be same");
                                                      }
                                                    },
                                                    child: Text(
                                                        pro.translatedText[7] ??
                                                            "Confirm?")),
                                              ],
                                            ),
                                            subtitle: Text(
                                                Utils.formatTimeStamp("HH:mm a",
                                                    DateTime.now().toString())),
                                            titleAlignment:
                                                ListTileTitleAlignment.top,
                                          ));
                                        })
                                      : const SizedBox.shrink(),

                                  // business selection add - 5
                                  pro.messageIndexList.contains(4)
                                      ? chatTile(
                                          child: ListTile(
                                            leading: const Icon(Icons.person),
                                            titleAlignment:
                                                ListTileTitleAlignment.top,
                                            title: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(pro.translatedText
                                                        .isNotEmpty
                                                    ? (pro.translatedText[18])
                                                    : "Kindly select your business category"),
                                                ListView.builder(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount: pro
                                                          .botBusinessListType
                                                          .isNotEmpty
                                                      ? pro.botBusinessListType
                                                          .length
                                                      : CoreDataFormates
                                                          .chatBotBusinessType
                                                          .length,
                                                  shrinkWrap: true,
                                                  itemBuilder: (context, index) =>
                                                      ElevatedButton(
                                                          style: ButtonStyle(
                                                              backgroundColor: WidgetStatePropertyAll(
                                                                  pro.chatbotBusinessIndex ==
                                                                          index
                                                                      ? const Color(
                                                                          0xffFFFFFF)
                                                                      : null),
                                                              side: WidgetStatePropertyAll(BorderSide(
                                                                  width: 2,
                                                                  color: pro.chatbotBusinessIndex ==
                                                                          index
                                                                      ? Utils
                                                                          .linkColor
                                                                      : Colors
                                                                          .transparent))),
                                                          onPressed: () async {
                                                            pro.setchatbotBusinessIndexFunc(
                                                                index);
                                                            pro.addIndexFunc(5);
                                                          },
                                                          child: Text(pro
                                                                  .botBusinessListType
                                                                  .isNotEmpty
                                                              ? pro.botBusinessListType[index]
                                                              : CoreDataFormates.chatBotBusinessType[index])),
                                                )
                                              ],
                                            ),
                                            subtitle: Text(
                                                Utils.formatTimeStamp("HH:mm a",
                                                    DateTime.now().toString())),
                                          ),
                                        )
                                      : const SizedBox.shrink(),

                                  //---- oky no worries
                                  pro.messageIndexList.contains(3)
                                      ? chatTile(
                                          child: ListTile(
                                            leading: const Icon(Icons.person),
                                            title: Text(pro.translatedText[8] ??
                                                "Okay, no worries. Let me give you quick guide how I can assist you"),
                                            subtitle: Text(
                                                Utils.formatTimeStamp("HH:mm a",
                                                    DateTime.now().toString())),
                                            titleAlignment:
                                                ListTileTitleAlignment.top,
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                  //Youtube video play add - 6
                                  pro.messageIndexList.contains(5)
                                      ? chatTile(
                                          child: ListTile(
                                            leading: const Icon(Icons.person),
                                            title: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  children: [
                                                    IconButton(
                                                        color: Colors.grey,
                                                        onPressed: () async {
                                                          showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              return const Dialog(
                                                                child: VideoPlayerWidget(
                                                                    videoUrl:
                                                                        "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4"),
                                                              );
                                                            },
                                                          );
                                                        },
                                                        icon: SvgPicture.asset(
                                                            "assets/svg/playVideo.svg")),
                                                  ],
                                                ),
                                                ElevatedButton(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            WidgetStatePropertyAll(
                                                                ytvideo == true
                                                                    ? const Color(
                                                                        0xffFFFFFF)
                                                                    : null),
                                                        side: WidgetStatePropertyAll(
                                                            BorderSide(
                                                                width: 2,
                                                                color: ytvideo ==
                                                                        true
                                                                    ? Utils
                                                                        .linkColor
                                                                    : Colors
                                                                        .transparent))),
                                                    onPressed: () {
                                                      ytvideo = true;
                                                      setState(() {});
                                                      pro.addIndexFunc(6);
                                                    },
                                                    child: Text(
                                                        pro.translatedText[
                                                                14] ??
                                                            "Done?"))
                                              ],
                                            ),
                                            subtitle: Text(
                                                Utils.formatTimeStamp("HH:mm a",
                                                    DateTime.now().toString())),
                                            titleAlignment:
                                                ListTileTitleAlignment.top,
                                          ),
                                        )
                                      : const SizedBox.shrink(),

                                  // ----- let me give u quick guide
                                  pro.messageIndexList.contains(6)
                                      ? chatTile(
                                          child: ListTile(
                                            leading: const Icon(Icons.person),
                                            title: Text(pro.translatedText[9] ??
                                                "Thank you. Let me give you quick guide how I can assist you"),
                                            subtitle: Text(
                                                Utils.formatTimeStamp("HH:mm a",
                                                    DateTime.now().toString())),
                                            titleAlignment:
                                                ListTileTitleAlignment.top,
                                          ),
                                        )
                                      : const SizedBox.shrink(),

                                  // manualll ---- add 6 delete 7
                                  (pro.messageIndexList.contains(3) ||
                                          pro.messageIndexList.contains(6))
                                      ? chatTile(
                                          child: ListTile(
                                            leading: const Icon(Icons.person),
                                            title: Column(
                                              children: [
                                                Text(pro.translatedText[10] ??
                                                    "You can use following options to create Sales or Inventory\n 1) Use mic to record \n 2) Upload image from gallery or from camera \n 3) Upload pdf"),
                                                Row(
                                                  children: [
                                                    ElevatedButton(
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                WidgetStatePropertyAll(
                                                                    underStoodBtn ==
                                                                            true
                                                                        ? const Color(
                                                                            0xffFFFFFF)
                                                                        : null),
                                                            side: WidgetStatePropertyAll(BorderSide(
                                                                width: 2,
                                                                color: underStoodBtn ==
                                                                        true
                                                                    ? Utils
                                                                        .linkColor
                                                                    : Colors
                                                                        .transparent))),
                                                        onPressed: () {
                                                          underStoodBtn = true;
                                                          assistantBtn = false;

                                                          pro.addIndexFunc(7);
                                                          pro.deleteIndexFunc(
                                                              8);
                                                          // pro.addIndexFunc(
                                                          //     5);
                                                          // pro.deleteIndexFunc(
                                                          //     6);
                                                          pro.showNextMessageEventFunc(
                                                              MessageModel(
                                                                  messageIndex:
                                                                      5,
                                                                  messageList:
                                                                      CoreDataFormates
                                                                          .chatMessages,
                                                                  code: pro
                                                                      .appLangCode),
                                                              context);

                                                          setState(() {});
                                                        },
                                                        child: Text(
                                                            pro.translatedText[
                                                                    11] ??
                                                                "Understood!")),
                                                    SizedBox(
                                                      width: 10.w,
                                                    ),
                                                    ElevatedButton(
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                WidgetStatePropertyAll(
                                                                    assistantBtn ==
                                                                            true
                                                                        ? const Color(
                                                                            0xffFFFFFF)
                                                                        : null),
                                                            side: WidgetStatePropertyAll(BorderSide(
                                                                width: 2,
                                                                color: assistantBtn ==
                                                                        true
                                                                    ? Utils
                                                                        .linkColor
                                                                    : Colors
                                                                        .transparent))),
                                                        onPressed: () {
                                                          pro.deleteIndexFunc(
                                                              7);

                                                          assistantBtn = true;
                                                          underStoodBtn = false;
                                                          setState(() {});
                                                        },
                                                        child: Text(
                                                            pro.translatedText[
                                                                    12] ??
                                                                "Need assistant?")),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            subtitle: Text(
                                                Utils.formatTimeStamp("HH:mm a",
                                                    DateTime.now().toString())),
                                            titleAlignment:
                                                ListTileTitleAlignment.top,
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                  // i am glad u under
                                  pro.messageIndexList.contains(7)
                                      ? chatTile(
                                          child: ListTile(
                                            leading: const Icon(Icons.person),
                                            title: Text(pro
                                                    .translatedText[15] ??
                                                "I'm glad you understood how to use me. My dear Owner, you can now begin using me."),
                                            subtitle: Text(
                                                Utils.formatTimeStamp("HH:mm a",
                                                    DateTime.now().toString())),
                                            titleAlignment:
                                                ListTileTitleAlignment.top,
                                          ),
                                        )
                                      : const SizedBox.shrink(),

                                  // Start using app
                                  pro.messageIndexList.contains(7)
                                      ? chatTile(
                                          child: ListTile(
                                            leading: const Icon(Icons.person),
                                            title: ElevatedButton(
                                                onPressed: () {
                                                  pro.changeFeatureSettingFunc(
                                                      true);
                                                },
                                                child: Text(
                                                    pro.translatedText[16] ??
                                                        "Start using ChotuAI")),
                                            subtitle: Text(
                                                Utils.formatTimeStamp("HH:mm a",
                                                    DateTime.now().toString())),
                                            titleAlignment:
                                                ListTileTitleAlignment.top,
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              )
                            ]));
      },
    );
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
}

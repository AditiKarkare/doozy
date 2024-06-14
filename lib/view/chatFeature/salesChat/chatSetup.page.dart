import 'package:doozy/shared/core/models/salesHistory.model.dart';
import 'package:doozy/shared/core/repositries/provider.dart';
import 'package:doozy/view/chatBot/widget.dart';
import 'package:doozy/view/chatFeature/salesChat/salesResponse.page.dart';
import 'package:doozy/view/chatFeature/widgets/audiosent.card.dart';
import 'package:doozy/view/chatFeature/widgets/bill.card.dart';
import 'package:doozy/view/chatFeature/widgets/botErrorMsg.card.dart';
import 'package:doozy/view/chatFeature/widgets/imagesent.card.dart';
import 'package:doozy/view/chatFeature/widgets/manualText.card.dart';
import 'package:doozy/view/chatFeature/widgets/pdfsent.card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ChatSetupPage extends StatefulWidget {
  const ChatSetupPage({super.key});

  @override
  State<ChatSetupPage> createState() => ChatSetupPageState();
}

class ChatSetupPageState extends State<ChatSetupPage> {
  @override
  void initState() {
    // Provider.of<GlobalProvider>(context, listen: false).scrollListFunc(
    //     Provider.of<GlobalProvider>(context, listen: false)
    //         .salesChatScrollCont);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProvider>(
      builder: (context, pro, child) {
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            pro.scrollListFunc(pro.salesChatScrollCont);
          });
        }

        return pro.salesChatList.isNotEmpty
            ? ListView.builder(
                padding: EdgeInsets.only(top: 10.w),
                controller: pro.salesChatScrollCont,
                itemCount: pro.salesChatList.length,
                itemBuilder: (context, index) {
                  return (index == (pro.salesChatList.length - 1) &&
                          pro.salesResponseList.isNotEmpty)
                      ? (SalesResponsePageList(
                          productList: pro.salesResponseList))
                      : (pro.salesChatList[index].messageType == 0
                          ? userChatTile(
                              child: pro.salesChatList[index].widgetType == 2
                                  ? AudioSentCardWidget(
                                      audioLink: pro
                                              .salesChatList[index]
                                              .messageDataModel
                                              .audioRecording ??
                                          "",
                                    )
                                  : pro.salesChatList[index].widgetType == 3
                                      ? ImageSentCardWidget(
                                          imageLink: pro.salesChatList[index]
                                                  .messageDataModel.ocrImage ??
                                              "",
                                        )
                                      : pro.salesChatList[index].widgetType == 6
                                          ? PdfSentCardWidget(
                                              pdfLink: pro
                                                      .salesChatList[index]
                                                      .messageDataModel
                                                      .ocrImage ??
                                                  "")
                                          : ManualTextCardWidget(
                                              text: pro
                                                      .salesChatList[index]
                                                      .messageDataModel
                                                      .manualMsg ??
                                                  "",
                                            ))
                          : (pro.salesChatList[index].messageType == 1 &&
                                  pro.salesChatList[index].widgetType == 7)
                              ? BotErrorMessageCard(
                                  text: pro.salesChatList[index]
                                          .messageDataModel.manualMsg ??
                                      "")
                              : BillCardWidget(
                                  salesHistoryItemsModel: pro
                                          .salesChatList[index]
                                          .messageDataModel
                                          .salesHistoryItemsModel ??
                                      SalesHistoryItemsModel()));
                })
            : const SizedBox.shrink();
      },
    );
  }
}

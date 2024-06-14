import 'package:doozy/shared/core/repositries/provider.dart';
import 'package:doozy/view/chatBot/widget.dart';
import 'package:doozy/view/chatFeature/inventoryChat.page.dart/inventoryResponse.page.dart';
import 'package:doozy/view/chatFeature/widgets/audiosent.card.dart';
import 'package:doozy/view/chatFeature/widgets/botErrorMsg.card.dart';
import 'package:doozy/view/chatFeature/widgets/imagesent.card.dart';
import 'package:doozy/view/chatFeature/widgets/inventoryBill.card.dart';
import 'package:doozy/view/chatFeature/widgets/manualText.card.dart';
import 'package:doozy/view/chatFeature/widgets/pdfsent.card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class InventoryChatPage extends StatefulWidget {
  const InventoryChatPage({super.key});

  @override
  State<InventoryChatPage> createState() => _InventoryChatPageState();
}

class _InventoryChatPageState extends State<InventoryChatPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProvider>(
      builder: (context, pro, child) {
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            pro.scrollListFunc(pro.invChatScrollCont);
          });
        }

        return pro.inventoryChatList.isNotEmpty
            ? ListView.builder(
                padding: EdgeInsets.only(top: 10.w),
                controller: pro.invChatScrollCont,
                itemCount: pro.inventoryChatList.length,
                itemBuilder: (context, index) {
                  return (index == (pro.inventoryChatList.length - 1) &&
                          pro.inventoryResponseList.isNotEmpty)
                      ? (InventoryResponsePage(
                          productList: pro.inventoryResponseList))
                      : (pro.inventoryChatList[index].messageType == 0
                          ? userChatTile(
                              child: pro.inventoryChatList[index].widgetType ==
                                      2
                                  ? AudioSentCardWidget(
                                      audioLink: pro
                                              .inventoryChatList[index]
                                              .messageDataModel
                                              .audioRecording ??
                                          "",
                                    )
                                  : pro.inventoryChatList[index].widgetType == 3
                                      ? ImageSentCardWidget(
                                          imageLink: pro
                                                  .inventoryChatList[index]
                                                  .messageDataModel
                                                  .ocrImage ??
                                              "",
                                        )
                                      : pro.inventoryChatList[index]
                                                  .widgetType ==
                                              6
                                          ? PdfSentCardWidget(
                                              pdfLink: pro
                                                      .inventoryChatList[index]
                                                      .messageDataModel
                                                      .ocrImage ??
                                                  "",
                                            )
                                          : ManualTextCardWidget(
                                              text: pro
                                                      .inventoryChatList[index]
                                                      .messageDataModel
                                                      .manualMsg ??
                                                  "",
                                            ))
                          : (pro.inventoryChatList[index].messageType == 1 &&
                                  pro.inventoryChatList[index].widgetType == 7)
                              ? BotErrorMessageCard(
                                  text: pro.inventoryChatList[index]
                                          .messageDataModel.manualMsg ??
                                      "")
                              : InventoryBillCard(
                                  productList: pro
                                          .inventoryChatList[index]
                                          .messageDataModel
                                          .audioProductModelList ??
                                      []));
                })
            : const SizedBox.shrink();
      },
    );
  }
}

Color borderColor = Colors.black;

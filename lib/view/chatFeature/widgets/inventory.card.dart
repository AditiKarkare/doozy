import 'package:doozy/shared/utils/constants.dart';
import 'package:doozy/view/chatBot/widget.dart';
import 'package:doozy/shared/core/models/messageData.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InventoryCard extends StatefulWidget {
  final MessageDataModel messageDataModel;
  const InventoryCard({super.key, required this.messageDataModel});

  @override
  State<InventoryCard> createState() => _InventoryCardState();
}

class _InventoryCardState extends State<InventoryCard> {
  @override
  Widget build(BuildContext context) {
    return chatTile(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ListView.builder(
            padding: EdgeInsets.symmetric(
                vertical:
                    widget.messageDataModel.audioProductModelList!.isNotEmpty
                        ? 15
                        : 0),
            itemCount: widget.messageDataModel.audioProductModelList!.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, itemIndex) {
              return ListTile(
                leading: Utils.networkImageNoCached(
                    imageUrl: "", width: 50.w, height: 50.w, fit: BoxFit.cover),
                title: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    widget.messageDataModel.audioProductModelList![itemIndex]
                            .productName ??
                        "",
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 15.sp),
                  ),
                ),
                subtitle: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Qty : ",
                                style: TextStyle(
                                    fontSize: 14.sp, color: Utils.linkColor),
                              ),
                              Text(
                                "${widget.messageDataModel.audioProductModelList![itemIndex].productQty ?? ""}",
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 140.w,
                            child: Row(
                              children: [
                                Text(
                                  "M.R.P : ",
                                  style: TextStyle(
                                      fontSize: 14.sp, color: Utils.linkColor),
                                ),
                                Flexible(
                                  child: Text(
                                    "₹${widget.messageDataModel.audioProductModelList![itemIndex].amount?.toStringAsFixed(2) ?? ""}",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Unit : ",
                              style: TextStyle(
                                  fontSize: 14.sp, color: Utils.linkColor),
                            ),
                            Text(
                              widget
                                      .messageDataModel
                                      .audioProductModelList![itemIndex]
                                      .productUnit ??
                                  "",
                              style: TextStyle(fontSize: 14.sp),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 140.w,
                          child: Row(
                            children: [
                              Text(
                                "S.P : ",
                                style: TextStyle(
                                    fontSize: 14.sp, color: Utils.linkColor),
                              ),
                              Text(
                                "₹${widget.messageDataModel.audioProductModelList![itemIndex].productPrice?.toStringAsFixed(2) ?? ""}",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    overflow: TextOverflow.ellipsis,
                                    color: Utils.primaryPinkColor),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }),
      ],
    ));
  }
}

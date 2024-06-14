import 'package:doozy/shared/core/models/audioProduct.model.dart';
import 'package:doozy/shared/core/repositries/provider.dart';
import 'package:doozy/shared/utils/constants.dart';
import 'package:doozy/view/chatBot/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class InventoryBillCard extends StatefulWidget {
  final List<AudioProductModel> productList;
  const InventoryBillCard({super.key, required this.productList});

  @override
  State<InventoryBillCard> createState() => _InventoryBillCardState();
}

class _InventoryBillCardState extends State<InventoryBillCard> {
  TextEditingController labelCont = TextEditingController();
  TextEditingController qtyCont = TextEditingController();
  TextEditingController unitCont = TextEditingController();
  TextEditingController priceCont = TextEditingController();
  List<AudioProductModel> productList = [];
  int modelIndex = 0;

  @override
  void initState() {
    productList = widget.productList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProvider>(builder: (context, pro, child) {
      return chatTile(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ListView.builder(
              padding: EdgeInsets.symmetric(
                  vertical: productList.isNotEmpty ? 15 : 0),
              itemCount: productList.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, itemIndex) {
                return ListTile(
                  leading: Utils.networkImageNoCached(
                      imageUrl: "",
                      width: 50.w,
                      height: 50.w,
                      fit: BoxFit.cover),
                  title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    child: Text(
                      productList[itemIndex].productName ?? "",
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15.sp),
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
                                  pro.appTlLanguage.isNotEmpty
                                      ? "${pro.appTlLanguage[52]} : "
                                      : "Qty :",
                                  style: TextStyle(
                                      fontSize: 14.sp, color: Utils.linkColor),
                                ),
                                Text(
                                  " ${productList[itemIndex].productQty ?? ""}",
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  pro.appTlLanguage.isNotEmpty
                                      ? "${pro.appTlLanguage[50]} : "
                                      : "M.R.P :",
                                  style: TextStyle(
                                      fontSize: 14.sp, color: Utils.linkColor),
                                ),
                                Text(
                                  " ₹${productList[itemIndex].amount?.toStringAsFixed(2) ?? ""}",
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                              ],
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
                                pro.appTlLanguage.isNotEmpty
                                    ? "${pro.appTlLanguage[53]} : "
                                    : "Unit :",
                                style: TextStyle(
                                    fontSize: 14.sp, color: Utils.linkColor),
                              ),
                              Text(
                                " ${productList[itemIndex].productUnit ?? ""}",
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                pro.appTlLanguage.isNotEmpty
                                    ? "${pro.appTlLanguage[51]} : "
                                    : "S.P :",
                                style: TextStyle(
                                    fontSize: 14.sp, color: Utils.linkColor),
                              ),
                              Text(
                                " ₹${productList[itemIndex].productPrice?.toStringAsFixed(2) ?? ""}",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Utils.primaryPinkColor),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }),
        ],
      ));
    });
  }
}

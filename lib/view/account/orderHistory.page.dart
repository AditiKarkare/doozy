import 'package:doozy/shared/core/models/salesHistory.model.dart';
import 'package:doozy/shared/core/repositries/provider.dart';
import 'package:doozy/shared/utils/constants.dart';
import 'package:doozy/shared/services/widgets/appbar.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class OrderHistoryPage extends StatefulWidget {
  final Map data;

  const OrderHistoryPage({super.key, required this.data});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  SalesHistoryItemsModel salesHistoryItemsModel = SalesHistoryItemsModel();
  int orderNo = 0;
  setData() {
    orderNo = widget.data["orderNo"];
    salesHistoryItemsModel = widget.data["model"];
    setState(() {});
  }

  @override
  void initState() {
    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProvider>(builder: (context, pro, child) {
      return Scaffold(
          appBar: AppBarShared.appBarStyle(context, "", action: [
            // Padding(
            //   padding: EdgeInsets.only(right: 15.w),
            //   child: IconButton(
            //       onPressed: () async {
            //         var data = {
            //           "data": {
            //             "sale id": int.parse(
            //                 pro.animatedSalesListData[orderNo].saleId!)
            //           }
            //         };
            //         pro.deleteBillFunc(context, orderNo, data);
            //         Navigator.pop(context);
            //       },
            //       icon: Icon(
            //         Icons.delete,
            //         size: 30.sp,
            //         color: Colors.red.shade900,
            //       )),
            // )
          ]),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: Colors.black)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "Order No: $orderNo , Items: ${salesHistoryItemsModel.orderItems?.length ?? 0} , Amount: ₹${salesHistoryItemsModel.amount?.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: salesHistoryItemsModel.orderItems?.length,
                  itemBuilder: (context, index) => Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: Colors.white,
                        boxShadow: [Utils.commonBoxShadow]),
                    margin:
                        EdgeInsets.symmetric(vertical: 5.w, horizontal: 20.w),
                    padding: EdgeInsets.symmetric(vertical: 10.w),
                    child: ListTile(
                      leading: Utils.networkImageNoCached(
                          imageUrl: "",
                          width: 50.w,
                          height: 50.w,
                          fit: BoxFit.cover),
                      title: Text(
                        salesHistoryItemsModel.orderItems?[index].productName ??
                            "",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15.sp),
                      ),
                      subtitle: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Qty : ",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Utils.linkColor),
                                  ),
                                  Text(
                                    "${salesHistoryItemsModel.orderItems?[index].productQty ?? "-"}",
                                    style: TextStyle(fontSize: 14.sp),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "M.R.P : ",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Utils.linkColor),
                                  ),
                                  Text(
                                    "₹${salesHistoryItemsModel.orderItems?[index].amount?.toStringAsFixed(2) ?? "-"}",
                                    style: TextStyle(fontSize: 14.sp),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Unit : ",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Utils.linkColor),
                                  ),
                                  Text(
                                    salesHistoryItemsModel
                                            .orderItems?[index].productUnit ??
                                        "-",
                                    style: TextStyle(fontSize: 14.sp),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "S.P : ",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Utils.linkColor),
                                  ),
                                  Text(
                                    "₹${salesHistoryItemsModel.orderItems?[index].productPrice ?? "-"}",
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
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              )
            ],
          ));
    });
  }
}

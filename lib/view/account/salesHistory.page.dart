import 'package:doozy/shared/core/repositries/provider.dart';
import 'package:doozy/shared/utils/constants.dart';
import 'package:doozy/shared/services/widgets/appbar.widget.dart';
import 'package:doozy/shared/services/widgets/datePicker.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SalesHistoryPage extends StatefulWidget {
  const SalesHistoryPage({super.key});

  @override
  State<SalesHistoryPage> createState() => _SalesHistoryPageState();
}

class _SalesHistoryPageState extends State<SalesHistoryPage> {
  setData() async {
    await Provider.of<GlobalProvider>(context, listen: false)
        .clearAnimatedListData();
    await Provider.of<GlobalProvider>(context, listen: false)
        .calculateTotalSalesAmountFunc();
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
        appBar: AppBarShared.appBarStyle(
            context,
            pro.appTlLanguage.isNotEmpty
                ? pro.appTlLanguage[3]
                : "Sales History",
            // toolbarHeight: 100,
            action: [const DateTimePickerWidget()]),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        pro.appTlLanguage.isNotEmpty
                            ? pro.appTlLanguage[13]
                            : "Month :",
                        style: TextStyle(fontSize: 16.sp),
                      ),
                      Text(
                        "  ${Utils.formatdateStamp("dd MMM yyyy", pro.salesHistStartDate)} to ${Utils.formatdateStamp("dd MMM yyyy", pro.salesHistEndDate)}",
                        style: TextStyle(
                            color: Utils.primaryPinkColor, fontSize: 16.sp),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            pro.appTlLanguage.isNotEmpty
                                ? pro.appTlLanguage[14]
                                : "Total Sales :  ",
                            style: TextStyle(fontSize: 16.sp),
                          ),
                          Text(
                            "  ${pro.totalMonthlySaleAmount.toStringAsFixed(2)}",
                            style: TextStyle(
                                color: Utils.primaryPinkColor, fontSize: 16.sp),
                          ),
                        ],
                      ),
                      GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            splashColor: Colors.transparent,
                                            title: const Text("Share as PDF"),
                                            onTap: () async {
                                              await Provider.of<GlobalProvider>(
                                                      context,
                                                      listen: false)
                                                  .shareSalesBillPdfFunc(pro
                                                      .animatedSalesListData);
                                              Navigator.pop(context);
                                            },
                                          ),
                                          const Divider(),
                                          ListTile(
                                            splashColor: Colors.transparent,
                                            title: const Text("Share as Image"),
                                            onTap: () async {
                                              await Provider.of<GlobalProvider>(
                                                      context,
                                                      listen: false)
                                                  .shareSalesBillImageFunc(pro
                                                      .animatedSalesListData);
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    ));
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Download ",
                                style: TextStyle(fontSize: 16.sp),
                              ),
                              Image.asset(
                                "assets/png/pdf.png",
                                width: 20.w,
                                height: 20.w,
                              ),
                            ],
                          ))
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              decoration: BoxDecoration(
                  color: const Color(0xffB4F6CE),
                  border: Border(
                      bottom: BorderSide(color: Colors.black, width: 2.w))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: Text(
                          pro.appTlLanguage.isNotEmpty
                              ? pro.appTlLanguage[15]
                              : "Order No.",
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: Text(
                          pro.appTlLanguage.isNotEmpty
                              ? pro.appTlLanguage[16]
                              : "Total Items",
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 24.w),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            pro.appTlLanguage.isNotEmpty
                                ? pro.appTlLanguage[17]
                                : "Total Amount",
                            style: TextStyle(
                                fontSize: 14.sp, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: pro.animatedSalesListData.length,
                    itemBuilder: (context, index) =>
                        salesHistoryCard(context, index)))
          ],
        ),
      );
    });
  }

  Widget salesHistoryCard(context, index) {
    return Consumer<GlobalProvider>(builder: (context, pro, child) {
      return GestureDetector(
        onTap: () => Navigator.pushNamed(context, "/orderHistoryPage",
            arguments: {
              "orderNo": index + 1,
              "model": pro.animatedSalesListData[index]
            }),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5.w),
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          color: Colors.white.withOpacity(0.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 50.w,
                    child: Text(
                      "${index + 1}",
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    width: 50.w,
                    child: Text(
                      "${pro.animatedSalesListData[index].orderItems?.length ?? 0}",
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    width: 150.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        pro.animatedSalesListData[index].amount != null
                            ? Text(
                                "₹${pro.animatedSalesListData[index].amount?.toStringAsFixed(2)}",
                                style: TextStyle(
                                  color: Utils.primaryGreenColor,
                                  fontSize: 15.sp,
                                ),
                              )
                            : Text(
                                "₹0.0",
                                style: TextStyle(
                                  color: Utils.primaryGreenColor,
                                  fontSize: 15.sp,
                                ),
                              ),
                        GestureDetector(
                          onTap: () {
                            var data = {
                              "data": {
                                "sale id": int.parse(
                                    pro.animatedSalesListData[index].saleId!)
                              }
                            };
                            pro.deleteBillFunc(context, index, data);
                          },
                          child: Icon(
                            Icons.delete,
                            size: 25.sp,
                            color: Colors.red.shade900,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              const Divider()
            ],
          ),
        ),
      );
    });
  }
}

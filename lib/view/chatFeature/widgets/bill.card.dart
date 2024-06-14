import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:doozy/shared/core/models/salesHistory.model.dart';
import 'package:doozy/shared/core/others/dataFormates.dart';
import 'package:doozy/shared/core/repositries/provider.dart';
import 'package:doozy/shared/utils/constants.dart';
import 'package:doozy/view/chatBot/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BillCardWidget extends StatefulWidget {
  final SalesHistoryItemsModel salesHistoryItemsModel;
  const BillCardWidget({super.key, required this.salesHistoryItemsModel});

  @override
  State<BillCardWidget> createState() => BillCardWidgetState();
}

class BillCardWidgetState extends State<BillCardWidget> {
  GlobalKey<BillCardWidgetState> saleBillKey = GlobalKey<BillCardWidgetState>();
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  bool _connected = false;
  List<BluetoothDevice> _devices = [];

  @override
  void initState() {
    super.initState();
    bluetoothPrint.startScan(timeout: const Duration(seconds: 6));
    bluetoothPrint.scanResults.listen((devices) {
      setState(() {
        _devices = devices;
      });
    });
  }

  void _connect(BluetoothDevice device) async {
    if (!_connected) {
      await bluetoothPrint.connect(device);
      bluetoothPrint.stopScan();
      setState(() {
        _connected = true;
      });
    }
  }

  void _disconnect() async {
    if (_connected) {
      await bluetoothPrint.disconnect();
      setState(() {
        _connected = false;
      });
    }
  }

  _printSample() async {
    GlobalProvider pro = Provider.of<GlobalProvider>(context, listen: false);
    String generateUPIQR(String upiId, double amount) {
      return 'upi://pay?pa=$upiId&am=$amount';
    }

    String link = generateUPIQR(CoreDataFormates.userModel.upi ?? "",
        widget.salesHistoryItemsModel.amount ?? 0.0);

    if (_connected) {
      Map<String, dynamic> config = {};
      List<LineText> list = [];
      list.add(
        LineText(
            type: LineText.TYPE_TEXT,
            content: CoreDataFormates.userModel.businessName ?? "",
            // "नमस्ते, यह एक हिंदी में मुद्रित बिल है।",
            //  pro.appTlLanguage.isNotEmpty
            //     ? pro.appTlLanguage[59]
            //     : CoreDataFormates.userModel.businessName ?? "",
            weight: 1,
            width: 1,
            linefeed: 1,
            align: LineText.ALIGN_CENTER),
      );
      list.add(
        LineText(
            type: LineText.TYPE_TEXT,
            content: "",
            weight: 1,
            linefeed: 1,
            align: LineText.ALIGN_CENTER),
      );

      list.add(
        LineText(
            type: LineText.TYPE_TEXT,
            linefeed: 1,
            align: LineText.ALIGN_CENTER,
            content: CoreDataFormates.userModel.businessAddress ?? ""
            // pro.appTlLanguage.isNotEmpty
            //     ? pro.appTlLanguage[60]
            //     : CoreDataFormates.userModel.businessAddress ?? ""

            ),
      );
      list.add(
        LineText(
            type: LineText.TYPE_TEXT,
            linefeed: 1,
            weight: 1,
            align: LineText.ALIGN_CENTER,
            content:
                "+${CoreDataFormates.userModel.phone?.substring(0, 2)} ${CoreDataFormates.userModel.phone?.substring(2)}"
            //  pro.appTlLanguage.isNotEmpty
            //     ? pro.appTlLanguage[61]
            //     : "+${CoreDataFormates.userModel.phone?.substring(0, 2)} ${CoreDataFormates.userModel.phone?.substring(2)}"

            ),
      );
      DateTime now = DateTime.now();

      String formattedDate = DateFormat('hh:mm a').format(now);

      list.add(
        LineText(
            type: LineText.TYPE_TEXT,
            linefeed: 1,
            align: LineText.ALIGN_CENTER,
            content:
                "Bill Date : ${Utils.formatdateStamp("dd/MM/yyyy", DateTime.now().toString())}, $formattedDate"

            //  pro.appTlLanguage.isNotEmpty
            //     ? pro.appTlLanguage[62]
            //     : "Bill Date : ${Utils.formatdateStamp("dd/MM/yyyy", DateTime.now().toString())}, ${Utils.formatTimeStamp("HH:mm a", DateTime.now().toString())}"

            ),
      );
      list.add(
        LineText(
            type: LineText.TYPE_TEXT,
            linefeed: 1,
            weight: 1,
            align: LineText.ALIGN_CENTER,
            content:
                "Total Items : ${widget.salesHistoryItemsModel.orderItems?.length ?? 0} "

            // pro.appTlLanguage.isNotEmpty
            //     ? "${pro.appTlLanguage[63]} ${widget.salesHistoryItemsModel.orderItems?.length ?? 0} "
            //     : "Total Items : ${widget.salesHistoryItemsModel.orderItems?.length ?? 0} "
            ),
      );
      list.add(
        LineText(
            type: LineText.TYPE_TEXT,
            content: "",
            weight: 1,
            linefeed: 1,
            align: LineText.ALIGN_CENTER),
      );
      int index = 0;
      for (var element in widget.salesHistoryItemsModel.orderItems ?? []) {
        index++;
        list.add(
          LineText(
              type: LineText.TYPE_TEXT,
              align: LineText.ALIGN_LEFT,
              linefeed: 1,
              weight: 1,
              content: "$index) ${element.productName} "),
        );
        // list.add(
        //   LineText(
        //       type: LineText.TYPE_TEXT,
        //       align: LineText.ALIGN_LEFT,
        //       linefeed: 1,
        //       content: "Qty : ${element.productQty}"
        //       // pro.appTlLanguage.isNotEmpty
        //       //     ? "${pro.appTlLanguage[52]} : ${element.productQty}"
        //       //     : "Qty : ${element.productQty}"

        //       ),
        // );
        list.add(
          LineText(
              type: LineText.TYPE_TEXT,
              align: LineText.ALIGN_LEFT,
              linefeed: 1,
              content: "   Qty : ${element.productQty} "

              // pro.appTlLanguage.isNotEmpty
              //     ? "${pro.appTlLanguage[53]} : ${element.productUnit}"
              //     : "Units : ${element.productUnit}"

              ),
        );
        list.add(
          LineText(
              type: LineText.TYPE_TEXT,
              align: LineText.ALIGN_LEFT,
              linefeed: 1,
              content: "   Units : ${element.productUnit} "

              // pro.appTlLanguage.isNotEmpty
              //     ? "${pro.appTlLanguage[53]} : ${element.productUnit}"
              //     : "Units : ${element.productUnit}"

              ),
        );
        list.add(
          LineText(
              type: LineText.TYPE_TEXT,
              align: LineText.ALIGN_LEFT,
              linefeed: 1,
              content: "   Amount : ${element.amount}"

              //  pro.appTlLanguage.isNotEmpty
              //     ? "${pro.appTlLanguage[67]} : ${element.amount}"
              //     : "Amount : ${element.amount}"

              ),
        );

        list.add(
          LineText(
              type: LineText.TYPE_TEXT,
              align: LineText.ALIGN_LEFT,
              linefeed: 1,
              content: ""),
        );
      }

      list.add(
        LineText(
            type: LineText.TYPE_TEXT,
            align: LineText.ALIGN_LEFT,
            linefeed: 1,
            weight: 1,
            content:
                "Total Amount : ${widget.salesHistoryItemsModel.amount ?? "0.0"}"

            //  pro.appTlLanguage.isNotEmpty
            //     ? "${pro.appTlLanguage[68]} : ${widget.salesHistoryItemsModel.amount ?? "0.0"}"
            //     : "Total Amount : ${widget.salesHistoryItemsModel.amount ?? "0.0"}"

            ),
      );
      list.add(
        LineText(
            type: LineText.TYPE_TEXT,
            align: LineText.ALIGN_LEFT,
            linefeed: 1,
            content: ""),
      );
      list.add(
        LineText(
          type: LineText.TYPE_QRCODE,
          align: LineText.ALIGN_CENTER,
          width: 30,
          content: link,
        ),
      );
      list.add(
        LineText(
            type: LineText.TYPE_TEXT,
            align: LineText.ALIGN_LEFT,
            linefeed: 1,
            content: ""),
      );

      list.add(
        LineText(
            type: LineText.TYPE_TEXT,
            align: LineText.ALIGN_RIGHT,
            linefeed: 1,
            size: 2,
            weight: 1,
            content: "Powered by ChotuAI"

            // pro.appTlLanguage.isNotEmpty
            //     ? " ${pro.appTlLanguage[58]} Doozy "
            //     : "Powered by Doozy"

            ),
      );
      list.add(
        LineText(
            type: LineText.TYPE_TEXT,
            align: LineText.ALIGN_LEFT,
            linefeed: 1,
            content: ""),
      );
      await bluetoothPrint.printReceipt({}, list);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: saleBillKey,
      child: Consumer<GlobalProvider>(builder: (context, pro, child) {
        return chatTile(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListView.builder(
                padding: EdgeInsets.symmetric(
                    vertical:
                        widget.salesHistoryItemsModel.orderItems!.isNotEmpty
                            ? 15
                            : 0),
                itemCount: widget.salesHistoryItemsModel.orderItems?.length,
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
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        widget.salesHistoryItemsModel.orderItems![itemIndex]
                                .productName ??
                            "",
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
                                        fontSize: 14.sp,
                                        color: Utils.linkColor),
                                  ),
                                  Text(
                                    " ${widget.salesHistoryItemsModel.orderItems![itemIndex].productQty ?? ""}",
                                    style: TextStyle(fontSize: 14.sp),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 140.w,
                                child: Row(
                                  children: [
                                    Text(
                                      pro.appTlLanguage.isNotEmpty
                                          ? "${pro.appTlLanguage[50]} : "
                                          : "M.R.P :",
                                      style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Utils.linkColor),
                                    ),
                                    Flexible(
                                      child: Text(
                                        " ₹${widget.salesHistoryItemsModel.orderItems![itemIndex].amount?.toStringAsFixed(2) ?? ""}",
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
                                  pro.appTlLanguage.isNotEmpty
                                      ? "${pro.appTlLanguage[53]} : "
                                      : "Unit :",
                                  style: TextStyle(
                                      fontSize: 14.sp, color: Utils.linkColor),
                                ),
                                Text(
                                  " ${widget.salesHistoryItemsModel.orderItems![itemIndex].productUnit ?? ""}",
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 140.w,
                              child: Row(
                                children: [
                                  Text(
                                    pro.appTlLanguage.isNotEmpty
                                        ? "${pro.appTlLanguage[51]} : "
                                        : "S.P : ",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Utils.linkColor),
                                  ),
                                  Text(
                                    "₹${widget.salesHistoryItemsModel.orderItems![itemIndex].productPrice?.toStringAsFixed(2) ?? " ${widget.salesHistoryItemsModel.orderItems![itemIndex].amount?.toStringAsFixed(2) ?? ""}"}",
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
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        pro.appTlLanguage.isNotEmpty
                            ? pro.appTlLanguage[17]
                            : "Total Amount :",
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: Utils.linkColor,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "  ₹${widget.salesHistoryItemsModel.amount?.toStringAsFixed(2)} ",
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ],
                  ),
                  Row(children: [
                    IconButton(
                        onPressed: () async {
                          bluetoothPrint.startScan(
                              timeout: const Duration(seconds: 6));
                          bluetoothPrint.scanResults.listen((devices) async {
                            setState(() {
                              _devices = devices;
                            });
                          });
                          await showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                    child: _devices.isEmpty
                                        ? Padding(
                                            padding: EdgeInsets.all(10.w),
                                            child: Text(
                                                textAlign: TextAlign.center,
                                                pro.appTlLanguage.isNotEmpty
                                                    ? pro.appTlLanguage[74]
                                                    : "Bluetooth devices not found,\n Please tap and try again"),
                                          )
                                        : ListView.builder(
                                            itemCount: _devices.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) =>
                                                ListTile(
                                              leading: const Icon(Icons.print),
                                              title: Text(
                                                  _devices[index].name ?? ""),
                                              onTap: () async {
                                                bluetoothPrint.startScan(
                                                    timeout: const Duration(
                                                        seconds: 5));
                                                bluetoothPrint.scanResults
                                                    .listen((devices) {
                                                  setState(() {
                                                    _devices = devices;
                                                  });
                                                });
                                                _connect(_devices[index]);

                                                if (_connected) {
                                                  _printSample();
                                                }
                                              },
                                            ),
                                          ),
                                  ));
                        },
                        icon: const Icon(Icons.print_outlined)),
                    IconButton(
                        onPressed: () => showDialog(
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
                                              .shareBillPdfFunc(widget
                                                  .salesHistoryItemsModel);
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
                                              .shareBillImageFunc(widget
                                                  .salesHistoryItemsModel);
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                )),
                        icon: const Icon(Icons.ios_share_outlined)),
                  ]),
                ],
              ),
            )
          ],
        ));
      }),
    );
  }
}

// class ShowAvailableBluetoothDevice extends StatefulWidget {
//   final SalesHistoryItemsModel salesHistoryItemsModel;
//   const ShowAvailableBluetoothDevice({
//     super.key,
//     required this.salesHistoryItemsModel,
//   });

//   @override
//   State<ShowAvailableBluetoothDevice> createState() =>
//       _ShowAvailableBluetoothDeviceState();
// }

// class _ShowAvailableBluetoothDeviceState
//     extends State<ShowAvailableBluetoothDevice> {
//   BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
//   bool _connected = false;
//   List<BluetoothDevice> _devices = [];

//   @override
//   void initState() {
//     super.initState();
//     bluetoothPrint.startScan(timeout: Duration(seconds: 2));
//     bluetoothPrint.scanResults.listen((devices) {
//       setState(() {
//         _devices = devices;
//       });
//     });
//   }

//   void _connect(BluetoothDevice device) async {
//     if (!_connected) {
//       await bluetoothPrint.connect(device);
//       setState(() {
//         _connected = true;
//       });
//     }
//   }

//   void _disconnect() async {
//     if (_connected) {
//       await bluetoothPrint.disconnect();
//       setState(() {
//         _connected = false;
//       });
//     }
//   }

//   void _printSample() async {
//     if (_connected) {
//       List<LineText> list = [];
//       list.add(LineText(
//           type: LineText.TYPE_TEXT,
//           content: "Hello Bluetooth Printer!",
//           weight: 1,
//           align: LineText.ALIGN_CENTER,
//           linefeed: 1));
//       await bluetoothPrint.printReceipt({}, list);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<GlobalProvider>(builder: (context, pro, child) {
//       return Dialog(
//         child: ListView.builder(
//           itemCount: pro.blueToothdevicesList.length,
//           shrinkWrap: true,
//           itemBuilder: (context, index) => ListTile(
//             leading: Icon(Icons.print),
//             title: Text(pro.blueToothdevicesList[index].name ?? ""),
//             onTap: () async {
//               await pro.setCurrentBTDevice(pro.blueToothdevicesList[index]);
//               await pro.printPdfViaBluetooth(pro.blueToothdevicesList[index],
//                   widget.salesHistoryItemsModel);
//             },
//           ),
//         ),
//       );
//     });
//   }
// }

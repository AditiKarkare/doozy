import 'dart:async';
import 'package:doozy/shared/core/models/audioProduct.model.dart';
import 'package:doozy/shared/core/others/dataFormates.dart';
import 'package:doozy/shared/core/repositries/provider.dart';
import 'package:doozy/shared/services/inputFormatter.dart';
import 'package:doozy/shared/services/widgets/customToast.widget.dart';
import 'package:doozy/shared/services/widgets/dialogs.widget.dart';
import 'package:doozy/shared/services/widgets/staticDropdown.widget.dart';
import 'package:doozy/shared/utils/constants.dart';
import 'package:doozy/view/chatBot/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SalesResponsePageList extends StatefulWidget {
  final List<AudioProductModel> productList;
  // final int modelIndex;
  const SalesResponsePageList({
    super.key,
    required this.productList,
    //  required this.modelIndex
  });

  @override
  State<SalesResponsePageList> createState() => _SalesResponsePageListState();
}

class _SalesResponsePageListState extends State<SalesResponsePageList> {
  List<AudioProductModel> productList = [];
  Timer? _timer;

  // int modelIndex = 0;

  @override
  void initState() {
    // modelIndex = widget.modelIndex;
    productList = widget.productList;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProvider>(builder: (context, pro, child) {
      return chatTile(
        child: Padding(
          padding:
              EdgeInsets.symmetric(vertical: productList.isNotEmpty ? 15 : 0),
          child: Column(
            children: [
              ListView.builder(
                  itemCount: productList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, itemIndex) {
                    return SalesResponseCard(
                        audioProductModel: productList[itemIndex],
                        // modelIndex: modelIndex,
                        itemIndex: itemIndex);
                  }),
              productList.isNotEmpty
                  ? SizedBox(
                      height: 20.h,
                    )
                  : const SizedBox.shrink(),
              productList.isNotEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Row(
                        children: [
                          Flexible(
                            child: elevatedBtn(
                                lable: pro.appTlLanguage.isNotEmpty
                                    ? pro.appTlLanguage[57]
                                    : "CREATE BILL",
                                onPressed: pro.isBillCreating == true
                                    ? () {}
                                    : () async {
                                        // pro.changeIsBillCreating(true);
                                        // (true);
                                        List<AudioProductModel> tempList = [];
                                        for (var element in productList) {
                                          if (element.productQty == null ||
                                                  element.productQty == 0 ||
                                                  element.amount == null ||
                                                  element.amount == 0 ||
                                                  element.amount == 0.0
                                              // ||

                                              // element.productPrice == null ||
                                              // element.productPrice == 0

                                              ) {
                                            pro.changereadyToCreateBill(false);
                                          } else {
                                            pro.changereadyToCreateBill(true);
                                          }
                                          bool doesNotMatch = CoreDataFormates
                                              .productUnitList
                                              .every((value) =>
                                                  value != element.productUnit);
                                          if (element.productUnit == null ||
                                              doesNotMatch) {
                                            element.productUnit = "Oth";
                                            tempList.add(element);
                                          } else {
                                            tempList.add(element);
                                          }
                                        }

                                        if (pro.readyToCreateBill == false) {
                                          _timer = Timer.periodic(
                                              const Duration(seconds: 1),
                                              (timer) {
                                            print("object");
                                            borderColor =
                                                borderColor == Colors.black
                                                    ? Utils.primaryPinkColor
                                                    : Colors.black;
                                            setState(() {});
                                          });
                                        } else {
                                          _timer?.cancel();
                                        }

                                        pro.readyToCreateBill == true
                                            ? await pro
                                                .createBillSalesResponseFunc(
                                                context: context,
                                                productList: tempList,
                                              )
                                            : null;
                                      },
                                backgroundColor: WidgetStatePropertyAll(
                                    Utils.primaryGreenColor)),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Flexible(
                            child: elevatedBtn(
                                lable: pro.appTlLanguage.isNotEmpty
                                    ? pro.appTlLanguage[55]
                                    : "CANCEL",
                                onPressed: () async {
                                  confirmDialog(
                                      context,
                                      pro.appTlLanguage.isNotEmpty
                                          ? pro.appTlLanguage[73]
                                          : "Are you sure, want to delete  \nall products?",
                                      () async {
                                    pro.changereadyToCreateBill(true);
                                    pro.clearResponseList(
                                        type: pro.toggleState);
                                    Navigator.pop(context);
                                  },
                                      pro.appTlLanguage.isNotEmpty
                                          ? pro.appTlLanguage[71]
                                          : "Yes",
                                      pro.appTlLanguage.isNotEmpty
                                          ? pro.appTlLanguage[72]
                                          : "No");
                                },
                                backgroundColor: WidgetStatePropertyAll(
                                    Utils.primaryPinkColor)),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink()
            ],
          ),
        ),
      );
    });
  }

  Widget elevatedBtn(
      {required String lable,
      required void Function()? onPressed,
      required WidgetStateProperty<Color?> backgroundColor}) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(backgroundColor: backgroundColor),
        child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              lable,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500),
            )));
  }
}

GlobalKey<SalesResponseCardState> billCardKey =
    GlobalKey<SalesResponseCardState>();

class SalesResponseCard extends StatefulWidget {
  final AudioProductModel audioProductModel;

  final int itemIndex;
  const SalesResponseCard(
      {super.key, required this.audioProductModel, required this.itemIndex});

  @override
  State<SalesResponseCard> createState() => SalesResponseCardState();
}

class SalesResponseCardState extends State<SalesResponseCard> {
  AudioProductModel audioProductModel = AudioProductModel();
  TextEditingController labelCont = TextEditingController();
  TextEditingController qtyCont = TextEditingController();
  TextEditingController unitCont = TextEditingController();
  TextEditingController priceCont = TextEditingController();
  TextEditingController sellingPriceCont = TextEditingController();
  String unitName = "";
  int itemIndex = 0;
  int index = 0;

  List<int> alreadyCalculatedList = [];
  // bool caneditfalse = false;

//Type 0 - Loose product , 1 - brand product
  setPrice(
      {required int type, required String? qty, required String? price}) async {
    num result = int.parse(qty ?? "0") * double.parse(price ?? "0");
    if (type == 0) {
      priceCont = TextEditingController(text: result.toString());
      sellingPriceCont = TextEditingController(text: result.toString());
      audioProductModel.amount = double.parse(priceCont.text);
      audioProductModel.productPrice = double.parse(sellingPriceCont.text);
    } else {
      priceCont = TextEditingController(text: result.toString());
      sellingPriceCont = TextEditingController(text: result.toString());
      audioProductModel.amount = double.parse(priceCont.text);
      audioProductModel.productPrice = double.parse(sellingPriceCont.text);
    }
  }

  setData() async {
    audioProductModel = widget.audioProductModel;
    labelCont = TextEditingController(text: audioProductModel.productName);
    qtyCont = TextEditingController(
        text: audioProductModel.productQty.toString() == "null"
            ? "0"
            : audioProductModel.productQty.toString());
    if (CoreDataFormates.productUnitList
        .contains(audioProductModel.productUnit)) {
      unitName = audioProductModel.productUnit ?? "Oth";
    } else {
      unitName = "Oth";
    }
    setPrice(
        type: audioProductModel.gtin == null ? 0 : 1,
        qty: audioProductModel.productQty.toString() == "null"
            ? "0"
            : audioProductModel.productQty.toString(),
        price: audioProductModel.amount.toString() == "null"
            ? audioProductModel.productPrice?.toStringAsFixed(2)
            : audioProductModel.amount?.toStringAsFixed(2));
  }

  @override
  void initState() {
    itemIndex = widget.itemIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProvider>(builder: (context, pro, child) {
      index++;
      alreadyCalculatedList.add(index);
      for (var i = index; i == index; i++) {
        pro.isSalesResponseEdit == false ? setData() : null;
      }
      return Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 13.h),
              child: Text(
                "${itemIndex + 1}) ",
                style: TextStyle(fontSize: 14.sp, color: Utils.linkColor),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Flexible(
                child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: TextFormField(
                            controller: labelCont,
                            readOnly:
                                audioProductModel.gtin == null ? false : true,
                            textInputAction: TextInputAction.done,
                            onTap: () {
                              pro.changeisSalesResponseEdit(true);
                            },
                            onChanged: (value) async {
                              labelCont.text = value;
                              audioProductModel.productName = labelCont.text;
                              setState(() {});
                            },
                          )),
                    ),
                    IconButton(
                        onPressed: () {
                          confirmDialog(
                              context,
                              pro.appTlLanguage.isNotEmpty
                                  ? "${pro.appTlLanguage[70]} ${audioProductModel.productName} ?"
                                  : "Are you sure, want to delete ${audioProductModel.productName} ? ",
                              () async {
                            pro.changeisSalesResponseEdit(false);
                            setState(() {});
                            Utils().hideKeyboard(context);
                            pro.appTlLanguage.isNotEmpty
                                ? showToast(context,
                                    "${audioProductModel.productName} ${pro.appTlLanguage[46]}")
                                : showToast(context,
                                    "${audioProductModel.productName} removed sucessfully");
                            pro.removeItemFromSalesResponseList(itemIndex);
                            Utils().hideKeyboard(context);
                            Navigator.pop(context);
                          },
                              pro.appTlLanguage.isNotEmpty
                                  ? pro.appTlLanguage[71]
                                  : "Yes",
                              pro.appTlLanguage.isNotEmpty
                                  ? pro.appTlLanguage[72]
                                  : "No");
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red.shade900,
                        ))
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 100.w,
                      child: TextFormField(
                        controller: qtyCont,
                        textInputAction: TextInputAction.done,
                        onTap: () {
                          pro.changeisSalesResponseEdit(true);
                        },
                        onChanged: (value) {
                          qtyCont.text = value;
                          audioProductModel.productQty =
                              int.parse(qtyCont.text);
                          setState(() {});
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d{0,2}')),
                          DecimalInputFormatter(maxDecimals: 2),
                        ],
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: (qtyCont.text == "0" ||
                                            qtyCont.text == "") &&
                                        pro.readyToCreateBill == false
                                    ? borderColor
                                    : Colors.transparent,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: (qtyCont.text == "0" ||
                                            qtyCont.text == "" ||
                                            qtyCont.text == "0.0") &&
                                        pro.readyToCreateBill == false
                                    ? borderColor
                                    : Colors.transparent,
                              ),
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(top: 10, left: 10),
                              child: Text(
                                pro.appTlLanguage.isNotEmpty
                                    ? "${pro.appTlLanguage[52]} :  "
                                    : "Qty :",
                                style: TextStyle(
                                    fontSize: 14.sp, color: Utils.linkColor),
                              ),
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Expanded(
                        child: TextFormField(
                      controller: priceCont,
                      readOnly: audioProductModel.gtin == null ? false : true,
                      textInputAction: TextInputAction.done,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        EightDigitNumberFormatter(),
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        // FilteringTextInputFormatter.allow(
                        //     RegExp(r'^\d*\.?\d{0,2}')),
                        // DecimalInputFormatter(maxDecimals: 2),
                      ],
                      onChanged: (value) {
                        priceCont.text = value;
                        if (RegExp(r'^\d+$').hasMatch(value)) {
                          audioProductModel.amount =
                              int.parse(priceCont.text).toDouble();
                          setState(() {});
                        } else if (RegExp(r'^\d+\.\d{1}$').hasMatch(value)) {
                          audioProductModel.amount =
                              double.parse(priceCont.text);
                          setState(() {});
                        } else if (RegExp(r'^\d+\.\d{2}$').hasMatch(value)) {
                          audioProductModel.amount =
                              double.parse(priceCont.text);
                          setState(() {});
                        } else if (value == "") {
                          audioProductModel.amount = 0;
                          setState(() {});
                        }
                      },
                      onTap: () {
                        pro.changeisSalesResponseEdit(true);

                        priceCont.selection = TextSelection(
                            baseOffset: 0, extentOffset: priceCont.text.length);
                      },
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: (priceCont.text == "0" ||
                                          priceCont.text == "") &&
                                      pro.readyToCreateBill == false
                                  ? borderColor
                                  : Colors.transparent,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: (priceCont.text == "0" ||
                                          priceCont.text == "" ||
                                          priceCont.text == "0.0") &&
                                      pro.readyToCreateBill == false
                                  ? borderColor
                                  : Colors.transparent,
                            ),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(top: 10, left: 10),
                            child: Text(
                              pro.appTlLanguage.isNotEmpty
                                  ? "${pro.appTlLanguage[50]} : "
                                  : "M.R.P : ",
                              style: TextStyle(
                                  fontSize: 14.sp, color: Utils.linkColor),
                            ),
                          )),
                    )),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 100.w,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10.w),
                        child: staticDropDown(
                          context,
                          labelText: "",
                          dropdownvalue: unitName,
                          list: CoreDataFormates.productUnitList,
                          onCallBack: (p0) {
                            unitName = p0!;
                            audioProductModel.productUnit = unitName;
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Expanded(
                        child: TextFormField(
                      controller: sellingPriceCont,
                      textInputAction: TextInputAction.done,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        EightDigitNumberFormatter(),
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                        // FilteringTextInputFormatter.allow(
                        //     RegExp(r'^\d*\.?\d{0,2}')),
                        // DecimalInputFormatter(maxDecimals: 2),
                      ],
                      onTap: () {
                        pro.changeisSalesResponseEdit(true);
                        sellingPriceCont.selection = TextSelection(
                            baseOffset: 0,
                            extentOffset: sellingPriceCont.text.length);
                      },
                      onChanged: (value) {
                        sellingPriceCont.text = value;

                        if (RegExp(r'^\d+$').hasMatch(value)) {
                          audioProductModel.productPrice =
                              int.parse(sellingPriceCont.text).toDouble();
                          setState(() {});
                        } else if (RegExp(r'^\d+\.\d{1}$').hasMatch(value)) {
                          audioProductModel.productPrice =
                              double.parse(sellingPriceCont.text).toDouble();
                          setState(() {});
                        } else if (RegExp(r'^\d+\.\d{2}$').hasMatch(value)) {
                          audioProductModel.productPrice =
                              double.parse(sellingPriceCont.text);
                          setState(() {});
                        }
                      },
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: (sellingPriceCont.text == "0" ||
                                          sellingPriceCont.text == "") &&
                                      pro.readyToCreateBill == false
                                  ? Colors.transparent
                                  : Colors.transparent,
                            ),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(top: 10, left: 10),
                            child: Text(
                              pro.appTlLanguage.isNotEmpty
                                  ? "${pro.appTlLanguage[51]} : "
                                  : "S.P :",
                              style: TextStyle(
                                  fontSize: 14.sp, color: Utils.linkColor),
                            ),
                          )),
                    )),
                  ],
                )
              ],
            )),
          ],
        ),
      );
    });
  }
}

// bool _isFocused = false;

Color borderColor = Colors.black;

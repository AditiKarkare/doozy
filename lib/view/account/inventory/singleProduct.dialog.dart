import 'package:doozy/shared/core/models/audioProduct.model.dart';
import 'package:doozy/shared/core/others/dataFormates.dart';
import 'package:doozy/shared/core/repositries/provider.dart';
import 'package:doozy/shared/services/inputFormatter.dart';
import 'package:doozy/shared/utils/constants.dart';
import 'package:doozy/shared/services/widgets/customToast.widget.dart';
import 'package:doozy/shared/services/widgets/staticDropdown.widget.dart';
import 'package:doozy/shared/services/widgets/textformfield.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SingleProductDialogWidget extends StatefulWidget {
  final Function(bool) canEditCallBackFunc;
  final bool isSearchCard;
  final int invSearchItemIndex;
  final AudioProductModel audioProductModel;
  const SingleProductDialogWidget(
      {super.key,
      required this.audioProductModel,
      this.isSearchCard = false,
      this.invSearchItemIndex = 0,
      required this.canEditCallBackFunc});

  @override
  State<SingleProductDialogWidget> createState() =>
      _SingleProductDialogWidgetState();
}

class _SingleProductDialogWidgetState extends State<SingleProductDialogWidget> {
  AudioProductModel audioProductModel = AudioProductModel();
  TextEditingController mrpCont = TextEditingController();
  TextEditingController nameCont = TextEditingController();
  TextEditingController spCont = TextEditingController();
  int quantity = 0;
  String unitName = "";
  int unitId = 0;

  setData() {
    mrpCont = TextEditingController(
        text: audioProductModel.amount?.toStringAsFixed(0));
    nameCont = TextEditingController(text: audioProductModel.productName);
    spCont = TextEditingController(
        text: audioProductModel.productPrice?.toStringAsFixed(0));
    quantity = audioProductModel.productQty ?? 0;
    unitName = audioProductModel.productUnit ?? "Oth";
  }

  @override
  void initState() {
    audioProductModel = widget.audioProductModel;
    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProvider>(builder: (context, pro, child) {
      return Dialog(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () async {
                          var data = {"inv id": audioProductModel.id};
                          pro.deleteInvSearchItemFunc(
                              widget.invSearchItemIndex);
                          pro.deleteItemInventory(context, data);
                          widget.canEditCallBackFunc(true);
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.delete,
                          size: 30.sp,
                          color: Colors.red.shade800,
                        ))
                  ],
                ),
                Center(
                  child: SizedBox(
                    width: 60.w,
                    height: 60.w,
                    child: Utils.networkImageNoCached(
                        imageUrl: "", fit: BoxFit.cover),
                  ),
                ),
                roundedTextFormField(
                  context,
                  labelText: pro.appTlLanguage.isNotEmpty
                      ? pro.appTlLanguage[50]
                      : "M.R.P",
                  keyboardType: TextInputType.number,
                  hintText: "Enter mrp here..",
                  controller: mrpCont,
                  enabled: false,
                  prefix: Icon(
                    Icons.currency_rupee_rounded,
                    size: 16.sp,
                  ),
                  textInputAction: TextInputAction.done,
                  onChanged: (value) {
                    mrpCont.text = value!;
                    setState(() {});
                  },
                ),
                roundedTextFormField(
                  context,
                  labelText: pro.appTlLanguage.isNotEmpty
                      ? pro.appTlLanguage[51]
                      : "S.P",
                  hintText: "Enter store price here..",
                  keyboardType: TextInputType.number,
                  controller: spCont,
                  inputFormatters: [
                    // CustomNumberTextInputFormatter()
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}')),
                    DecimalInputFormatter(maxDecimals: 2),
                  ],
                  prefix: Icon(
                    Icons.currency_rupee_rounded,
                    size: 16.sp,
                  ),
                  textInputAction: TextInputAction.done,
                  onChanged: (value) {
                    spCont.text = value!;

                    if (RegExp(r'^\d+$').hasMatch(value)) {
                      audioProductModel.amount =
                          int.parse(spCont.text).toDouble();
                      setState(() {});
                    } else if (RegExp(r'^\d+\.\d{1}$').hasMatch(value)) {
                      audioProductModel.amount = double.parse(spCont.text);
                      setState(() {});
                    } else if (RegExp(r'^\d+\.\d{2}$').hasMatch(value)) {
                      audioProductModel.amount = double.parse(spCont.text);
                      setState(() {});
                    } else if (value == "") {
                      audioProductModel.amount = 0;
                      setState(() {});
                    }
                  },
                ),
                SizedBox(height: 15.h),
                Row(
                  children: [
                    Text(
                      pro.appTlLanguage.isNotEmpty
                          ? pro.appTlLanguage[52]
                          : 'Quantity:',
                      style: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w500),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.remove_circle,
                            size: 30.sp,
                            color: Utils.primaryPinkColor,
                          ),
                          onPressed: _decrement,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(color: Colors.black)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Text(
                            quantity.toString(),
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.add_circle_sharp,
                            color: Utils.primaryGreenColor,
                            size: 30.sp,
                          ),
                          onPressed: _increment,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                SizedBox(
                  width: 76.w,
                  child: staticDropDown(
                    context,
                    labelText: pro.appTlLanguage.isNotEmpty
                        ? pro.appTlLanguage[53]
                        : "Units",
                    dropdownvalue: unitName,
                    enabled: false,
                    list: CoreDataFormates.productUnitList,
                    onCallBack: (p0) {
                      unitName = p0!;
                      setState(() {});
                    },
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Center(
                    child: SizedBox(
                  width: 150.w,
                  child: ElevatedButton(
                      onPressed: () async {
                        var data = {
                          "inv id": audioProductModel.id?.toInt(),
                          // "PRODUCT ID": audioProductModel.productId?.toInt(),
                          "PRODUCT QTY": quantity.toInt(),
                          // "PRODUCT UNIT": unitName,
                          "PRODUCT AMOUNT": spCont.text != ""
                              ? double.parse(spCont.text)
                              : null,
                          // 'PRODUCT AMOUNT': mrpCont.text != ""
                          //     ? int.parse(mrpCont.text).toDouble()
                          //     : null,
                        };

                        if (quantity > 0 && double.parse(spCont.text) > 0) {
                          if (widget.isSearchCard == true) {
                            var replaceData = {
                              "inv id": audioProductModel.id?.toInt(),
                              "PRODUCT NAME": audioProductModel.productName,
                              "PRODUCT ID":
                                  audioProductModel.productId?.toInt(),
                              "PRODUCT QTY": quantity,
                              "PRODUCT UNIT": unitName,
                              "PRODUCT SP": double.parse(spCont.text),
                              'PRODUCT AMOUNT': double.parse(mrpCont.text),
                            };

                            Map<String, dynamic> result;
                            result = pro.replaceAndCombine(
                                replaceData, "PRODUCT QTY", quantity.toInt());
                            result = pro.replaceAndCombine(
                                replaceData,
                                "PRODUCT AMOUNT",
                                spCont.text != ""
                                    ? double.parse(spCont.text)
                                    : null);

                            pro.replaceInvSearchItemFunc(
                                result, widget.invSearchItemIndex);

                            setData();
                          }
                          await Provider.of<GlobalProvider>(context,
                                  listen: false)
                              .updateItemInventory(context, data);
                          widget.canEditCallBackFunc(true);

                          Navigator.pop(context);
                          pro.appTlLanguage.isNotEmpty
                              ? showToast(context, pro.appTlLanguage[42])
                              : showToast(context, "Item updated sucessfully");
                        } else {
                          pro.appTlLanguage.isNotEmpty
                              ? showToast(context, pro.appTlLanguage[78])
                              : showToast(context,
                                  "Quanity and Store price cannot be 0 or less than 0");
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(Utils.primaryGreenColor)),
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 10.w),
                        child: Text(
                          pro.appTlLanguage.isNotEmpty
                              ? pro.appTlLanguage[25]
                              : "SAVE",
                          style: TextStyle(
                              fontSize: 17.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      )),
                ))
              ]),
        ),
      );
    });
  }

  void _increment() {
    setState(() {
      quantity++;
    });
  }

  void _decrement() {
    if (quantity > 0) {
      setState(() {
        quantity--;
      });
    }
  }
}

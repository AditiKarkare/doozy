import 'package:doozy/shared/core/dio/endpoints.dart';
import 'package:doozy/shared/core/models/audioProduct.model.dart';
import 'package:doozy/shared/core/others/dataFormates.dart';
import 'package:doozy/shared/core/repositries/provider.dart';
import 'package:doozy/shared/utils/constants.dart';
import 'package:doozy/shared/services/widgets/animatedList.widget.dart';
import 'package:doozy/shared/services/widgets/appbar.widget.dart';
import 'package:doozy/shared/services/widgets/textformfield.widget.dart';
import 'package:doozy/view/account/inventory/singleProduct.dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  int filterIndex = 0;
  TextEditingController searchCont = TextEditingController();
  GlobalKey<CustomAnimatedListState> key = GlobalKey<CustomAnimatedListState>();

  @override
  void initState() {
    Provider.of<GlobalProvider>(context, listen: false)
        .changeInveSearchFunc(false);
    Provider.of<GlobalProvider>(context, listen: false)
        .searchInventoryProduct(searchName: "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProvider>(builder: (context, pro, child) {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBarShared.appBarStyle(context, "",
              showLeading: false,
              toolbarHeight: 200,
              titleWidget: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back)),
                      Text(pro.appTlLanguage.isNotEmpty
                          ? pro.appTlLanguage[6]
                          : "Inventory"),
                      SizedBox(
                        width: 50.w,
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: roundedTextFormField(context,
                        fillColor: Colors.white,
                        prefix: Icon(
                          Icons.manage_search_sharp,
                          size: 30.sp,
                        ),
                        controller: searchCont,
                        suffixIcon: IconButton(
                            onPressed: () async {
                              Utils().hideKeyboard(context);
                              await pro.searchInventoryProduct(
                                  searchName: searchCont.text);
                            },
                            color: Utils.primaryPinkColor,
                            icon: const Icon(Icons.search)),
                        onFieldSubmitted: (value) async {
                      Utils().hideKeyboard(context);
                      await pro.searchInventoryProduct(
                          searchName: searchCont.text);
                      if (value == "") {
                        pro.changeInveSearchFunc(false);
                      }
                    },
                        hintText: pro.appTlLanguage.isNotEmpty
                            ? pro.appTlLanguage[7]
                            : "Search product name here..."),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: pro.tlInventroyFilter.isNotEmpty
                          ? pro.tlInventroyFilter.length
                          : CoreDataFormates.filterList.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: filterIndex == index
                                    ? WidgetStatePropertyAll(
                                        Utils.primaryGreenColor)
                                    : WidgetStatePropertyAll(Utils.greyColor)),
                            onPressed: () async {
                              pro.setInvFilterIndexFunc(index);
                              pro.applyInvFilterFunc();
                              filterIndex = index;
                              setState(() {});
                            },
                            child: Text(
                                pro.tlInventroyFilter.isNotEmpty
                                    ? pro.tlInventroyFilter[index]
                                    : CoreDataFormates.filterList
                                        .elementAt(index),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.sp))),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              )),
          body: Stack(children: [
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                        "assets/png/bg.png",
                      ))),
            ),
            pro.invFilterList.isNotEmpty
                ? (ListView.builder(
                    itemCount: pro.invFilterList.length,
                    padding: EdgeInsets.symmetric(vertical: 10.w),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => filterInventoryCard(
                        pro.invFilterList[index], context, index)))
                : (pro.isSearchResponseNull == false
                    ? (pro.isInvSearching == true
                        ? (pro.issearchInvDataLoading == true
                            ? (pro.appLangCode == "en"
                                ? Center(
                                    child: Image.asset(
                                        "assets/json/englishLoader.gif"))
                                : pro.appLangCode == "mr"
                                    ? Center(
                                        child: Image.asset(
                                            "assets/json/marathiLoader.gif"))
                                    : Center(
                                        child: Image.asset(
                                            "assets/json/hindiLoader.gif")))
                            : ListView.builder(
                                itemCount: pro.invSearchList.length,
                                padding: EdgeInsets.symmetric(vertical: 10.w),
                                shrinkWrap: true,
                                itemBuilder: (context, index) =>
                                    searchInventoryCard(
                                        pro.invSearchList[index],
                                        context,
                                        index)))
                        : CustomAnimatedList(
                            key: key,
                            cardFunction: inventoryCard,
                            endpoint: DioEndpoints.fetchInventory,
                            noDataImage: "assets/svg/noData.svg",
                            noDataMessage:
                                "Your inventory is empty.. \nPlease add products by tapping on below button",
                            loadingWidget: "assets/json/englishLoader.gif",
                            noDataTitle: "NO PRODUCT FOUND",
                            noDataExtraWidget: Padding(
                              padding: EdgeInsets.only(top: 10.h),
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                          Utils.primaryPinkColor)),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    pro.changeToggleState(1);
                                  },
                                  child: const Text(
                                    "ADD INVENTORY",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                          ))
                    : (CoreDataFormates.userModel.appLangCode == "en"
                        ? Center(child: Image.asset("assets/png/engNd.png"))
                        : CoreDataFormates.userModel.appLangCode == "mr"
                            ? Center(
                                child: Image.asset("assets/png/marathiNd.png"))
                            : Center(
                                child: Image.asset("assets/png/hindiNd.png"),
                              )))
          ]));
    });
  }

  Widget inventoryCard(dynamic, context, index) {
    bool canRefresh = false;
    AudioProductModel audioProductModel = AudioProductModel.fromJson(dynamic);
    return Consumer<GlobalProvider>(builder: (context, pro, child) {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: Colors.white,
            boxShadow: [Utils.commonBoxShadow]),
        margin: EdgeInsets.symmetric(vertical: 5.w, horizontal: 20.w),
        child: ListTile(
          leading: Utils.networkImageNoCached(
              imageUrl: "", width: 50.w, height: 80.w, fit: BoxFit.fill),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  " ${audioProductModel.productName}",
                  style:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: 15.sp),
                ),
              ),
              IconButton(
                  onPressed: () async {
                    var data = {"inv id": audioProductModel.id};
                    await Provider.of<GlobalProvider>(context, listen: false)
                        .deleteItemInventory(context, data);
                    key.currentState?.onRefresh();
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red.shade900,
                  )),
            ],
          ),
          subtitle: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        pro.appTlLanguage.isNotEmpty
                            ? "${pro.appTlLanguage[52]} : "
                            : "Qty : ",
                        style:
                            TextStyle(fontSize: 14.sp, color: Utils.linkColor),
                      ),
                      Text(
                        "${audioProductModel.productQty ?? "-"}",
                        style: TextStyle(fontSize: 14.sp),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 115.w,
                    child: Row(
                      children: [
                        Text(
                          pro.appTlLanguage.isNotEmpty
                              ? "${pro.appTlLanguage[50]} : "
                              : "M.R.P :",
                          style: TextStyle(
                              fontSize: 14.sp, color: Utils.linkColor),
                        ),
                        Flexible(
                          child: Text(
                            "₹${audioProductModel.amount?.toStringAsFixed(2) ?? "-"}",
                            style: TextStyle(
                                fontSize: 14.sp,
                                overflow: TextOverflow.ellipsis),
                          ),
                        )
                      ],
                    ),
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
                            ? "${pro.appTlLanguage[53]} : "
                            : "Unit :",
                        style:
                            TextStyle(fontSize: 14.sp, color: Utils.linkColor),
                      ),
                      Text(
                        audioProductModel.productUnit ?? "-",
                        style: TextStyle(fontSize: 14.sp),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 115.w,
                    child: Text.rich(TextSpan(children: [
                      TextSpan(
                          text: pro.appTlLanguage.isNotEmpty
                              ? "${pro.appTlLanguage[51]} : "
                              : "S.P :",
                          style: TextStyle(
                              fontSize: 14.sp, color: Utils.linkColor)),
                      TextSpan(
                          text:
                              "₹${audioProductModel.productPrice?.toStringAsFixed(2) ?? "-"}",
                          style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 14.sp,
                              color: Utils.primaryPinkColor))
                    ])),
                  )
                ],
              )
            ],
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => SingleProductDialogWidget(
                audioProductModel: audioProductModel,
                canEditCallBackFunc: (p0) async {
                  if (p0 == true) {
                    key.currentState?.onRefresh();
                  }
                },
              ),
            );
          },
        ),
      );
    });
  }

  //
  Widget searchInventoryCard(
      AudioProductModel audioProductModel, context, index) {
    return Consumer<GlobalProvider>(builder: (context, pro, child) {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: Colors.white,
            boxShadow: [Utils.commonBoxShadow]),
        margin: EdgeInsets.symmetric(vertical: 5.w, horizontal: 20.w),
        child: ListTile(
          leading: Utils.networkImageNoCached(
              imageUrl: "", width: 50.w, height: 80.w, fit: BoxFit.fill),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  " ${audioProductModel.productName}",
                  style:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: 15.sp),
                ),
              ),
              IconButton(
                  onPressed: () async {
                    var data = {"is_deleted": "TRUE"};
                    await Provider.of<GlobalProvider>(context, listen: false)
                        .deleteItemInventory(context, data);
                    key.currentState?.onRefresh();
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red.shade900,
                  )),
            ],
          ),
          subtitle: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        pro.appTlLanguage.isNotEmpty
                            ? "${pro.appTlLanguage[52]} : "
                            : "Qty :",
                        style:
                            TextStyle(fontSize: 14.sp, color: Utils.linkColor),
                      ),
                      Text(
                        "${audioProductModel.productQty ?? "-"}",
                        style: TextStyle(fontSize: 14.sp),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        pro.appTlLanguage.isNotEmpty
                            ? "${pro.appTlLanguage[50]} : "
                            : "M.R.P : ",
                        style:
                            TextStyle(fontSize: 14.sp, color: Utils.linkColor),
                      ),
                      Text(
                        "₹${audioProductModel.amount?.toStringAsFixed(2) ?? "-"}",
                        style: TextStyle(fontSize: 14.sp),
                      )
                    ],
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
                            ? "${pro.appTlLanguage[53]} : "
                            : "Unit : ",
                        style:
                            TextStyle(fontSize: 14.sp, color: Utils.linkColor),
                      ),
                      Text(
                        audioProductModel.productUnit ?? "-",
                        style: TextStyle(fontSize: 14.sp),
                      )
                    ],
                  ),
                  Text.rich(TextSpan(children: [
                    TextSpan(
                        text: pro.appTlLanguage.isNotEmpty
                            ? "${pro.appTlLanguage[51]} : "
                            : "S.P : ",
                        style:
                            TextStyle(fontSize: 14.sp, color: Utils.linkColor)),
                    TextSpan(
                        text:
                            "₹${audioProductModel.productPrice?.toStringAsFixed(2) ?? "-"}",
                        style: TextStyle(
                            fontSize: 14.sp, color: Utils.primaryPinkColor))
                  ]))
                ],
              )
            ],
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => SingleProductDialogWidget(
                isSearchCard: true,
                audioProductModel: audioProductModel,
                invSearchItemIndex:
                    pro.invSearchList.indexOf(audioProductModel),
                canEditCallBackFunc: (p0) async {
                  if (p0 == true) {
                    key.currentState?.onRefresh();
                  }
                },
              ),
            );
          },
        ),
      );
    });
  }

  //
  Widget filterInventoryCard(
      AudioProductModel audioProductModel, context, index) {
    return Consumer<GlobalProvider>(builder: (context, pro, child) {
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: Colors.white,
            boxShadow: [Utils.commonBoxShadow]),
        margin: EdgeInsets.symmetric(vertical: 5.w, horizontal: 20.w),
        child: ListTile(
          leading: Utils.networkImageNoCached(
              imageUrl: "", width: 50.w, height: 80.w, fit: BoxFit.fill),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  " ${audioProductModel.productName}",
                  style:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: 15.sp),
                ),
              ),
              IconButton(
                  onPressed: () async {
                    var data = {"is_deleted": "TRUE"};
                    await Provider.of<GlobalProvider>(context, listen: false)
                        .deleteItemInventory(context, data);
                    key.currentState?.onRefresh();
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red.shade900,
                  )),
            ],
          ),
          subtitle: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        pro.appTlLanguage.isNotEmpty
                            ? "${pro.appTlLanguage[52]} : "
                            : "Qty :",
                        style:
                            TextStyle(fontSize: 14.sp, color: Utils.linkColor),
                      ),
                      Text(
                        "${audioProductModel.productQty ?? "-"}",
                        style: TextStyle(fontSize: 14.sp),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        pro.appTlLanguage.isNotEmpty
                            ? "${pro.appTlLanguage[50]} : "
                            : "M.R.P : ",
                        style:
                            TextStyle(fontSize: 14.sp, color: Utils.linkColor),
                      ),
                      Text(
                        "₹${audioProductModel.amount?.toStringAsFixed(2) ?? "-"}",
                        style: TextStyle(fontSize: 14.sp),
                      )
                    ],
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
                            ? "${pro.appTlLanguage[53]} : "
                            : "Unit : ",
                        style:
                            TextStyle(fontSize: 14.sp, color: Utils.linkColor),
                      ),
                      Text(
                        audioProductModel.productUnit ?? "-",
                        style: TextStyle(fontSize: 14.sp),
                      )
                    ],
                  ),
                  Text.rich(TextSpan(children: [
                    TextSpan(
                        text: pro.appTlLanguage.isNotEmpty
                            ? "${pro.appTlLanguage[51]} : "
                            : "S.P : ",
                        style:
                            TextStyle(fontSize: 14.sp, color: Utils.linkColor)),
                    TextSpan(
                        text:
                            "₹${audioProductModel.productPrice?.toStringAsFixed(2) ?? "-"}",
                        style: TextStyle(
                            fontSize: 14.sp, color: Utils.primaryPinkColor))
                  ]))
                ],
              )
            ],
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => SingleProductDialogWidget(
                audioProductModel: audioProductModel,
                canEditCallBackFunc: (p0) async {
                  if (p0 == true) {
                    key.currentState?.onRefresh();
                  }
                },
              ),
            );
          },
        ),
      );
    });
  }
}

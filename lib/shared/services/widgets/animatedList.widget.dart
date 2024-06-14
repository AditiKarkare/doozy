// ignore_for_file: use_build_context_synchronously
import 'package:doozy/main.dart';
import 'package:doozy/shared/core/repositries/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:translator_plus/translator_plus.dart';

class CustomAnimatedList extends StatefulWidget {
  // Widget card;
  final Widget Function(dynamic item, BuildContext context, int index)
      cardFunction;
  final Widget? noDataExtraWidget;
  final String endpoint;
  final String noDataImage;
  final String noDataTitle;
  final String noDataMessage;
  final String loadingWidget;
  Widget? noDataWidget;

  // GlobalKey<AnimatedListState> AnimatedListKey = GlobalKey();
  CustomAnimatedList(
      {super.key,
      required this.cardFunction,
      required this.endpoint,
      required this.noDataImage,
      required this.noDataMessage,
      required this.loadingWidget,
      required this.noDataTitle,
      this.noDataExtraWidget,
      this.noDataWidget});

  @override
  State<CustomAnimatedList> createState() => CustomAnimatedListState();
}

class CustomAnimatedListState extends State<CustomAnimatedList> {
  bool isConnected = true;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  static CustomAnimatedListState? customAnimatedListState;

  @override
  void initState() {
    super.initState();
    Provider.of<GlobalProvider>(context, listen: false).clearAnimatedListData();
    customAnimatedListState = this;
    getData();
  }

  int initialPage = 1;

  void onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    Provider.of<GlobalProvider>(context, listen: false).animatedListData = [];
    initialPage = 1;
    getData();

    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    // initialPage++;
    getData();
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  getData() async {
    GlobalProvider pro = Provider.of<GlobalProvider>(context, listen: false);
    pro.changeAnimatedLoadedData(true);
    pro.clearAnimatedListData();
    supabase
        .from("inventory_products_view")
        .select("*")
        .filter("IS DELETED", "eq", "FALSE")
        .order("CREATED AT", ascending: false)
        .then((value) async {
      print(value);
      for (var element in value) {
        final translator = GoogleTranslator();
        // Translation translation = await translator
        //     .translate(element["PRODUCT NAME"], to: pro.appLangCode);
        var data = {
          "inv id": element["inv id"],
          "PRODUCT ID": element["PRODUCT ID"],
          "PRODUCT QTY": element["PRODUCT QTY"],
          "PRODUCT UNIT": element["PRODUCT UNIT"],
          "PRODUCT SP": element["PRODUCT SP"],
          "PRODUCT AMOUNT": element["PRODUCT AMOUNT"],
          "PRODUCT NAME": element["PRODUCT NAME"],
        };

        pro.animatedListData.add(data);
      }
      pro.changeAnimatedLoadedData(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProvider>(builder: (context, pro, child) {
      return SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: const WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = const Text("pull up load");
            } else if (mode == LoadStatus.loading) {
              body = const CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = const Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = const Text("release to load more");
            } else {
              body = const Text("No more Data");
            }
            return SizedBox(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: onRefresh,
        onLoading: _onLoading,
        child: Provider.of<GlobalProvider>(context, listen: false)
                    .loadedAnimatedData ==
                true
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 300.h,
                      child: pro.appLangCode == "en"
                          ? Image.asset("assets/json/englishLoader.gif")
                          : pro.appLangCode == "mr"
                              ? Image.asset("assets/json/marathiLoader.gif")
                              : Image.asset("assets/json/hindiLoader.gif")),
                  // const Text(
                  //   'Loading',
                  //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  // ),
                  // const Text(
                  //   'Waiting for data to load...',
                  //   style: TextStyle(fontSize: 16),
                  // )
                ],
              )
            : pro.animatedListData.isEmpty
                ? widget.noDataWidget ??
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 300.w,
                            child: SvgPicture.asset(
                              widget.noDataImage,
                            )),
                        Text(widget.noDataTitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(height: 5.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 26.w),
                          child: Text(widget.noDataMessage,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 16)),
                        ),
                        widget.noDataExtraWidget ?? SizedBox.fromSize()
                      ],
                    )
                : ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(vertical: 10.w),
                    itemBuilder: (c, i) => widget.cardFunction(
                        pro.animatedListData[i], context, i),
                    itemCount: pro.animatedListData.length,
                  ),
      );
    });
  }
}

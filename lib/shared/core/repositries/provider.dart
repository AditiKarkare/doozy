// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:doozy/main.dart';
import 'package:doozy/shared/core/dio/dio.req.dart';
import 'package:doozy/shared/core/dio/endpoints.dart';
import 'package:doozy/shared/core/models/appsettings.model.dart';
import 'package:doozy/shared/core/models/message.entity.dart';
import 'package:doozy/shared/core/models/user.model.dart';
import 'package:doozy/shared/utils/constants.dart';
import 'package:doozy/view/authentication/login.page.dart';
import 'package:doozy/view/chatBot/chat.page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:doozy/shared/core/models/audioProduct.model.dart';
import 'package:doozy/shared/core/models/message.model.dart';
import 'package:doozy/shared/core/models/salesHistory.model.dart';
import 'package:doozy/shared/core/others/dataFormates.dart';
import 'package:doozy/shared/core/others/urls.dart';
import 'package:doozy/shared/core/repositries/listentoChannel.func.dart';
import 'package:doozy/shared/services/documentPicker.dart';
import 'package:doozy/shared/services/widgets/customToast.widget.dart';
import 'package:doozy/shared/core/models/messageData.model.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:pdfx/pdfx.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:translator_plus/translator_plus.dart';
import 'package:upi_payment_qrcode_generator/upi_payment_qrcode_generator.dart';

class GlobalProvider extends ChangeNotifier {
  //----------------------------------Authentication -------------------------------------------------------------
  verifyOtpFunc({
    required String token,
    required String? phone,
    required BuildContext context,
    required Function stopLoading,
    required Function startLoading,
  }) async {
    startLoading();

    try {
      final AuthResponse response = await supabase.auth.verifyOTP(
        phone: "+91$phone",
        token: token,
        type: OtpType.sms,
      );

      if (response.user == null) {
        throw Exception('server pronblm');
      } else {
        final data = await supabase.from("app_settings").select();
        await changeToggleState(0);
        clearAppSettingsFunc();
        addDatatoappsettingListFunc(AppSettingsModel.fromJson(data[0]));
        final prof = await supabase.from('profiles').select();

        CoreDataFormates.userModel = UserModel.fromJson(prof[0]);
        if (CoreDataFormates.userModel.businessName == null) {
          await changeFeatureSettingFunc(
            false,
          );
        } else {
          await changeFeatureSettingFunc(true);
        }
        setAudioLangCodeFunc(
            code: CoreDataFormates.userModel.audioLangCode ?? "en-In",
            langName: CoreDataFormates.userModel.lang ?? "English");
        await clearTLLanguage();
        setAppLangCodeFunc(CoreDataFormates.userModel.appLangCode ?? "en");
        appLangCode == "hi"
            ? await addChangedDataToTLLangList(CoreDataFormates.hindiAppLang)
            : appLangCode == "mr"
                ? await addChangedDataToTLLangList(
                    CoreDataFormates.marathiAppLang)
                : null;

        if (CoreDataFormates.userModel.appLangCode != "en") {
          await changeAppLanguageFunc(context);
        }

        //

        CoreAppUrls.user = response.user;
        CoreAppUrls.session = response.session;

        Utils().hideKeyboard(context);
        Navigator.pushNamed(context, "/homePage");
        stopLoading();
      }
    } catch (e) {
      stopLoading();
    }
  }

  resendOtpEventFunc({required String phone}) async {
    await supabase.auth.resend(type: OtpType.sms, phone: phone);
  }

  // -------------------------- App setting ---------------------
  List<AppSettingsModel> appsettingList = [];
  addDatatoappsettingListFunc(AppSettingsModel appSettingsModel) {
    appsettingList.add(appSettingsModel);
    notifyListeners();
  }

  clearAppSettingsFunc() {
    appsettingList = [];
    notifyListeners();
  }

  bool allowSwitchingTab = true;

  changeAllowSwitchingTabFunc(bool value) {
    allowSwitchingTab = value;
    notifyListeners();
  }

  //
  int toggleState = 0;
  // TabController? tabController;

  changeToggleState(int index) async {
    toggleState = index;
    // tabController?.index = index;
    notifyListeners();
  }

  //
  int manualEditorBtnState = 0;
  changeManualEditorBtnState(int index) async {
    manualEditorBtnState = index;
    notifyListeners();
  }

  //chat
  List<SalesMessageModel> salesChatList = [];
  List<SalesMessageModel> inventoryChatList = [];

  clearChatListFunc() {
    salesChatList = [];
    inventoryChatList = [];

    notifyListeners();
  }

  addBusinessDataToChatFunc({required SalesMessageModel salesMessageModel}) {
    salesChatList.add(salesMessageModel);
    inventoryChatList.add(salesMessageModel);
    notifyListeners();
  }

  // ------------------------------- Remove model from list-----------------

  removeModelFromSalesChatFunc(int modelIndex) {
    salesChatList.removeAt(modelIndex);
    notifyListeners();
  }

  removeModelFromInventoryChatFunc(int modelIndex) {
    inventoryChatList.removeAt(modelIndex);
    notifyListeners();
  }

  remove2ModelFromSalesChatFunc(int modelIndex) {
    salesChatList.removeAt(modelIndex);
    salesChatList.removeAt(modelIndex - 1);
    notifyListeners();
  }

  remove2ModelFromInventoryChatFunc(int modelIndex) {
    inventoryChatList.removeAt(modelIndex);
    inventoryChatList.removeAt(modelIndex - 1);
    notifyListeners();
  }

  removeItemFromAudioProductModelChat(int modelIndex, int productIndex) {
    salesChatList
        .elementAt(modelIndex)
        .messageDataModel
        .audioProductModelList
        ?.removeAt(productIndex);
    notifyListeners();
  }

  removeItemFromSalesResponseList(int productIndex) {
    salesResponseList.removeAt(productIndex);
    notifyListeners();
  }

  removeItemFromInventoryResponseList(int productIndex) {
    inventoryResponseList.removeAt(productIndex);
    notifyListeners();
  }

  removeItemFromSalesHistoryModelChat(int modelIndex, int productIndex) {
    inventoryChatList
        .elementAt(modelIndex)
        .messageDataModel
        .audioProductModelList
        ?.removeAt(productIndex);
    notifyListeners();
  }

//  ----------------------------------------------- OCR FUNC -------------------------------------------
  int sendOcrCount = 0;
  increaseOcrSendCount() async {
    sendOcrCount++;
    notifyListeners();
  }

// ---------------------------------

  sendOcrFunc(BuildContext context) {
    ModalImage(
            context: context,
            onImageSelect: (filePath, fileType) async {
              print(fileType);

              String temppFile;
              temppFile = filePath;
              changeLoading(true);
              increaseOcrSendCount();
              File file = File(
                filePath,
              );
              List<int> bytes = file.readAsBytesSync();
              var base64Audio = base64Encode(bytes);
              changeAllowSwitchingTabFunc(false);

              if (fileType == "pdf") {
                toggleState == 0
                    ? salesChatList.add(SalesMessageModel(
                        messageType: 0,
                        widgetType: 6,
                        messageDataModel:
                            MessageDataModel(ocrImage: base64Audio)))
                    : inventoryChatList.add(SalesMessageModel(
                        messageType: 0,
                        widgetType: 6,
                        messageDataModel:
                            MessageDataModel(ocrImage: base64Audio)));
              } else {
                toggleState == 0
                    ? salesChatList.add(SalesMessageModel(
                        messageType: 0,
                        widgetType: 3,
                        messageDataModel:
                            MessageDataModel(ocrImage: base64Audio)))
                    : inventoryChatList.add(SalesMessageModel(
                        messageType: 0,
                        widgetType: 3,
                        messageDataModel:
                            MessageDataModel(ocrImage: base64Audio)));
              }

              checkScrollFunc(salesChatList.length, inventoryChatList.length);
              playMesgAudio(msgAudioType: 0);

              Map<String, dynamic> data = {};

              if (file.existsSync()) {
                data = {"data": base64Audio};
                await DioRequestCalls.postCall(
                        context: context,
                        endpoint: DioEndpoints.getOcr,
                        data: data)
                    .then((value) {
                  print(value);
                  getOcrDataFunc(value["result"]);
                });

                file.deleteSync();
              }
              changeLoading(false);
            },
            isImageCroppable: true)
        .mainBottomSheet(context);
  }

//--------------------------
  bool isBillCreating = false;
  changeIsBillCreating(bool value) {
    isBillCreating = value;
    notifyListeners();
  }

  bool readyToCreateBill = true;
  changereadyToCreateBill(bool value) {
    readyToCreateBill = value;
    notifyListeners();
  }

  createBillFunc(
      {required BuildContext context,
      required List<AudioProductModel> productList,
      required int modelIndex}) async {
    if (productList.isNotEmpty) {
      changeIsBillCreating(true);

      double totalAmount = 0;
      int totalOrder = productList.length;
      for (var element in productList) {
        if (element.amount != null) {
          totalAmount += element.amount ?? 0.0;
        }
      }
      var data = {
        "orderCount": totalOrder,
        "TOTAL AMOUNT": totalAmount,
        "ITEMS": productList
      };

      List list = [];
      for (var element in productList) {
        list.add(element.toJson());
      }

      var sendData = {
        "data": {"amount": totalAmount.toDouble(), "items": list}
      };

      await DioRequestCalls.postCall(
              context: context,
              endpoint: DioEndpoints.createSale,
              data: sendData)
          .then((value) {
        print(value);
        if (value["result"] != null) {
          salesChatList.add(SalesMessageModel(
              messageType: 1,
              widgetType: 1,
              messageDataModel: MessageDataModel(
                  salesHistoryItemsModel:
                      SalesHistoryItemsModel.fromJson(data))));
          changeLoading(false);
          appTlLanguage.isNotEmpty
              ? showToast(context, appTlLanguage[38])
              : showToast(context, "Bill is created by ChotuAI");
          removeModelFromSalesChatFunc(modelIndex);
          checkScrollFunc(salesChatList.length, inventoryChatList.length);
          changeIsBillCreating(false);
          notifyListeners();
        }

        changeIsBillCreating(false);
      });
    }
  }

  createBillSalesResponseFunc({
    required BuildContext context,
    required List<AudioProductModel> productList,
  }) async {
    if (productList.isNotEmpty) {
      changeIsBillCreating(true);

      double totalAmount = 0;
      int totalOrder = productList.length;
      for (var element in productList) {
        if (element.amount != null) {
          totalAmount += element.amount ?? 0.0;
        }
      }
      var data = {
        "orderCount": totalOrder,
        "TOTAL AMOUNT": totalAmount,
        "ITEMS": productList
      };

      List list = [];
      for (var element in productList) {
        list.add(element.toJson());
      }

      var sendData = {
        "data": {"amount": totalAmount.toDouble(), "items": list}
      };

      await DioRequestCalls.postCall(
              context: context,
              endpoint: DioEndpoints.createSale,
              data: sendData)
          .then((value) {
        print(value);
        if (value["result"] != null) {
          salesChatList.add(SalesMessageModel(
              messageType: 1,
              widgetType: 1,
              messageDataModel: MessageDataModel(
                  salesHistoryItemsModel:
                      SalesHistoryItemsModel.fromJson(data))));
          changeLoading(false);
          appTlLanguage.isNotEmpty
              ? showToast(context, appTlLanguage[38])
              : showToast(context, "Bill is created by ChotuAI");
          clearResponseList(type: toggleState);
          // removeModelFromSalesChatFunc(modelIndex);
          checkScrollFunc(salesChatList.length, inventoryChatList.length);
          changeIsBillCreating(false);
          notifyListeners();
        }

        changeIsBillCreating(false);
      });
    }
  }

  deleteBillFunc(BuildContext context, int itemIndex, Map data) {
    DioRequestCalls.deleteCall(endpoint: DioEndpoints.deleteSale, data: data)
        .then((value) {
      if (value["result"] == "Sale deleted successfully...") {
        removeItemFromAnimatedSalesList(itemIndex);
        appTlLanguage.isNotEmpty
            ? showToast(context, appTlLanguage[41])
            : showToast(context, "Bill deleted sucessfully");
      }
      print(value);
    });
  }

//-----------------------
  bool isInvCreating = false;
  changeIsInvCreating(bool value) {
    isInvCreating = value;
    notifyListeners();
  }

  addToInventoryFunc({
    required BuildContext context,
    required List<AudioProductModel> productList,
    // required int modelIndex
  }) async {
    changeIsInvCreating(true);
    List data = [];
    for (var element in productList) {
      data.add(element.toJson());
    }

    var mapdata = {"data": data};
    await DioRequestCalls.postCall(
            context: context,
            endpoint: DioEndpoints.addToInventory,
            data: mapdata)
        .then((value) {
      inventoryChatList.add(SalesMessageModel(
          messageType: 1,
          widgetType: 1,
          messageDataModel:
              MessageDataModel(audioProductModelList: productList)));
      clearResponseList(type: toggleState);
      // removeModelFromInventoryChatFunc(modelIndex);
      changeLoading(false);
      appTlLanguage.isNotEmpty
          ? showToast(context, appTlLanguage[39])
          : showToast(context, "Added product to your inventory sucessfully");
      changeIsInvCreating(false);
    });
  }

  updateItemInventory(BuildContext context, Map data) async {
    var sendData = {
      "data": [data]
    };
    DioRequestCalls.postCall(
            context: context,
            endpoint: DioEndpoints.updateInventory,
            data: sendData)
        .then((value) {
      print(value);
    });
  }

  deleteItemInventory(BuildContext context, Map data) async {
    var sendData = {"data": data};
    DioRequestCalls.postCall(
            context: context,
            endpoint: DioEndpoints.deleteInventory,
            data: sendData)
        .then((value) {
      if (value["message"] == "Inventory deleted successfully") {
        showToast(context, "Item deleted successfully");
      }
      print(value);
    });
  }

//-------------------------------------------------------- AUDIO Func ----------------------------
  bool salesRecording = false;
  bool inventoryRecording = false;
  bool _hasPermission = false;
  Directory? _tempDir;
  String? _filePath;
  Timer? _timer;
  FlutterSoundRecorder recorder = FlutterSoundRecorder();
  int recordingEventCount = 0;
  int sendFileEventCount = 0;

  changeSalesRecordingState(bool value) async {
    salesRecording = value;
    notifyListeners();
  }

  changeInventoryRecordingState(bool value) async {
    inventoryRecording = value;
    notifyListeners();
  }

  microPhoneTapEventFunc(bool isRecording) async {
    setRecordingBoolean(isRecording);
    initialize();
  }

  Future<void> initialize() async {
    _hasPermission = await checkPermission();
    if (!_hasPermission) return;
    _tempDir = await getApplicationDocumentsDirectory();
    _filePath = '${_tempDir?.path}/audio.wav';

    startRecording();
  }

  Future<bool> checkPermission() async {
    var status = await Permission.microphone.status;
    if (status.isGranted) {
      return true;
    } else {
      var result = await Permission.microphone.request();
      toggleState == 0
          ? (salesRecording = false)
          : (inventoryRecording = false);
      stopRecording();
      return result.isGranted;
    }
  }

  void startRecording() async {
    toggleState == 0 ? (salesRecording = true) : (inventoryRecording = true);
    increaseRecordingCount();
    recorder.openAudioSession();
    recorder.startRecorder(toFile: _filePath, codec: Codec.pcm16WAV);
  }

  void setRecordingBoolean(bool value) async {
    toggleState == 0 ? (salesRecording = value) : (inventoryRecording = value);
  }

  void increaseRecordingCount() async {
    recordingEventCount++;
  }

  sendAudio(context) async {
    changeAllowSwitchingTabFunc(false);
    await recorder.stopRecorder();
    if (toggleState == 0
        ? (salesRecording == false)
        : (inventoryRecording == false)) {
      File file = File(
        _filePath!,
      );
      List<int> bytes = file.readAsBytesSync();
      var base64Audio = base64Encode(bytes);

      toggleState == 0
          ? salesChatList.add(SalesMessageModel(
              messageType: 0,
              widgetType: 2,
              messageDataModel: MessageDataModel(audioRecording: base64Audio)))
          : inventoryChatList.add(SalesMessageModel(
              messageType: 0,
              widgetType: 2,
              messageDataModel: MessageDataModel(audioRecording: base64Audio)));

      checkScrollFunc(salesChatList.length, inventoryChatList.length);
      playMesgAudio(msgAudioType: 0);
      changeLoading(true);
      Map<String, dynamic> data = {};
      //
      if (file.existsSync()) {
        data = {"data": base64Audio, "lang": audioCode};

        await DioRequestCalls.postCall(
                context: context, endpoint: DioEndpoints.getAudio, data: data)
            .then((value) {
          print(value);

          if (value["result"] != null) {
            getAudioDataFunc(value["result"]);
            changeLoading(false);
          } else {
            changeLoading(false);
          }
        });

        listenToChannelFunc(context);
        recorder.deleteRecord(fileName: file.path);
        file.deleteSync();
      }
    }
  }

  stopRecordingEvent(context, bool isRecording) async {
    await sendAudio(context);
    setRecordingBoolean(isRecording);
    stopRecording();
  }

  stopRecording() async {
    if (toggleState == 0
        ? (salesRecording == false)
        : (inventoryRecording == false)) {
      recorder.stopRecorder();
      _timer?.cancel();
    }
  }

  // ---------------------------------------- Manual Func -----------------------------------

  sendManualFunc(BuildContext context, String productDetails) async {
    if (productDetails != "") {
      toggleState == 0
          ? salesChatList.add(SalesMessageModel(
              messageType: 0,
              widgetType: 4,
              messageDataModel: MessageDataModel(manualMsg: productDetails)))
          : inventoryChatList.add(SalesMessageModel(
              messageType: 0,
              widgetType: 4,
              messageDataModel: MessageDataModel(manualMsg: productDetails)));

      changeAllowSwitchingTabFunc(false);

      await playMesgAudio(msgAudioType: 0);
      Map<String, dynamic> data = {};

      data = {"data": productDetails};
      await DioRequestCalls.postCall(
              context: context, endpoint: DioEndpoints.getManual, data: data)
          .then((value) {
        print(value);
        changeLoading(false);
        getManualResDataFunc(value["result"]);
      });

      notifyListeners();
    }
  }

  //-------------------------------------------------------------------------------------------------------------

  bool isLoading = false;
  bool useFeature = true;

//HomeList
  ScrollController salesChatScrollCont = ScrollController();
  ScrollController invChatScrollCont = ScrollController();
  scrollListFunc(ScrollController controller) async {
    if (controller.hasClients) {
      controller.animateTo(
        10000000000000000,
        duration: const Duration(milliseconds: 100),
        curve: Curves.ease,
      );
    }
  }

  int oldSaleLenght = 0;
  int oldInvLenght = 0;
  checkScrollFunc(int newSaleLenght, int newInvLenght) {
    if (oldSaleLenght != newSaleLenght) {
      scrollListFunc(salesChatScrollCont);
    }
    oldSaleLenght = newSaleLenght;

    if (oldInvLenght != newInvLenght) {
      scrollListFunc(invChatScrollCont);
    }
    oldInvLenght = newInvLenght;

    notifyListeners();
  }

  changeLoading(bool value) async {
    isLoading = value;
    notifyListeners();
  }

  changeFeatureSettingFunc(bool value) async {
    useFeature = value;
    notifyListeners();
  }

  // ---------------------------------------- Play Message Audio -----------------------------------

// 0 - msg sent , 1 - response recieved
  FlutterSoundPlayer audioPlayer = FlutterSoundPlayer();
  playMesgAudio({required int msgAudioType}) async {
    String audioUrl = "";
    if (msgAudioType == 0) {
      audioUrl = "assets/audio/sentMsg.mp3";
    } else {
      audioUrl = "assets/audio/receivedMsg.mp3";
    }
    final byteData = await rootBundle.load(audioUrl);
    final file = File('${(await getTemporaryDirectory()).path}/temp_audio.mp3');
    audioUrl = file.path;
    await file.writeAsBytes(byteData.buffer.asUint8List());
    await audioPlayer.openAudioSession();

    await audioPlayer.startPlayer(
      fromURI: audioUrl,
      codec: Codec.mp3,
    );
  }

  // ---------------------------------------- Share One Bill ---------------------------------------

  Future<pw.Font> loadFont(String path) async {
    final fontData = await rootBundle.load(path);
    return pw.Font.ttf(fontData);
  }

  Future<Uint8List> createBill(SalesHistoryItemsModel salesHistMode) async {
    int totalQuantity = 0;
    final ByteData svgData = await rootBundle.load('assets/png/chotuAI.png');
    final logoImg = pw.MemoryImage(svgData.buffer.asUint8List());
    for (var element in salesHistMode.orderItems!) {
      totalQuantity += element.productQty ?? 0;
    }
    String generateUPIQR(String upiId, double amount) {
      return 'upi://pay?pa=$upiId&am=$amount';
    }

    String link = generateUPIQR(
        CoreDataFormates.userModel.upi ?? "", salesHistMode.amount ?? 0.0);
    final qrImageData = await QrPainter(
      data: link,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.H,
    ).toImageData(200);
    final qrImage = pw.MemoryImage(qrImageData!.buffer.asUint8List());
    final pdf = Document();
    final font = await loadFont('assets/fonts/Helvetica.ttf');

    pdf.addPage(pw.MultiPage(
        maxPages: 100,
        footer: (context) {
          return pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Text("Powered By ",
                  style: pw.TextStyle(
                    fontSize: 13.sp,
                    font: font,
                  )),
              pw.Image(logoImg, width: 100.w, height: 10.w)
            ],
          );
        },
        build: (context) => [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Text(CoreDataFormates.userModel.businessName ?? "",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          fontSize: 16.sp,
                          font: font,
                          fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(
                    height: 5.h,
                  ),
                  pw.Text(CoreDataFormates.userModel.businessAddress ?? "",
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                        fontSize: 16.sp,
                        font: font,
                      )),
                  pw.SizedBox(
                    height: 5.h,
                  ),
                  pw.Text(
                      "+${CoreDataFormates.userModel.phone?.substring(0, 2)} ${CoreDataFormates.userModel.phone?.substring(2)}",
                      style: pw.TextStyle(
                        fontSize: 16.sp,
                        font: font,
                      )),
                  pw.SizedBox(
                    height: 5.h,
                  ),
                  pw.Text(
                      "Bill Date : ${Utils.formatdateStamp("dd/MM/yyyy", DateTime.now().toString())}, ${Utils.formatTimeStamp("HH:mm a", DateTime.now().toString())}",
                      style: pw.TextStyle(
                        fontSize: 15.sp,
                        font: font,
                      )),
                  pw.SizedBox(
                    height: 5.h,
                  ),
                  pw.Text(
                    "Total Items : ${salesHistMode.orderItems?.length ?? 0} ",
                    style: pw.TextStyle(
                      fontSize: 14.sp,
                      font: font,
                    ),
                  ),
                  pw.Divider(),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Row(children: [
                          pw.SizedBox(
                            width: 40.w,
                            child: pw.Text("Sr.",
                                style: pw.TextStyle(
                                  fontSize: 15.sp,
                                  font: font,
                                )),
                          ),
                          pw.SizedBox(
                            width: 5.w,
                          ),
                          pw.Container(
                            width: 120.w,
                            alignment: pw.Alignment.centerLeft,
                            child: pw.Text("Name",
                                style: pw.TextStyle(
                                  fontSize: 15.sp,
                                  font: font,
                                )),
                          ),
                        ]),
                        pw.Row(children: [
                          pw.Container(
                            alignment: pw.Alignment.centerRight,
                            width: 90.w,
                            child: pw.Text("Qty",
                                style: pw.TextStyle(
                                  fontSize: 15.sp,
                                  font: font,
                                )),
                          ),
                          pw.Container(
                            alignment: pw.Alignment.centerRight,
                            width: 90.w,
                            child: pw.Text("Unit",
                                style: pw.TextStyle(
                                  fontSize: 15.sp,
                                  font: font,
                                )),
                          ),
                          pw.Container(
                            alignment: pw.Alignment.centerRight,
                            width: 90.w,
                            child: pw.Text("Amount",
                                style: pw.TextStyle(
                                  fontSize: 15.sp,
                                  font: font,
                                )),
                          ),
                        ])
                      ]),
                  pw.SizedBox(
                    height: 6.h,
                  ),
                  pw.ListView.builder(
                      padding: const pw.EdgeInsets.symmetric(vertical: 15),
                      itemCount: salesHistMode.orderItems?.length ?? 0,
                      itemBuilder: (context, itemIndex) {
                        return pw.Padding(
                            padding: pw.EdgeInsets.only(bottom: 5.h),
                            child: pw.Row(
                                mainAxisAlignment:
                                    pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.Row(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.SizedBox(
                                          width: 30.w,
                                          child: pw.Text(
                                            "${itemIndex + 1})",
                                            style: pw.TextStyle(
                                              fontSize: 15.sp,
                                              font: font,
                                            ),
                                          ),
                                        ),
                                        pw.SizedBox(
                                          width: 5.w,
                                        ),
                                        pw.Container(
                                          width: 120.w,
                                          alignment: pw.Alignment.centerLeft,
                                          child: pw.Text(
                                            salesHistMode.orderItems![itemIndex]
                                                    .productName ??
                                                "",
                                            style: pw.TextStyle(
                                              fontSize: 15.sp,
                                              font: font,
                                            ),
                                          ),
                                        ),
                                      ]),
                                  pw.Row(
                                    children: [
                                      pw.Container(
                                        alignment: pw.Alignment.centerRight,
                                        width: 90.w,
                                        child: pw.Text(
                                          "${salesHistMode.orderItems![itemIndex].productQty ?? ""} ",
                                          style: pw.TextStyle(
                                            fontSize: 15.sp,
                                            font: font,
                                          ),
                                        ),
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.centerRight,
                                        width: 90.w,
                                        child: pw.Text(
                                          "${salesHistMode.orderItems![itemIndex].productUnit ?? "Other"} ",
                                          style: pw.TextStyle(
                                            fontSize: 15.sp,
                                            font: font,
                                          ),
                                        ),
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.centerRight,
                                        width: 90.w,
                                        child: pw.Text(
                                          "${salesHistMode.orderItems![itemIndex].amount?.toStringAsFixed(2) ?? ""} ",
                                          style: pw.TextStyle(
                                            fontSize: 15.sp,
                                            font: font,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]));
                      }),
                  pw.Divider(),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        "Total Amount : ",
                        style: pw.TextStyle(
                          fontSize: 14.sp,
                          font: font,
                        ),
                      ),
                      pw.Text(
                        "${salesHistMode.amount?.toStringAsFixed(2)}  ",
                        style: pw.TextStyle(
                          fontSize: 14.sp,
                          font: font,
                        ),
                      ),
                    ],
                  ),
                  pw.Divider(),
                  pw.SizedBox(
                    height: 40.h,
                  ),
                  pw.Center(
                    child: pw.Image(qrImage),
                  ),
                  pw.SizedBox(
                    height: 10.h,
                  ),
                  pw.Center(
                    child: pw.Text(
                      "Scan the QR to pay",
                      style: pw.TextStyle(
                        fontSize: 14.sp,
                        font: font,
                      ),
                    ),
                  ),
                ],
              ),
            ]));

    final output = await pdf.save();
    return output;
  }

  Future<void> savePdfToDownloads(Uint8List pdfData) async {
    String downloadPath = await Utils.downloadPath();
    File file = File('$downloadPath/doozy.pdf');
    await file.writeAsBytes(pdfData);

    print('PDF saved to ${file.path}');
  }

  Future<bool> requestPermissions() async {
    bool checkStoragerPermission = await Permission.storage.request().isGranted;
    bool checkManageExtStoragePermission =
        await Permission.manageExternalStorage.request().isGranted;
    // var status = await Permission.storage.status;
    if (checkStoragerPermission || checkManageExtStoragePermission) {
      return true;
    } else {
      var result = await Permission.manageExternalStorage.request();
      return result.isGranted;
    }
  }

  shareBillPdfFunc(SalesHistoryItemsModel salesHistMode) async {
    bool value = await requestPermissions();
    if (value == true) {
      Uint8List bytes = await createBill(salesHistMode);
      await savePdfToDownloads(bytes);
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/doozy.pdf').create();
      await file.writeAsBytes(bytes);
      Share.shareFiles(
        [file.path],
      );
      notifyListeners();
    }
  }

  shareBillImageFunc(SalesHistoryItemsModel salesHistMode) async {
    bool value = await requestPermissions();
    if (value == true) {
      Uint8List bytes = await createBill(salesHistMode);
      await savePdfToDownloads(bytes);
      final imageFiles = <File>[];

      final document = await PdfDocument.openData(bytes);
      for (var i = 1; i <= document.pagesCount; i++) {
        final page = await document.getPage(i);
        PdfPageImage? pageImage = await page.render(
            backgroundColor: "#FFFFFF",
            width: page.width,
            height: page.height,
            format: PdfPageImageFormat.png);
        final tempDir = await getTemporaryDirectory();
        final file = await File('${tempDir.path}/doozy$i.png').create();
        await file.writeAsBytes(pageImage!.bytes);
        imageFiles.add(file);
        await page.close();
      }

      final filePaths = imageFiles.map((file) => file.path).toList();
      await Share.shareFiles(filePaths, text: 'Check out these PDF images!');
      Share.shareFiles(
        filePaths,
      );

      notifyListeners();
    }
  }
  // ---------------------------------------- Share All Bills ---------------------------------------

  Future<pw.Font> loadSalesFont(String path) async {
    final fontData = await rootBundle.load(path);
    return pw.Font.ttf(fontData);
  }

  List<AudioProductModel> totalSalesProducts = [];
  emptyAppProductList(List<AudioProductModel> totalProducts) {
    totalSalesProducts = [];
    notifyListeners();
  }

  List<List<SalesHistoryItemsModel>> listOfLists = [];
  splitList(List<SalesHistoryItemsModel> salesHistModeList, int chunkSize) {
    for (int i = 0; i < salesHistModeList.length; i += chunkSize) {
      int end = (i + chunkSize < salesHistModeList.length)
          ? i + chunkSize
          : salesHistModeList.length;
      listOfLists.add(salesHistModeList.sublist(i, end));
    }
  }

  Future<Uint8List> createSalesHistBill(
      List<SalesHistoryItemsModel> salesHistModeList) async {
    num totalQuantity = 0;
    num totalAmount = 0;
    num totalItems = 0;
    int orderNumber = 0;

    final ByteData svgData = await rootBundle.load('assets/png/chotuAI.png');
    final logoImg = pw.MemoryImage(svgData.buffer.asUint8List());
    listOfLists = [];
    splitList(salesHistModeList, 20);
    for (int i = 0; i < listOfLists.length; i++) {
      print('Sublist ${i + 1}: ${listOfLists[i]}');
    }
    for (var value in salesHistModeList) {
      for (var element in value.orderItems!) {
        totalQuantity += element.productQty ?? 0;
      }
    }
    print(totalQuantity);

    for (var value in salesHistModeList) {
      totalAmount += value.amount ?? 0;
    }

    for (var value in salesHistModeList) {
      totalItems += value.orderItems?.length ?? 0;
    }

    print(totalItems);

    String generateUPIQR(String upiId, num amount) {
      return 'upi://pay?pa=$upiId&am=$amount';
    }

    String link =
        generateUPIQR(CoreDataFormates.userModel.upi ?? "", totalAmount ?? 0);
    final qrImageData = await QrPainter(
      data: link,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.H,
    ).toImageData(200);

    if (salesHistModeList.length < 10) {}
    final qrImage = pw.MemoryImage(qrImageData!.buffer.asUint8List());
    final pdf = Document();
    final font = await loadSalesFont('assets/fonts/Helvetica.ttf');

    for (int i = 0; i < listOfLists.length; i++) {
      pdf.addPage(pw.Page(
          build: (context) => pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      mainAxisSize: pw.MainAxisSize.min,
                      children: [
                        i > 0
                            ? pw.SizedBox()
                            : pw.Text(
                                CoreDataFormates.userModel.businessName ?? "",
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(
                                    fontSize: 16.sp,
                                    font: font,
                                    fontWeight: pw.FontWeight.bold)),
                        i > 0
                            ? pw.SizedBox()
                            : pw.SizedBox(
                                height: 5.h,
                              ),
                        i > 0
                            ? pw.SizedBox()
                            : pw.Text(
                                CoreDataFormates.userModel.businessAddress ??
                                    "",
                                textAlign: pw.TextAlign.center,
                                style: pw.TextStyle(
                                  fontSize: 16.sp,
                                  font: font,
                                )),
                        i > 0
                            ? pw.SizedBox()
                            : pw.SizedBox(
                                height: 5.h,
                              ),
                        i > 0
                            ? pw.SizedBox()
                            : pw.Text(
                                "+${CoreDataFormates.userModel.phone?.substring(0, 2)} ${CoreDataFormates.userModel.phone?.substring(2)}",
                                style: pw.TextStyle(
                                  fontSize: 16.sp,
                                  font: font,
                                )),
                        i > 0
                            ? pw.SizedBox()
                            : pw.SizedBox(
                                height: 5.h,
                              ),
                        i > 0
                            ? pw.SizedBox()
                            : pw.Text(
                                "Bill Date : ${Utils.formatdateStamp("dd/MM/yyyy", DateTime.now().toString())}, ${Utils.formatTimeStamp("HH:mm a", DateTime.now().toString())}",
                                style: pw.TextStyle(
                                  fontSize: 15.sp,
                                  font: font,
                                )),
                        i > 0
                            ? pw.SizedBox()
                            : pw.SizedBox(
                                height: 5.h,
                              ),
                        i > 0
                            ? pw.SizedBox()
                            : pw.Text(
                                "Total Items : $totalItems",
                                style: pw.TextStyle(
                                  fontSize: 14.sp,
                                  font: font,
                                ),
                              ),
                        i > 0 ? pw.SizedBox() : pw.Divider(),
                        i > 0
                            ? pw.SizedBox()
                            : pw.Row(
                                mainAxisAlignment:
                                    pw.MainAxisAlignment.spaceBetween,
                                children: [
                                    pw.Row(children: [
                                      pw.Container(
                                        width: 100.w,
                                        alignment: pw.Alignment.centerLeft,
                                        child: pw.Text("Bill Date",
                                            style: pw.TextStyle(
                                              fontSize: 15.sp,
                                              font: font,
                                            )),
                                      ),
                                    ]),
                                    pw.Row(children: [
                                      pw.Container(
                                        alignment: pw.Alignment.centerRight,
                                        width: 90.w,
                                        child: pw.Text("Order no.",
                                            style: pw.TextStyle(
                                              fontSize: 15.sp,
                                              font: font,
                                            )),
                                      ),
                                      pw.SizedBox(
                                        width: 5.w,
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.centerRight,
                                        width: 90.w,
                                        child: pw.Text("Total Items",
                                            style: pw.TextStyle(
                                              fontSize: 15.sp,
                                              font: font,
                                            )),
                                      ),
                                      pw.SizedBox(
                                        width: 5.w,
                                      ),
                                      pw.Container(
                                        alignment: pw.Alignment.centerRight,
                                        width: 90.w,
                                        child: pw.Text("Total Amount",
                                            style: pw.TextStyle(
                                              fontSize: 15.sp,
                                              font: font,
                                            )),
                                      ),
                                    ])
                                  ]),
                        pw.SizedBox(
                          height: 6.h,
                        ),
                        pw.ListView.builder(
                            padding:
                                const pw.EdgeInsets.symmetric(vertical: 15),
                            itemCount: listOfLists[i].length,
                            // itemCount: salesHistModeList.length ?? 0,
                            itemBuilder: (context, itemIndex) {
                              orderNumber++;

                              return pw.Padding(
                                  padding: pw.EdgeInsets.only(bottom: 5.h),
                                  child: pw.Row(
                                      mainAxisAlignment:
                                          pw.MainAxisAlignment.spaceBetween,
                                      children: [
                                        pw.Row(
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.start,
                                            children: [
                                              pw.Container(
                                                width: 150.w,
                                                alignment:
                                                    pw.Alignment.centerLeft,
                                                child: pw.Text(
                                                  "${Utils.formatdateStamp("dd/MM/yyyy", listOfLists[i][itemIndex].createdDate ?? "")} " ??
                                                      "",
                                                  style: pw.TextStyle(
                                                    fontSize: 15.sp,
                                                    font: font,
                                                  ),
                                                ),
                                              ),
                                            ]),
                                        pw.Row(
                                          children: [
                                            pw.Container(
                                              alignment: pw.Alignment.center,
                                              width: 90.w,
                                              child: pw.Text(
                                                "$orderNumber",
                                                style: pw.TextStyle(
                                                  fontSize: 15.sp,
                                                  font: font,
                                                ),
                                              ),
                                            ),
                                            pw.Container(
                                              alignment: pw.Alignment.center,
                                              width: 90.w,
                                              child: pw.Text(
                                                "${listOfLists[i][itemIndex].orderItems?.length ?? "0"} ",
                                                style: pw.TextStyle(
                                                  fontSize: 15.sp,
                                                  font: font,
                                                ),
                                              ),
                                            ),
                                            pw.Container(
                                              alignment:
                                                  pw.Alignment.centerRight,
                                              width: 90.w,
                                              child: pw.Text(
                                                "${listOfLists[i][itemIndex].amount?.toStringAsFixed(2) ?? "0"} ",
                                                style: pw.TextStyle(
                                                  fontSize: 15.sp,
                                                  font: font,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ]));
                            }),
                        (i == listOfLists.length - 1)
                            ? pw.Divider()
                            : pw.SizedBox(),
                        (i == listOfLists.length - 1)
                            ? pw.Row(
                                mainAxisAlignment:
                                    pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.Text(
                                    "Total Amount : ",
                                    style: pw.TextStyle(
                                      fontSize: 14.sp,
                                      font: font,
                                    ),
                                  ),
                                  pw.Text(
                                    "${totalAmount.toStringAsFixed(2)}  ",
                                    style: pw.TextStyle(
                                      fontSize: 14.sp,
                                      font: font,
                                    ),
                                  ),
                                ],
                              )
                            : pw.SizedBox()
                      ],
                    ),
                    pw.Footer(
                        trailing: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.Text("Powered By ",
                            style: pw.TextStyle(
                              fontSize: 13.sp,
                              font: font,
                            )),
                        pw.Image(logoImg, width: 100.w, height: 10.w)
                      ],
                    )),
                  ])));
    }

    final output = await pdf.save();
    return output;
  }

  Future<void> saveSalesPdfToDownloads(Uint8List pdfData) async {
    String downloadPath = await Utils.downloadPath();
    File file = File('$downloadPath/doozy.pdf');
    await file.writeAsBytes(pdfData);

    print('PDF saved to ${file.path}');
  }

  Future<bool> requestSalesPermissions() async {
    bool checkStoragerPermission = await Permission.storage.request().isGranted;
    bool checkManageExtStoragePermission =
        await Permission.manageExternalStorage.request().isGranted;
    // var status = await Permission.storage.status;
    if (checkStoragerPermission || checkManageExtStoragePermission) {
      return true;
    } else {
      var result = await Permission.manageExternalStorage.request();
      return result.isGranted;
    }
  }

  shareSalesBillPdfFunc(List<SalesHistoryItemsModel> salesHistMode) async {
    bool value = await requestSalesPermissions();
    if (value == true) {
      Uint8List bytes = await createSalesHistBill(salesHistMode);
      await saveSalesPdfToDownloads(bytes);
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/doozy.pdf').create();
      await file.writeAsBytes(bytes);
      Share.shareFiles(
        [file.path],
      );
      notifyListeners();
    }
  }

  shareSalesBillImageFunc(List<SalesHistoryItemsModel> salesHistMode) async {
    bool value = await requestSalesPermissions();
    if (value == true) {
      Uint8List bytes = await createSalesHistBill(salesHistMode);
      await saveSalesPdfToDownloads(bytes);
      final imageFiles = <File>[];

      final document = await PdfDocument.openData(bytes);
      for (var i = 1; i <= document.pagesCount; i++) {
        final page = await document.getPage(i);
        PdfPageImage? pageImage = await page.render(
            backgroundColor: "#FFFFFF",
            width: page.width,
            height: page.height,
            format: PdfPageImageFormat.png);
        final tempDir = await getTemporaryDirectory();
        final file = await File('${tempDir.path}/doozy$i.png').create();
        await file.writeAsBytes(pageImage!.bytes);
        imageFiles.add(file);
        await page.close();
      }

      final filePaths = imageFiles.map((file) => file.path).toList();
      await Share.shareFiles(filePaths, text: 'Check out these PDF images!');
      Share.shareFiles(
        filePaths,
      );

      notifyListeners();
    }
  }

  // ---------------------------------- Get Response From Stream -----------------------------------
  List animatedListData = [];
  List<SalesHistoryItemsModel> animatedSalesListData = [];
  bool loadedAnimatedData = false;

  changeAnimatedLoadedData(bool value) {
    loadedAnimatedData = value;
    notifyListeners();
  }

  removeItemFromAnimatedSalesList(int index) {
    animatedSalesListData.removeAt(index);
    notifyListeners();
  }

  clearAnimatedListData() {
    animatedListData = [];
    animatedSalesListData = [];
    notifyListeners();
  }

  getResponse(Map<String, dynamic> recievedData) async {
    if (recievedData["eventType"] == "fetchInventory") {
      // await displayInventoryFunc(recievedData["result"]);
    } else if (recievedData["eventType"] == "fetchSale") {
      displaySalesHistoryListFunc(recievedData["result"]);
    } else if (recievedData["eventType"] == "process_sent") {
      getManualResDataFunc(recievedData["result"]);
    } else if (recievedData["eventType"] == "doc") {
      getOcrDataFunc(recievedData["result"]);
    } else if (recievedData["eventType"] == "audio") {
      getAudioDataFunc(recievedData["result"]);
    } else if (recievedData["eventType"] == "session") {
      getSessionIdFunc(recievedData["result"]["session_id"] ?? "");
    } else {}
  }

  fetchSalesHistoryListFunc() async {
    var data = await CoreDataFormates().createInventoryObject(
        message: 1,
        session: "",
        eventType: CoreDataFormates.eventType.elementAt(7),
        value: jsonEncode({"page": 1}));
    CoreAppUrls.channel?.sink.add(jsonEncode(data));
    notifyListeners();
  }

  displaySalesHistoryListFunc(String response) async {
    List list = await jsonDecode(response);
    List audioList = [];
    await addElements(list);
    notifyListeners();
  }

  Future addElements(List list) async {
    Map<String, dynamic> data;

    List salesList = [];
    for (var element in list) {
      List productList = [];
      for (var e in element["ITEMS"]) {
        productList.add(e);
      }
      data = {"TOTAL AMOUNT": element["TOTAL AMOUNT"], "ITEMS": productList};
      animatedListData.add(data);
    }

    changeAnimatedLoadedData(true);
    notifyListeners();
  }

  getManualResDataFunc(List resList) async {
    List<AudioProductModel> tempList = [];
    for (var element in resList) {
      tempList.add(AudioProductModel.fromJson(element));
    }
    changeIsBillCreating(false);
    changeIsBillCreating(false);
    addDatatoResponseListFunc(tempList: tempList, type: toggleState);
    // toggleState == 0
    //     ? salesChatList.add(SalesMessageModel(
    //         messageType: 1,
    //         widgetType: 0,
    //         messageDataModel:
    //             MessageDataModel(audioProductModelList: tempList)))
    //     : inventoryChatList.add(SalesMessageModel(
    //         messageType: 1,
    //         widgetType: 5,
    //         messageDataModel:
    //             MessageDataModel(audioProductModelList: tempList)));
    changeAllowSwitchingTabFunc(true);
    playMesgAudio(msgAudioType: 1);

    tempList = [];

    changeLoading(false);
    checkScrollFunc(salesChatList.length, inventoryChatList.length);
    notifyListeners();
  }

  Map<String, dynamic> replaceAndCombine(
      Map<String, dynamic> map, String key, dynamic newValue) {
    Map<String, dynamic> modifiedMap = Map<String, dynamic>.from(map);
    modifiedMap[key] = newValue;
    return {...map, ...modifiedMap};
  }

  getGTINResDataFunc(List resList) async {
    List<AudioProductModel> tempList = [];
    if (toggleState == 0) {
      //-----------
      if (salesResponseList.isNotEmpty) {
        for (var element in resList) {
          for (var value in salesResponseList) {
            if (value.productName == element["PRODUCT NAME"]) {
              if (value.productQty == null) {
                value.productQty = 1;
              } else {
                value.productQty = value.productQty! + 1;
              }
            } else {
              tempList.add(AudioProductModel.fromJson(element));
            }
          }
        }
      } else {
        for (var element in resList) {
          Map<String, dynamic> result =
              replaceAndCombine(element, "PRODUCT QTY", 1);

          tempList.add(AudioProductModel.fromJson(result));
        }
      }
      //-----------------
    } else {
      //--------
      if (inventoryResponseList.isNotEmpty) {
        for (var element in resList) {
          for (var value in inventoryResponseList) {
            if (value.productName == element["PRODUCT NAME"]) {
              inventoryResponseList.indexOf(value);
              if (value.productQty == null) {
                value.productQty = 1;
              } else {
                value.productQty = value.productQty! + 1;
              }
            } else {
              tempList.add(AudioProductModel.fromJson(element));
            }
          }
        }
      } else {
        for (var element in resList) {
          Map<String, dynamic> result =
              replaceAndCombine(element, "PRODUCT QTY", 1);
          tempList.add(AudioProductModel.fromJson(result));
        }
      }
    }

    changeisGTINactivatedFunc(false);
    changeIsBillCreating(false);
    changeIsBillCreating(false);

    addDatatoResponseListFunc(tempList: tempList, type: toggleState);
    // toggleState == 0
    //     ? salesChatList.add(SalesMessageModel(
    //         messageType: 1,
    //         widgetType: 0,
    //         messageDataModel:
    //             MessageDataModel(audioProductModelList: tempList)))
    //     : inventoryChatList.add(SalesMessageModel(
    //         messageType: 1,
    //         widgetType: 5,
    //         messageDataModel:
    //             MessageDataModel(audioProductModelList: tempList)));

    playMesgAudio(msgAudioType: 1);
    tempList = [];
    changeAllowSwitchingTabFunc(true);
    changeLoading(false);
    checkScrollFunc(salesChatList.length, inventoryChatList.length);
    notifyListeners();
  }

  getOcrDataFunc(List resList) {
    List<AudioProductModel> tempList = [];
    for (var element in resList) {
      tempList.add(AudioProductModel.fromJson(element));
    }
    changeIsBillCreating(false);
    addDatatoResponseListFunc(tempList: tempList, type: toggleState);
    // toggleState == 0
    //     ? salesChatList.add(SalesMessageModel(
    //         messageType: 1,
    //         widgetType: 0,
    //         messageDataModel:
    //             MessageDataModel(audioProductModelList: tempList)))
    //     : inventoryChatList.add(SalesMessageModel(
    //         messageType: 1,
    //         widgetType: 5,
    //         messageDataModel:
    //             MessageDataModel(audioProductModelList: tempList)));

    tempList = [];
    playMesgAudio(msgAudioType: 1);
    changeAllowSwitchingTabFunc(true);
    changeLoading(false);
    checkScrollFunc(salesChatList.length, inventoryChatList.length);
    notifyListeners();
  }

  getAudioDataFunc(List resList) {
    List<AudioProductModel> tempList = [];
    for (var element in resList) {
      tempList.add(AudioProductModel.fromJson(element));
    }
    changeIsBillCreating(false);
    addDatatoResponseListFunc(tempList: tempList, type: toggleState);
    // toggleState == 0
    //     ? salesChatList.add(SalesMessageModel(
    //         messageType: 1,
    //         widgetType: 0,
    //         messageDataModel:
    //             MessageDataModel(audioProductModelList: tempList)))
    //     : inventoryChatList.add(SalesMessageModel(
    //         messageType: 1,
    //         widgetType: 5,
    //         messageDataModel:
    //             MessageDataModel(audioProductModelList: tempList)));

    tempList = [];
    playMesgAudio(msgAudioType: 1);
    changeAllowSwitchingTabFunc(true);
    checkScrollFunc(salesChatList.length, inventoryChatList.length);

    changeLoading(false);
    notifyListeners();
  }

  getSessionIdFunc(String response) async {
    await CoreDataFormates.prefs?.setString("SessionKey", response);
  }

  //------------------------- Calculate Total Sales Monthly -------------------------------------------
  double totalMonthlySaleAmount = 0.0;
  setMonthlySaleAmountFunc(double value) {
    totalMonthlySaleAmount = value;
    notifyListeners();
  }
  //

  String salesHistStartDate = DateTime.now().toString();
  String salesHistEndDate = DateTime.now().toString();
  setSalesFilterDate(String startDate, String endDate) {
    salesHistStartDate = startDate;
    salesHistEndDate = endDate;
    notifyListeners();
  }

  Future<double> calculateTotalSalesAmountFunc() async {
    String stdt = Utils.formatdateStamp("dd-MM-yyyy", salesHistStartDate);
    String eddt = Utils.formatdateStamp("dd-MM-yyyy", salesHistEndDate);
    try {
      if (stdt == eddt) {
        final response = await supabase
            .from('sales')
            .select('*')
            .gte('created_at', salesHistStartDate);
        // 24 May 2024
        // .range(0, 10); // number of rows we want to fetch at a time

        if (response.isEmpty) {
          clearAnimatedListData();
          setMonthlySaleAmountFunc(0);

          throw 'Response is empty';
        }

        final List<dynamic> sales = response as List<dynamic>;

        if (response.isNotEmpty) {
          clearAnimatedListData();
          await setSalesAudioData(response);
        }

        final totalAmount = sales.fold(
            0.0, (sum, sale) => sum + (sale['total_amt'].toDouble() as double));

        setMonthlySaleAmountFunc(totalAmount);
        return totalAmount;
      } else {
        final response = await supabase
            .from('sales')
            .select('*')
            .gte('created_at', salesHistStartDate) // 1 May 2024 to
            .lte('created_at', salesHistEndDate); // 24 May 2024
        // .range(0, 10); // number of rows we want to fetch at a time

        print(response);
        if (response.isEmpty) {
          clearAnimatedListData();
          setMonthlySaleAmountFunc(0);

          throw 'Response is empty';
        }

        final List<dynamic> sales = response as List<dynamic>;

        if (response.isNotEmpty) {
          clearAnimatedListData();
          await setSalesAudioData(response);
        }

        final totalAmount = sales.fold(
            0.0, (sum, sale) => sum + (sale['total_amt'].toDouble() as double));

        setMonthlySaleAmountFunc(totalAmount);
        return totalAmount;
      }
    } catch (error) {
      print('Error calculating total sales amount: $error');
      rethrow;
    }
  }

  setSalesAudioData(List list) async {
    List<AudioProductModel> audioProList = [];
    SalesHistoryItemsModel salesHistoryItemsModel = SalesHistoryItemsModel();
    for (var element in list) {
      for (var value in element["items"] ?? []) {
        audioProList.add(AudioProductModel.fromJson(value));
      }
      var data = {
        "TOTAL AMOUNT": element["total_amt"],
        "ITEMS": audioProList,
        "SALE ID": element["id"].toString(),
        "created_at": element["created_at"],
      };
      salesHistoryItemsModel = SalesHistoryItemsModel.fromJson(data);
      animatedSalesListData.add(salesHistoryItemsModel);
      audioProList = [];
    }
  }

  //---------------------------------- Response widget -----------------------------------
  bool isSalesResponseEdit = false;
  changeisSalesResponseEdit(bool value) {
    isSalesResponseEdit = value;
    notifyListeners();
  }

  bool isInventoryResponseEdit = false;
  changeisInventoryResponseEdit(bool value) {
    isInventoryResponseEdit = value;
    notifyListeners();
  }

  //--------------------------------------App Language -------------------------
  String audioCode = "en-IN";
  String audioLang = "English";

  List lanMapData = [];
  List appTlLanguage = [];
  String appLangCode = "en";
  bool appLangLoading = false;

  changeAppLangLoad(bool value) {
    appLangLoading = value;
    notifyListeners();
  }

  addDataToTLLangList(String text) {
    appTlLanguage.add(text);
    notifyListeners();
  }

  addChangedDataToTLLangList(List<String> translatedLang) {
    appTlLanguage = translatedLang;
    notifyListeners();
  }

  addChangedTextToTLLangList(int index, String text) {
    appTlLanguage[index] = text;
    notifyListeners();
  }

  clearTLLanguage() {
    appTlLanguage = [];
    tlInventroyFilter = [];
    notifyListeners();
  }

  setAppLangCodeFunc(String code) {
    appLangCode = code;
    notifyListeners();
  }

  setAudioLangCodeFunc({required String code, required String langName}) {
    audioCode = code;
    audioLang = langName;
    notifyListeners();
  }

  List tlInventroyFilter = [];
  addDataToTLInvFilter(String text) {
    tlInventroyFilter.add(text);
    notifyListeners();
  }

  emptyTLInvFilterList() {
    tlInventroyFilter = [];
    notifyListeners();
  }

  addDataToLangMapData(Map map) {
    lanMapData.add(lanMapData);
    notifyListeners();
  }

  bool isMainFuncCompleted = false;
  changeisMainFuncCompletedFunc(bool value) {
    isMainFuncCompleted = value;
    notifyListeners();
  }

  checkUser(BuildContext context) async {
    final session = supabase.auth.currentSession;
    if (session != null) {
      await retrieveUserData(context, session.user.id);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  retrieveUserData(context, String userId) async {
    final response =
        await supabase.from('profiles').select().eq('id', userId).single();

    if (response.isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      final data = await supabase.from("app_settings").select();
      clearAppSettingsFunc();
      appsettingList.add(AppSettingsModel.fromJson(data[0]));
      final userData = response;
      CoreDataFormates.userModel = UserModel.fromJson(userData);

      setAppLangCodeFunc(CoreDataFormates.userModel.appLangCode ?? "en");
      setAudioLangCodeFunc(
          code: CoreDataFormates.userModel.audioLangCode ?? "en-IN",
          langName: CoreDataFormates.userModel.lang ?? "English");

      if (CoreDataFormates.userModel.businessName == null) {
        await changeFeatureSettingFunc(
          false,
        );
      } else {
        await changeFeatureSettingFunc(true);
      }
      await changeToggleState(0);
      await clearTLLanguage();
      // await setAppLangCodeFunc(CoreDataFormates.userModel.appLangCode ?? "en");
      appLangCode == "hi"
          ? await addChangedDataToTLLangList(CoreDataFormates.hindiAppLang)
          : appLangCode == "mr"
              ? await addChangedDataToTLLangList(
                  CoreDataFormates.marathiAppLang)
              : await addChangedDataToTLLangList(
                  CoreDataFormates.appLanguageList);
      if (CoreDataFormates.userModel.appLangCode != "en") {
        await changeAppLanguageFunc(context);
      }
      changeisMainFuncCompletedFunc(true);
      Navigator.pushNamed(context, "/homePage");
      print('User data: $userData');
    }
  }

  changeAppLanguageFunc(BuildContext context) async {
    final translator = GoogleTranslator();
    changeAppLangLoad(true);
    for (var i = 59; i <= 62; i++) {
      Translation translation = await translator.translate(
          CoreDataFormates.appLanguageList.elementAt(i),
          to: appLangCode);
      await addChangedTextToTLLangList(i, translation.text);
    }

    if (appLangCode == "hi") {
      emptyTLInvFilterList();
      for (var element in CoreDataFormates.filterListHindi) {
        addDataToTLInvFilter(element);
      }
    } else if (appLangCode == "mr") {
      emptyTLInvFilterList();
      for (var element in CoreDataFormates.filterListMarathi) {
        addDataToTLInvFilter(element);
      }
    } else {
      emptyTLInvFilterList();
      for (var element in CoreDataFormates.filterList) {
        addDataToTLInvFilter(element);
      }
    }

    changeAppLangLoad(false);
    Utils().hideKeyboard(context);
    notifyListeners();
  }

  //-----------------------------------Search Inventory ---------------------------------------------
  bool isInvSearching = false;
  bool isSearchResponseNull = false;
  bool issearchInvDataLoading = false;

  changeissearchInvDataLoading(bool value) {
    issearchInvDataLoading = value;
    notifyListeners();
  }

  changeInveSearchFunc(bool value) {
    isInvSearching = value;
    notifyListeners();
  }

  changeInveSearchResponseBoolFunc(bool value) {
    isSearchResponseNull = value;
    notifyListeners();
  }

  List<AudioProductModel> invSearchList = [];

  replaceInvSearchItemFunc(Map<String, dynamic> data, int index) {
    invSearchList[index] = AudioProductModel.fromJson(data);
    notifyListeners();
  }

  deleteInvSearchItemFunc(int index) {
    invSearchList.removeAt(index);
    notifyListeners();
  }

  clearInvSearchList() {
    invSearchList = [];
    notifyListeners();
  }

  searchInventoryProduct({required String searchName}) async {
    await changeInveSearchFunc(true);
    await clearInvSearchList();

    print(searchName);
    final response = await supabase
        .from('inventory_products_view')
        .select("*")
        .filter("USER ID", "eq", CoreDataFormates.userModel.id)
        .eq("IS DELETED", "FALSE")
        .ilike("PRODUCT NAME", "%$searchName%");
    if (response.isNotEmpty) {
      print(searchName);
      print(response.length);
      await clearInvSearchList();
      await changeInveSearchResponseBoolFunc(false);
      await changeissearchInvDataLoading(true);
      final translator = GoogleTranslator();
      for (var element in response) {
        // Translation translation = await translator
        //     .translate(element["PRODUCT NAME"], to: appLangCode);
        var data = {
          "inv id": element["inv id"],
          "PRODUCT ID": element["PRODUCT ID"],
          "PRODUCT QTY": element["PRODUCT QTY"],
          "PRODUCT UNIT": element["PRODUCT UNIT"],
          "PRODUCT SP": element["PRODUCT SP"],
          "PRODUCT AMOUNT": element["PRODUCT AMOUNT"],
          // "PRODUCT NAME": translation.text,
          "PRODUCT NAME": element["PRODUCT NAME"],
        };
        invSearchList.add(AudioProductModel.fromJson(data));
      }
      changeissearchInvDataLoading(false);
    } else {
      changeInveSearchResponseBoolFunc(true);
    }
  }

  //------------------------------------ Inventory Filter --------------------------------
  //invFilter Type = 0 -All , 1 - Loose , 2 - Low stock , 3 - High stock , 4 - Empty stock
  int invFilterType = 0;
  setInvFilterIndexFunc(int type) {
    invFilterType = type;
    notifyListeners();
  }

  List<AudioProductModel> invFilterList = [];

  Future<bool> applyInvFilterFunc() async {
    invFilterList = [];
    if (invFilterType == 1) {
      final response = await supabase
          .from("inventory_products_view")
          .select("*")
          .eq("PRODUCT GTIN", "NULL");

      if (response.isNotEmpty) {
        for (var element in response) {
          invFilterList.add(AudioProductModel.fromJson(element));
        }
      } else {
        return false;
      }
    } else if (invFilterType == 2) {
      final response = await supabase
          .from("inventory_products_view")
          .select("*")
          .lte("PRODUCT QTY", "10");
      if (response.isNotEmpty) {
        for (var element in response) {
          invFilterList.add(AudioProductModel.fromJson(element));
        }
      } else {
        return false;
      }
    } else if (invFilterType == 3) {
      final response = await supabase
          .from("inventory_products_view")
          .select("*")
          .gte("PRODUCT QTY", "25");
      if (response.isNotEmpty) {
        for (var element in response) {
          invFilterList.add(AudioProductModel.fromJson(element));
        }
      } else {
        return false;
      }
    } else if (invFilterType == 4) {
      final response = await supabase
          .from("inventory_products_view")
          .select("*")
          .lte("PRODUCT QTY", "0");
      if (response.isNotEmpty) {
        for (var element in response) {
          invFilterList.add(AudioProductModel.fromJson(element));
        }
      } else {
        return false;
      }
    } else {
      invFilterList = [];
    }
    notifyListeners();
    return false;
  }

  //----------------------------------Bardcode Scanner -------------------------------------

  // BluetoothDevice? connectedDevice;

  bool isGTINactivated = false;
  changeisGTINactivatedFunc(bool value) {
    isGTINactivated = value;
    notifyListeners();
  }

  sendGTINFunc(BuildContext context, String productDetails) async {
    if (productDetails != "") {
      toggleState == 0
          ? salesChatList.add(SalesMessageModel(
              messageType: 0,
              widgetType: 4,
              messageDataModel: MessageDataModel(manualMsg: productDetails)))
          : inventoryChatList.add(SalesMessageModel(
              messageType: 0,
              widgetType: 4,
              messageDataModel: MessageDataModel(manualMsg: productDetails)));

      changeAllowSwitchingTabFunc(false);

      await playMesgAudio(msgAudioType: 0);
      changeisGTINactivatedFunc(true);
      final reponse = await supabase
          .from('product_view')
          .select("*")
          .eq("PRODUCT GTIN", productDetails);

      if (reponse.isNotEmpty) {
        await getGTINResDataFunc(reponse);
        changeLoading(false);
      } else {
        final reponse = await supabase
            .from('missing_gtin_data')
            .upsert({'gtin': productDetails});
        print(reponse);
        changeisGTINactivatedFunc(false);
        changeLoading(false);
      }
      notifyListeners();
    }
  }

  sentGTINFunc() async {
    changeisGTINactivatedFunc(true);
    final reponse =
        await supabase.from('products').select("*").eq("gtin", "6294017124031");

    print(reponse);
  }

  String scannedBarcode = '';

  // --------------------------------Business Details ----------------------------------------------------
  // location tracing..
  bool hasPermission = false;
  bool serviceEnabled = false;
  bool isBusinessLocLoading = false;
  TextEditingController busniessAddress = TextEditingController();

  changeisBusinessLocLoadingFunc(bool value) {
    isBusinessLocLoading = value;
    notifyListeners();
  }

  setBusinessSddresFunc(String value) {
    busniessAddress.text = value;
    notifyListeners();
  }

  Future<bool> checkLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      return true;
    } else {
      var result = await Permission.location.request();
      return result.isGranted;
    }
  }

  fetchCurrentLocationEvent() async {
    changeisBusinessLocLoadingFunc(true);
    _hasPermission = await checkLocationPermission();
    if (_hasPermission == true) {
      try {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);

        Placemark placemark = placemarks.first;
        String completeAddress =
            '${placemark.street}, ${placemark.subLocality}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}, ${placemark.postalCode}';

        setBusinessSddresFunc(completeAddress);

        changeisBusinessLocLoadingFunc(false);
      } catch (e) {
        print(e);
      }
    }
  }

  updateUserDataEvent(String tableName, Map data) async {
    await supabase
        .from(tableName)
        .update(data)
        .eq("id", CoreDataFormates.userModel.id!);
    final newdata = await supabase.from(tableName).select();
    CoreDataFormates.userModel = UserModel.fromJson(newdata[0]);
    notifyListeners();
  }

  //----------------------------------------- Change app lang from otp ------------------------
  bool isLangChangeOTp = false;
  changeIsLangChangeOTp(bool value) {
    isLangChangeOTp = value;
    notifyListeners();
  }

  //----------------------------------- Ready for new bill -------------------------------------
  List<AudioProductModel> salesResponseList = [];
  List<AudioProductModel> inventoryResponseList = [];

  addDatatoResponseListFunc(
      {required List<AudioProductModel> tempList, required int type}) async {
    if (type == 0) {
      for (var element in tempList) {
        salesResponseList.add(element);
      }
    } else {
      for (var element in tempList) {
        inventoryResponseList.add(element);
      }
    }

    notifyListeners();
  }

  clearResponseList({required int type}) {
    if (type == 0) {
      salesResponseList = [];
    } else {
      inventoryResponseList = [];
    }
    notifyListeners();
  }

//----------------------------- Chat bot -----------------------------------------------------------------
  List<int> messageIndexList = [];
  List<String> translatedText = [];
  List<String> botBusinessListType = [];
  String previousLangCode = "";
  bool isChatBotLoading = false;
  int chatbotSelectedLangIndex = -1;
  int chatbotBusinessIndex = -1;

  setchatbotSelectedLangIndexFunc(int value) {
    chatbotSelectedLangIndex = value;
    notifyListeners();
  }

  setchatbotBusinessIndexFunc(int value) {
    chatbotBusinessIndex = value;
    notifyListeners();
  }

  SendMessageModel sendMessageModel = SendMessageModel();

  adddatatoBotTranslatedText(String text) {
    translatedText.add(text);
    notifyListeners();
  }

  adddatatoBotBusinessText(String text) {
    botBusinessListType.add(text);
    notifyListeners();
  }

  emptyBotTranslatedText() {
    translatedText = [];
    botBusinessListType = [];
    tlInventroyFilter = [];
    notifyListeners();
  }

  sendMessageModelFunc(SendMessageModel sendMessageModel) {
    sendMessageModel = sendMessageModel;
    notifyListeners();
  }

  setChatbotpreviousLangCodeFunc(String code) {
    previousLangCode = code;
    notifyListeners();
  }

  changeisChatBotLoadingFunc(bool value) {
    isChatBotLoading = value;
    notifyListeners();
  }

  addIndexFunc(int index) {
    messageIndexList.add(index);
    notifyListeners();
  }

  emptyIndexFunc() {
    messageIndexList = [];
    notifyListeners();
  }

  deleteIndexFunc(int index) {
    messageIndexList.remove(index);
    notifyListeners();
  }

  showNextMessageEventFunc(
      MessageModel messageModel, BuildContext context) async {
    if (previousLangCode != messageModel.code) {
      // Utils().hideKeyboard(context);
      setAppLangCodeFunc(messageModel.code ?? "en");
      changeAppLangLoad(true);
      final translator = GoogleTranslator();
      if (messageModel.code == "mr") {
        await emptyBotTranslatedText();
        await emptyBotTranslatedText();
        for (var element in CoreDataFormates.chatBotMsgMarathi) {
          await adddatatoBotTranslatedText(element);
        }
        for (var element in CoreDataFormates.chatBotBusinessType) {
          await adddatatoBotBusinessText(element);
        }
        for (var element in CoreDataFormates.filterListMarathi) {
          addDataToTLInvFilter(element);
        }
      } else if (messageModel.code == "hi") {
        await emptyBotTranslatedText();
        for (var element in CoreDataFormates.chatBotMsgHindi) {
          await adddatatoBotTranslatedText(element);
        }
        for (var element in CoreDataFormates.chatBotBusinessTypeHindi) {
          await adddatatoBotBusinessText(element);
        }
        for (var element in CoreDataFormates.filterListHindi) {
          addDataToTLInvFilter(element);
        }
      } else {
        await emptyBotTranslatedText();
        for (var element in CoreDataFormates.chatMessages) {
          await adddatatoBotTranslatedText(element);
        }
        for (var element in CoreDataFormates.chatBotBusinessType) {
          await adddatatoBotBusinessText(element);
        }
        for (var element in CoreDataFormates.filterList) {
          addDataToTLInvFilter(element);
        }
      }

      // Utils().hideKeyboard(context);
      await clearTLLanguage();
      appLangCode == "hi"
          ? await addChangedDataToTLLangList(CoreDataFormates.hindiAppLang)
          : appLangCode == "mr"
              ? await addChangedDataToTLLangList(
                  CoreDataFormates.marathiAppLang)
              : await addChangedDataToTLLangList(
                  CoreDataFormates.appLanguageList);
      // Utils().hideKeyboard(context);
      for (var i = 59; i <= 62; i++) {
        Translation translation = await translator.translate(
            CoreDataFormates.appLanguageList.elementAt(i),
            to: appLangCode);
        await addChangedTextToTLLangList(i, translation.text);
      }
      changeAppLangLoad(false);
    }

    sendMessageModelFunc(SendMessageModel(
      messageIndexList: messageIndexList,
      translatedMessageList: translatedText,
      code: messageModel.code,
    ));
    setChatbotpreviousLangCodeFunc(messageModel.code!);

    notifyListeners();
  }

//
  updateChatBotUserDataEventFunc(
      String tableName, String key, String value) async {
    await supabase
        .from(tableName)
        .update({key: value}).eq("id", CoreDataFormates.userModel.id!);

    notifyListeners();
  }
}

class ManualProductProvider extends ChangeNotifier {
  int manualEditorBtnState = 0;
  changeManualEditorBtnState(int index) async {
    manualEditorBtnState = index;
    notifyListeners();
  }

  //---------------------- validate chatbot upiid ------------------------------
  Color upiColor = Colors.black;

  changeUPIColorFunc(Color color) {
    upiColor = color;
    notifyListeners();
  }

  bool isUpiValid = true;
  changeisUpiValidFunc(bool value) {
    isUpiValid = value;
    notifyListeners();
  }

  Timer? timer;
  changeBotUPIIdColorFunc() async {
    changeUPIColorFunc(Colors.black);
    timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (upiColor == Colors.black) {
        changeUPIColorFunc(Utils.primaryPinkColor);
      } else {
        changeUPIColorFunc(Colors.black);
      }

      notifyListeners();
    });
  }
}

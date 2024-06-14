import 'dart:convert';
import 'package:doozy/shared/core/models/appsettings.model.dart';
import 'package:doozy/shared/core/models/audioProduct.model.dart';
import 'package:doozy/shared/core/models/user.model.dart';
import 'package:doozy/shared/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CoreDataFormates {
  Future<Map<String, dynamic>> createSaleObject(
      {required int message,
      required String session,
      required String eventType,
      required String value,
      required double amount}) async {
    Map<String, dynamic> data = {
      "messageId": message,
      "sessionId": session,
      "eventType": eventType,
      "value": jsonEncode({"items": value, "amount": amount.toStringAsFixed(2)})
    };
    return data;
  }

  Future<Map<String, dynamic>> createInventoryObject({
    required int message,
    required String session,
    required String eventType,
    required String value,
  }) async {
    Map<String, dynamic> data = {
      "messageId": message,
      "sessionId": session,
      "eventType": eventType,
      "value": value
    };

    return data;
  }

  static UserModel userModel = UserModel();
  static List<AudioProductModel> imageSalesList = [];
  static SharedPreferences? prefs;
  static List<String> eventType = [
    "audio",
    "query",
    "image",
    "pdf",
    "createSale",
    "createInventory",
    "fetchInventory",
    "fetchSale"
  ];

  //
  static List<String> productUnitList = ["kg", "g", "l", "ml", "pcs", "Oth"];
  static List<AppSettingsModel> appsettingList = [];

// Inventory Filter list
  static List filterList = [
    "All",
    "Loose",
    "Low Stock",
    "High Stock",
    "Out Of Stock"
  ];
  static List filterListHindi = [
    "सभी",
    "ढीला",
    "कम स्टॉक",
    "उच्च स्टॉक",
    "स्टॉक ख़त्म"
  ];
  static List filterListMarathi = [
    "सर्व",
    "सैल",
    "कमी साठा",
    "उच्च साठा",
    "स्टॉक संपला"
  ];
//types of business
  static List<String> chatBotBusinessType = [
    "Fruit / Vegetable vendor",
    "Restaurant / Canteen",
    "Kirana Shop",
    "Other"
  ];
  static List<String> chatBotBusinessTypeHindi = [
    "फल/सब्जी विक्रेता",
    "रेस्तरां/कैंटीन",
    "किराना दुकान",
    "अन्य"
  ];
  static List<String> chatBotBusinessTypeMarathi = [
    "फळ/भाजी विक्रेते",
    "रेस्टॉरंट / कॅन्टीन",
    "किराणा दुकान",
    "इतर"
  ];

//bot messages
  static List<String> chatMessages = [
    "ChotuAI welcomes you",
    "Kindly choose your preferred language",
    "Could you please provide your UPI ID so that we can prepare a QR code for the bill amount, making transactions easier for you and your customers?",
    "Yes Sure!",
    "Not right now",
    "Please use the below text field to enter the UPI ID",
    "Type here..",
    "Start?",
    "Okay, no worries. \nLet me give you quick guide how I can assist you",
    "Thank you! 🙏 \nI am ready to serve you.",
    "Please check out this guide to learn how to use ChotuAI! \n\nFor Sales: \n1) Click on the “Sales” Tab. \n2) Click on the “Voice Icon”. \n3) Just say what the customer wants. \n4) Create a Bill. \n5) Custom QR for Payment, DONE! \n\nFor Catalogue Digitization: \n1) Click on the “Inventory” Tab \n2) Click on the “Voice Icon” \n3) Just say what you have \n4) Review, DONE! \n\nFor Inventory Management: \n1) Click on the “Inventory” Tab \n2) Click on the “Voice Icon” or “Camera” \n3) Just say what new is added or click a picture of a bill \n4) Review, DONE!",
    "Understood!",
    "Need assistant?",
    //
    "Namaste,\nYour  ChotuAI  is here to serve you, please tell me the name of your shop",
    "Done?",
    "I'm glad you understood how to use me. \nMy dear Owner, you can now begin using me.",
    "Start using ChotuAI",
    "Re-enter UPI ID here...",
    "Kindly select your business category",
    "Enter UPI ID here..."
  ];
  static List<String> chatBotMsgHindi = [
    "छोटू एआई आपका स्वागत करता है",
    "कृपया अपनी पसंदीदा भाषा चुनें",
    "क्या आप कृपया अपनी यूपीआय आईडी प्रदान कर सकते हैं ताकि हम बिल राशि के लिए एक क्यूआर कोड तैयार कर सकें, जिससे आपके और आपके ग्राहकों के लिए लेनदेन आसान हो जाए?",
    "हाँ यकीनन!",
    "अभी नहीं",
    "कृपया यूपीआय आईडी दर्ज करने के लिए नीचे दिए गए टेक्स्ट फ़ील्ड का उपयोग करें",
    "यहाँ टाइप करें..",
    "शुरू करना?",
    "ठीक है, कोई चिंता नहीं. \nमैं आपको त्वरित मार्गदर्शन देता हूं कि मैं आपकी कैसे सहायता कर सकता हूं",
    "धन्यवाद! 🙏 \nमैं आपकी सेवा करने के लिए तैयार हूं।",
    "छोटूएआई का उपयोग कैसे करें यह जानने के लिए कृपया इस गाइड को देखें! \n\nबिक्री के लिए: \n1) बिक्री टैब पर क्लिक करें। \n2) वॉयस आइकन पर क्लिक करें। \n3) बस वही कहें जो ग्राहक चाहता है। \n4) एक बिल बनाएं। \n5) भुगतान के लिए कस्टम क्यूआर, हो गया! \n\nकैटलॉग डिजिटलीकरण के लिए: \n1) इन्वेंटरी टैब पर क्लिक करें \n2) वॉयस आइकन पर क्लिक करें \n3) बस वही कहें जो आपके पास है \n4) समीक्षा करें, हो गया! \n\nइन्वेंटरी प्रबंधन के लिए: \n1) इन्वेंटरी टैब पर क्लिक करें \n2) वॉयस आइकन या कैमरा पर क्लिक करें \n3) बस बताएं कि क्या नया जोड़ा गया है या किसी बिल की तस्वीर पर क्लिक करें \n4) समीक्षा, हो गया!",
    "समझा!",
    "सहायक की आवश्यकता है?",
    //
    "नमस्ते,\nआपका छोटू एआई आपकी सेवा के लिए यहां है, कृपया मुझे अपनी दुकान का नाम बताएं",
    "हो गया?",
    "मुझे खुशी है कि आप समझ गए कि मेरा उपयोग कैसे करना है। \nमेरे प्रिय स्वामी, अब आप मेरा उपयोग करना शुरू कर सकते हैं।",
    "छोटू एआई का उपयोग शुरू करें",
    "यहां यूपीआय आईडी पुनः दर्ज करें...",
    "कृपया अपनी व्यवसाय श्रेणी चुनें",
    "यहां यूपीआय आईडी दर्ज करें...",
  ];
  static List<String> chatBotMsgMarathi = [
    "छोटू एआय तुमचे स्वागत करतो",
    "कृपया तुमची पसंतीची भाषा निवडा",
    "तुम्ही कृपया तुमचा यूपीआय आयडी देऊ शकता जेणेकरून आम्ही बिलाच्या रकमेसाठी क्युआर कोड तयार करू शकू, ज्यामुळे तुमच्यासाठी आणि तुमच्या ग्राहकांसाठी व्यवहार सोपे होतील?",
    "होय खात्री!",
    "योग्य नाही आता",
    "यूपीआय आयडी टाकण्यासाठी कृपया खालील मजकूर फील्ड वापरा",
    "येथे लिहा..",
    "सुरू?",
    "ठीक आहे, काळजी करू नका. \nमी तुम्हाला कशी मदत करू शकेन ते मी तुम्हाला द्रुत मार्गदर्शक देऊ",
    "धन्यवाद! 🙏 \nमी तुमची सेवा करायला तयार आहे.",
    "छोटू एआय कसे वापरावे हे जाणून घेण्यासाठी कृपया हे मार्गदर्शक पहा! \n\nविक्रीसाठी: \n1) “विक्री” टॅबवर क्लिक करा. \n2) व्हॉइस आयकॉन वर क्लिक करा. \n३) ग्राहकाला काय हवे आहे ते सांगा. \n4) विधेयक तयार करा. \n५) पेमेंटसाठी सानुकूल QR, पूर्ण झाले! \n\nकॅटलॉग डिजिटायझेशनसाठी: \n1) “इन्व्हेंटरी” टॅबवर क्लिक करा \n2) “व्हॉइस आयकॉन” वर क्लिक करा \n3) तुमच्याकडे काय आहे ते सांगा \n4) पुनरावलोकन करा, पूर्ण झाले! \n\nइन्व्हेंटरी मॅनेजमेंटसाठी: \n1) “इन्व्हेंटरी” टॅबवर क्लिक करा \n2) “व्हॉइस आयकॉन” किंवा “कॅमेरा” वर क्लिक करा \n3) फक्त नवीन काय जोडले आहे ते सांगा किंवा बिलाच्या चित्रावर क्लिक करा \n4) पुनरावलोकन करा, पूर्ण झाले!",
    "समजले!",
    "सहाय्यक पाहिजे?",
    //
    "नमस्कार,\nतुमचा छोटू एआय तुमच्या सेवेसाठी आहे, कृपया मला तुमच्या दुकानाचे नाव सांगा",
    "झाले?",
    "माझा वापर कसा करायचा हे तुम्हाला समजले आहे याचा मला आनंद आहे. \nमाझ्या प्रिय मालक, तुम्ही आता माझा वापर सुरू करू शकता.",
    "छोटू एआय वापरणे सुरू करा",
    "येथे यूपीआय आयडी पुन्हा प्रविष्ट करा...",
    "कृपया तुमची व्यवसाय श्रेणी निवडा",
    "येथे यूपीआय आयडी प्रविष्ट करा...",
  ];
//

//Sales Chat History Compenents
//message type : 0 - user , 1 - response ,
//widget type :
// 0 - create bill, 5 - create inventory , 7 - error msg
// 1 - bill created , 2 - audio sent , 3- ocr sent , 4 - manual product sent, 6 - Pdf sent

  static List<String> appLangDynamicList = [
    "${CoreDataFormates.userModel.businessName}",
    "${CoreDataFormates.userModel.businessAddress}",
    "+${CoreDataFormates.userModel.phone?.substring(0, 2)} ${CoreDataFormates.userModel.phone?.substring(2)}",
    "Bill Date : ${Utils.formatdateStamp("dd/MM/yyyy", DateTime.now().toString())}, ${Utils.formatTimeStamp("HH:mm a", DateTime.now().toString())}",
  ];
  static List<String> appLanguageList = [
    "SALES",
    "INVENTORY",
    "My Inventory",
    "Sales History",
    "Business Details",
    //5
    "Logout",
    "Inventory",
    "Search product name here...",
    "All",
    "Loose",
    //10
    "Low Stock",
    "High Stock",
    "Out Of Stock",
    "Month : ",
    "Total Sales : ",
    //15
    "Order No.",
    "Total Items",
    "Total Amount",
    "Add Shop Location",
    "Business Name",
    //20
    "Phone Number",
    "Whatsapp Number",
    "UPI ID",
    "Select audio language",
    "Select app language",
    //25
    "Save",
    "Enter number",
    "By clicking you agree",
    " Privacy Policy ",
    " and ",
    //30
    "Terms and Condition ",
    "Made in Bharat with",
    "Verify OTP",
    "Enter the OTP sent to",
    "Edit Number",
    //35
    "Didnt receive the OTP?",
    "Resend",
    "Continue",
    "Bill is created by ChotuAI",
    "Added product to your inventory sucessfully",
    //40
    "Details Updated Sucessfully",
    "Bill deleted sucessfully",
    "Item updated sucessfully",
    "Enter phone number",
    "Shop name updated Sucessfully",
    //45
    "UPI ID updated Sucessfully",
    "removed sucessfully",
    "Please enter shop name",
    "Please complete guidelines first to enable features",
    "Type here..",
    //50
    "M.R.P",
    "S.P",
    "Quantity",
    "Units",
    "ADD",
    //55
    "CANCEL",
    "Please wait data is loading..",
    "CREATE BILL",
    "Powered By",
    (CoreDataFormates.userModel.businessName ?? "No business name"),
    //60
    "${CoreDataFormates.userModel.businessAddress}",
    "+${CoreDataFormates.userModel.phone?.substring(0, 2)} ${CoreDataFormates.userModel.phone?.substring(2)}",
    "Bill Date : ${Utils.formatdateStamp("dd/MM/yyyy", DateTime.now().toString())}, ${Utils.formatTimeStamp("HH:mm a", DateTime.now().toString())}",
    "Total Items : ",
    "Sr.",
    //65
    "Name",
    "Qty",
    "Amount",
    "Total Amount : ",
    "Scan the QR to pay",
    //70
    "Are you sure, want to delete",
    "Yes",
    "No",
    "Are you sure, want to delete  \nall products?",
    "Bluetooth devices not found,\n Please tap and try again",
    //75
    "You switched audio language to",
    "Sending you bill Malik",
    "Both UPI ID should be same",
    "Quanity and Store price cannot be 0 or less than 0",
    "Malik, Kindly follow the instructions to start using me"
  ];
  static List<String> hindiAppLang = [
    "बिक्री",
    "भंडार",
    "मेरी सूची",
    "बिक्री इतिहास",
    "व्यावसायिक विवरण",
    //
    "लॉग आउट",
    "भंडार",
    "यहाँ उत्पाद का नाम खोजें...",
    "सभी",
    "ढीला",
    //
    "कम स्टॉक",
    "हाई स्टॉक",
    "स्टॉक ख़त्म",
    "महीना : ",
    "कुल बिक्री : ",
    //
    "आदेश संख्या।",
    "कुल सामान",
    "कुल राशि",
    "दुकान का स्थान जोड़ें",
    "व्यवसाय का नाम",
    //
    "फ़ोन नंबर",
    "व्हाट्सएप नंबर",
    "यूपीआई आईडी",
    "ऑडियो भाषा चुनें",
    "ऐप भाषा चुनें",
    //
    "हो गया",
    "नंबर डालें",
    "क्लिक करके आप सहमत हैं",
    " गोपनीयता नीति ",
    " और ",
    //
    "नियम व शर्तें ",
    "मेड इन भारत के साथ",
    "ओटीपी सत्यापित करें",
    "भेजा गया ओटीपी दर्ज करें",
    "संख्या संपादित करें",
    //
    "ओटीपी प्राप्त नहीं हुआ?",
    "पुनः भेजें",
    "जारी रखना",
    "बिल छोटूएआई द्वारा बनाया गया है",
    "आपकी सूची में उत्पाद सफलतापूर्वक जोड़ा गया",
    //
    "विवरण सफलतापूर्वक अद्यतन किया गया",
    "बिल सफलतापूर्वक हटा दिया गया",
    "आइटम सफलतापूर्वक अपडेट किया गया",
    "फोन नंबर दर्ज",
    "दुकान का नाम सफलतापूर्वक अपडेट किया गया",
    //
    "यूपीआई आईडी सफलतापूर्वक अपडेट हो गई",
    "सफलतापूर्वक हटा दिया गया",
    "कृपया दुकान का नाम दर्ज करें",
    "कृपया सुविधाओं को सक्षम करने के लिए पहले दिशानिर्देश पूरे करें",
    "यहाँ टाइप करें..",
    //
    "एम आर पी",
    "एस.पी",
    "मात्रा",
    "इकाइयाँ",
    "जोड़ना",
    //
    "रद्द करना",
    "कृपया प्रतीक्षा करें डेटा लोड हो रहा है..",
    "बिल बनाएं",
    "द्वारा संचालित",
    "${CoreDataFormates.userModel.businessName}",
    //
    "${CoreDataFormates.userModel.businessAddress}",
    "+${CoreDataFormates.userModel.phone?.substring(0, 2)} ${CoreDataFormates.userModel.phone?.substring(2)}",
    "Bill Date : ${Utils.formatdateStamp("dd/MM/yyyy", DateTime.now().toString())}, ${Utils.formatTimeStamp("HH:mm a", DateTime.now().toString())}",
    "कुल सामान : ",
    "क्रमांक",
    //
    "नाम",
    "मात्रा",
    "मात्रा",
    "कुल राशि : ",
    "भुगतान करने के लिए QR स्कैन करें",
    //
    "क्या आप निश्चित हैं, हटाना चाहते हैं",
    "हाँ",
    "नहीं",
    "क्या आप निश्चित हैं, \nसभी उत्पादों को हटाना चाहते हैं?",
    "ब्लूटूथ डिवाइस नहीं मिला,\nकृपया टैप करें और पुनः प्रयास करें",
    //
    "आपने ऑडियो भाषा को इसमें बदल दिया है",
    "मालीक, आपको बिल भेज रहा हूँ...",
    "दोनों की UPI आईडी एक जैसी होनी चाहिए",
    "मात्रा और स्टोर कीमत 0 या 0 से कम नहीं हो सकती",
    "मालिक, कृपया मेरा उपयोग शुरू करने के लिए निर्देशों का पालन करें"
  ];
  static List<String> marathiAppLang = [
    "विक्री",
    "इन्व्हेंटरी",
    "माझी यादी",
    "विक्री इतिहास",
    "व्यवसाय तपशील",
    //
    "बाहेर पडणे",
    "इन्व्हेंटरी",
    "येथे उत्पादनाचे नाव शोधा...",
    "सर्व",
    "सैल",
    //
    "कमी साठा",
    "उच्च स्टॉक",
    "साठा संपला",
    "महिना:",
    "एकूण विक्री : ",
    //
    "ऑर्डर क्र.",
    "एकूण वस्तू",
    "एकूण रक्कम",
    "दुकानाचे स्थान जोडा",
    "व्यवसायाचे नाव",
    //
    "फोन नंबर",
    "व्हॉट्सॲप नंबर",
    "UPI आयडी",
    "ऑडिओ भाषा निवडा",
    "ॲप भाषा निवडा",
    //
    "झाले",
    "नंबर प्रविष्ट करा",
    "आपण सहमत आहात क्लिक करून",
    "गोपनीयता धोरण",
    "आणि",
    //
    "नियम व अटी ",
    "मेड इन भारतात",
    "ओटीपी सत्यापित करा",
    "वर पाठवलेला OTP प्रविष्ट करा",
    "संख्या संपादित करा",
    //
    "OTP मिळाला नाही?",
    "पुन्हा पाठवा",
    "सुरू",
    "बिल ChotuAI ने तयार केले आहे",
    "तुमच्या इन्व्हेंटरीमध्ये उत्पादन यशस्वीरित्या जोडले",
    //
    "तपशील यशस्वीरित्या अद्यतनित केले",
    "बिल यशस्वीरित्या हटवले",
    "आयटम यशस्वीरित्या अपडेट केला",
    "फोन नंबर प्रविष्ट करा",
    "दुकानाचे नाव यशस्वीरित्या अपडेट केले",
    //
    "UPI आयडी यशस्वीरित्या अपडेट केला",
    "यशस्वीपणे काढले",
    "कृपया दुकानाचे नाव टाका",
    "वैशिष्ट्ये सक्षम करण्यासाठी कृपया प्रथम मार्गदर्शक तत्त्वे पूर्ण करा",
    "येथे लिहा..",
    //
    "एम आर पी",
    "एसपी",
    "प्रमाण",
    "युनिट्स",
    "जोडा",
    //
    "रद्द करा",
    "कृपया डेटा लोड होत असल्याची प्रतीक्षा करा..",
    "बिल तयार करा",
    "द्वारा समर्थित",
    "${CoreDataFormates.userModel.businessName}",
    //
    "${CoreDataFormates.userModel.businessAddress}",
    "+${CoreDataFormates.userModel.phone?.substring(0, 2)} ${CoreDataFormates.userModel.phone?.substring(2)}",
    "Bill Date : ${Utils.formatdateStamp("dd/MM/yyyy", DateTime.now().toString())}, ${Utils.formatTimeStamp("HH:mm a", DateTime.now().toString())}",
    "एकूण वस्तू: ",
    "अनुक्रमांक",
    //
    "नाव",
    "प्रमाण",
    "रक्कम",
    "एकूण रक्कम: ",
    "पैसे देण्यासाठी QR स्कॅन करा",
    //
    "तुम्हाला नक्की हटवायचे आहे का",
    "हो",
    "नाही",
    "तुम्हाला खात्री आहे की, \nall उत्पादने हटवायची आहेत?",
    "ब्लूटूथ डिव्हाइस आढळले नाहीत,\n कृपया टॅप करा आणि पुन्हा प्रयत्न करा",
    //
    "तुम्ही ऑडिओ भाषा यावर स्विच केली",
    "तुला बिल पाठवत आहे मालीक...",
    "दोन्ही UPI आयडी समान असावेत",
    "प्रमाण आणि स्टोअर किंमत 0 किंवा 0 पेक्षा कमी असू शकत नाही",
    "मालिक, कृपया माझा वापर सुरू करण्यासाठी सूचनांचे अनुसरण करा"
  ];
}

import 'package:doozy/view/account/businessDetail.page.dart';
import 'package:doozy/view/account/orderHistory.page.dart';
import 'package:doozy/view/account/salesHistory.page.dart';
import 'package:doozy/view/authentication/login.page.dart';
import 'package:doozy/view/authentication/otp.page.dart';
import 'package:doozy/view/home/home.page.dart';
import 'package:doozy/view/account/inventory/inventory.page.dart';
import 'package:doozy/view/home/splashScreen.page.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Routing {
  static Route routing(RouteSettings settings) {
    switch (settings.name) {
      case "/otpPage":
        return PageTransition(
            child: OtpPage(
              phoneNumber: settings.arguments as String,
            ),
            type: PageTransitionType.rightToLeftWithFade);

      case "/loginPage":
        return PageTransition(
            child: const LoginPage(),
            type: PageTransitionType.rightToLeftWithFade);

      case "/homePage":
        return PageTransition(
            child: const HomePage(),
            type: PageTransitionType.rightToLeftWithFade);

      case "/inventoryPage":
        return PageTransition(
            child: const InventoryPage(),
            type: PageTransitionType.rightToLeftWithFade);

      case "/salesHistoryPage":
        return PageTransition(
            child: const SalesHistoryPage(),
            type: PageTransitionType.rightToLeftWithFade);

      case "/businessDetailPage":
        return PageTransition(
            child: const BusinessDetailPage(),
            type: PageTransitionType.rightToLeftWithFade);

      case "/orderHistoryPage":
        return PageTransition(
            child: OrderHistoryPage(
              data: settings.arguments as Map,
            ),
            type: PageTransitionType.rightToLeftWithFade);

      case "/splashScreenPage":
        return PageTransition(
            child: const SplashScreenPage(),
            type: PageTransitionType.rightToLeftWithFade);

      default:
        return PageTransition(
            child: const HomePage(),
            type: PageTransitionType.rightToLeftWithFade);
    }
  }
}

import 'package:doozy/shared/core/others/urls.dart';
import 'package:doozy/shared/core/repositries/provider.dart';
import 'package:doozy/shared/routeSettings/routeSetting.dart';
import 'package:doozy/view/home/splashScreen.page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: CoreAppUrls.APIURL, anonKey: CoreAppUrls.APIKEY);
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => GlobalProvider()),
          ChangeNotifierProvider(create: (_) => ManualProductProvider()),
        ],
        builder: (context, child) => ScreenUtilInit(
              designSize: const Size(375, 812),
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (context, child) => const MaterialApp(
                title: 'ChotuAI',
                onGenerateRoute: Routing.routing,
                debugShowCheckedModeBanner: false,
                home: SplashScreenPage(),
                // home: LoginPage(),
              ),
            ));
  }
}

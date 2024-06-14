import 'package:doozy/main.dart';
import 'package:doozy/shared/core/models/user.model.dart';
import 'package:doozy/shared/core/others/dataFormates.dart';
import 'package:doozy/shared/core/repositries/provider.dart';
import 'package:doozy/shared/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalProvider>(builder: (context, pro, child) {
      return Drawer(
        width: 195.w,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.09,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.cancel,
                        size: 30.sp,
                        color: Utils.primaryPinkColor,
                      )),
                ),
              ],
            ),
            ListTile(
              title: Text(pro.appTlLanguage.isNotEmpty
                  ? pro.appTlLanguage[2]
                  : 'My Inventory'),
              leading: const Icon(Icons.grid_view),
              onTap: () => Navigator.pushNamed(context, "/inventoryPage"),
            ),
            ListTile(
                title: Text(pro.appTlLanguage.isNotEmpty
                    ? pro.appTlLanguage[3]
                    : 'Sales History'),
                leading: const Icon(Icons.description),
                onTap: () async {
                  Navigator.pushNamed(context, "/salesHistoryPage");
                }),
            ListTile(
              title: Text(pro.appTlLanguage.isNotEmpty
                  ? pro.appTlLanguage[4]
                  : 'Business Details'),
              leading: const Icon(Icons.person_pin),
              onTap: () => Navigator.pushNamed(context, "/businessDetailPage"),
            ),
            ListTile(
              title: Text(pro.appTlLanguage.isNotEmpty
                  ? pro.appTlLanguage[5]
                  : 'Logout'),
              leading: const Icon(Icons.logout),
              onTap: () async {
                pro.clearChatListFunc();
                pro.changeLoading(false);
                pro.changeAllowSwitchingTabFunc(true);
                pro.clearAppSettingsFunc();
                pro.clearTLLanguage();
                pro.emptyIndexFunc();
                pro.emptyBotTranslatedText();

                CoreDataFormates.userModel = UserModel();
                supabase.auth.signOut();
                Navigator.pushNamed(context, "/loginPage");
              },
            ),
          ],
        ),
      );
    });
  }
}

import 'dart:convert';

import 'package:doozy/shared/core/others/urls.dart';
import 'package:doozy/shared/core/repositries/provider.dart';
import 'package:provider/provider.dart';

listenToChannelFunc(context) async {
  CoreAppUrls.channel?.stream.listen((event) async {
    Map<String, dynamic> recievedData = await jsonDecode(event);
    print(recievedData);
    await Provider.of<GlobalProvider>(context, listen: false)
        .getResponse(recievedData);
  });
}

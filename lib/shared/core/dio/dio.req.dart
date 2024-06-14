import 'package:dio/dio.dart';
import 'package:doozy/main.dart';
import 'package:doozy/shared/core/models/message.model.dart';
import 'package:doozy/shared/core/models/messageData.model.dart';
import 'package:doozy/shared/core/others/urls.dart';
import 'package:doozy/shared/core/repositries/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DioRequestCalls {
  static final dio = Dio();
  static Response? response;

  static Future<dynamic> postCall(
      {required BuildContext context,
      required String endpoint,
      required Map data,
      Map<String, dynamic>? queryParameters}) async {
    GlobalProvider pro = Provider.of<GlobalProvider>(context, listen: false);
    try {
      response = await dio.post("${CoreAppUrls.dioUrl}api/$endpoint",
          data: data,
          queryParameters: queryParameters,
          options: Options(headers: {
            "Authorization":
                "Bearer ${supabase.auth.currentSession!.accessToken}"
          }));

      return response?.data;
    } on DioException catch (e) {
      if (e.response != null) {
        print('DioError: ${e.response?.statusCode}');
        print('DioError: ${e.response?.data}');
        pro.changeLoading(false);
        pro.changeAllowSwitchingTabFunc(true);
        pro.toggleState == 0
            ? pro.salesChatList.add(SalesMessageModel(
                messageType: 1,
                widgetType: 7,
                messageDataModel:
                    MessageDataModel(manualMsg: e.response?.data["error"])))
            : pro.inventoryChatList.add(SalesMessageModel(
                messageType: 1,
                widgetType: 7,
                messageDataModel:
                    MessageDataModel(manualMsg: e.response?.data["error"])));
      } else {
        print('DioError: ${e.message}');
      }

      rethrow;
    }
  }

  static Future<dynamic> patchCall(
      {required String endpoint, required int id, required Map data}) async {
    try {
      response =
          await dio.patch("${CoreAppUrls.dioUrl}$endpoint$id", data: data);
      return response?.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> deleteCall({
    required String endpoint,
    int? id,
    Object? data,
  }) async {
    try {
      response = await dio.delete("${CoreAppUrls.dioUrl}api/$endpoint",
          data: data,
          options: Options(headers: {
            "Authorization":
                "Bearer ${supabase.auth.currentSession!.accessToken}"
          }));
      return response?.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> getCall({
    required String endpoint,
    Map? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      response = await dio.get("${CoreAppUrls.dioUrl}api/$endpoint",
          // data: data,
          queryParameters: queryParameters,
          options: Options(headers: {
            "Authorization":
                "Bearer ${supabase.auth.currentSession!.accessToken}"
          }));
      return response?.data;
    } catch (e) {
      rethrow;
    }
  }

  static Future<dynamic> getByIdCall(
      {required String endpoint, required int id}) async {
    try {
      response = await dio.get("${CoreAppUrls.dioUrl}$endpoint$id");
      return response?.data;
    } catch (e) {
      rethrow;
    }
  }
}

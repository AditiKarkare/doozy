import 'package:doozy/shared/core/models/messageData.model.dart';

class SalesMessageModel {
  int messageType;
  int widgetType;
  MessageDataModel messageDataModel;

  SalesMessageModel(
      {required this.messageType,
      required this.widgetType,
      required this.messageDataModel});
}

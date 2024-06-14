class MessageModel {
  int? messageIndex;
  List<String>? messageList;
  String? code;
  MessageModel({this.messageIndex, this.code, this.messageList});
}

class SendMessageModel {
  List<int>? messageIndexList;
  List<String>? translatedMessageList;
  String? code;
  SendMessageModel(
      {this.messageIndexList, this.code, this.translatedMessageList});
}

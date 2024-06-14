import 'package:doozy/shared/core/models/audioProduct.model.dart';
import 'package:doozy/shared/core/models/salesHistory.model.dart';

class MessageDataModel {
  AudioProductModel? audioProductModel;
  List<AudioProductModel>? audioProductModelList;
  SalesHistoryItemsModel? salesHistoryItemsModel;
  String? audioRecording;
  String? ocrImage;
  String? manualMsg;

  MessageDataModel(
      {this.audioProductModel,
      this.audioProductModelList,
      this.salesHistoryItemsModel,
      this.audioRecording,
      this.ocrImage,
      this.manualMsg});

  MessageDataModel.fromJson(Map<String, dynamic> json) {
    audioRecording = json['audioRecording'];
    ocrImage = json['ocrImage'];
    manualMsg = json['manualMsg'];
    if (json['audioProductModel'] != null) {
      audioProductModel = AudioProductModel.fromJson(json['audioProductModel']);
    } else {
      audioProductModel = AudioProductModel();
    }

    if (json['audioProductModelList'] != null) {
      audioProductModelList = [];

      for (var element in audioProductModelList ?? []) {
        audioProductModelList?.add(AudioProductModel.fromJson(json[element]));
      }
    } else {
      audioProductModelList = [];
    }
    if (json['salesHistoryItemsModel'] != null) {
      salesHistoryItemsModel =
          SalesHistoryItemsModel.fromJson(json['salesHistoryItemsModel']);
    } else {
      salesHistoryItemsModel = SalesHistoryItemsModel();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['audioRecording'] = audioRecording;
    data['ocrImage'] = ocrImage;
    data['manualMsg'] = manualMsg;
    if (audioProductModel != null) {
      data['audioProductModel'] = audioProductModel?.toJson();
    } else {
      data['audioProductModel'] = null;
    }
    if (salesHistoryItemsModel != null) {
      data['salesHistoryItemsModel'] = salesHistoryItemsModel?.toJson();
    } else {
      data['salesHistoryItemsModel'] = null;
    }
    if (audioProductModelList != null) {
      for (var element in audioProductModelList ?? []) {
        data['audioProductModelList'].add(element.toJson());
      }
    } else {
      data['audioProductModelList'] = null;
    }

    return data;
  }
}

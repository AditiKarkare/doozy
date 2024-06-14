import 'package:doozy/shared/core/models/audioProduct.model.dart';

class InvoiceDataModel {
  String? vendorName;
  String? invDate;
  String? invId;
  List<AudioProductModel>? items;

  InvoiceDataModel({this.vendorName, this.invDate, this.invId, this.items});

  InvoiceDataModel.fromJson(Map<String, dynamic> json) {
    vendorName = json['vendorName'];
    invDate = json['invDate'];
    invId = json['invId'];
    if (json['items'] != null) {
      items = [];
      for (var element in json['items']) {
        items?.add(AudioProductModel.fromJson(element));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['vendorName'] = vendorName;
    data['invDate'] = invDate;
    data['invId'] = invId;
    if (items != null) {
      data['items'] = [];
      for (var element in items ?? []) {
        data['items'] = [...element.toJson()];
      }
    }
    return data;
  }
}

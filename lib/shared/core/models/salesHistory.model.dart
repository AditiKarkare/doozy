import 'package:doozy/shared/core/models/audioProduct.model.dart';

// AudioProductModel audioProductModel = AudioProductModel();

class SalesHistoryItemsModel {
  int? orderCount;
  String? createdDate;
  String? saleId;
  double? amount;
  List<AudioProductModel>? orderItems;

  SalesHistoryItemsModel(
      {this.orderCount,
      this.amount,
      this.orderItems,
      this.saleId,
      this.createdDate});

  SalesHistoryItemsModel.fromJson(Map<String, dynamic> json) {
    orderCount = json['orderCount'];
    createdDate = json['created_at'];
    saleId = json['SALE ID'];
    if (json['TOTAL AMOUNT'] != null) {
      amount = json['TOTAL AMOUNT'].toDouble();
    } else {
      amount = null;
    }

    if (json['ITEMS'] != null) {
      orderItems = [];
      for (var element in json['ITEMS']) {
        orderItems?.add(element);
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderCount'] = orderCount;
    data['created_at'] = createdDate;
    data['SALE ID'] = saleId;
    data['TOTAL AMOUNT'] = amount;
    if (orderItems != null) {
      data['ITEMS'] = orderItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

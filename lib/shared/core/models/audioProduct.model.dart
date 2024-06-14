class AudioProductModel {
  String? brandName;
  String? dDescription;
  String? origin;
  String? gtin;
  String? category;
  String? subCategory;
  String? image;
  num? netQty;
  num? tax;
  //
  int? id;
  int? productId;
  int? productQty;
  num? productPrice;
  num? amount;
  String? productUnit;
  String? productName;

  AudioProductModel(
      {this.id,
      this.productId,
      this.productQty,
      this.productUnit,
      this.productName,
      this.productPrice,
      this.amount,
      //
      this.brandName,
      this.dDescription,
      this.category,
      this.gtin,
      this.image,
      this.netQty,
      this.origin,
      this.subCategory,
      this.tax});

  AudioProductModel.fromJson(Map<String, dynamic> json) {
    brandName = json['PRODUCT BRAND'];
    dDescription = json['PRODUCT D DESCRIPTION'];
    origin = json['PRODUCT ORIGIN'];
    gtin = json['PRODUCT GTIN'];
    category = json['PRODUCT CATEGORY'];
    subCategory = json['PRODUCT SUB-CATEGORY'];
    image = json['PRODUCT IMAGE'];

    if (json['PRODUCT NET-QTY'] != null) {
      netQty = json['PRODUCT NET-QTY'].toDouble();
    }

    if (json["PRODUCT TAX"] != null) {
      tax = json["PRODUCT TAX"].toDouble();
    }
    //
    id = json['inv id'];
    productId = json['PRODUCT ID'];
    productQty = json['PRODUCT QTY'];
    productUnit = json['PRODUCT UNIT'];
    if (json['PRODUCT SP'] != null) {
      productPrice = json['PRODUCT SP'].toDouble();
    }

    if (json['PRODUCT AMOUNT'] != null) {
      amount = json['PRODUCT AMOUNT'].toDouble();
    }

    productName = json['PRODUCT NAME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    //
    data['PRODUCT BRAND'] = brandName;
    data['PRODUCT D DESCRIPTION'] = dDescription;
    data['PRODUCT ORIGIN'] = origin;
    data['PRODUCT GTIN'] = gtin;
    data['PRODUCT CATEGORY'] = category;
    data['PRODUCT SUB-CATEGORY'] = subCategory;
    data['PRODUCT IMAGE'] = image;
    data['PRODUCT NET-QTY'] = netQty;
    data['PRODUCT TAX'] = tax;
//
    data['inv id'] = id;
    data['PRODUCT ID'] = productId;
    data['PRODUCT QTY'] = productQty;
    data['PRODUCT UNIT'] = productUnit;
    data['PRODUCT SP'] = productPrice;
    data['PRODUCT AMOUNT'] = amount;
    data['PRODUCT NAME'] = productName;
    return data;
  }
}

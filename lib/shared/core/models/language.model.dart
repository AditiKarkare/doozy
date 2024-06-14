class SupportedLanguage {
  String? code;
  String? name;
  String? translateCode;

  SupportedLanguage({this.code, this.name});

  SupportedLanguage.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
    translateCode = json['tl_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    data['tl_code'] = translateCode;
    return data;
  }
}

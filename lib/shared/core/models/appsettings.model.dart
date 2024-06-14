import 'package:doozy/shared/core/models/language.model.dart';

class AppSettingsModel {
  int? id;
  List<SupportedLanguage>? supportedLangs;
  String? currentVersion;
  String? oldVersion;
  String? createdAt;
  String? updatedAt;

  AppSettingsModel(
      {this.id,
      this.supportedLangs,
      this.currentVersion,
      this.oldVersion,
      this.createdAt,
      this.updatedAt});

  AppSettingsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['supported_langs'] != null) {
      supportedLangs = [];
      for (var element in json['supported_langs']) {
        supportedLangs?.add(SupportedLanguage.fromJson(element));
      }
    }
    currentVersion = json['current_version'];
    oldVersion = json['old_version'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (supportedLangs != null) {
      data['supported_langs'] = [];
      for (var element in supportedLangs ?? []) {
        data['supported_langs'].add(element.toJson());
      }
    }
    data['current_version'] = currentVersion;
    data['old_version'] = oldVersion;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

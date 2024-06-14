class UserModel {
  String? id;
  String? name;
  String? businessName;
  String? businessAddress;
  String? phone;
  String? phoneConfirmedAt;
  String? email;
  String? emailConfirmedAt;
  String? altPhone;
  String? businessPhoneConfirmedAt;
  String? businessEmail;
  String? upi;
  String? whatsappNo;
  String? whatsappNoConfirmedAt;
  String? plan;
  String? planExpiringAt;
  String? lang;
  String? createdAt;
  String? updatedAt;
  String? appLangCode;
  String? audioLangCode;

  UserModel(
      {this.id,
      this.name,
      this.phone,
      this.businessAddress,
      this.phoneConfirmedAt,
      this.email,
      this.emailConfirmedAt,
      this.altPhone,
      this.businessName,
      this.businessPhoneConfirmedAt,
      this.businessEmail,
      this.upi,
      this.whatsappNo,
      this.whatsappNoConfirmedAt,
      this.plan,
      this.planExpiringAt,
      this.lang,
      this.appLangCode,
      this.audioLangCode,
      this.createdAt,
      this.updatedAt});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    businessAddress = json['business_address'];
    businessName = json['business_name'];
    phone = json['phone'];
    phoneConfirmedAt = json['phone_confirmed_at'];
    email = json['email'];
    emailConfirmedAt = json['email_confirmed_at'];
    altPhone = json['alt_phone'];
    businessPhoneConfirmedAt = json['business_phone_confirmed_at'];
    businessEmail = json['business_email'];
    upi = json['upi'];
    whatsappNo = json['whatsapp_no'];
    whatsappNoConfirmedAt = json['whatsapp_no_confirmed_at'];
    plan = json['plan'];
    planExpiringAt = json['plan_expiring_at'];
    lang = json['lang'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    appLangCode = json['app_lang'];
    audioLangCode = json['audio_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['business_name'] = businessName;
    data['phone'] = phone;
    data['phone_confirmed_at'] = phoneConfirmedAt;
    data['email'] = email;
    data['email_confirmed_at'] = emailConfirmedAt;
    data['alt_phone'] = altPhone;
    data['business_phone_confirmed_at'] = businessPhoneConfirmedAt;
    data['business_email'] = businessEmail;
    data['upi'] = upi;
    data['whatsapp_no'] = whatsappNo;
    data['whatsapp_no_confirmed_at'] = whatsappNoConfirmedAt;
    data['plan'] = plan;
    data['plan_expiring_at'] = planExpiringAt;
    data['lang'] = lang;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['audio_code'] = audioLangCode;
    return data;
  }
}

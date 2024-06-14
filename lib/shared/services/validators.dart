class AppValidators {
  static String? anyString(String? value, String? text) {
    String finalValue = value!.trim();

    if (finalValue.isEmpty) {
      return "Please enter $text";
    } else {
      return null;
    }
  }

  static String? validateEmail(String? value, String? alret) {
    String patttern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(patttern);
    value = value?.trim();
    if (value == null) {
      return 'Email address cannot be empty';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid ${alret ?? "email address"} ';
    } else {
      return null;
    }
  }

  static String? validateUPI(String? value, String? alret) {
    String patttern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]";
    RegExp regExp = RegExp(patttern);
    value = value?.trim();
    if (value == null) {
      return 'Email address cannot be empty';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid ${alret ?? "email address"} ';
    } else {
      return null;
    }
  }

  static String? validatePhoneNum(String? value) {
    String patttern = r'^(?:[+0][1-9])?[0-9]{10,12}$';
    RegExp regExp = RegExp(patttern);
    value = value?.trim();
    if (value == null) {
      return 'Phone number address cannot be empty';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter a valid number';
    } else {
      return null;
    }
  }

  static String? validateDecimal(String? value) {
    String patttern = r'\d+(\.\d{0,2})?$';
    RegExp regExp = RegExp(patttern);
    value = value?.trim();
    if (value == null) {
      return 'Price cannot be empty';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter a price';
    } else {
      return null;
    }
  }
}

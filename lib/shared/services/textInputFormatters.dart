import 'package:flutter/services.dart';

class TextInputFormatters {
  //--allow

  static FilteringTextInputFormatter onlyDigitsWithDecimal =
      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d?'));
  static FilteringTextInputFormatter onlyDigits =
      FilteringTextInputFormatter.allow(RegExp('[0-9]'));
  static FilteringTextInputFormatter onlyNumAlpha =
      FilteringTextInputFormatter.allow(RegExp('[0-9a-zA-Z]'));

  //--deny
  static FilteringTextInputFormatter noDash =
      FilteringTextInputFormatter.deny(RegExp(r'[ ]'));
}

Future<String> obscurePhoneNumber(String phoneNumber) async {
  if (phoneNumber.isEmpty) {
    return phoneNumber; // Return original if less than 4 characters
  }
  int length = phoneNumber.length;
  int start = (length ~/ 4) - 1;
  int end = (length ~/ 2) + 1;
  String obscuredDigits = '';
  for (int i = 0; i < length; i++) {
    if (i >= start && i <= end) {
      obscuredDigits += 'X';
    } else {
      obscuredDigits += phoneNumber[i];
    }
  }
  return obscuredDigits;
}

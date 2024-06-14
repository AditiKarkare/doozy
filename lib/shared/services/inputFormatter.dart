import 'package:flutter/services.dart';

class DecimalInputFormatter extends TextInputFormatter {
  final int maxDecimals;

  DecimalInputFormatter({required this.maxDecimals});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final newText = newValue.text;
    if (newText.contains('.') &&
        newText.substring(newText.indexOf('.') + 1).length > maxDecimals) {
      return oldValue;
    }
    return newValue;
  }
}

class CapitalizeWordsInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text;
    if (text.isNotEmpty) {
      text = _capitalizeWords(text);
    }
    return newValue.copyWith(
      text: text,
      selection: newValue.selection,
    );
  }

  String _capitalizeWords(String input) {
    final List<String> words = input.split(' ');
    for (int i = 0; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        words[i] = words[i][0].toUpperCase() + words[i].substring(1);
      }
    }
    return words.join(' ');
  }
}

class CustomNumberTextInputFormatter extends TextInputFormatter {
  static const int _maxDecimalLength = 2;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    } else if (newValue.text == '.') {
      return newValue.copyWith(text: '0.');
    } else if (double.tryParse(newValue.text) == null) {
      // If the input is not a valid number, don't change the text.
      return oldValue;
    }

    // Split the value to get integer and decimal parts.
    List<String> parts = newValue.text.split('.');
    String integerPart = parts[0];
    String decimalPart = parts.length > 1 ? parts[1] : '';

    // Limit the integer part to be greater than 0.
    if (integerPart.isNotEmpty && int.parse(integerPart) == 0) {
      integerPart = '';
    }

    // Limit the decimal part to only 2 decimal places.
    if (decimalPart.length > _maxDecimalLength) {
      decimalPart = decimalPart.substring(0, _maxDecimalLength);
    }

    // Concatenate the integer and decimal parts back together.
    String newText =
        '$integerPart${decimalPart.isNotEmpty ? '.$decimalPart' : ''}';

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

class EightDigitNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Get the new input text
    String newText = newValue.text;

    // If the new input is empty, allow it
    if (newText.isEmpty) {
      return newValue;
    }

    // If the new input is not a valid number, reject it
    if (double.tryParse(newText) == null) {
      return oldValue;
    }

    // Check if the input contains a decimal point
    if (newText.contains('.')) {
      // Split the input into integer and decimal parts
      List<String> parts = newText.split('.');

      // If there are more than 2 parts (which is invalid), reject it
      if (parts.length > 2) {
        return oldValue;
      }

      // If the integer part length exceeds 5 or the decimal part length exceeds 2, reject it
      if (parts[0].length > 5 || parts[1].length > 2) {
        return oldValue;
      }

      // If the total length including the decimal point exceeds 8, reject it
      if (newText.length > 8) {
        return oldValue;
      }
    } else {
      // If there is no decimal point, just check the length
      if (newText.length > 8) {
        return oldValue;
      }
    }

    // If all checks pass, accept the new value
    return newValue;
  }
}

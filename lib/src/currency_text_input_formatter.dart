import 'dart:math';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyTextInputFormatter extends TextInputFormatter {
  CurrencyTextInputFormatter({
    this.locale,
    this.name,
    this.symbol,
    this.decimalDigits,
    this.customPattern,
    this.turnOffGrouping = false,
    this.allowNegative = false,
  });

  final String? locale;
  final String? name;
  final String? symbol;
  final int? decimalDigits;
  final String? customPattern;
  final bool turnOffGrouping;
  final bool allowNegative;

  static bool _lastCharacterIsDigit(String text) => RegExp('[0-9]').hasMatch(text.substring(text.length - 1));

  @override TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final isInsertedCharacter =
        oldValue.text.length + 1 == newValue.text.length && newValue.text.startsWith(oldValue.text);
    final isRemovedCharacter =
        oldValue.text.length - 1 == newValue.text.length && oldValue.text.startsWith(newValue.text);

    // Apparently, Flutter has a bug where the framework calls
    // formatEditUpdate twice, or even four times, after a backspace press (see
    // https://github.com/gtgalone/currency_text_input_formatter/issues/11).
    // However, only the first of these calls has inputs which are consistent
    // with a character insertion/removal at the end (which is the most common
    // use case of editing the TextField - the others being insertion/removal
    // in the middle, or pasting text onto the TextField). This condition
    // fixes a problem where a character wasn't properly erased after a
    // backspace press, when this Flutter bug was present. This comes at the
    // cost of losing insertion/removal in the middle and pasting text.
    if (!isInsertedCharacter && !isRemovedCharacter) {
      return oldValue;
    }

    final format = NumberFormat.currency(
      locale: locale,
      name: name,
      symbol: symbol,
      decimalDigits: decimalDigits,
      customPattern: customPattern,
    );

    if (turnOffGrouping) format.turnOffGrouping();
    final indicateNegative = allowNegative && newValue.text.startsWith('-');
    String newText = newValue.text.replaceAll(RegExp('[^0-9]'), '');

    // If the user wants to remove a digit, but the last character of the
    // formatted text is not a digit (for example, "1,00 €"), we need to remove
    // the digit manually.
    if (isRemovedCharacter && !_lastCharacterIsDigit(oldValue.text)) {
      final int length = newText.length - 1;
      newText = newText.substring(0, length > 0 ? length : 0);
    }

    if (newText.trim() == '') {
      return newValue.copyWith(
        text: indicateNegative ? '-' : '',
        selection: TextSelection.collapsed(offset: indicateNegative ? 1 : 0),
      );
    } else if (newText == '00' || newText == '000') {
      return TextEditingValue(
        text: indicateNegative ? '-' : '',
        selection: TextSelection.collapsed(offset: indicateNegative ? 1 : 0),
      );
    }

    num newInt = int.parse(newText);
    if (format.decimalDigits! > 0) newInt /= pow(10, format.decimalDigits!);

    final newString = (indicateNegative ? '-' : '') + format.format(newInt).trim();
    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }
}

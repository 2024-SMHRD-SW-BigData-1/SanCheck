import 'package:flutter/services.dart';

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    // 숫자만 추출
    String digits = newText.replaceAll(RegExp(r'[^0-9]'), '');

    // 하이픈 삽입
    String formattedText = '';
    if (digits.length > 4) {
      formattedText = '${digits.substring(0, 4)}-${digits.substring(4, 6)}';
      if (digits.length > 6) {
        formattedText += '-${digits.substring(6, 8)}';
      }
    } else if (digits.length > 2) {
      formattedText = '${digits.substring(0, 4)}-${digits.substring(4, 6)}';
    } else if (digits.length > 0) {
      formattedText = digits;
    }

    // 텍스트 길이 조정
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}

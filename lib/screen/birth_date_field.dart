import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'date_input_formatter.dart'; // DateInputFormatter를 가져옵니다.

class BirthDateField extends StatefulWidget {
  final DateTime? initialDate;
  final void Function(DateTime?)? onDateSelected;

  BirthDateField({this.initialDate, this.onDateSelected});

  @override
  _BirthDateFieldState createState() => _BirthDateFieldState();
}

class _BirthDateFieldState extends State<BirthDateField> {
  DateTime? _selectedBirthDate;
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedBirthDate = widget.initialDate;
    _dateController.text = _selectedBirthDate != null
        ? DateFormat('yyyy-MM-dd').format(_selectedBirthDate!)
        : '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '생년월일',
          style: TextStyle(
            color: Color(0xFF1E1E1E),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: _dateController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            DateInputFormatter(), // 날짜 포맷터 적용
          ],
          decoration: InputDecoration(
            hintText: 'YYYY-MM-DD',
            filled: true,
            fillColor: Color(0xFFF5F5F5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          onChanged: (text) {
            _handleDateInput(text);
          },
        ),
      ],
    );
  }

  void _handleDateInput(String text) {
    // 포맷된 날짜 문자열에서 하이픈 제거
    String formattedText = text.replaceAll(RegExp(r'[^0-9]'), '');

    // 길이가 8인 경우 날짜 객체로 변환
    if (formattedText.length == 8) {
      try {
        DateTime parsedDate = DateFormat('yyyyMMdd').parseStrict(formattedText);
        setState(() {
          _selectedBirthDate = parsedDate;
        });
        if (widget.onDateSelected != null) {
          widget.onDateSelected!(parsedDate);
        }
      } catch (e) {
        // 유효하지 않은 날짜 처리
        setState(() {
          _selectedBirthDate = null;
        });
        if (widget.onDateSelected != null) {
          widget.onDateSelected!(null);
        }
      }
    } else {
      // 유효하지 않은 날짜 처리
      setState(() {
        _selectedBirthDate = null;
      });
      if (widget.onDateSelected != null) {
        widget.onDateSelected!(null);
      }
    }
  }
}

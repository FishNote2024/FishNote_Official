import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:fish_note/journal/model/fish_daily.dart';

class JournalEditView extends StatefulWidget {
  final List<FishDaily> events;

  const JournalEditView({Key? key, required this.events}) : super(key: key);

  @override
  _JournalEditViewState createState() => _JournalEditViewState();
}

class _JournalEditViewState extends State<JournalEditView> {
  List<Map<String, dynamic>> fishes = [
    {'어종': '고등어', '어법': '외끌이대형저인망', '어획량': '120'}
  ];
  DateTime? selectedDateTime;
  TextEditingController _dateTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundBlue,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          DateFormat('MM월 dd일 (E)', 'ko_KR')
              .format(widget.events.first.datetime),
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // 수정 완료 로직
            },
            child: Text(
              '수정완료',
              style: body2(primaryYellow900),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: widget.events.length,
        itemBuilder: (context, index) {
          final event = widget.events[index];
          final locationName = event.locationName;
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            color: backgroundWhite,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        DateFormat('HH:mm').format(event.datetime) +
                            ' ${locationName}',
                        style: header3B(gray8),
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: () {
                          //삭제하기 로직
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  '해당 투망기록을 삭제하시겠습니까?',
                                  style: header3B(black),
                                ),
                                content: Text(
                                    '작성한 내용이 영구적으로 삭제됩니다.\n 정말 해당 투망 기록을 삭제 하시겠습니까?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(false); // '아니오' 선택 시
                                    },
                                    child: Text('돌아가기',
                                        style: body2(primaryBlue500)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(true); // '예' 선택 시
                                    },
                                    child: Text(
                                      '삭제하기',
                                      style: body2(primaryBlue500),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ).then((result) {
                            if (result == true) {
                              print('사용자가 삭제하기를 선택했습니다.');
                            } else {
                              print('사용자가 돌아가기를 선택했습니다.');
                            }
                          });
                        },
                        child: Row(
                          children: [
                            Text(
                              '삭제하기',
                              style: body2(alertRedBackground),
                            ),
                            Icon(Icons.delete, color: Colors.red),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  _buildTextField(
                    label: '투망시간',
                    initialValue:
                    DateFormat('yyyy년 MM월 dd일 (E) HH시 mm분', 'ko_KR')
                        .format(event.datetime),
                    icon: Icons.calendar_today,
                    onIconPressed: () =>
                        _handleCalendarIconPressed(event.datetime),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          label: '위도',
                          initialValue: event.location['lat'].toString(),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          label: '경도',
                          initialValue: event.location['lng'].toString(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    '해상기록',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '파고: ',
                          style: body2(gray5),
                        ),
                        TextSpan(
                          text: '${event.wav}',
                          style: body2(black),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  SizedBox(height: 16),
                  Text(
                    '양망기록',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  _buildTextField(
                    label: '양망시간',
                    initialValue:
                    DateFormat('yyyy년 MM월 dd일 (E) HH시 mm분', 'ko_KR')
                        .format(event.datetime),
                    icon: Icons.calendar_today,
                    onIconPressed: () =>
                        _handleCalendarIconPressed(event.datetime),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '어획',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            fishes.add({'어종': '', '어법': '', '어획량': ''});
                          });
                        },
                        child: Text(
                          '어획 추가하기',
                          style: body2(gray4),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: fishes.asMap().entries.map((entry) {
                      int index = entry.key;
                      Map<String, dynamic> fish = entry.value;
                      return _buildFishField(index);
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    label: '메모',
                    initialValue: '여기에 메모를 입력하세요',
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFishField(int index) {
    return Column(
      key: ValueKey(index),
      children: [
        SizedBox(height: 8),
        _buildDropdownField(
          label: '어종',
          value: fishes[index]['어종'] ?? '',
          onChanged: (newValue) {
            setState(() {
              fishes[index]['어종'] = newValue;
            });
          }, items: ["고등어","참치","연어"],
        ),
        SizedBox(height: 8),
        _buildDropdownField(
          label: '어법',
          value: fishes[index]['어법'] ?? '',
          items: <String>['외끌이대형저인망', '건강망 어업'],
          onChanged: (newValue) {
            setState(() {
              fishes[index]['어법'] = newValue;
            });
          },
        ),
        SizedBox(height: 8),
        _buildFishAmountField(
          label: '어획량',
          initialValue: fishes[index]['어획량'] ?? '',
          onChanged: (newValue) {
            setState(() {
              fishes[index]['어획량'] = newValue;
            });
          },
        ),
        Row(
          children: [
            const Spacer(),
            TextButton(
              onPressed: () {
                setState(() {
                  fishes.removeAt(index);
                });
              },
              child: Row(
                children: [
                  Text(
                    '삭제하기',
                    style: body2(alertRedBackground),
                  ),
                  Icon(Icons.delete, color: Colors.red),
                ],
              ),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }

  Widget _buildFishAmountField({
    required String label,
    required String initialValue,
    required Function(String) onChanged,
  }) {
    TextEditingController controller =
    TextEditingController(text: initialValue);

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        suffixText: 'kg',
      ),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        String newValue = value.replaceAll(RegExp(r'[^0-9]'), '');
        controller.value = TextEditingValue(
          text: newValue,
          selection: TextSelection.fromPosition(
            TextPosition(offset: newValue.length),
          ),
        );
        onChanged(newValue);
      },
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    IconData? icon,
    int maxLines = 1,
    VoidCallback? onIconPressed,
  }) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: icon != null
            ? IconButton(
          icon: Icon(icon),
          onPressed: onIconPressed,
        )
            : null,
        border: OutlineInputBorder(),
      ),
      controller: TextEditingController(text: initialValue),
      maxLines: maxLines,
    );
  }

  Future _handleCalendarIconPressed(DateTime date) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
        confirmText: "확인",
        cancelText: "뒤로",
        // builder: (context, child) {
        //   return Theme(
        //     data: Theme.of(context).copyWith(
        //         colorScheme: const ColorScheme.light(
        //           primary: Colors.black,
        //           onPrimary: Colors.black,
        //           onSurface: Colors.black,
        //         ),
        //         textTheme: TextTheme()),
        //     child: child!,
        //   );
        // }
        );
    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(date),
        initialEntryMode: TimePickerEntryMode.input,
        hourLabelText: "시",
        minuteLabelText: "분",
        cancelText: "뒤로",
        confirmText: "확인",
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _dateTimeController.text =
              DateFormat('yyyy년 MM월 dd일 (E) HH시 mm분', 'ko_KR')
                  .format(selectedDateTime!);
        });
      }
    }
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,  // value를 nullable로 변경
    required List<String> items,  // 리스트 타입 명시
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      value: value != null && items.contains(value) ? value : null,  // value 검증 후 할당
      items: items.map((String itemValue) {
        return DropdownMenuItem<String>(
          value: itemValue,
          child: Text(itemValue),
        );
      }).toList(),
      onChanged: onChanged,  // 콜백 그대로 전달

    );
  }
}


import 'package:fish_note/signUp/model/user_information_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:provider/provider.dart';
import '../../net/model/net_record.dart';
import 'journal_detail_view.dart';

class JournalEditView extends StatefulWidget {
  final List<NetRecord> events;

  const JournalEditView({Key? key, required this.events}) : super(key: key);

  @override
  _JournalEditViewState createState() => _JournalEditViewState();
}

class _JournalEditViewState extends State<JournalEditView> {
  DateTime? selectedDateTime;
  DateTime? originalDateTime;
  TextEditingController _dateTimeController = TextEditingController();
  late Set<String> species;

  @override
  void initState() {
    super.initState();
    originalDateTime = widget.events.first.throwDate;
    selectedDateTime = originalDateTime;
    _dateTimeController.text = DateFormat('yyyy년 MM월 dd일 (E) HH시 mm분', 'ko_KR').format(originalDateTime!);

    // Provider에서 데이터를 가져옵니다.
    final netRecordProvider = Provider.of<NetRecordProvider>(context, listen: false);
    final userInformationProvider = Provider.of<UserInformationProvider>(context, listen: false);
    species = {...netRecordProvider.species, ...userInformationProvider.species};
  }

  @override
  Widget build(BuildContext context) {
    final netRecordProvider = Provider.of<NetRecordProvider>(context);

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
          DateFormat('MM월 dd일 (E)', 'ko_KR').format(originalDateTime!),
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                selectedDateTime = originalDateTime;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JournalDetailView(events:netRecordProvider.netRecords,
                    ),
                  ),
                );
              });
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
          return _buildEventEditCard(event, index, netRecordProvider);
        },
      ),
    );
  }

  Widget _buildEventEditCard(NetRecord event, int index, NetRecordProvider netRecordProvider) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: backgroundWhite,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(event),
            const SizedBox(height: 8),
            _buildEditableTextField(
              label: '투망시간',
              initialValue: DateFormat('yyyy년 MM월 dd일 (E) HH시 mm분', 'ko_KR').format(event.throwDate),
              icon: Icons.calendar_today,
              onIconPressed: () => _handleCalendarIconPressed(event.throwDate, event.id, netRecordProvider),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildEditableTextField(
                    label: '위도',
                    initialValue: event.location[0].toString(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildEditableTextField(
                    label: '경도',
                    initialValue: event.location[1].toString(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('해상기록'),
            const SizedBox(height: 8),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '파고: ',
                    style: body2(gray5), // "파고:" 텍스트의 스타일
                  ),
                  TextSpan(
                    text: '${event.id}', // 파고 정보 사용
                    style: body2(black), // 파고 부분의 스타일
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('양망기록'),
            const SizedBox(height: 8),
            _buildEditableTextField(
              label: '양망시간',
              initialValue: DateFormat('yyyy년 MM월 dd일 (E) HH시 mm분', 'ko_KR').format(event.getDate),
              icon: Icons.calendar_today,
              onIconPressed: () => _handleCalendarIconPressed(event.getDate, event.id, netRecordProvider),
            ),
            const SizedBox(height: 16),
            _buildAddSpeciesButton(index),
            _buildSpeciesList(event, netRecordProvider),
            const SizedBox(height: 16),
            _buildSectionTitle('메모'),
            const SizedBox(height: 8),
            _buildEditableMemo(event.memo ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(NetRecord event) {
    return Row(
      children: [
        Text(
          DateFormat('HH:mm').format(event.throwDate) + ' ${event.locationName}',
          style: header3B(gray8),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildEditableTextField({
    required String label,
    required String initialValue,
    IconData? icon,
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
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: header3B(gray8),
    );
  }

  Widget _buildSpeciesList(NetRecord event, NetRecordProvider netRecordProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(event.species.length, (index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdownField(
              label: '어종',
              value: event.species.elementAt(index),
              items: species,
              onChanged: (newValue) {
                setState(() {
                  // 어종을 변경합니다.
                  event.species.remove(event.species.elementAt(index));
                  event.species.add(newValue!);
                  // 변경된 사항을 Provider에 업데이트합니다.
                  netRecordProvider.updateRecord(event.id, species: event.species);
                });
              },
            ),
            const SizedBox(height: 8),
            _buildFishAmountField(
              label: '어획량',
              initialValue: '${event.amount[index]}',
              onChanged: (newValue) {
                setState(() {
                  event.amount[index] = double.parse(newValue);
                  // 변경된 어획량을 Provider에 업데이트합니다.
                  netRecordProvider.updateRecord(event.id, amount: event.amount);
                });
              },
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    // 어종과 어획량을 삭제합니다.
                    event.species.remove(event.species.elementAt(index));
                    event.amount.removeAt(index);
                    // 변경된 사항을 Provider에 업데이트합니다.
                    netRecordProvider.updateRecord(event.id, species: event.species, amount: event.amount);
                  });
                },
                icon: Icon(Icons.delete, color: alertRedBackground),
                label: Text('삭제하기', style: body2(alertRedBackground)),
              ),
            ),
            const Divider(),
          ],
        );
      }),
    );
  }

  Widget _buildAddSpeciesButton(int eventIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '어획',
          style: header3B(black),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              widget.events[eventIndex].species.add('새로운 어종');
              widget.events[eventIndex].amount.add(0.0); // 새로운 어종에 대한 어획량 추가
              // 변경된 사항을 Provider에 업데이트합니다.
              Provider.of<NetRecordProvider>(context, listen: false).updateRecord(
                widget.events[eventIndex].id,
                species: widget.events[eventIndex].species,
                amount: widget.events[eventIndex].amount,
              );
            });
          },
          child: Text(
            '어획 추가하기',
            style: body2(gray4),
          ),
        ),
      ],
    );
  }

  Widget _buildEditableMemo(String memo) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      constraints: const BoxConstraints(
        minWidth: double.infinity,
        minHeight: 100.0,
      ),
      child: TextField(
        maxLines: null,
        controller: TextEditingController(text: memo),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '메모를 입력하세요',
        ),
        onChanged: (value) {
          // 메모가 변경되었을 때 Provider에 업데이트합니다.
          final netRecordProvider = Provider.of<NetRecordProvider>(context, listen: false);
          netRecordProvider.updateRecord(widget.events.first.id, memo: value);
        },
      ),
    );
  }

  Future _handleCalendarIconPressed(DateTime date, int id, NetRecordProvider netRecordProvider) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      confirmText: "확인",
      cancelText: "뒤로",
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
          netRecordProvider.updateRecord(id, throwTime: selectedDateTime!);
        });
      }
    }
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required Set<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      value: value != null && items.contains(value) ? value : null,
      items: items.map((String itemValue) {
        return DropdownMenuItem<String>(
          value: itemValue,
          child: Text(itemValue),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildFishAmountField({
    required String label,
    required String initialValue,
    required Function(String) onChanged,
  }) {
    TextEditingController controller = TextEditingController(text: initialValue);

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        suffixText: 'kg',
      ),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        String newValue = value.replaceAll(RegExp(r'[^0-9.]'), '');
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
}

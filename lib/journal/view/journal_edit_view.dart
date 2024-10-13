import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fish_note/journal/view/journal_detail_view.dart';
import 'package:fish_note/login/model/login_model_provider.dart';
import 'package:fish_note/signUp/model/user_information_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:fish_note/theme/colors.dart';
import 'package:fish_note/theme/font.dart';
import 'package:provider/provider.dart';
import '../../net/model/net_record.dart';

class JournalEditView extends StatefulWidget {
  final List<NetRecord> events;
  final String recordId;

  const JournalEditView({Key? key, required this.events, required this.recordId}) : super(key: key);

  @override
  _JournalEditViewState createState() => _JournalEditViewState();
}

class _JournalEditViewState extends State<JournalEditView> {
  List<String> memos = [];
  List<TextEditingController> _memoControllers = [];
  List<List<TextEditingController>> _amountControllers = [];
  DateTime? selectedDateTime;
  DateTime? originalDateTime; // Store the original date
  DateTime? tempThrowDateTime;
  DateTime? tempGetDateTime;
  GeoPoint geoPoint=GeoPoint(0.0,0.0);
  TextEditingController _dateTimeController = TextEditingController();
  TextEditingController _dateGetTimeController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  late NetRecordProvider netRecordProvider;
  late UserInformationProvider userInformationProvider;
  late LoginModelProvider loginModelProvider;
  late Set<String> species;
  // @override
  // void initState() {
  //   super.initState();
  //   originalDateTime = widget.events.first.throwDate; // Initialize the original date
  //   selectedDateTime = originalDateTime; // Initially, selected date is the original date
  //   _dateTimeController.text = DateFormat('yyyy년 MM월 dd일 (E) HH시 mm분', 'ko_KR').format(originalDateTime!);
  // }
  @override
  void initState() {
    super.initState();
    netRecordProvider = Provider.of<NetRecordProvider>(context, listen: false);
    userInformationProvider = Provider.of<UserInformationProvider>(context, listen: false);
    loginModelProvider = Provider.of<LoginModelProvider>(context, listen: false);
    if (widget.events.isNotEmpty) {
      memos = widget.events.map((e) => e.memo ?? '').toList(); // 각 이벤트에 대한 메모를 리스트로 만듦
    } else {
      memos = ['']; // 기본값
    }
    for (var event in widget.events) {
      List<TextEditingController> controllers = [];
      for (var amount in event.amount) {
        controllers.add(TextEditingController(text: amount.toString()));
      }
      _amountControllers.add(controllers);
    }

    for (var memo in memos) {
      _memoControllers.add(TextEditingController(text: memo));
    }

    if (widget.events.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, '/journal');
      });
    } else {
      originalDateTime = widget.events.first.throwDate; // Initialize the original date
      selectedDateTime = originalDateTime; // Initially, selected date is the original date
      tempThrowDateTime = originalDateTime;
      tempGetDateTime = widget.events.first.getDate;
      _dateTimeController.text = DateFormat('MM월 dd일(E) HH시 mm분', 'ko_KR').format(originalDateTime ?? DateTime.now());
      _dateGetTimeController.text = DateFormat('MM월 dd일(E) HH시 mm분', 'ko_KR').format(tempGetDateTime ?? DateTime.now());
      species = {...netRecordProvider.species, ...userInformationProvider.species};
      latitudeController.addListener(_updateGeoPoint);
      longitudeController.addListener(_updateGeoPoint);
    }
  }

  @override
  void dispose() {
    latitudeController.removeListener(_updateGeoPoint);
    longitudeController.removeListener(_updateGeoPoint);
    super.dispose();
  }

  void _updateGeoPoint() {
    // 위도와 경도 값을 입력받아 GeoPoint를 업데이트
    final latitude = double.tryParse(latitudeController.text) ?? 0.0;
    final longitude = double.tryParse(longitudeController.text) ?? 0.0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        geoPoint = GeoPoint(latitude, longitude);
      });
    });
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
            List<NetRecord> updatedList = updateEventList(); // Gather all updated records
            Navigator.pop(context, updatedList); // Pass the updated list back
          },
        ),
        title: Text(
          DateFormat('MM월 dd일 (E)', 'ko_KR').format(selectedDateTime!),
          style: body2(textBlack),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              final userId = Provider.of<LoginModelProvider>(context, listen: false).kakaoId;
              Provider.of<NetRecordProvider>(context, listen: false).updateRecord(
                widget.recordId,
                userId,
                // species: ,
                // amount: ,
                location: geoPoint,
                throwTime: tempThrowDateTime,
                getTime: tempGetDateTime,
                memo: memos.first,

              );
              List<NetRecord> updatedList = updateEventList(); // Gather all updated records
              Navigator.pop(context, updatedList); // Pass the updated list back
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
          return _buildEventEditCard(event, index);
        },
      ),
    );
  }

  Widget _buildEventEditCard(NetRecord event, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: backgroundWhite,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(event, context, index),
            const SizedBox(height: 8),
            _buildEditableGetField(
                label: '투망시간   ',
                icon: Icons.calendar_today,
                onIconPressed: () => _handleCalendarIconPressed(index),
                editController: _dateTimeController
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text("투망위치   ", style: body3(gray5),),
                Expanded(
                  child: _buildEditableTextField(
                    label: '위도',
                    textController: latitudeController,
                    initValue: event.location.latitude.toString(),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildEditableTextField(
                    label: '경도',
                    textController:  longitudeController,
                    initValue:event.location.longitude.toString(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSectionTitle('해상기록'),
            SizedBox(height: 16.5),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '파고: ',
                    style: body2(gray5), // "파고:" 텍스트의 스타일
                  ),
                  TextSpan(
                    text: '${event.wave}m', // 파고 정보 사용
                    style: body2(black), // 파고 부분의 스타일
                  ),
                ],
              ),
            ),
            if (event.isGet) ...[
              const SizedBox(height: 16),
              _buildSectionTitle('양망기록'),
              const SizedBox(height: 8),
              _buildEditableGetField(
                  label: '양망시간    ',
                  icon: Icons.calendar_today,
                  onIconPressed: () =>
                      _handleCalendarIconPressedGet(index),
                  editController: _dateGetTimeController
              ),
              const SizedBox(height: 16),
              _buildAddSpeciesButton(index),
              _buildSpeciesList(event,index),
              const SizedBox(height: 16),
              _buildSectionTitle('메모'),
              const SizedBox(height: 8),
              _buildEditableMemo(event.memo ?? '', index),
            ],
          ],
        ),
      ),
    );
  }

  List<NetRecord> updateEventList() {
    List<NetRecord> updatedEvents = [];
    for (NetRecord event in widget.events) {
      NetRecord? updatedEvent = netRecordProvider.getRecordById(event.id);
      updatedEvents.add(updatedEvent!);
    }
    return updatedEvents;
  }

  Widget _buildHeader(NetRecord event, BuildContext context, int index) {
    return Row(
      children: [
        Text(
          '${DateFormat('HH:mm').format(event.throwDate)} ${event.locationName}',
          style: header4(gray8),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('삭제 확인'),
                  content: const Text('해당 투망 기록을 삭제하시겠습니까?'),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('취소'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('삭제'),
                      onPressed: () async {

                        // 삭제 로직을 추가하세요.
                        await netRecordProvider.deleteRecord(
                            loginModelProvider.kakaoId, event.id);
                        Navigator.of(context).pop();
                        setState(() {
                          widget.events.removeAt(index);
                        });
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('삭제하기', style: body2(alertRedBackground),),
              const SizedBox(width: 4.0),
              SvgPicture.asset("assets/icons/trash.svg")
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEditableTextField({
    required String label,
    IconData? icon,
    VoidCallback? onIconPressed,
    required TextEditingController textController,
    required String initValue
  }) {
    if (textController.text.isEmpty) {
      textController.text = initValue;
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        Text(label, style: body3(gray5)),
        const SizedBox(width: 6),
        Expanded(
          child: TextField(
            style: body2(gray4),
            decoration: InputDecoration(
              isDense:true,
              suffixIcon: icon != null
                  ? IconButton(
                icon: Icon(icon),
                onPressed: onIconPressed,
              )
                  : null,
              enabledBorder:const OutlineInputBorder(borderSide: BorderSide(
                color: gray4,
              )),
              focusedBorder:const OutlineInputBorder(borderSide: BorderSide(
                color: black,
              )),
            ),
            controller: textController,
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }


  Widget _buildEditableGetField({
    required String label,
    IconData? icon,
    VoidCallback? onIconPressed,
    required TextEditingController editController
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: body3(gray5)),
        const SizedBox(width: 6),
        Expanded(
          child: TextField(
            style: body2(gray4),
            decoration: InputDecoration(
              isDense:true,
              suffixIcon: icon != null
                  ? IconButton(
                icon: Icon(icon),
                onPressed: onIconPressed,
              )
                  : null,
              enabledBorder:const OutlineInputBorder(borderSide: BorderSide(
                color: gray4,
              )),
              focusedBorder:const OutlineInputBorder(borderSide: BorderSide(
                color: gray4,
              )),
            ),
            controller: editController,
            readOnly: true,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: header4(gray8),
    );
  }

  Widget _buildSpeciesList(NetRecord event, int eventIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(event.species.length, (index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdownField(
              label: '어종      ',
              value: species.elementAt(index),
              items: species,
              onChanged: (newValue) {
                setState(() {
                  event.species.remove(
                      event.species.elementAt(index)); // Remove the old value
                  event.species.add(newValue!); // Add the new value
                });
              },
            ),
            const SizedBox(height: 8),
            _buildFishAmountField(
              label: '어획량   ',
              initialValue: '${event.amount[index]}',
              onChanged: (newValue) {
                setState(() {
                  event.amount[index] = double.parse(newValue);
                });
              },
              controller: _amountControllers[eventIndex][index],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    event.species.remove(event.species.elementAt(index));
                    event.amount.removeAt(index);
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('삭제하기', style: body2(alertRedBackground),),
                    const SizedBox(width: 4.0),
                    SvgPicture.asset("assets/icons/trash.svg")
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
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
          style: header4(black),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              widget.events[eventIndex].species.add('새로운 어종');
              widget.events[eventIndex].amount.add(0.0); // 새로운 어종에 대한 어획량 추가
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

  Widget _buildEditableMemo(String initialMemo, int index) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      constraints: const BoxConstraints(
        minWidth: double.infinity,
        minHeight: 100.0,
      ),
      child: TextField(
        style: body1(black),
        maxLines: null,
        controller: _memoControllers[index],
        onChanged: (value) {
          setState(() {
            memos[index] = value;
          });
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '메모를 입력하세요',
        ),
      ),
    );
  }

  Future<void> _handleCalendarIconPressed(int index) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.events[index].throwDate, // 각 이벤트의 날짜 사용
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      confirmText: "확인",
      cancelText: "뒤로",
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(widget.events[index].throwDate),
        initialEntryMode: TimePickerEntryMode.input,
        hourLabelText: "시",
        minuteLabelText: "분",
        cancelText: "뒤로",
        confirmText: "확인",
      );

      if (pickedTime != null) {
        setState(() {
          // 이벤트별로 날짜 업데이트
          tempThrowDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          // 컨트롤러 값 즉시 업데이트
          _dateTimeController.text = DateFormat('MM월 dd일(E) HH시 mm분', 'ko_KR')
              .format(tempThrowDateTime!);
        });
      }
    }
  }

  Future<void> _handleCalendarIconPressedGet(int index) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.events[index].getDate, // 각 이벤트의 날짜 사용
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      confirmText: "확인",
      cancelText: "뒤로",
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(widget.events[index].getDate),
        initialEntryMode: TimePickerEntryMode.input,
        hourLabelText: "시",
        minuteLabelText: "분",
        cancelText: "뒤로",
        confirmText: "확인",
      );

      if (pickedTime != null) {
        setState(() {
          // 이벤트별로 날짜 업데이트
          tempGetDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          // 컨트롤러 값 즉시 업데이트
          _dateTimeController.text = DateFormat('MM월 dd일(E) HH시 mm분', 'ko_KR')
              .format(tempGetDateTime!);
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: body3(gray5)),
        const SizedBox(width: 6),
        Expanded(
          child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              isDense:true,
              enabledBorder:OutlineInputBorder(borderSide: BorderSide(
                color: gray4,
              )),
              focusedBorder:  OutlineInputBorder(borderSide: BorderSide(
                color: black,
              )),
            ),
            value: value != null && items.contains(value) ? value : null,
            items: items.map((String itemValue) {
              return DropdownMenuItem<String>(
                value: itemValue,
                child: Text(itemValue, style: body2(gray4),),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildFishAmountField({
    required String label,
    required String initialValue,
    required Function(String) onChanged,
    required TextEditingController controller
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: body3(gray5)),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            children: [
              TextField(
                controller: controller,
                style: body2(gray4),
                decoration:  InputDecoration(
                  suffixStyle: body2(gray4),
                  isDense: true,
                  enabledBorder:const OutlineInputBorder(borderSide: BorderSide(
                    color: gray4,
                  )),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(
                  color: black,
                )),
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
              ),
            ],
          ),
        ),
      ],
    );
  }
}

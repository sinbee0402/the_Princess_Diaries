import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:princess_diaries/presentation/main/main_view_model.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  final _firstDay = DateTime.utc(
    DateTime.now().year - 10,
    DateTime.now().month,
    DateTime.now().day,
  );
  final _lastDay = DateTime.utc(
    DateTime.now().year + 10,
    DateTime.now().month,
    DateTime.now().day,
  );

  Widget _buildDowWidget(DateTime date) {
    final dowText = DateFormat.E().format(date)[0];

    return Center(
      child: Text(
        dowText,
        style: TextStyle(
          color: Colors.black.withOpacity(0.5),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDayWidget(DateTime date) {
    return Center(
      child: Text(
        date.day.toString(),
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MainViewModel>();
    final state = viewModel.state;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          DateFormat.yMMMM('ko_KR').format(viewModel.focusedMonth),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO : 공유 기능
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.push('/settings');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TableCalendar(
                locale: 'ko_KR',
                calendarFormat: _calendarFormat,
                firstDay: _firstDay,
                lastDay: _lastDay,
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                  viewModel.changeMonth(_focusedDay);
                },
                eventLoader: (date) {
                  return [];
                },
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  titleTextFormatter: (date, locale) {
                    return DateFormat.yMMMM().format(date);
                  },
                  formatButtonVisible: false,
                  headerPadding: const EdgeInsets.symmetric(vertical: 16),
                  titleTextStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  leftChevronVisible: true,
                  rightChevronVisible: true,
                ),
                calendarStyle: const CalendarStyle(
                  selectedTextStyle: TextStyle(color: Colors.transparent),
                  selectedDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage('assets/icon-question-mark.png'),
                        fit: BoxFit.cover),
                  ),
                  // markerDecoration: const BoxDecoration(
                  //   shape: BoxShape.circle,
                  //   image: DecorationImage(
                  //       image: AssetImage('assets/icon-question-mark.png'),
                  //       fit: BoxFit.cover),
                  //   //color: Colors.pinkAccent,
                  // ),
                  todayDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFF7B7D3),
                  ),
                  todayTextStyle: TextStyle(
                    color: Color(0xFFED0F69),
                    fontWeight: FontWeight.bold,
                  ),
                  holidayTextStyle: TextStyle(color: Colors.red),
                ),
                calendarBuilders: CalendarBuilders(
                  dowBuilder: (_, weekday) {
                    return _buildDowWidget(weekday);
                  },
                  defaultBuilder: (_, date, focusedDay) {
                    return _buildDayWidget(date);
                  },
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekendStyle: TextStyle(color: Colors.red),
                ),
                daysOfWeekHeight: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

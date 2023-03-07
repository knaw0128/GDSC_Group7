import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Homepage',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> habits = [];
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  void _addHabit(String habit) {
    setState(() {
      habits.add(habit);
    });
  }

  void _deleteHabit(int index) {
    setState(() {
      habits.removeAt(index);
    });
  }

  void _navigateToAddHabitPage(BuildContext context) async {
    final String? newHabit = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddHabitPage()),
    );
    if (newHabit != null) {
      _addHabit(newHabit);
    }
  }

  final List<bool> _isHabitCompleted = List.filled(100, false);

  void _toggleHabitCompletion(int index) {
    setState(() {
      _isHabitCompleted[index] = !_isHabitCompleted[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Homepage',
          style: TextStyle(
            color: Colors.brown[900],
          ),
        ),
        backgroundColor: Colors.orange[100],
        shadowColor: Colors.orange[100],
      ),
      body: Column(
        children: [
          TableCalendar(
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.orange[300],
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.orange[400],
                shape: BoxShape.circle,
              ),
              weekendTextStyle: TextStyle(
                color: Colors.orange[900],
              ),
              holidayTextStyle: TextStyle(
                color: Colors.orange[900],
              ),
            ),
            calendarFormat: _calendarFormat,
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2023, 12, 1),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: _onDaySelected,
          ),
          Expanded(
            child: Container(
              color: Colors.orange[100],
              child: ListView.builder(
                itemCount: habits.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      _deleteHabit(index);
                    },
                    child: Container(
                      height: 50, //50 新習慣長方形的高度
                      width: 200, //none 似乎沒有作用

                      margin: EdgeInsets.symmetric(vertical: 8), //4（原）
                      padding: EdgeInsets.symmetric(horizontal: 24), //16（原）
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)), //5
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _toggleHabitCompletion(index);
                            },
                            child: Container(
                              width: 24.0,
                              height: 24.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _isHabitCompleted[index]
                                    ? Colors.green
                                    : Colors.white,
                                border: Border.all(color: Colors.grey),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.0),
                          Text(habits[index]),
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              _deleteHabit(index);
                            },
                            child: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddHabitPage(context);
        },
        child: Icon(
          Icons.add,
          color: Colors.brown[900],
        ),
        foregroundColor: Colors.orange[300],
        backgroundColor: Colors.orange[400],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class AddHabitPage extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add a Habit',
          style: TextStyle(
            color: Colors.brown[900],
          ),
        ),
        backgroundColor: Colors.white, // Colors.orange[50]
        shadowColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextField(
              style: TextStyle(color: Colors.grey),
              controller: _textEditingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter a new habit',
                labelStyle: TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),

            SizedBox(
              height: 16,
            ),

            // Image.asset('assets/images/background.jpg', fit: BoxFit.scaleDown)
            // Expanded(
            //   child: Image.asset(
            //     'assets/images/background.jpg',
            //     fit: BoxFit.cover,
            //   ),
            // ),
            FractionallySizedBox(
              widthFactor: 1.0,
              child: Image.asset(
                'assets/images/background.jpg',
                fit: BoxFit.cover,
              ),
            ),

            // CupertinoButton(
            //   onPressed: () {
            //     final String habit = _textEditingController.text.trim();
            //     Navigator.pop(context, habit);
            //   },
            //   child: Text(
            //     'Save',
            //     style: TextStyle(
            //       color: Colors.brown[900],
            //     ),
            //   ),
            //   color: Colors.orange[100],
            // ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done, color: Colors.brown[900]),
        foregroundColor: Colors.orange[300],
        backgroundColor: Colors.orange[400],
        onPressed: () {
          final String habit = _textEditingController.text.trim();
          Navigator.pop(context, habit);
        },
      ),
    );
  }
}

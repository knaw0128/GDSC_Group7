import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Homepage',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

//登入頁面區
class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  List<Map<String, String>> _registeredUsers = [
    {"username": "user1", "password": "password1"},
    {"username": "user2", "password": "password2"},
    {"username": "user3", "password": "password3"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Login",
          style: TextStyle(
            color: Colors.brown[900],
          ),
        ),
        backgroundColor: Colors.orange[100],
        shadowColor: Colors.orange[100],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Username cannot be empty";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                ),
                obscureText: true,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Password cannot be empty";
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange[100],
                ),
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.brown[900],
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() == true) {
                    bool validUser = false;
                    for (var user in _registeredUsers) {
                      if (user['username'] == _usernameController.text &&
                          user['password'] == _passwordController.text) {
                        validUser = true;
                        break;
                      }
                    }
                    if (validUser) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Invalid login"),
                            content: Text("Username or password is incorrect."),
                            actions: [
                              TextButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//登入頁面區

//主畫面區
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
            headerStyle: HeaderStyle(formatButtonVisible: false),
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
//主畫面區

//添加習慣區
class AddHabitPage extends StatefulWidget {
  const AddHabitPage({Key? key}) : super(key: key);

  @override
  _AddHabitPage createState() => _AddHabitPage();
}

// class AddHabitPage extends StatelessWidget {
class _AddHabitPage extends State<AddHabitPage> {
  final TextEditingController _textEditingController = TextEditingController();

  final List<String> frequency = [
    '1 times per week',
    '3 times per week',
  ];

  String? selectedFrequency;

  final _formKey = GlobalKey<FormState>();

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
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _textEditingController,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  // contentPadding: const EdgeInsets.symmetric(
                  //   horizontal: 20,
                  //   vertical: 20,
                  // ),
                  contentPadding: EdgeInsets.zero,
                  hintText: 'Enter a Habit Name',
                  hintStyle: const TextStyle(fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a habit name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              DropdownButtonFormField2(
                decoration: InputDecoration(
                  //Add isDense true and zero Padding.
                  //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  //Add more decoration as you want here
                  //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                ),
                isExpanded: true,
                hint: const Text(
                  'Frequency',
                  style: TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                items: frequency
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ))
                    .toList(),
                validator: (value) {
                  if (value == null) {
                    return 'Please select frequency.';
                  }
                  return null;
                },
                onChanged: (value) {
                  //Do something when changing the item if you want.
                },
                onSaved: (value) {
                  selectedFrequency = value.toString();
                },
                buttonStyleData: const ButtonStyleData(
                  height: 60,
                  padding: EdgeInsets.only(left: 20, right: 10),
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black45,
                  ),
                  iconSize: 30,
                ),
                dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final String habit = _textEditingController.text.trim();
                    Navigator.pop(context, habit);
                  }
                },
                child: const Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//添加習慣區

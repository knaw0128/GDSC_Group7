import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
    final String newHabit = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddHabitPage()),
    );
    if (newHabit != null) {
      _addHabit(newHabit);
    }
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
      body: Container(
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
                height: 50,
                margin: EdgeInsets.symmetric(vertical: 4),
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(habits[index]),
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
        backgroundColor: Colors.orange[100],
        shadowColor: Colors.orange[100],
      ),
      body: Container(
        color: Colors.orange[100],
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
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
            CupertinoButton(
              onPressed: () {
                final String habit = _textEditingController.text.trim();
                Navigator.pop(context, habit);
              },
              child: Text(
                'Save',
                style: TextStyle(
                  color: Colors.brown[900],
                ),
              ),
              color: Colors.orange[100],
            ),
          ],
        ),
      ),
    );
  }
}

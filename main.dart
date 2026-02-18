import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo/add_task_dialog.dart';
import 'todo_list.dart';
import 'todo_model.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  bool _isDarkMode = true;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar To-Do List',
      debugShowCheckedModeBanner: false,
      theme: _isDarkMode ? _darkTheme : _lightTheme,
      home: TodoHomePage(isDarkMode: _isDarkMode, onToggleTheme: _toggleTheme),
    );
  }

  ThemeData get _darkTheme {
    return ThemeData(
      primarySwatch: Colors.teal,
      scaffoldBackgroundColor: const Color(0xFF1E1E2E),
      cardColor: const Color(0xFF2A2A3E),
      textTheme: GoogleFonts.robotoTextTheme().apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF3A3A4E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide.none,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
    );
  }

  ThemeData get _lightTheme {
    return ThemeData(
      primarySwatch: Colors.teal,
      scaffoldBackgroundColor: Colors.white,
      cardColor: Colors.white,
      textTheme: GoogleFonts.robotoTextTheme().apply(
        bodyColor: Colors.black,
        displayColor: Colors.black,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide.none,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
    );
  }
}

class TodoHomePage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const TodoHomePage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  List<TodoItem> _todos = [];
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todoStrings = prefs.getStringList('todos') ?? [];
    setState(() {
      _todos = todoStrings.map((s) => TodoItem.fromJson(s)).toList();
    });
  }

  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todoStrings = _todos.map((t) => t.toJson()).toList();
    await prefs.setStringList('todos', todoStrings);
  }

  void _addTodo(String title, IconData icon, DateTime date) {
    setState(() {
      _todos.add(TodoItem(title: title, icon: icon, date: date));
    });
    _saveTodos();
  }

  void _toggleTodo(int index) {
    setState(() {
      _todos[index].isDone = !_todos[index].isDone;
    });
    _saveTodos();
  }

  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
    _saveTodos();
  }

  List<TodoItem> _getTasksForDay(DateTime day) {
    return _todos.where((todo) => isSameDay(todo.date, day)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final tasksForDay = _getTasksForDay(_selectedDay);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calendar To-Do List',
          style: GoogleFonts.roboto(fontWeight: FontWeight.bold),
        ),
        backgroundColor: widget.isDarkMode
            ? const Color(0xFF1E1E2E)
            : Colors.teal,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: widget.onToggleTheme,
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.isDarkMode
                ? [
                    const Color(0xFF1E1E2E),
                    const Color(0xFF2D2D3A),
                    const Color(0xFF3A3A4E),
                  ]
                : [
                    Colors.white,
                    const Color(0xFFF5F5F5),
                    const Color(0xFFE0E0E0),
                  ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: Colors.teal,
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
                weekendTextStyle: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
              headerStyle: HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
                titleTextStyle: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontSize: 18,
                ),
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TodoList(
                todos: tasksForDay,
                onAdd: (title, icon) => _addTodo(title, icon, _selectedDay),
                onToggle: (index) => _toggleTodo(
                  _todos.indexWhere((t) => t == tasksForDay[index]),
                ),
                onDelete: (index) => _deleteTodo(
                  _todos.indexWhere((t) => t == tasksForDay[index]),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(
        onAdd: (title, icon) => _addTodo(title, icon, _selectedDay),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'add_task_dialog.dart';
import 'progress_indicator.dart';
import 'todo_model.dart';

class TodoList extends StatelessWidget {
  final List<TodoItem> todos;
  final Function(String, IconData) onAdd;
  final Function(int) onToggle;
  final Function(int) onDelete;

  const TodoList({
    super.key,
    required this.todos,
    required this.onAdd,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final completed = todos.where((t) => t.isDone).length;
    final total = todos.length;
    final progress = total == 0 ? 0.0 : completed / total;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CustomProgressIndicator(
            progress: progress,
            completed: completed,
            total: total,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: AnimationLimiter(
              child: ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Card(
                            elevation: 8,
                            shadowColor: Colors.teal.withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: todo.isDone
                                      ? [
                                          Colors.grey.shade700,
                                          Colors.grey.shade800,
                                        ]
                                      : [
                                          const Color(0xFF2A2A3E),
                                          const Color(0xFF3A3A4E),
                                        ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: ListTile(
                                leading: Icon(
                                  todo.icon,
                                  color: todo.isDone
                                      ? Colors.grey
                                      : Colors.teal,
                                  size: 28,
                                ),
                                title: Text(
                                  todo.title,
                                  style: TextStyle(
                                    decoration: todo.isDone
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color: todo.isDone
                                        ? Colors.grey
                                        : Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Checkbox(
                                      value: todo.isDone,
                                      onChanged: (_) => onToggle(index),
                                      activeColor: Colors.purpleAccent,
                                      checkColor: Colors.white,
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.redAccent,
                                      ),
                                      onPressed: () =>
                                          _confirmDelete(context, index),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A3E),
        title: const Text(
          'Delete Task?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'This action cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              onDelete(index);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

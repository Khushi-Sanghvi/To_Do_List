import 'package:flutter/material.dart';

class AddTaskDialog extends StatefulWidget {
  final Function(String, IconData) onAdd;

  const AddTaskDialog({super.key, required this.onAdd});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _controller = TextEditingController();
  IconData _selectedIcon = Icons.task;

  final List<IconData> _icons = [
    Icons.task,
    Icons.work,
    Icons.home,
    Icons.shopping_cart,
    Icons.fitness_center,
    Icons.book,
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF2A2A3E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Add New Task', style: TextStyle(color: Colors.white)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(hintText: 'Enter task title'),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<IconData>(
            value: _selectedIcon,
            items: _icons.map((icon) {
              return DropdownMenuItem(
                value: icon,
                child: Row(
                  children: [
                    Icon(icon, color: Colors.teal),
                    const SizedBox(width: 8),
                    Text(
                      icon.toString().split('.').last,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) => setState(() => _selectedIcon = value!),
            decoration: const InputDecoration(
              labelText: 'Select Icon',
              labelStyle: TextStyle(color: Colors.white70),
            ),
            dropdownColor: const Color(0xFF3A3A4E),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              widget.onAdd(_controller.text, _selectedIcon);
              Navigator.of(context).pop();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Add'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

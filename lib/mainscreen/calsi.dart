import 'package:flutter/material.dart';

class calsi extends StatefulWidget {
  final bool isExpense;
  final Function(double) onSave;

  calsi({required this.isExpense, required this.onSave});

  @override
  _calsiState createState() => _calsiState();
}

class _calsiState extends State<calsi> {
  String input = '';

  void _saveData() async {
    if (input.isNotEmpty) {
      final amount = double.tryParse(input) ?? 0.0;
      widget.onSave(amount);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Text('Enter Amount'),
        content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  setState(() {
                    input = value;
                  });
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter amount',
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _saveData,
                child: Text('Save'),
              ),
            ],
            ),
        );
    }
}
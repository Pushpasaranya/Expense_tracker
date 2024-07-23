

import 'package:expense_tracker/mainscreen/add.dart';
import 'package:expense_tracker/model/piechart.dart';
import 'package:expense_tracker/mainscreen/report.dart';
import 'package:flutter/material.dart';


class bot extends StatefulWidget {
  const bot({super.key});

  @override
  State<bot> createState() => _botState();
}

class _botState extends State<bot> {
  int _index = 0;

  final pages = [
    report(),
    add1(),
    piechart(),
  ];

  void tap(index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages[_index],
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _index = 1;
            });
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.purple,
        ),
        bottomNavigationBar: BottomAppBar(
            height: 70,
            shape: CircularNotchedRectangle(),
            notchMargin: 10.0,
            child: Container(
              height: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 20,
                    onPressed: () {
                      setState(() {
                        _index = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.note_alt_outlined,
                          color: _index == 0 ? Colors.purple : Colors.grey,
                        ),
                        Text(
                          'Report',
                          style: TextStyle(
                            color: _index == 0 ? Colors.purple : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 20,
                    onPressed: () {
                      setState(() {
                        _index = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.pie_chart,
                          color: _index == 2 ? Colors.purple : Colors.grey,
                        ),
                        Text(
                          'Piechart',
                          style: TextStyle(
                            color: _index == 2 ? Colors.purple : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ),
        );
    }
}
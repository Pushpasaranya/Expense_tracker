import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pie_chart/pie_chart.dart';

class piechart extends StatefulWidget {
  @override
  _piechartState createState() => _piechartState();
}

class _piechartState extends State<piechart> {
  double expenses = 0.0;
  List<Map<String, dynamic>> transactions = [];
  DateTime selectedDate = DateTime.now();
  DateFormat monthFormat = DateFormat.yMMMM();

  Map<String, double> dataMap = {
    "Shopping": 0.0,
    "Food": 0.0,
    "Transport": 0.0,
    "Health": 0.0,
    "Others": 0.0,
  };

  final List<Color> colorList = [
    const Color(0xfffdcb6e),
    const Color(0xff00b894),
    const Color(0xffe17055),
    const Color(0xffA82793),
    const Color(0xff0984e3),
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      expenses = prefs.getDouble('whole_expense') ?? 0.0;
      transactions = (prefs.getStringList('transactions') ?? []).map((e) {
        final Map<String, dynamic> transaction = Map<String, dynamic>.from(Uri.parse(e).queryParameters);
        transaction['amount'] = double.parse(transaction['amount']);
        return transaction;
      }).toList();
      _updateDataMap();
    });
  }

  void _updateDataMap() {
    double shopping = 0.0, food = 0.0, transport = 0.0, health = 0.0, others = 0.0;

    for (var transaction in transactions) {
      if (transaction['type'] == 'Expense') {
        switch (transaction['category']) {
          case 'Shopping':
            shopping += transaction['amount'];
            break;
          case 'Food':
            food += transaction['amount'];
            break;
          case 'Transport':
            transport += transaction['amount'];
            break;
          case 'Health':
            health += transaction['amount'];
            break;
          default:
            others += transaction['amount'];
            break;
        }
      }
    }

    setState(() {
      dataMap['Shopping'] = shopping;
      dataMap['Food'] = food;
      dataMap['Transport'] = transport;
      dataMap['Health'] = health;
      dataMap['Others'] = others;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'PIE CHART',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child:  Stack(
      children: [
      Container(
      decoration: BoxDecoration(
      image: DecorationImage(
      image: AssetImage('assets/exp4.jpg'),
      fit: BoxFit.cover,
    ),
    ),
    child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
    child: Container(
    color: Colors.black.withOpacity(0),
    ),
    ),
    ),


        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              monthFormat.format(selectedDate),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            PieChart(
              dataMap: dataMap,
              animationDuration: Duration(milliseconds: 800),
              chartLegendSpacing: 32,
              chartRadius: MediaQuery.of(context).size.width / 3.2,
              colorList: colorList,
              initialAngleInDegree: 0,
              chartType: ChartType.ring,
              ringStrokeWidth: 32,
              centerText: "Expenses",
              legendOptions: LegendOptions(
                showLegendsInRow: false,
                legendPosition: LegendPosition.right,
                showLegends: true,
                legendShape: BoxShape.circle,
                legendTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,color: Colors.white
                ),
              ),
              chartValuesOptions: ChartValuesOptions(
                showChartValueBackground: true,
                showChartValues: true,
                showChartValuesInPercentage: false,
                showChartValuesOutside: false,
                decimalPlaces: 1,
              ),
            ),
          ],
        ),],
      ),),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:pie_chart/pie_chart.dart';
//
// class statistics extends StatefulWidget {
//   const statistics({Key? key}) : super(key: key);
//
//   @override
//   State<statistics> createState() => _statisticsState();
// }
//
// class _statisticsState extends State<statistics> {
//   Map<String, double> dataMap = {};
//
//   @override
//   void initState() {
//     super.initState();
//     _loadData();
//   }
//
//   Future<void> _loadData() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       dataMap['Shopping'] = prefs.getDouble('shopping') ?? 0.0;
//       dataMap['Food'] = prefs.getDouble('food') ?? 0.0;
//       dataMap['Transport'] = prefs.getDouble('transport') ?? 0.0;
//       dataMap['Health'] = prefs.getDouble('health') ?? 0.0;
//       dataMap['Gift'] = prefs.getDouble('gift') ?? 0.0;
//       dataMap['Sports'] = prefs.getDouble('sports') ?? 0.0;
//       dataMap['Pets'] = prefs.getDouble('pets') ?? 0.0;
//       dataMap['Social'] = prefs.getDouble('social') ?? 0.0;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Statistics"),
//       ),
//       body: Center(
//         child: PieChart(
//           dataMap: dataMap,
//           chartRadius: MediaQuery.of(context).size.width / 1.2,
//           chartValuesOptions: ChartValuesOptions(
//             showChartValuesInPercentage: true,
//           ),
//         ),
//       ),
//     );
//   }
// }

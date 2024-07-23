import 'dart:ui';
import 'package:expense_tracker/mainscreen/statistics.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

class add1 extends StatefulWidget {
  const add1({Key? key}) : super(key: key);

  @override
  State<add1> createState() => _add1State();
}

class _add1State extends State<add1> {
  int _selectedIndex = 0;
  double wholeExpense = 0.0;
  double wholeIncome = 0.0;
  double balance = 0.0;
  List<String> categories = [];

  List<IconData> images = [
    Icons.shopping_cart,
    Icons.ramen_dining,
    Icons.electric_car,
    Icons.medical_information_sharp,
    Icons.card_giftcard,
    Icons.sports_martial_arts_outlined,
    Icons.pets,
    Icons.phone_android,
    Icons.menu_book_outlined,
    Icons.people,
    Icons.liquor,
    Icons.spa,
    Icons.house,
    Icons.theater_comedy,
    Icons.fastfood,
    Icons.apple,
    Icons.boy,
  ];

  List<IconData> images1 = [
    Icons.money,
    Icons.access_time,
    Icons.card_giftcard_rounded,
    Icons.bar_chart,
  ];

  List<String> images3 = [
    "Shopping",
    "Food",
    "Transport",
    "Health",
    "Gift",
    "Sports",
    "Pets",
    "Telephone",
    "Education",
    "Social",
    "Liquor",
    "Beauty",
    "Home",
    "Entertainment",
    "Snacks",
    "Fruit",
    "Child",
  ];

  List<String> images2 = [
    "Salary",
    "Part Time",
    "Awards",
    "Investments",
  ];

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _saveAmount(bool isExpense, double amount, String category, DateTime date) async {
    final prefs = await SharedPreferences.getInstance();
    final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    // Construct transaction data
    Map<String, dynamic> transaction = {
      'type': isExpense ? 'Expense' : 'Income',
      'amount': amount.toString(),
      'category': category,
      'date': date.toIso8601String(), // Use selected date here
    };

    // Retrieve existing transactions or initialize an empty list
    List<String> transactions = prefs.getStringList('transactions') ?? [];

    // Append new transaction to the list
    transactions.add(Uri(queryParameters: transaction).toString());

    // Save the updated transactions list to SharedPreferences
    await prefs.setStringList('transactions', transactions);

    // Update expense, income, balance based on type
    if (isExpense) {
      double currentExpenses = prefs.getDouble('expenses_$dateKey') ?? 0.0;
      currentExpenses += amount;
      await prefs.setDouble('expenses_$dateKey', currentExpenses);
      wholeExpense += amount;
      await prefs.setDouble('whole_expense', wholeExpense);
    } else {
      double currentIncome = prefs.getDouble('income_$dateKey') ?? 0.0;
      currentIncome += amount;
      await prefs.setDouble('income_$dateKey', currentIncome);
      wholeIncome += amount;
      await prefs.setDouble('whole_income', wholeIncome);
    }

    // Update balance
    balance = wholeIncome - wholeExpense;
    await prefs.setDouble('balance', balance);

    setState(() {
      _loadStatistics();
    });
  }



  Future<void> _loadStatistics() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      wholeExpense = prefs.getDouble('whole_expense') ?? 0.0;
      wholeIncome = prefs.getDouble('whole_income') ?? 0.0;
      balance = prefs.getDouble('balance') ?? 0.0;
    });

    await _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String>? transactions = prefs.getStringList('transactions');

      if (transactions == null) {
        transactions = [];
      }

      // Sort transactions by timestamp or transaction ID (if available)
      transactions.sort((a, b) {
        final Map<String, dynamic> transactionA = Uri.splitQueryString(a);
        final Map<String, dynamic> transactionB = Uri.splitQueryString(b);

        DateTime dateA = DateTime.parse(transactionA['date'] ?? '');
        DateTime dateB = DateTime.parse(transactionB['date'] ?? '');

        // Compare dates for sorting (descending order)
        return dateB.compareTo(dateA);
      });

      // Extract active categories from sorted transactions
      Set activeCategories = transactions.map((e) {
        final Map<String, dynamic> transaction = Uri.splitQueryString(e);
        return transaction['category'] ?? ''; // Handle potential null values
      }).toSet();

      // Update the state with the active categories
      // setState(() {
      //   categories = activeCategories.toList[];
      // });
    } catch (e) {
      print('Error loading categories: $e');
      // Handle error: show error message, retry logic, etc.
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/exp3.jpg'),
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
            SingleChildScrollView(
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(19.0),
                      child: SizedBox(
                        height: 100,
                        child: ToggleSwitch(
                          minWidth: 90.0,
                          minHeight: 50.0,
                          initialLabelIndex: _selectedIndex,
                          cornerRadius: 20.0,
                          activeFgColor: Colors.white,
                          inactiveBgColor: Colors.grey,
                          inactiveFgColor: Colors.white,
                          totalSwitches: 3,
                          labels: ['Expenses', 'Income', 'Budget'],
                          borderColor: [
                            Color(0xff3b5998),
                            Color(0xff8b9dc3),
                          ],
                          dividerColor: Colors.blueGrey,
                          activeBgColors: [
                            [Color(0xff3b5998), Color(0xff8b9dc3)],
                            [Color(0xff3b5998), Color(0xff8b9dc3)],
                            [Color(0xff3b5998), Color(0xff8b9dc3)],
                          ],
                          onToggle: (index) {
                            setState(() {
                              _selectedIndex = index!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  _getContentForSelectedIndex(_selectedIndex),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getContentForSelectedIndex(int index) {
    switch (index) {
      case 0:
        return _buildGrid(images, images3, true);
      case 1:
        return _buildGrid(images1, images2, false);
      case 2:
        return _buildBudgetView();
      default:
        return Container();
    }
  }

  Widget _buildGrid(List<IconData> icons, List<String> labels, bool isExpense) {
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: icons.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                showAmountDialog(
                  context,
                      (double amount, DateTime date) async {
                    await _saveAmount(isExpense, amount, labels[index], date);
                    setState(() {
                      _loadStatistics();
                    });
                  },
                );
              },
              child: Column(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(),
                      color: Colors.green,
                    ),
                    child: Icon(
                      icons[index],
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    labels[index],
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBudgetView() {
    return Column(
      children: [
        _buildWholeStatisticsContainer("Yearly", wholeExpense, wholeIncome, balance),
        SizedBox(height: 20),
        _buildWholeStatisticsContainer("Monthly", wholeExpense, wholeIncome, balance),
        SizedBox(height: 20),
        _buildWholeStatisticsContainer("Weekly", wholeExpense, wholeIncome, balance),
      ],
    );
  }

  Widget _buildWholeStatisticsContainer(String title, double expense, double income, double balance) {
    return Card(
      child: Container(
        height: 120,
        width: 350,
        decoration: BoxDecoration(
          // border: Border.all(),
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("$title Statistics",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.black),),
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) => const statistics()),
                  //     );
                  //   },
                  //   child: Icon(Icons.arrow_forward_ios),
                  // ),
                ],
              ),
              SizedBox(height: 10),
              Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text("Whole Expense",),
                        Text(expense.toStringAsFixed(2)),
                      ],
                    ),
                    Column(
                      children: [
                        Text("Whole Income"),
                        Text(income.toStringAsFixed(2)),
                      ],
                    ),
                    Column(
                      children: [
                        Text("Balance"),
                        Text(balance.toStringAsFixed(2)),
                      ],
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

void showAmountDialog(BuildContext context, Function(double, DateTime) onSave) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      DateTime selectedDate = DateTime.now();
      double? _amount;

      return AlertDialog(
        title: Text('Enter Amount'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(DateTime.now().year - 1, 5),
                          lastDate: DateTime(DateTime.now().year + 1, 9),
                        );

                        if (picked != null && picked != selectedDate) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                      child: Icon(Icons.calendar_today),
                    ),
                    SizedBox(width: 10),
                    Text(
                      DateFormat.yMMMd().format(selectedDate),
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                TextField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) {
                    _amount = double.tryParse(value);
                  },
                  decoration: InputDecoration(hintText: "Enter Amount"),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_amount != null) {
                      Navigator.of(context).pop();
                      onSave(_amount!, selectedDate); // Pass selectedDate here
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}


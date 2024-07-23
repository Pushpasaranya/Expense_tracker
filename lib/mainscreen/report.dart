import 'dart:io';
import 'dart:ui';


import 'package:expense_tracker/model/welcomescreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firebase.dart';

import '../theme.dart';

class report extends StatefulWidget {
  @override
  _reportState createState() => _reportState();
}

class _reportState extends State<report> {
  double expenses = 0.0;
  double income = 0.0;
  double balance = 0.0;
  double salaryIncome = 0.0;
  double partSalaryIncome = 0.0;
  double awardsIncome = 0.0;
  double investmentIncome = 0.0;


  List<Map<String, dynamic>> transactions = [];
  List<String> categories = [];
  DateTime selectedDate = DateTime.now();
  DateFormat monthFormat = DateFormat.yMMMM();

  File? _image;
  final String _imageKey = 'profile_image';
  double _rating = 0.0;
  final auth = AuthService();
  Map<String, double> expensesByCategory = {};


  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.subscribeToTopic('budget_alerts');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle the notification when the app is in the foreground
      print('Message received: ${message.notification?.title}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Handle the notification when the app is opened from a notification
      print('Message clicked: ${message.notification?.title}');
    });

    _checkBudgetAndNotify(); // Check budget and send notification if needed
    _loadData();
    _loadCategories();
    _loadImageFromPrefs();
    _loadStatistics();
  }

void _checkBudgetAndNotify() async {
  double budget = 1000.0; // Replace with your actual budget
  if (balance < 0) {
    await _sendBudgetExceededNotification();
  }
}

Future<void> _sendBudgetExceededNotification() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Create a notification payload
  Map<String, dynamic> messagePayload = {
    'notification': {
      'title': 'Budget Alert',
      'body': 'Your expenses have exceeded your budget!',
    },
    'data': {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
    },
  };

  // Subscribe to a topic
  // await messaging.subscribeToTopic('budget_alerts');
  await FirebaseMessaging.instance.subscribeToTopic('budget_alerts');


  // Send the notification to the subscribed topic
  // await messaging.sendMessage(
  //   to: 'budget_alerts',
  //   messageId: messagePayload,
  // );
}


  Future<void> _loadStatistics() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      expenses = prefs.getDouble('whole_expense') ?? 0.0;
      income = prefs.getDouble('whole_income') ?? 0.0;
      balance = prefs.getDouble('balance') ?? 0.0;
    });
  }


  Future<void> _loadImageFromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? imagePath = prefs.getString(_imageKey);
    if (imagePath != null) {
      setState(() {
        _image = File(imagePath);
      });
    }
  }

  Future<void> _saveImageToPrefs(String imagePath) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_imageKey, imagePath);
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _saveImageToPrefs(pickedFile.path);
    } else {
      print('No image selected.');
    }
  }




  void _deleteItem(int index) async {
    // Get the transaction type and amount
    String type = transactions[index]['type'];
    double amount = transactions[index]['amount'];
    String category = transactions[index]['category'];

    setState(() {
      // Remove the transaction from the list
      transactions.removeAt(index);

      // Recalculate expenses and income based on transaction type
      if (type == 'Expense') {
        expenses -= amount;
      } else if (type == 'Income') {
        income -= amount;
        _updateIncome(
            category, -amount); // Adjust income for specific category if needed
      }

      // Calculate the new balance
      balance = income - expenses;
    });

    // Save the updated transactions and summary
    await _saveTransactions();
    await _saveSummary();
  }

  void _calculateExpensesAndIncome() {
    double totalExpenses = 0.0;
    double totalIncome = 0.0;

    transactions.forEach((transaction) {
      if (transaction['type'] == 'Expense') {
        totalExpenses += transaction['amount'];
      } else if (transaction['type'] == 'Income') {
        totalIncome += transaction['amount'];
      }
    });

    setState(() {
      expenses = totalExpenses;
      income = totalIncome;
      balance = income - expenses;
    });

    // Save updated summary
    _saveSummary();
  }

  void _editItem(int index) {
    TextEditingController _amountCtrl = TextEditingController();
    _amountCtrl.text = transactions[index]['amount'].toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Amount'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _amountCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Amount'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                double newAmount = double.tryParse(_amountCtrl.text) ?? 0.0;

                if (newAmount > 0) {
                  setState(() {
                    // Update the transaction amount
                    transactions[index]['amount'] = newAmount;

                    // Recalculate expenses and income
                    _calculateExpensesAndIncome();
                  });

                  try {
                    await _saveTransactions(); // Save updated transactions
                    await _saveSummary(); // Save updated summary
                    Navigator.of(context).pop(); // Close the dialog
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Failed to save transaction. Please try again.'),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter a valid amount.'),
                    ),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _updateIncome(String category, double amount) {
    // Your update income logic
    print('Updating income: $category, Amount: $amount');
  }

  Future<void> _saveTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> transactionStrings = transactions.map((transaction) {
      return Uri(queryParameters: transaction.map((key, value) =>
          MapEntry(key, value.toString()))).toString();
    }).toList();

    await prefs.setStringList('transactions', transactionStrings);
  }

  Future<void> _saveSummary() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble('whole_expense', expenses);
      await prefs.setDouble('whole_income', income);
      await prefs.setDouble('balance', balance);

      print(
          'Summary saved: Expenses: $expenses, Income: $income, Balance: $balance');
    } catch (e) {
      print('Error saving summary: $e');
      throw e;
    }
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadStatistics();
  }

  void _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      transactions = (prefs.getStringList('transactions') ?? []).map((e) {
        final Map<String, dynamic> transaction =
        Map<String, dynamic>.from(Uri
            .parse(e)
            .queryParameters);
        transaction['amount'] = double.parse(transaction['amount']);
        return transaction;
      }).toList();

      // Filter transactions based on selected date
      _filterTransactions();
    });
  }

  void _filterTransactions() {
    setState(() {
      transactions = transactions.where((transaction) {
        DateTime transactionDate = DateTime.parse(transaction['date']);
        return transactionDate.month == selectedDate.month &&
            transactionDate.year == selectedDate.year;
      }).toList();
    });
  }


  Future<void> _loadCategories() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      categories = prefs.getStringList('categories') ?? [];
    });
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Example share',
        text: 'Example share text',
        linkUrl: 'https://flutter.dev/',
        chooserTitle: 'Example Chooser Title'
    );
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Rate the App"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("How would you rate our app?"),
              SizedBox(height: 20),
              RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemSize: 20,
                itemBuilder: (context, _) =>
                    Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                  });
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Close"),
              onPressed: () {
                setState(() {
                  _rating = 0.0; // Set rating to empty
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Submit"),
              onPressed: () {
                // Handle the rating submission if needed
                print("Rating submitted: $_rating");
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    // Clear session data and navigate to login screen
    // Example of clearing image and navigating to login screen
    setState(() {
      _image = null; // Clear profile image
    });
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => welcomescreen()),
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black26,
          title: Center(
            child: Text(
              'Expense Tracker',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),

        ),
        drawer: Drawer(
      
          elevation: 1,
          child: ListView(
            children: [
              DrawerHeader(
                child: Stack(
                  children: [
      
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/exp1.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            color: Colors.black.withOpacity(0.10),
                          ),
                        ),
                      ),
                    ),
                    // Profile image and name
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Select Image Source"),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text("Camera"),
                                      onPressed: () {
                                        _getImage(ImageSource.camera);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    TextButton(
                                      child: Text("Gallery"),
                                      onPressed: () {
                                        _getImage(ImageSource.gallery);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: _image != null
                                  ? FileImage(_image!)
                                  : null,
                              child: _image == null
                                  ? Icon(Icons.add_a_photo_outlined, size: 30)
                                  : null,
                            ),
                          ),
                        ),

                      ],
                    ),
                  ],
                ),
              ),
      
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('General',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.color_lens_outlined),
                    SizedBox(width: 18,),
                    ChangeThemeButtonWidget()
                    // GestureDetector(
                    //   onTap: ChangeThemeButtonWidget(),
                    //   child: Text(
                    //     "Theme",
                    //     style: TextStyle(
                    //         fontWeight: FontWeight.bold, fontSize: 15),
                    //   ),
                    // ),
                  ],
      
                ),
              ),
      
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.edit_note_sharp),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: _showRatingDialog,
                      child: Text(
                        "Rate the app",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.share),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        // Example of sharing a file
                        share();
                      },
                      child: Text(
                        "Share File",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.logout),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        _logout();
      
                        // Handle Log out tap if needed
                      },
                      child: Text(
                        "Log out",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            // Background image
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/Bscreen.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
      
      
            Column(
              children: [
                Container(
                  color: Colors.black54,
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () =>
                                _handleTileTap(context, 'Expenses', expenses),
                            child: _buildSummaryTile('Expenses', expenses),
                          ),
                          GestureDetector(
                            onTap: () =>
                                _handleTileTap(context, 'Income', income),
                            child: _buildSummaryTile('Income', income),
                          ),
                          GestureDetector(
                            onTap: () =>
                                _handleTileTap(context, 'Balance', balance),
                            child: _buildSummaryTile('Balance', balance),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),

                Expanded(
      
                  child: ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      DateTime transactionDate = DateTime.parse(
                          transaction['date']);
      
                      // Check if the transaction belongs to the selected month
                      if (transactionDate.month == selectedDate.month &&
                          transactionDate.year == selectedDate.year) {
                        return Card(
                          elevation: 2,
                          margin: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: ListTile(
                            tileColor: Colors.grey[200],
                            leading: CircleAvatar(
                              child: Icon(transaction['type'] == 'Expense'
                                  ? Icons.remove
                                  : Icons.add),
                            ),
                            title: Text(transaction['category']),
                            subtitle: Text(DateFormat.yMMMd().format(
                                transactionDate)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  transaction['type'] == 'Expense'
                                      ? '-₹${transaction['amount']
                                      .toStringAsFixed(2)}'
                                      : '+₹${transaction['amount']
                                      .toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: transaction['type'] == 'Expense'
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    _editItem(index);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    _deleteItem(index);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
      
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryTile(String title, double value) {
    return GestureDetector(
      onTap: () {
        _showAmountDetails(title, value);
      },
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          SizedBox(height: 8),
          Text(
            value.toStringAsFixed(2),
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _handleTileTap(BuildContext context, String title, double expenses) {
    List<Map<String, dynamic>> incomeEntries = [
      {'title': 'Salary Income', 'amount': salaryIncome},
      {'title': 'Part Salary Income', 'amount': partSalaryIncome},
      {'title': 'Awards Income', 'amount': awardsIncome},
      {'title': 'Investment Income', 'amount': investmentIncome},
    ];

    if (title == 'Income') {
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Income Details'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var entry in incomeEntries)
                    Text('${entry['title']}: ₹${entry['amount'].toStringAsFixed(
                        2)}'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                ),
              ],
            ),
      );
    } else if (title == 'Expenses') {
      // Placeholder for expenses logic, replace with your actual implementation
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Expense Details'),
              content: Text('Placeholder for expense details'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                ),
              ],
            ),
      );
    } else {
      // Handle other summary tiles if needed
    }
  }


  void _showAmountDetails(String title, double value) {
    String detailsText = '';
    switch (title) {
      case 'Expenses':
        detailsText = 'Total Expenses: ₹${expenses.toStringAsFixed(2)}';
        break;
      case 'Income':
        detailsText = 'Total Income: ₹${income.toStringAsFixed(2)}';
        break;
      case 'Balance':
        detailsText = 'Current Balance: ₹${balance.toStringAsFixed(2)}';
        break;
      default:
        detailsText = 'Details not available';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(detailsText),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

}
  class ChangeThemeButtonWidget extends StatelessWidget {
  const ChangeThemeButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
  final themeProvider = Provider.of<ThemeProvider>(context);
  return Switch(
  value: themeProvider.isDarkMode,
  onChanged: (value) {
  final provider = Provider.of<ThemeProvider>(context, listen: false);
  provider.toggleTheme(value);},
  );

  }
  }




import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MainForm extends StatefulWidget {
  MainForm({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MainFormState createState() => _MainFormState();
}

String getUrlPref = "";
String getRetryPref = "";

class _MainFormState extends State<MainForm> {
  late String? _dataModel;

  final formGlobalKey = GlobalKey<FormState>();
  final formActionList = <String>[
    'null',
    'Payment',
    'Register Pay',
    'Ask Register Pay',
    'Silent',
    'Customer Wallet'
  ];
  final currenciesList = <String>['COP', 'USD', 'CAD'];
  String formActionValue = "Payment";
  String currencyValue = "COP";
  TextEditingController amountController = TextEditingController();
  TextEditingController orderIdController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController retryController = TextEditingController();

  Future<String?> _submitForm(String amount, String currency, String orderId,
      String email, String retry) async {
    try {
      var response = await http.post(
          Uri.parse(
              'https://izipaypruebaswordpress.000webhostapp.com/api/sdk/'),
          body: {
            "amount": amount,
            "email": email,
          });
      if (response.statusCode != 200) return null;
      var formToken = jsonDecode(response.body);
      String responseString = formToken['description'].toString();
      return responseString;
    } on Exception catch (_) {
      print("");
      return null;
    }
  }

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      getRetryPref = (prefs.getString("retry") ?? "");
      getUrlPref = (prefs.getString("url") ?? "");
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(widget.title),
              new IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/configuration');
                  },
                  icon: new Icon(Icons.settings_rounded))
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: formGlobalKey,
            child: Wrap(
              spacing: 10,
              children: [
                // Amount
                const SizedBox(height: 50),
                TextFormField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                  ],
                  decoration:
                      InputDecoration(labelText: "Amount", hintText: "0"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter amount";
                    }
                  },
                ),
                // Currency
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: currencyValue,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  decoration: InputDecoration(labelText: "Currency"),
                  onChanged: (String? newValue) {
                    setState(() {
                      currencyValue = newValue!;
                    });
                  },
                  items: currenciesList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                // Form Action
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  value: formActionValue,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  decoration: InputDecoration(labelText: "Form Action"),
                  onChanged: (String? newValue) {
                    setState(() {
                      formActionValue = newValue!;
                    });
                  },
                  items: formActionList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                // Order Reference
                const SizedBox(height: 15),
                TextFormField(
                  controller: orderIdController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      labelText: "Order Reference", hintText: ""),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter amount";
                    }
                  },
                ),
                // Email
                const SizedBox(height: 15),
                TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        labelText: "Email", hintText: "example@email.com"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your email";
                      }
                      if (value.contains("@") || value.endsWith(".com"))
                        return null;
                    }),
                const SizedBox(height: 60),
                ElevatedButton(
                    onPressed: () async {
                      String amount = amountController.text;
                      String currency = currencyValue;
                      String email = emailController.text;
                      String orderId = orderIdController.text;
                      if (formGlobalKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Making transaction')),
                        );
                        String? data = await _submitForm(
                            amount, currency, orderId, email, getRetryPref);
                        setState(() {
                          _dataModel = data;
                        });
                        Navigator.pushNamed(context, '/embedded-form',
                            arguments: {'formToken': data});
                      }
                    },
                    child: Text("Submit"))
              ],
            ),
          ),
        ));
  }
}

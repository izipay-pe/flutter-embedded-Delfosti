import 'package:flutter/material.dart';

import 'configuration.dart';
import 'success.dart';
import 'refused.dart';
import 'embedded_form.dart';
import 'form.dart';

void main() {
  runApp(Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MainForm(title: 'Embedded Form Flutter'),
        '/configuration': (context) => Configuration(title: "Settings"),
        '/embedded-form': (context) => PaymentWebView(title: 'WebView Embedded Form'),
        '/success': (context) => Success(title: "Transaction Success"),
        '/refused': (context) => Refused(title: 'Transaction Refused'),
      }
    );
  }
}

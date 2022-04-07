import 'dart:io';
import 'package:embedded_form_flutter/kr_response.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatefulWidget {
  PaymentWebView({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  PaymentWebViewState createState() => PaymentWebViewState();
}

late String getUrlPref;

class PaymentWebViewState extends State<PaymentWebView> {
  late WebViewController _controller;

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      getUrlPref = (prefs.getString("url") ?? "");
    });
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    _loadData();
  }

  Widget build(BuildContext context) {
    final formTokenArgument = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: WebView(
            initialUrl:
                "https://citas.ramsesconsulting.com/pagoEmbebido.php?formToken=${formTokenArgument['formToken']}",
            javascriptMode: JavascriptMode.unrestricted,
            onPageStarted: (String url) async {
              Map<String, dynamic> dataToSend = {};
              if (url.contains("/transaction-success")) {
                Uri.parse(url).queryParameters.forEach((key, value) {
                  dataToSend[key] = value;
                });
                Navigator.pushNamedAndRemoveUntil(
                    context, '/success', (r) => false,
                    arguments: KrResponse.fromJson(dataToSend));
              } else if (url.contains("/transaction-refused")) {
                Uri.parse(url).queryParameters.forEach((key, value) {
                  dataToSend[key] = value;
                });
                Navigator.pushNamedAndRemoveUntil(
                    context, '/refused', (r) => false,
                    arguments: KrResponse.fromJson(dataToSend));
              }
            }));
  }
}

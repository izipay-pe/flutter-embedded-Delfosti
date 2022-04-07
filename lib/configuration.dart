
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class Configuration extends StatefulWidget {
  Configuration({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _Configuration createState() => _Configuration();
}


class _Configuration extends State<Configuration> {
  final _urlController = TextEditingController();
  final _retryController = TextEditingController();

  Future<dynamic> getHealthStatus(String url) async {
    final getStatus = await http.get(Uri.parse('https://$url/health'));
    if (getStatus.statusCode == 200) {
      return jsonDecode(getStatus.body);
    }
    return "Error";
  }

  void _saveSettings() async {
    final url = _urlController.text;
    final retry = _retryController.text;
    if (url.isEmpty || retry.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Field is empty')),
      );
    } else {
      dynamic getStatus = await getHealthStatus(url);
      if (getStatus["status"] != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Un-valid url'))
        );
      } else if (int.parse(retry) < 0 || int.parse(retry) > 3){
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Retries should be less than 4 and more than 0'))
        );
      } else {
        saveSettings(url, retry).then((_) => {
          Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false)
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Saving data'))
        );
      }
    }
  }

  void _populateSettings() async {
    final settings = await getSettings();
    setState(() {
      _urlController.text = settings[0];
      _retryController.text = settings[1];
    });
  }

  Future saveSettings(String url, String retry) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString('url', url);
    await preferences.setString('retry', retry);
  }

  Future<List> getSettings() async {
    final preferences = await SharedPreferences.getInstance();

    final url = (preferences.getString('url') ?? "");
    final retry = preferences.getString('retry') ?? "";

    return [url, retry];
  }

  @override
  void initState() {
    super.initState();
    _populateSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
      body: ListView(
        children: [
          ListTile(
            title: new TextField(
              controller: _urlController,
              decoration: InputDecoration(labelText: "Backend URL"),
            ),
          ),
          ListTile(
            title: TextField(
              controller: _retryController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
              ],
              decoration: InputDecoration(labelText: "Number of retries"),
            ),
          ),
          TextButton(
              onPressed: _saveSettings,
              child: Text("Save Settings")
          )
        ],
      )
    );
  }
}

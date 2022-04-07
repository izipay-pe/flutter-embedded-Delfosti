import 'dart:convert';

import 'package:embedded_form_flutter/kr_response.dart';
import 'package:flutter/material.dart';

class Success extends StatefulWidget {
  Success({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _SuccessState createState() => _SuccessState();
}

class _SuccessState extends State<Success> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final arguments = (
        ModalRoute.of(context)!.settings.arguments as KrResponse).toJson();
    final ScrollController _firstController = ScrollController();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            new IconButton(
                onPressed: (){
                  Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false);
                },
                icon: new Icon(Icons.arrow_back)
            ),
            Text(widget.title),
          ],
        ),
      ),
        body: ListView(
          children: [
            Text("Successful Transaction",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
            ),
            Text(
              'ShopId: ${jsonDecode(arguments["kr-answer"])["shopId"]}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
            ),
            Text(
              'Amount: ${jsonDecode(arguments["kr-answer"])["orderDetails"]["orderTotalAmount"]}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
            ),
            Text(
              'Order Cycle: ${jsonDecode(arguments["kr-answer"])["orderCycle"]}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
            ),
            Text(
              'Order Status: ${jsonDecode(arguments["kr-answer"])["orderStatus"]}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
            ),
            FloatingActionButton(onPressed: () {
              setState(() {
                _visible = !_visible;
              });
            },
              tooltip: 'Toggle Opacity',
              child: const Icon(Icons.flip)
            ),
            AnimatedOpacity(
              opacity: _visible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 0),
              child: Scrollbar(
                controller: _firstController,
                child: Container(
                  width: 200.0,
                  color: Colors.lightGreen,
                    child: SelectableText.rich(
                      TextSpan(
                        text: "$arguments"
                      )
                    )
                ),
              )
            )
          ],
        ),
    );
  }
}

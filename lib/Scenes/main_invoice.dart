import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:huppekeeee/Utils/app_util.dart' as AppUtils;


class InvoiceScreen extends StatefulWidget {
  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {



  @override
  void initState() {
    super.initState();

    // generatePdf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Invoice"),
            brightness: Brightness.dark,
            backgroundColor: Colors.black87,
            textTheme: AppUtils.titleTheme,
            leading: new IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              }
            ),
          ),
          body: Stack(
            children: <Widget>[

            ],
          )
    );
  }
}
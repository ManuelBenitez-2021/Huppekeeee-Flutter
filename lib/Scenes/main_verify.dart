import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:huppekeeee/Utils/app_util.dart' as AppUtils;

class VerifyScreen extends StatefulWidget {
  VerifyScreen();

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Pending'),
        brightness: Brightness.dark,
        backgroundColor: Colors.black87,
        textTheme: AppUtils.titleTheme,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(20, 24, 20, 4),
            child: Column(
              children: <Widget>[
                Container(
                  child: Center(
                    child: Container(
                      child: Image.asset('assets/imgs/logo.png'),
                      width: 180,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Text(
                    "Your account is pendding now. Please contact to +8562096227257.",
                    style: AppUtils.orderDetailMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
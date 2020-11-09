import 'dart:async';
import 'dart:io';

import 'package:huppekeeee/Scenes/main_fill_status.dart';
import 'package:huppekeeee/Scenes/main_invoice.dart';
import 'package:huppekeeee/Scenes/main_label.dart';
import 'package:huppekeeee/Scenes/main_order.dart';
import 'package:huppekeeee/Scenes/main_pay_status.dart';
import 'package:huppekeeee/Scenes/main_track.dart';
import 'package:huppekeeee/Scenes/main_verify.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'Scenes/main_label_view.dart';
import 'Scenes/main_scene.dart';
import 'Scenes/main_sign.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final FirebaseApp app = await Firebase.initializeApp (
    name: 'huppekeeee',
    options: Platform.isIOS || Platform.isMacOS
        ? FirebaseOptions(
      appId: '1:198299003179:ios:2294d499f10910f6923d6e',
      apiKey: 'AIzaSyCmSPbFYqspEBeGfYwWE-BduIA17Bg7sQ4',
      projectId: 'huppekeeee',
      messagingSenderId: '198299003179',
      databaseURL: 'https://huppekeeee.firebaseio.com/',
    )
        : FirebaseOptions(
      appId: '1:198299003179:android:934ed47516338036923d6e',
      apiKey: 'AIzaSyCmSPbFYqspEBeGfYwWE-BduIA17Bg7sQ4',
      projectId: 'huppekeeee',
      messagingSenderId: '198299003179',
      databaseURL: 'https://huppekeeee.firebaseio.com/',
    ),
  );

  runApp(
      new MaterialApp(
        home: SplashScreen(app: app),
        routes: <String, WidgetBuilder> {
          '/sign': (BuildContext context) => new SignScreen(),
          '/main': (BuildContext context) => new MainScreen(),
          '/order' : (BuildContext context) => new OrderScreen(),
          '/label' : (BuildContext context) => new LabelScreen(),
          '/labelview' : (BuildContext context) => new LabelViewScreen(),
          '/fill' : (BuildContext context) => new FillStatusScreen(),
          '/pay' : (BuildContext context) => new PayStatusScreen(),
          '/track' : (BuildContext context) => new TrackScreen(),
          '/verify' : (BuildContext context) => new VerifyScreen(),
          '/invoice' : (BuildContext context) => new InvoiceScreen(),
        },
      )
  );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black87, // navigation bar color
    statusBarColor: Colors.black87,
  ));
}

class SplashScreen extends StatefulWidget {
  SplashScreen({this.app});
  final FirebaseApp app;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Timer timer;

  void callMainScreen() {
    timer = Timer(
        const Duration(seconds: 2), () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => SignScreen(app: widget.app)));
        }
    );
  }

  @override
  void initState() {
    super.initState();
    callMainScreen();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var assersImage = new AssetImage('assets/imgs/logo.png');
    var logo = new Image(image: assersImage,
      width: 300,);

    return Scaffold(
      body: Container(
        decoration: new BoxDecoration(color: Colors.black),
        child: new Center(
          child: logo,
        ),
      ),
    );
  }

}
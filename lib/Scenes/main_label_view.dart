import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:huppekeeee/Models/model_label.dart';
import 'package:huppekeeee/Models/model_order.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:huppekeeee/Utils/app_util.dart' as AppUtils;


class LabelViewScreen extends StatefulWidget {
  LabelViewScreen({this.app});
  final FirebaseApp app;

  @override
  _LabelViewScreenState createState() => _LabelViewScreenState();
}

class _LabelViewScreenState extends State<LabelViewScreen> {

  OrderModel model = OrderModel();
  LabelModel labelModel = LabelModel();

  String base64PDF = "";
  bool isShowing = false;
  File pdfFile;

  DatabaseReference _labelRef;

  TextStyle getOrderPaymentStyle() {
    if (model.paymentStatus == "PAID") {
      return AppUtils.orderDetailPaid;
    } else {
      return AppUtils.orderDetailUnpaid;
    }
  }

  TextStyle getOrderDeliveryStyle() {
    if (model.fulfillmentStatus.contains("PROCESSING")) {
      return AppUtils.orderDetailUnpaid;
    } else {
      return AppUtils.orderDetailPaid;
    }
  }

  void getOrderData() {
    model = AppUtils.gSelOrder;

    _labelRef.child(model.id).once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        LabelModel label = LabelModel(id: snapshot.value['id']
            , regdate: snapshot.value['regdate']
            , uid: snapshot.value['uid']
            , barcode: snapshot.value['barcode']
            , content: snapshot.value['content']);
        onShowLabel(label);
      }
    });
  }

  Future onShowLabel(LabelModel label) async {
    labelModel = label;
    base64PDF = label.content;

    var decodedBytes = base64Decode(base64PDF.replaceAll('\n', ''));
    String dir = (await getApplicationDocumentsDirectory()).path;
    if (Platform.isAndroid) {
      dir = (await getExternalStorageDirectory()).path;
    }
    pdfFile = new File('$dir/test.pdf');
    await pdfFile.writeAsBytes(decodedBytes.buffer.asUint8List());
    print(pdfFile.path);
    isShowing = true;

    setState(() { });
  }
  
  @override
  void initState() {
    super.initState();

    final FirebaseDatabase database = FirebaseDatabase(app: widget.app);
    _labelRef = database.reference().child('labels');

    getOrderData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Label"),
        brightness: Brightness.dark,
        backgroundColor: Colors.black87,
        textTheme: AppUtils.titleTheme,
        leading: new IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop(false);
            }
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(0, 24, 0, 4),
                  child: Image.asset('assets/imgs/logo.png'),
                  width: 180,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 4),
                  child: Text(
                    'Order Number : # ' + model.id,
                    style: AppUtils.orderDetailMedium,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(12, 8, 0, 0),
                      child: Text(
                        "Total : € " + model.total.toString(),
                        style: AppUtils.orderDetailMedium,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 8, 12, 0),
                      child: Text(
                        "Subtotal : € " + model.subtotal.toString(),
                        style: AppUtils.orderDetailContent,
                      ),
                    ),
                  ],
                ),

                if (isShowing) Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(12, 8, 0, 0),
                      child: Text(
                        "Created Date",
                        style: AppUtils.orderDetailMedium,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 8, 12, 0),
                      child: Text(
                        labelModel.regdate,
                        style: AppUtils.orderDetailContent,
                      ),
                    ),
                  ],
                ),

                if (isShowing) Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    height: 350,
                    child: PdfPreview(
                      build: (format) => pdfFile.readAsBytes(),
                    ),
                ),

                if (isShowing) Container(
                  margin: EdgeInsets.fromLTRB(12, 20, 12, 0),
                  width: double.infinity,
                  height: 40,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.black54),
                    ),
                    color: Colors.black54,
                    textColor: Colors.white,
                    onPressed: () {
                      OpenFile.open(pdfFile.path);
                    },
                    child: Text(
                      "Print Label",
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
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
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
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:progress_hud/progress_hud.dart';
import 'package:huppekeeee/Utils/app_util.dart' as AppUtils;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';


class LabelScreen extends StatefulWidget {
  LabelScreen({this.app});
  final FirebaseApp app;

  @override
  _LabelScreenState createState() => _LabelScreenState();
}

enum PackageType { Brievenbuspakje, Pakket }

class _LabelScreenState extends State<LabelScreen> {
  ProgressHUD progressHUD;
  OrderModel model = OrderModel();

  String senderName = 'Karin Brussaard';
  String senderAddress = '3151PN, Tasmanweg 161';
  String country = 'NL';
  String barCodeString = "";
  File pdfFile;
  String base64PDF = "";
  bool isShowing = false;

  DatabaseReference _labelRef;

  PackageType packageType = PackageType.Brievenbuspakje;

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
  }

  Map<String, Object> getParameter2() {
    Map<String, Object> datas = new Map();

    Map<String, Object> customerData = new Map();
    Map<String, String> customerAddress = new Map();
    customerAddress['AddressType'] = '02';
    customerAddress['City'] = 'Hoek van Holland';
    customerAddress['CompanyName'] = 'Huppekeeee';
    customerAddress['Countrycode'] = 'NL';
    customerAddress['HouseNr'] = '161';
    customerAddress['Street'] = 'Tasmanweg';
    customerAddress['Zipcode'] = '3151PN';
    customerData['Address'] = customerAddress;
    customerData['CollectionLocation'] = "100548";
    customerData['ContactPerson'] = "Karin Brussaard";
    customerData['CustomerCode'] = "NYQJ";
    customerData['CustomerNumber'] = "10738096";
    customerData['Email'] = "info@ahhhjoh.nl";
    customerData['Name'] = "Karin Brussaard";
    datas['Customer'] = customerData;

    Map<String, String> messageData = new Map();
    messageData['MessageID'] = '{{\$10738096}}';
    messageData['MessageTimeStamp'] = '{{' + DateTime.now().millisecondsSinceEpoch.toString() + '}}';
    messageData['Printertype'] = 'GraphicFile|PDF';
    datas['Message'] = messageData;

    List<Map<String, Object>> shippingData = new List();
    Map<String, Object> shippingOne = new Map();
    List<Map<String, Object>> shippingAddresses = new List();
    Map<String, Object> addressOne = new Map();
    addressOne['AddressType'] = '01';
    addressOne['City'] = model.shippingPerson.city;
    addressOne['Countrycode'] = 'NL';
    addressOne['FirstName'] = model.shippingPerson.name;
    addressOne['HouseNr'] = '';
    addressOne['HouseNrExt'] = 'a bls';
    addressOne['Name'] = '';
    addressOne['Street'] = model.shippingPerson.street;
    addressOne['Zipcode'] = model.shippingPerson.postalCode;
    shippingAddresses.add(addressOne);
    shippingOne['Addresses'] = shippingAddresses;
    shippingOne['Barcode'] = barCodeString;
    if (packageType == PackageType.Brievenbuspakje) {
      shippingOne['ProductCodeDelivery'] = '2928';
    } else {
      shippingOne['ProductCodeDelivery'] = '3085';
    }
    List<Map<String, Object>> shippingContacts = new List();
    Map<String, Object> contactOne = new Map();
    contactOne['ContactType'] = '01';
    contactOne['Email'] = 'receiver@email.com';
    contactOne['SMSNr'] = '+31612345678';
    shippingContacts.add(contactOne);
    shippingOne['Contacts'] = shippingContacts;
    shippingOne['Dimension'] = {'Weight':'2000'};
    shippingData.add(shippingOne);
    datas['Shipments'] = shippingData;

    return datas;
  }

  Future getBarcode() async {
    Timer(
        Duration(milliseconds: 100),
            () =>
            progressHUD.state.show()
    );

    http.Response response = await http.get(AppUtils.BARCODE_URL, headers: {"apikey":AppUtils.postNLKey});
    if(response.body.isNotEmpty) {
      var jsonData = json.decode(response.body);
      barCodeString = jsonData['Barcode'] as String;

      http.Response resp = await http.post('https://api-sandbox.postnl.nl/shipment/v2_2/label'
          , headers: {'apikey':AppUtils.postNLKey, 'Content-Type':'application/json'}
          , body: packageType == PackageType.Brievenbuspakje?json.encode(getParameter2()):json.encode(getParameter2()));
      if(resp.body.isNotEmpty) {
        var jsonLabel = json.decode(resp.body);
        var respShippingLabelJsonArray = jsonLabel['ResponseShipments'] as List;
        var respLabelJsonArray = respShippingLabelJsonArray[0]['Labels'] as List;
        base64PDF = respLabelJsonArray[0]['Content'] as String;

        var decodedBytes = base64Decode(base64PDF.replaceAll('\n', ''));
        String dir = (await getApplicationDocumentsDirectory()).path;
        pdfFile = new File('$dir/test.pdf');
        await pdfFile.writeAsBytes(decodedBytes.buffer.asUint8List());
        isShowing = true;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(AppUtils.gSelOrder.id, barCodeString);
      }
    }

    setState(() {
      progressHUD.state.dismiss();
    });
  }

  @override
  void initState() {
    super.initState();

    progressHUD = new ProgressHUD(
      backgroundColor: Colors.black45,
      color: Colors.black,
      containerColor: Colors.white,
      borderRadius: 5.0,
      loading: false,
      text: 'Loading...',
    );

    final FirebaseDatabase database = FirebaseDatabase(app: widget.app);
    _labelRef = database.reference().child('labels');

    getOrderData();
    getBarcode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Make Label"),
        brightness: Brightness.dark,
        backgroundColor: Colors.black87,
        textTheme: AppUtils.titleTheme,
        leading: new IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.white,
            ),
            onPressed: () {
              if (base64PDF.isNotEmpty) {
                DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
                var labelModel = LabelModel(id: model.id, regdate: dateFormat.format(DateTime.now()), uid: AppUtils.gUserModel.uid,barcode: barCodeString, content: base64PDF);
                _labelRef.child(model.id).set(labelModel.toJson());
              }
              Navigator.of(context).pop(true);
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                        child: Container(
                          child: ListTile(
                            title: const Text('Brievenbuspakje'),
                            leading: Radio(
                                value: PackageType.Brievenbuspakje,
                                groupValue: packageType,
                                onChanged: (PackageType type) {
                                  setState(() {
                                    packageType = type;
                                    getBarcode();
                                  });
                                },
                              ),
                          ),
                        ),
                      flex: 10,
                    ),
                    Flexible(
                      child: Container(
                        child: ListTile(
                          title: const Text('Pakket'),
                          leading: Radio(
                            value: PackageType.Pakket,
                            groupValue: packageType,
                            onChanged: (PackageType type) {
                              setState(() {
                                packageType = type;
                                getBarcode();
                              });
                            },
                          ),
                        ),
                      ),
                      flex: 8,
                    ),
                  ],
                ),

                if (isShowing) Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    height: 350,
                    child: PdfPreview (
                      // pageFormats: pdfFormats,
                      build: (format) => pdfFile.readAsBytes(),
                    ),
                ),

                Container(
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
          progressHUD,
        ],
      ),
    );
  }

}
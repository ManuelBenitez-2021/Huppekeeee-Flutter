import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'package:huppekeeee/Models/model_order.dart';
import 'package:huppekeeee/Models/model_product.dart';
import 'package:huppekeeee/Utils/app_util.dart' as AppUtils;
import 'package:huppekeeee/Utils/util_image.dart' as ImageUtils;


class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {

  List<ProductModel> productModels = [];
  OrderModel model = OrderModel();

  void getProductData() {
    model = AppUtils.gSelOrder;
    productModels = AppUtils.gSelOrder.items;
  }

  Future _getRequests() async{
    model = AppUtils.gSelOrder;
    productModels = AppUtils.gSelOrder.items;
    setState(() { });
  }

  var subTitleFont = 14.0;
  var descFont = 12.0;
  var descMarginTop = 2.0;

  Future<void> generatePdf() async {
    var myTheme = pw.ThemeData.withFont(
      base: pw.Font.ttf(await rootBundle.load("assets/fonts/Montserrat-Regular.ttf")),
      bold: pw.Font.ttf(await rootBundle.load("assets/fonts/Montserrat-Bold.ttf")),
      italic: pw.Font.ttf(await rootBundle.load("assets/fonts/Montserrat-Italic.ttf")),
      boldItalic: pw.Font.ttf(await rootBundle.load("assets/fonts/Montserrat-BoldItalic.ttf")),
    );

    var pdf = pw.Document(theme: myTheme);

    final PdfImage logoImage = await pdfImageFromImageProvider(pdf: pdf.document, image: ImageUtils.assert_logo);
    var page = pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Container(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Image(logoImage, width: 200, height: 100),

                pw.Container(
                  alignment: pw.Alignment.centerRight,
                    child: pw.Text('Factuur', style: pw.TextStyle(fontSize: 16))
                ),

                pw.Container(
                    margin: pw.EdgeInsets.fromLTRB(0, 0, 0, 8),
                  width: double.infinity,
                  height: 1,
                  color: PdfColors.black
                ),

                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                        flex: 1,
                        child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(AppUtils.APPTITLE, style: pw.TextStyle(fontSize: subTitleFont, fontWeight: pw.FontWeight.bold)),
                              pw.Container(margin: pw.EdgeInsets.fromLTRB(0, descMarginTop, 0, 0)),
                              pw.Text(AppUtils.APPSITEURL, style: pw.TextStyle(fontSize: descFont)),
                              pw.Container(
                                margin: pw.EdgeInsets.fromLTRB(0, 8, 0, 0),
                                child: pw.Text(AppUtils.APPTITLE, style: pw.TextStyle(fontSize: subTitleFont)),
                              ),
                              pw.Container(margin: pw.EdgeInsets.fromLTRB(0, descMarginTop, 0, 0)),
                              pw.Text(AppUtils.APPADDRESS1, style: pw.TextStyle(fontSize: descFont)),
                              pw.Container(margin: pw.EdgeInsets.fromLTRB(0, descMarginTop, 0, 0)),
                              pw.Text(AppUtils.APPADDRESS2, style: pw.TextStyle(fontSize: descFont)),
                              pw.Container(margin: pw.EdgeInsets.fromLTRB(0, descMarginTop, 0, 0)),
                              pw.Text(AppUtils.APPADDRESS3, style: pw.TextStyle(fontSize: descFont)),
                            ]
                        )
                      ),

                      pw.Expanded(
                          flex: 1,
                          child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text('Factuur', style: pw.TextStyle(fontSize: subTitleFont, fontWeight: pw.FontWeight.bold)),
                                pw.Container(margin: pw.EdgeInsets.fromLTRB(0, descMarginTop, 0, 0)),
                                pw.Text('Nummer #' + model.id, style: pw.TextStyle(fontSize: descFont)),
                                pw.Container(margin: pw.EdgeInsets.fromLTRB(0, descMarginTop, 0, 0)),
                                pw.Text('Datum ' + model.createDate.split(' ')[0], style: pw.TextStyle(fontSize: descFont)),
                                pw.Container(
                                  margin: pw.EdgeInsets.fromLTRB(0, 8, 0, 0),
                                  child: pw.Text('Klantenservice', style: pw.TextStyle(fontSize: subTitleFont, fontWeight: pw.FontWeight.bold)),
                                ),
                                pw.Container(margin: pw.EdgeInsets.fromLTRB(0, descMarginTop, 0, 0)),
                                pw.Text(AppUtils.SERVICEEMAIL, style: pw.TextStyle(fontSize: descFont)),
                              ]
                          )
                      ),
                    ]
                ),

                pw.Container(
                    margin: pw.EdgeInsets.fromLTRB(0, 8, 0, 8),
                    width: double.infinity,
                    height: 1,
                    color: PdfColors.black
                ),

                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                          flex: 1,
                          child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text('Verzenden naar', style: pw.TextStyle(fontSize: subTitleFont, fontWeight: pw.FontWeight.bold)),
                                pw.Text(model.shippingPerson.name, style: pw.TextStyle(fontSize: descFont)),
                                pw.Container(margin: pw.EdgeInsets.fromLTRB(0, descMarginTop, 0, 0)),
                                pw.Text(model.shippingPerson.street, style: pw.TextStyle(fontSize: descFont)),
                                pw.Container(margin: pw.EdgeInsets.fromLTRB(0, descMarginTop, 0, 0)),
                                pw.Text(model.shippingPerson.postalCode + " " + model.shippingPerson.city + ", " + model.shippingPerson.stateOrProvinceName, style: pw.TextStyle(fontSize: descFont)),
                                pw.Container(margin: pw.EdgeInsets.fromLTRB(0, descMarginTop, 0, 0)),
                                pw.Text(model.shippingPerson.countryName, style: pw.TextStyle(fontSize: descFont)),
                              ]
                          )
                      ),

                      pw.Expanded(
                          flex: 1,
                          child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text('Klant', style: pw.TextStyle(fontSize: subTitleFont, fontWeight: pw.FontWeight.bold)),
                                pw.Container(margin: pw.EdgeInsets.fromLTRB(0, descMarginTop, 0, 0)),
                                pw.Text(model.email, style: pw.TextStyle(fontSize: descFont)),
                                pw.Container(margin: pw.EdgeInsets.fromLTRB(0, descMarginTop, 0, 0)),
                                pw.Text('Betaalmethode : ' + (model.paymentMethod != null? model.paymentMethod : ''), style: pw.TextStyle(fontSize: descFont)),
                              ]
                          )
                      ),
                    ]
                ),

                pw.Container(
                    margin: pw.EdgeInsets.fromLTRB(0, 8, 0, 8),
                    width: double.infinity,
                    height: 1,
                    color: PdfColors.black
                ),

                pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 4,
                      child: pw.Text('Artikelen', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                    ),

                    pw.Expanded(
                      flex: 1,
                      child: pw.Text('Prijs', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                    ),

                    pw.Expanded(
                      flex: 1,
                      child: pw.Text('Aantal', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                    ),

                    pw.Expanded(
                      flex: 1,
                      child: pw.Text('Subtotaal', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                    ),
                  ]
                ),

                pw.Container(
                    margin: pw.EdgeInsets.fromLTRB(0, 8, 0, 8),
                    width: double.infinity,
                    height: 2,
                    color: PdfColors.black
                ),

                pw.ListView.builder(
                  itemCount: productModels.length,
                  itemBuilder: (context, index) {
                    return pw.Container(
                      margin: pw.EdgeInsets.fromLTRB(0, 0, 0, 8),
                      child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Expanded(
                              flex: 4,
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(productModels[index].name, style: pw.TextStyle(fontSize: subTitleFont, fontWeight: pw.FontWeight.bold)),
                                  pw.Container(margin: pw.EdgeInsets.fromLTRB(0, descMarginTop, 0, 0)),
                                  pw.Text('Art.nr. ' + productModels[index].sku, style: pw.TextStyle(fontSize: subTitleFont)),
                                  pw.Container(margin: pw.EdgeInsets.fromLTRB(0, descMarginTop, 0, 0)),
                                  if (productModels[index].selectedOptions.length > 0) pw.Text(productModels[index].selectedOptions[0].name, style: pw.TextStyle(fontSize: subTitleFont)),
                                  if (productModels[index].selectedOptions.length > 0) pw.Text(productModels[index].selectedOptions[0].value, style: pw.TextStyle(fontSize: subTitleFont, fontWeight: pw.FontWeight.bold, color: PdfColors.red)),
                                ],
                              ),
                            ),

                            pw.Expanded(
                              flex: 1,
                              child: pw.Text('€ ' + productModels[index].productPrice.toStringAsFixed(2), style: pw.TextStyle(fontSize: subTitleFont)),
                            ),

                            pw.Expanded(
                              flex: 1,
                              child: pw.Text(productModels[index].quantity.toString(), style: pw.TextStyle(fontSize: subTitleFont)),
                            ),

                            pw.Expanded(
                              flex: 1,
                              child: pw.Text('€ ' + (productModels[index].productPrice * productModels[index].quantity).toStringAsFixed(2), style: pw.TextStyle(fontSize: subTitleFont)),
                            ),
                          ]
                      ),
                    );
                  },
                ),

                pw.Container(
                    margin: pw.EdgeInsets.fromLTRB(0, 0, 0, 8),
                    width: double.infinity,
                    height: 1,
                    color: PdfColors.black
                ),

                pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                        flex: 4,
                        child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('Verzenden met Post NL', style: pw.TextStyle(fontSize: subTitleFont, fontWeight: pw.FontWeight.bold)),
                              pw.Text('LET OP: Ieder product wordt op bestelling gedrukt en kan om die reden niet geretourneerd worden. Zorg ervoor dat je de juiste maat kiest!', style: pw.TextStyle(fontSize: descFont)),
                            ]
                        )
                      ),

                      pw.Expanded(
                          flex: 2,
                          child: pw.Text('€ ' + (model.total - model.subtotal + double.parse(model.couponDiscount)).toStringAsFixed(2), style: pw.TextStyle(fontSize: subTitleFont)),
                      ),

                      pw.Expanded(
                          flex: 1,
                          child: pw.Text('€ ' + (model.total - model.subtotal + double.parse(model.couponDiscount)).toStringAsFixed(2), style: pw.TextStyle(fontSize: subTitleFont)),
                      ),
                    ]
                ),

                pw.Container(
                    margin: pw.EdgeInsets.fromLTRB(0, 8, 0, 0),
                    width: double.infinity,
                    height: 1,
                    color: PdfColors.black
                ),

                pw.Row(
                    children: [
                      pw.Expanded(
                          flex: 6,
                          child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.end,
                              children: [
                                pw.Text('Artikelen', style: pw.TextStyle(fontSize: subTitleFont)),
                                pw.Text('Verzending', style: pw.TextStyle(fontSize: subTitleFont)),
                                pw.Text('BTW', style: pw.TextStyle(fontSize: subTitleFont)),
                                if (double.parse(model.couponDiscount) > 0) pw.Text('Coupon (' + model.couponModel.name + ')', style: pw.TextStyle(fontSize: subTitleFont)),
                                pw.Text('Totaal', style: pw.TextStyle(fontSize: subTitleFont, fontWeight: pw.FontWeight.bold)),
                              ]
                          )
                      ),

                      pw.Expanded(
                        flex: 1,
                        child: pw.Column(
                          children: [
                            pw.Text('€ ' + model.subtotal.toStringAsFixed(2), style: pw.TextStyle(fontSize: subTitleFont)),
                            pw.Text('€ ' + (model.total - model.subtotal + double.parse(model.couponDiscount)).toStringAsFixed(2), style: pw.TextStyle(fontSize: subTitleFont)),
                            pw.Text('€ 0,00', style: pw.TextStyle(fontSize: subTitleFont)),
                            if (double.parse(model.couponDiscount) > 0) pw.Text('€ -' + double.parse(model.couponDiscount).toStringAsFixed(2), style: pw.TextStyle(fontSize: subTitleFont)),
                            pw.Text('€ ' + model.total.toStringAsFixed(2), style: pw.TextStyle(fontSize: subTitleFont, fontWeight: pw.FontWeight.bold)),
                          ]
                        )
                      ),
                    ]
                ),
              ]
            ),
          );
        }
    );
    pdf.addPage(page);

    String dir = (await getApplicationDocumentsDirectory()).path;
    if (Platform.isAndroid) {
      dir = (await getExternalStorageDirectory()).path;
    }
    File pdfFile = new File('$dir/example.pdf');
    await pdfFile.writeAsBytes(pdf.save());
    print(pdfFile.path);

    OpenFile.open(pdfFile.path);
  }

  @override
  void initState() {
    super.initState();

    getProductData();
  }

  TextStyle getOrderPaymentStyle() {
    if (model.paymentStatus == "PAID") {
      return AppUtils.orderDetailPaidUnderS;
    } else {
      return AppUtils.orderDetailUnpaidUnderS;
    }
  }

  TextStyle getOrderDeliveryStyle() {
    if (model.fulfillmentStatus.contains("PROCESSING")) {
      return AppUtils.orderDetailUnpaidUnderS;
    } else {
      return AppUtils.orderDetailPaidUnderS;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Number # " + AppUtils.gSelOrder.id),
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
          Container(
            margin: EdgeInsets.fromLTRB(20, 28, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    'Order Details',
                    style: AppUtils.orderDetailMedium,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/pay')
                            .then((val)=>val? _getRequests() : null);
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: Text(
                          model.paymentStatus,
                          style: getOrderPaymentStyle(),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/fill')
                            .then((val)=>val? _getRequests() : null);
                      },
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: Text(
                          model.fulfillmentStatus,
                          style: getOrderDeliveryStyle(),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                      child: Text(
                        'Total :  € ' + model.total.toStringAsFixed(2),
                        style: AppUtils.orderDetailContent,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                      child: Text(
                        'SubTotal :  € ' + model.subtotal.toStringAsFixed(2),
                        style: AppUtils.orderDetailContent,
                      ),
                    ),
                  ],
                ),

                if (model.orderComments != null) Container(
                  margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
                  child: Text(
                    'Customer Comment',
                    style: AppUtils.orderDetailMedium,
                  ),
                ),
                if (model.orderComments != null) Container(
                  margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Text(
                    model.orderComments,
                    style: AppUtils.orderDetailContent,

                  ),
                ),

                Container(
                  margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
                  child: Text(
                    'Delivered Person Information',
                    style: AppUtils.orderDetailMedium,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Text(
                    'Name : ' + model.shippingPerson.name,
                    style: AppUtils.orderDetailContent,
                    
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Text(
                    'Postal Code : ' + model.shippingPerson.postalCode,
                    style: AppUtils.orderDetailContent,

                  ),
                ),

                Container(
                  margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                  child: Text(
                    'Address : ' + model.shippingPerson.street + ', ' + model.shippingPerson.city
                        + ', ' + model.shippingPerson.postalCode + ' ' + model.shippingPerson.stateOrProvinceName
                        + ', ' + model.shippingPerson.countryName,
                    style: AppUtils.orderDetailContent,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 16, 0, 0),
                  child: Text(
                    'Product Information',
                    style: AppUtils.orderDetailMedium,
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: productModels.length,
                    itemBuilder: (context, index) {
                      return ProductModelUI(model: productModels[index]);
                    },
                  ),
                ),

                Container(
                  width: double.infinity,
                  height: 40,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.black54),
                          ),
                          color: Colors.black54,
                          textColor: Colors.white,
                          onPressed: () {
                            // Navigator.of(context).pushNamed('/invoice');
                            generatePdf();
                          },
                          child: Text(
                            'Invoice',
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                        ),
                        flex: 1,
                      ),

                      Container(
                        margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                      ),

                      Expanded(
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.black54),
                          ),
                          color: Colors.black54,
                          textColor: Colors.white,
                          onPressed: () {
                            model.fulfillmentStatus.contains("PROCESSING")? Navigator.of(context).pushNamed('/label') : Navigator.of(context).pushNamed('/track');
                          },
                          child: Text(
                            model.fulfillmentStatus.contains("PROCESSING")? "Label": "Track",
                            style: TextStyle(
                                color: Colors.white
                            ),
                          ),
                        ),
                        flex: 1,
                      ),

                      Container(
                        margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                      ),

                      Visibility(
                        child: Expanded(
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.black54),
                            ),
                            color: Colors.black54,
                            textColor: Colors.white,
                            onPressed: () {
                              Navigator.of(context).pushNamed('/labelview');
                            },
                            child: Text(
                              "Label",
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            ),
                          ),
                          flex: 1,
                        ),
                        visible: !model.fulfillmentStatus.contains("PROCESSING"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
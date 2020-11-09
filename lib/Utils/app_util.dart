library my_prj.AppUtil;

import 'package:huppekeeee/Models/model_order.dart';
import 'package:huppekeeee/Models/model_user.dart';
import 'package:flutter/material.dart';


// Invoice Constant
final String APPTITLE = "Huppekeeee";
final String APPSITEURL = "www.ahhhjoh.nl";
final String APPADDRESS1 = "Vlotlaan 532";
final String APPADDRESS2 = "2681 TX Monster, Zuid-Holland";
final String APPADDRESS3 = "Nederland";
final String APPTAX = "Tax registration ID NL001569325B27";
final String SERVICEEMAIL = "info@ahhhjoh.nl";

String token = 'secret_twUuQZfmfbLC7YWU4suskT47Fzh3gf7b';

final String BASE_URL = "https://app.ecwid.com/api/v3/39694284/";
final String ORDER_URL = BASE_URL + "orders?token=" + token;
final String ORDER_UPDATE = BASE_URL + "orders/";

String postNLKey = 'SKXbh9GFWTNxAdBs8E573f7gjvzvtg8R';
final String POSTNL_URL= "https://api-sandbox.postnl.nl/shipment/";
final String BARCODE_URL = POSTNL_URL + "v1_1/barcode?CustomerCode=NYQJ&CustomerNumber=10738096&Type=3S&Serie=000000000-999999999";
final String TRACKING_URL = POSTNL_URL + "v2/status/barcode/";

final bool isTestMode = true;

OrderModel gSelOrder = OrderModel();
UserModel gUserModel = UserModel();

TextTheme titleTheme = TextTheme(
  // ignore: deprecated_member_use
    title: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold
    )
);

TextStyle orderContent = TextStyle(
    fontWeight: FontWeight.w200,
    fontSize: 14,
);

TextStyle orderPaid = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: Colors.green,
);

TextStyle orderUnpaid = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: Colors.red,
);

TextStyle orderDetailContent = TextStyle(
    fontWeight: FontWeight.w200,
    fontSize: 14,
);

TextStyle orderDetailMedium = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16,
);

TextStyle orderDetailPaid = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: Colors.green,
);

TextStyle orderDetailUnpaid = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: Colors.red,
);

TextStyle orderDetailPaidUnderL = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: Colors.green,
    decoration: TextDecoration.underline,
);

TextStyle orderDetailUnpaidUnderL = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: Colors.red,
    decoration: TextDecoration.underline,
);

TextStyle orderDetailPaidUnderS = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
    color: Colors.green,
    decoration: TextDecoration.underline,
);

TextStyle orderDetailUnpaidUnderS = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 14,
    color: Colors.red,
    decoration: TextDecoration.underline,
);

import 'package:huppekeeee/Models/model_product.dart';
import 'package:huppekeeee/Utils/app_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'model_person.dart';
import 'package:huppekeeee/Utils/app_util.dart' as AppUtils;

class OrderModel {
  String id = "0";
  String email = "";
  String paymentMethod = "";
  double subtotal = 0.0;
  double total = 0.0;
  String paymentStatus = "";
  String fulfillmentStatus = "";
  String orderComments = "";
  String couponDiscount = '';
  CouponModel couponModel = CouponModel();
  String createDate = "";
  List<ProductModel> items = [];
  PersonModel shippingPerson = new PersonModel();

  OrderModel({this.id, this.email, this.paymentMethod
    , this.subtotal, this.total, this.paymentStatus
    , this.fulfillmentStatus, this.orderComments, this.couponDiscount
    , this.couponModel, this.createDate
    , this.items, this.shippingPerson
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    var dates = json['items'] as List;
    print(dates.toString());
    List<ProductModel> items = dates.map<ProductModel>((jsonData) => ProductModel.fromJson(jsonData)).toList();
    return OrderModel(
        id : json['id'] as String,
        email : json['email'] as String,
        paymentMethod : json['paymentMethod'] as String,
        subtotal : json['subtotal'] as double,
        total : json['total'] as double,
        paymentStatus : json['paymentStatus'] as String,
        fulfillmentStatus : json['fulfillmentStatus'] as String,
        orderComments : json['orderComments'] as String,
        couponDiscount : json['couponDiscount'].toString(),
        couponModel : CouponModel.fromJson(json['discountCoupon']),
        createDate : json['createDate'] as String,
        items: items,
        shippingPerson: PersonModel.fromJson(json['shippingPerson']));
  }
}

class OrderModelUI extends StatelessWidget {
  OrderModel model;

  OrderModelUI({this.model});

  TextStyle getOrderPaymentStyle() {
    if (model.paymentStatus == "PAID") {
      return orderPaid;
    } else {
      return orderUnpaid;
    }
  }

  TextStyle getOrderDeliveryStyle() {
    if (model.fulfillmentStatus == "PROCESSING") {
      return orderUnpaid;
    } else {
      return orderPaid;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Container(
        margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(8, 4, 8, 0),
                    child: Text("# " + model.id + "     € " + model.total.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(8, 4, 8, 0),
                    child: Text("Payment Status : " + model.paymentStatus,
                      style: getOrderPaymentStyle(),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(8, 4, 8, 0),
                    child: Text(model.fulfillmentStatus,
                      style: getOrderDeliveryStyle(),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(8, 4, 8, 0),
                    child: Text("Name : " + model.shippingPerson.name,
                      style: orderContent,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(8, 4, 8, 0),
                    child: Text(model.shippingPerson.street + ", " + model.shippingPerson.city + " " + model.shippingPerson.postalCode,
                      style: orderContent,
                    ),
                  ),
                ],
              ),
            ),

            Column(
              children: [
                Visibility(
                  child: Text(
                    "Send",
                    style: AppUtils.orderDetailPaid,
                  ),
                  visible: (!model.fulfillmentStatus.contains("PROCESSING")),
                )
              ],
            )
          ],
        )
      ),
    );
  }
}

class CouponModel {
  String id = "";
  String name = "";
  String code = "";
  String discountType = "";
  String status = "";
  String discount = "";
  String launchDate = "";
  String usesLimit = "";

  CouponModel({this.id, this.name, this.code
    , this.discountType, this.status, this.discount
    , this.launchDate, this.usesLimit
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return CouponModel();
    }
    return CouponModel(
      id : json['id'].toString(),
      name : json['name'].toString(),
      code : json['code'].toString(),
      discountType : json['discountType'].toString(),
      status : json['status'].toString(),
      discount : json['discount'].toString(),
      launchDate : json['launchDate'].toString(),
      usesLimit : json['usesLimit'].toString(),
    );
  }
}
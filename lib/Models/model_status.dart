
import 'dart:ui';

import 'package:huppekeeee/Models/model_order.dart';
import 'package:flutter/material.dart';

final List<StatusModel> fillStatusList = [
  StatusModel(title: "Awaiting Processing", description: "The default status for all new orders.", titleStyle: fillBlueTitle, descStyle: fillDesc),
  StatusModel(title: "Processing", description: "The order fulfillment has started.", titleStyle: fillOrangeTitle, descStyle: fillDesc),
  StatusModel(title: "Ready For Pickup", description: "The order is ready for the customer pickup at the designated location.", titleStyle: fillGreenTitle, descStyle: fillDesc),
  StatusModel(title: "Shipped", description: "The order has shipped and is on its way to the customer.", titleStyle: fillGreenTitle, descStyle: fillDesc),
  StatusModel(title: "Delivered", description: "The order is delivered to the customer.", titleStyle: fillGrayTitle, descStyle: fillDesc),
  StatusModel(title: "Will Not Deliver", description: "The order will not ship to the customer.", titleStyle: fillGrayTitle, descStyle: fillDesc),
  StatusModel(title: "Returned", description: "The order has been returned.", titleStyle: fillGrayTitle, descStyle: fillDesc),
];

final List<StatusModel> payStatusList = [
  StatusModel(title: "Paid", description: "The payment for the order is received in full.", titleStyle: fillGreenTitle, descStyle: fillDesc),
  StatusModel(title: "Cancelled", description: "The order is cancelled or your payment gateway has failed to charge the customer.", titleStyle: fillGrayTitle, descStyle: fillDesc),
  StatusModel(title: "Awaiting Payment", description: "No funds received - you need to arrange the payment with the customer.", titleStyle: fillOrangeTitle, descStyle: fillDesc),
  StatusModel(title: "Refunded", description: "The payment for the order is refunded in full.", titleStyle: fillGrayTitle, descStyle: fillDesc),
  StatusModel(title: "Partially Refunded", description: "The payment for the order is refunded partially.", titleStyle: fillBlackTitle, descStyle: fillDesc),
];

class StatusModel {

  String title;
  String description;
  TextStyle titleStyle;
  TextStyle descStyle;

  StatusModel({
    this.title, this.description,
    this.titleStyle, this.descStyle
  });

}

class StatusModelUI extends StatelessWidget {
  StatusModel model;
  OrderModel orderModel;

  StatusModelUI({this.model, this.orderModel});

  @override
  Widget build(BuildContext context) {

    var imgCheck = new AssetImage('assets/imgs/ic_check.png');

    return Container(
      padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
        child: Row (
          children:<Widget> [
            Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(model.title,
                      style: model.titleStyle,
                    ),

                    Container(
                      padding: EdgeInsets.fromLTRB(0, 4, 4, 4),
                      child: Text(model.description,
                        style: model.descStyle,
                      ),
                    ),

                    Divider(
                      color: Colors.black,
                    )
                  ],
                )
            ),

            Visibility(
              child: SizedBox(
                  width: 28,
                  height: 28,
                  child: Image (
                    image: imgCheck,
                  )
              ),
              visible: (orderModel.fulfillmentStatus.replaceAll("_", " ").toLowerCase() == model.title.toLowerCase()
                || orderModel.paymentStatus.replaceAll("_", " ").toLowerCase() == model.title.toLowerCase()),
            )
          ],
        )
    );
  }
}

TextStyle fillBlueTitle = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 18,
  color: Color.fromRGBO(0, 89, 210, 1.0),
);

TextStyle fillOrangeTitle = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 18,
  color: Color.fromRGBO(234, 163, 68, 1.0),
);

TextStyle fillGreenTitle = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 18,
  color: Color.fromRGBO(0, 177, 70, 1.0),
);

TextStyle fillGrayTitle = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 18,
  color: Color.fromRGBO(128, 128, 128, 1.0),
);

TextStyle fillBlackTitle = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: 18,
  color: Color.fromRGBO(0, 0, 0, 1.0),
);

TextStyle fillDesc = TextStyle(
  fontWeight: FontWeight.w200,
  fontSize: 14,
  color: Color.fromRGBO(128, 128, 128, 1.0),
);
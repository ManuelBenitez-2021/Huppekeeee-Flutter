
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:huppekeeee/Utils/app_util.dart' as AppUtils;

class ProductModel {
  int id = 0;
  int productId = 0;
  int categoryId = 0;
  double price = 0;
  double productPrice = 0;
  String sku = "000000";
  int quantity = 1;
  int tax = 0;
  String shipping = "";
  int quantityInStock = 1;
  String name = "";
  String nameTranslatedByNL = "";
  String imageUrl = "";
  List<SelectedOption> selectedOptions = [];

  ProductModel({this.id, this.productId, this.categoryId
    , this.price, this.productPrice, this.sku
    , this.quantity, this.tax, this.shipping
    , this.quantityInStock, this.name, this.nameTranslatedByNL
    , this.imageUrl, this.selectedOptions,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    var dates = json['selectedOptions'] as List;
    List<SelectedOption> items = [];
    if (dates != null) items = dates.map<SelectedOption>((jsonData) => SelectedOption.fromJson(jsonData)).toList();
    return ProductModel(
      id : json['id'] as int,
      productId : json['productId'] as int,
      categoryId : json['categoryId'] as int,
      price : json['price'] as double,
      productPrice : json['productPrice'] as double,
      sku : json['sku'] as String,
      quantity : json['quantity'] as int,
      tax : json['tax'] as int,
      shipping : json['shipping'].toString(),
      quantityInStock : json['quantityInStock'] as int,
      name : json['name'] as String,
      nameTranslatedByNL : json['nameTranslated']['nl'] as String,
      imageUrl : json['imageUrl'] as String,
      selectedOptions: items,
    );
  }

}

class SelectedOption {
  String name = "";
  String value = "";
  String type = "";

  SelectedOption({this.name, this.value, this.type});

  factory SelectedOption.fromJson(Map<String, dynamic> json) {
    return SelectedOption(
      name : json['name'] as String,
      value : json['value'] as String,
      type : json['type'] as String,
    );
  }
}

class ProductModelUI extends StatelessWidget {
  ProductModel model;

  ProductModelUI({this.model});
  
  Image onGetProductImage() {
    String imgUrl = model.imageUrl == null? 'imgUrl' : model.imageUrl;
    return Image.network(imgUrl,
      width: double.infinity,
      height: 180,
      fit: BoxFit.cover,
      alignment: Alignment.center,
    );
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
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                width: 60,
                height: 60,
                child: onGetProductImage(),
              ),

              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(8, 4, 8, 0),
                      child: Text(model.nameTranslatedByNL,
                        style: AppUtils.orderDetailMedium,
                      ),
                    ),

                    if (model.selectedOptions.length > 0) Container(
                      padding: EdgeInsets.fromLTRB(8, 4, 8, 0),
                      child: Text(model.selectedOptions[0].value,
                        style: AppUtils.orderDetailUnpaid,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
      ),
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TrackModel {
  String mainbarcode = "";
  String barcode = "";
  String productcode = "";

  TrackAddressModel fromAddress = new TrackAddressModel();
  TrackAddressModel toAddress = new TrackAddressModel();

  TrackItemModel currentTracking = new TrackItemModel();
  List<TrackItemModel> historyTrackings = [];

  TrackModel({this.mainbarcode, this.barcode, this.productcode
    , this.fromAddress, this.toAddress
    , this.currentTracking, this.historyTrackings,
  });

  factory TrackModel.fromJson(Map<String, dynamic> json) {
    var addresJsonArray = json['Address'] as List;
    var trackJsonArray =  json['OldStatus'] as List;
    List<TrackItemModel> trackItems = trackJsonArray.map<TrackItemModel>((jsonData) => TrackItemModel.fromJson(jsonData)).toList();
    return TrackModel(
      mainbarcode : json['MainBarcode'] as String,
      barcode : json['Barcode'] as String,
      productcode : json['ProductCode'] as String,

      fromAddress: TrackAddressModel.fromJson(addresJsonArray[1]),
      toAddress: TrackAddressModel.fromJson(addresJsonArray[0]),

      currentTracking: TrackItemModel.fromJson(json['Status']),
      historyTrackings: trackItems,
    );
  }
}


class TrackAddressModel {
  String city = "";
  String countryCode = "";
  // String name = "";
  String houseNumber = "";
  // String suffix = "";
  String street = "";
  String zipCode = "";

  TrackAddressModel({this.city, this.countryCode
    , this.houseNumber, this.street, this.zipCode,
  });

  factory TrackAddressModel.fromJson(Map<String, dynamic> json) {
    return TrackAddressModel(
      city : json['City'] as String,
      countryCode : json['CountryCode'] as String,
      // name : json['FirstName'] as String,
      houseNumber : json['HouseNumber'] as String,
      // suffix : json['HouseNumberSuffix'] as String,
      street : json['Street'] as String,
      zipCode : json['Zipcode'] as String,
    );
  }
}


class TrackItemModel {
  String timeStamp = "";
  String statusCode = "";
  String statusDescription = "";
  String phaseCode = "";
  String phaseDescription = "";

  TrackItemModel({this.timeStamp, this.statusCode, this.statusDescription
    , this.phaseCode, this.phaseDescription
  });

  factory TrackItemModel.fromJson(Map<String, dynamic> json) {
    return TrackItemModel(
      timeStamp : json['TimeStamp'] as String,
      statusCode : json['StatusCode'] as String,
      statusDescription : json['StatusDescription'] as String,
      phaseCode : json['PhaseCode'] as String,
      phaseDescription : json['PhaseDescription'] as String,
    );
  }
}

class TrackItemUI extends StatelessWidget {

  TrackItemModel model;
  TrackItemUI({this.model});


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        margin: EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
              child: Text("Tracking Date : " + model.timeStamp,
                style: TextStyle(
                  fontSize: 14
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
              child: Text("Status : " + model.statusDescription,
                style: TextStyle(
                    fontSize: 14
                ),
              ),
            ),

            Container(
              padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
              child: Text("Phase : " + model.phaseDescription,
                style: TextStyle(
                    fontSize: 14
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'dart:async';
import 'dart:convert';

import 'package:huppekeeee/Models/model_label.dart';
import 'package:huppekeeee/Models/model_track.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:huppekeeee/Utils/app_util.dart' as AppUtils;
import 'package:progress_hud/progress_hud.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class TrackScreen extends StatefulWidget {
  TrackScreen({this.app});
  final FirebaseApp app;

  @override
  _TrackScreenState createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {

  ProgressHUD progressHUD;

  DatabaseReference _labelRef;
  TrackModel trackModel = TrackModel();

  void generaterTrack() {
    trackModel.mainbarcode = "3SNYQJ383356360";
    trackModel.barcode = "3SNYQJ383356360";
    trackModel.productcode = "002928";

    TrackAddressModel fromAddress = TrackAddressModel();
    fromAddress.city = "Hoek van Holland";
    fromAddress.countryCode = "NL";
    // fromAddress.name = "Karin";
    fromAddress.houseNumber = "161";
    // fromAddress.suffix = "";
    fromAddress.street = "Tasmanweg";
    fromAddress.zipCode = "3151PN";
    trackModel.fromAddress = fromAddress;

    TrackAddressModel toAddress = TrackAddressModel();
    toAddress.city = "Eindhoven";
    toAddress.countryCode = "NL";
    // toAddress.name = "Afran Bressers";
    toAddress.houseNumber = "161";
    // toAddress.suffix = "-18";
    toAddress.street = "Torenallee";
    toAddress.zipCode = "5617BD";
    trackModel.toAddress = toAddress;

    TrackItemModel currentStatus = TrackItemModel();
    currentStatus.timeStamp = "13-10-2020 13:56:26";
    currentStatus.statusCode = "2";
    currentStatus.statusDescription = "Zending in ontvangst genomen";
    currentStatus.phaseCode = "1";
    currentStatus.phaseDescription = "Collectie";
    trackModel.currentTracking = currentStatus;

    TrackItemModel status1 = TrackItemModel();
    status1.timeStamp = "13-10-2020 13:56:26";
    status1.statusCode = "2";
    status1.statusDescription = "Zending in ontvangst genomen";
    status1.phaseCode = "1";
    status1.phaseDescription = "Collectie";

    TrackItemModel status2 = TrackItemModel();
    status2.timeStamp = "12-10-2020 10:59:26";
    status2.statusCode = "99";
    status2.statusDescription = "Niet van toepassing";
    status2.phaseCode = "99";
    status2.phaseDescription = "Niet van toepassing";

    TrackItemModel status3 = TrackItemModel();
    status3.timeStamp = "12-10-2020 10:59:26";
    status3.statusCode = "1";
    status3.statusDescription = "Zending voorgemeld";
    status3.phaseCode = "1";
    status3.phaseDescription = "Collectie";
    trackModel.historyTrackings = [];
    trackModel.historyTrackings.add(status1);
    trackModel.historyTrackings.add(status2);
    trackModel.historyTrackings.add(status3);

    setState(() {  });
  }

  Future getLabel() {
    Timer(
        Duration(milliseconds: 100),
            () =>
            progressHUD.state.show()
    );
    _labelRef.child(AppUtils.gSelOrder.id).once().then((DataSnapshot snapshot) {
      if (snapshot.value != null) {
        LabelModel label = LabelModel(id: snapshot.value['id']
            , regdate: snapshot.value['regdate']
            , uid: snapshot.value['uid']
            , barcode: snapshot.value['barcode']
            , content: snapshot.value['content']);
        getTrack(label);
      } else {
        Fluttertoast.showToast(msg:"The label of this order was not registered in server.");
        if (AppUtils.isTestMode) generaterTrack();
        progressHUD.state.dismiss();
      }
    });
  }

  Future getTrack(LabelModel label) async {
    http.Response response = await http.get(AppUtils.TRACKING_URL + label.barcode + '?detail=true&language=NL&customerCode=NYQJ', headers: {"apikey":AppUtils.postNLKey});
    if(response.body.isNotEmpty) {
      var jsonBody = json.decode(response.body);
      if (jsonBody['CompleteStatus']['Shipment'].toString().isNotEmpty) {
        var jsonTrack = jsonBody['CompleteStatus']['Shipment'];
        trackModel = TrackModel.fromJson(jsonTrack);
      } else {
        Fluttertoast.showToast(msg:"The tracking of this order doesn't find in server.");
        if (AppUtils.isTestMode) generaterTrack();
      }
    } else {
      Fluttertoast.showToast(msg:"The tracking of this order has some problems in server.");
      if (AppUtils.isTestMode) generaterTrack();
    }

    progressHUD.state.dismiss();
    setState(() {  });
  }

  @override
  void initState() {
    super.initState();

    final FirebaseDatabase database = FirebaseDatabase(app: widget.app);
    _labelRef = database.reference().child('labels');

    progressHUD = new ProgressHUD(
      backgroundColor: Colors.black45,
      color: Colors.black,
      containerColor: Colors.white,
      borderRadius: 5.0,
      loading: false,
      text: 'Loading...',
    );

    if (AppUtils.isTestMode) generaterTrack();
    getLabel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Check Track"),
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
          Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Text("Tracking Information",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              if (trackModel != null) Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                            child: Text("Main Barcode : " + trackModel.mainbarcode,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                            child: Text("Product Code : " + trackModel.productcode,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.fromLTRB(8, 12, 8, 0),
                            child: Text("Company Address",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.fromLTRB(12, 8, 8, 0),
                            child: Text(trackModel.fromAddress.street
                                + " " + trackModel.fromAddress.houseNumber
                                + " " + trackModel.fromAddress.city
                                + ", " + trackModel.fromAddress.zipCode
                                + " " + trackModel.fromAddress.countryCode,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.fromLTRB(8, 12, 8, 0),
                            child: Text("Client Address",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.fromLTRB(12, 8, 8, 8),
                            child: Text(trackModel.toAddress.street
                                + " " + trackModel.toAddress.houseNumber
                                + " " + trackModel.toAddress.city
                                + ", " + trackModel.toAddress.zipCode
                                + " " + trackModel.toAddress.countryCode,
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              ),

              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Text("Current Status",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              Container(
                  margin: EdgeInsets.fromLTRB(12, 8, 12, 0),
                  width: double.infinity,
                  child: TrackItemUI(model: trackModel.currentTracking,)
              ),

              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Text("History Status",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: trackModel.historyTrackings == null? 0 : trackModel.historyTrackings.length,
                  itemBuilder: (context, index) {
                    return
                      Container(
                          margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
                          width: double.infinity,
                          child: TrackItemUI(model: trackModel.historyTrackings[index])
                      );
                  },
                ),
              ),
            ],
          ),
          progressHUD,
        ],
      ),
    );
  }

}
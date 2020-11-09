import 'dart:async';
import 'dart:convert';

import 'package:huppekeeee/Models/model_order.dart';
import 'package:huppekeeee/Utils/app_util.dart' as AppUtils;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_hud/progress_hud.dart';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  ProgressHUD progressHUD;
  List<OrderModel> models = [];

  Future getCategoryData() async {
    Timer(
        Duration(milliseconds: 100),
            () =>
            progressHUD.state.show()
    );

    models.clear();
    http.Response response = await http.get(AppUtils.ORDER_URL);
    if(response.body.isNotEmpty) {
      var jsonData = json.decode(response.body);
      var datas = jsonData['items'] as List;
      List<OrderModel> preModels = datas.map<OrderModel>((jsonData) => OrderModel.fromJson(jsonData)).toList();
      for(OrderModel model in preModels) {
        if (model.shippingPerson.name == null) {
          continue;
        }
        models.add(model);
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

    getCategoryData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Huppekeeee'),
        brightness: Brightness.dark,
        backgroundColor: Colors.black87,
        textTheme: AppUtils.titleTheme,
      ),
      body: Stack(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(0, 24, 0, 4),
                  child: Stack(
                    alignment: AlignmentDirectional.topCenter,
                    children: <Widget>[
                      Container(
                        child: Image.asset('assets/imgs/logo.png'),
                        width: 180,
                      ),
                    ],
                  ),
                ),
                Expanded (
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: models.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          AppUtils.gSelOrder = models[index];
                          Navigator.of(context).pushNamed('/order')
                              .then((val)=>val? getCategoryData() : null);
                        },

                        child: OrderModelUI(model: models[index],),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          progressHUD,
        ],
      ),
    );
  }
}

class Choice {
  const Choice({ this.title, this.icon });
  final String title;
  final IconData icon;
}

const List<Choice> choices = <Choice>[
  Choice(title: 'Search', icon: Icons.search),
  Choice(title: 'Cart', icon: Icons.shopping_cart),
  Choice(title: 'Login', icon: Icons.account_circle),
  Choice(title: 'Contact', icon: Icons.contacts),
  Choice(title: 'Meest', icon: Icons.photo_album),
];
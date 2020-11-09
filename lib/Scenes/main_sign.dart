import 'package:huppekeeee/Models/model_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:progress_hud/progress_hud.dart';
import 'package:intl/intl.dart';

import 'package:huppekeeee/Utils/app_util.dart' as AppUtils;

class SignScreen extends StatefulWidget {
  SignScreen({this.app});
  final FirebaseApp app;

  @override
  _SignScreenState createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {

  ProgressHUD progressHUD;
  final myPhone = TextEditingController();

  bool isVerify = false;
  String stringId;
  FirebaseAuth auth = FirebaseAuth.instance;

  DatabaseReference _userRef;

  Future onClickLoginBtn() async {
    String phone = myPhone.text;
    if (phone.length == 0) {
      Fluttertoast.showToast(
        msg: "Your phone number is empty.",
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black54,
      );
      return;
    }

    if (phone == "2096227257" || phone == "2093601301") {
      phone = "+856" + phone;
    } else {
      phone = "+31" + phone;
    }

    progressHUD.state.show();
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (AuthCredential credential) {
        verifyCompleted(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        progressHUD.state.dismiss();
        if (e.code == 'invalid-phone-number') {
          Fluttertoast.showToast(
            msg: "The provided phone number is not valid.",
            textColor: Colors.white,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black54,
          );
        }
      },
      codeSent: (String verificationId, [int resendToken]) {
        progressHUD.state.dismiss();
        stringId = verificationId;
        isVerify = true;
        setState(() { });
      },
      timeout: const Duration(seconds: 60),
      codeAutoRetrievalTimeout: (String verificationId) {
        timeOut(verificationId);
      },
    );
  }

  void verifyCompleted(AuthCredential credential) async {
    await auth.signInWithCredential(credential)
    .whenComplete(() => {
        onMoveNextScene()
    });
  }

  void timeOut(String verificationId) {
    progressHUD.state.dismiss();
  }

  void verifyPin(String pinCode) async {
    progressHUD.state.dismiss();
    AuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: stringId, smsCode: pinCode);
    await auth.signInWithCredential(phoneAuthCredential)
    .whenComplete(() => {
      onMoveNextScene()
    });
  }

  void onMoveNextScene() {
    _userRef.child(auth.currentUser.uid).once().then((DataSnapshot snapshot) {
      if (snapshot.value == null) {
        DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
        UserModel user = UserModel(uid: auth.currentUser.uid, phone: myPhone.text, regdate: dateFormat.format(DateTime.now()), isActivie: false);
        _userRef.child(auth.currentUser.uid).set(user.toJson())
          .whenComplete(() => {
          onCallMainScene(user)
        }).catchError((Object error) => {
          Fluttertoast.showToast(
            msg: error.toString(),
            textColor: Colors.white,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.black54,
          )
        });
      } else {
        print('Connected to second database and read ${snapshot.value}');
        UserModel user = UserModel(uid: snapshot.value['uid']
            , phone: snapshot.value['phone']
            , regdate: snapshot.value['regdate']
            , isActivie: snapshot.value['isActivie']);
        onCallMainScene(user);
      }
    });
  }

  void onCallMainScene(UserModel user) {
    AppUtils.gUserModel = user;
    user.isActivie? Navigator.of(context).pushReplacementNamed('/main'): Navigator.of(context).pushReplacementNamed('/verify');
  }

  void onFailed(String error) {
    Fluttertoast.showToast(msg: error);
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
    _userRef = database.reference().child('users');

    if (auth.currentUser != null) {
      onMoveNextScene();
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myPhone.dispose();
    super.dispose();
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
            padding: EdgeInsets.fromLTRB(20, 24, 20, 4),
            child: Column(
              children: <Widget>[
                Container(
                  child: Center(
                    child: Container(
                      child: Image.asset('assets/imgs/logo.png'),
                      width: 180,
                    ),
                  ),
                ),

                Visibility(
                  child: Column(
                    children: [
                      Container (
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 32),
                        child: TextFormField (
                          controller: myPhone,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Enter your phone number',
                          ),
                          inputFormatters: <TextInputFormatter> [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),

                      SizedBox(
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
                              onClickLoginBtn();
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            ),
                          )
                      ),
                    ],
                  ),
                  visible: !isVerify,
                ),

                Visibility(
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Text(
                          "The Huppekeeee just sent a verification code to " + myPhone.text,
                          style: AppUtils.orderDetailMedium,
                        ),
                      ),

                      Container (
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 32),
                        child: Center(
                          child: OTPTextField(
                            length: 6,
                            width: MediaQuery.of(context).size.width,
                            textFieldAlignment: MainAxisAlignment.spaceAround,
                            fieldWidth: 45,
                            fieldStyle: FieldStyle.underline,
                            style: TextStyle(
                                fontSize: 28
                            ),
                            onCompleted: (pin) {
                              verifyPin(pin);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  visible: isVerify,
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
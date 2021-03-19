import 'package:flutter/material.dart';
import 'package:carbon_emission/services/calculations.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carbon_emission/models/user.dart';
import 'package:carbon_emission/screens/MainScreen.dart';

class LPG extends StatefulWidget {
  @override
  _LPG createState() => _LPG();
  static const routeName = '/LPGScreen';
}

class _LPG extends State<LPG> {
  final databaseReference = Firestore.instance;
  var numCylinders = 0.00;
  var familySize = 1.00;
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    Future<void> calculateCarbon_4() async {
      var doc = await databaseReference
          .collection("users")
          .document(user.email_id)
          .collection("activities")
          .document("Natural Gas")
          .get();

      double carbonEmitted = lpgCalc(numCylinders);
      String carbonMonth =
          double.parse((doc['totalCarbonEmissionThisMonth']).toStringAsFixed(2))
              .toString();

      await databaseReference
          .collection("users")
          .document(user.email_id)
          .collection("activities")
          .document("Natural Gas")
          .updateData({
        'totalCarbonEmissionToday':
            doc['totalCarbonEmissionToday'] + carbonEmitted,
        'totalCarbonEmissionThisMonth':
            doc['totalCarbonEmissionThisMonth'] + carbonEmitted,
        'lastCheckedAt': DateTime.now(),
      });

      await databaseReference
          .collection("users")
          .document(user.email_id)
          .updateData({
        'totalCarbonEmissionToday':
            user.total_carbon_emission_today + carbonEmitted,
        'totalCarbonEmissionThisMonth':
            user.total_carbon_emission_this_month + carbonEmitted,
      });

      double month = user.total_carbon_emission_this_month;
      user.total_carbon_emission_this_month = month + carbonEmitted;
      double today = user.total_carbon_emission_today;
      user.total_carbon_emission_today = today + carbonEmitted;
      Navigator.of(context).pushNamed(MainScreen.routeName);
    }

    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xff281627),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: _height * 0.04,
          ),
          Container(
            padding: EdgeInsets.all(8),
            margin:
                EdgeInsets.only(bottom: _height * 0.03, right: _width * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
                Icon(
                  Icons.account_circle_rounded,
                  color: Colors.white,
                  size: 35,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: _width * 0.05),
            margin: EdgeInsets.only(left: 14, bottom: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: RichText(
                  text: TextSpan(
                      text: "LPG",
                      style: TextStyle(color: Colors.white, fontSize: 25))),
            ),
          ),
          SizedBox(
            height: _height * 0.01,
          ),
          Container(
            width: _width * 0.9,
            padding: EdgeInsets.fromLTRB(_width * 0.01495, _height * 0.01495,
                _width * 0.01495, _height * 0.01495),
            margin: EdgeInsets.fromLTRB(_width * 0.02, 0, _width * 0.02, 0),
            decoration: BoxDecoration(
                borderRadius: new BorderRadius.circular(10),
                color: Colors.white),
            child: Row(
              children: <Widget>[
                Container(
                  margin:
                      EdgeInsets.fromLTRB(_width * 0.03, _height * 0.02, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RichText(
                          text: TextSpan(
                              text: "Weekly Carbon Footprint",
                              style: TextStyle(
                                  fontSize: 15, color: Color(0xff281627)))),
                      SizedBox(
                        height: _height * 0.01,
                      ),
                      RichText(
                          text: TextSpan(
                              text: "241 Kg",
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Color(0xff281627),
                                  fontWeight: FontWeight.w900))),
                    ],
                  ),
                ),
                Spacer(),
                Image(
                  width: _width * 0.26,
                  height: _height * 0.12,
                  image: AssetImage('assets/Natural gas.png'),
                ),
                SizedBox(width: _width * 0.02)
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: _width,
              padding: EdgeInsets.all(20),
              //   height: _height*0.53,
              decoration: BoxDecoration(
                  borderRadius: new BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30)),
                  color: Colors.white),
              margin: EdgeInsets.fromLTRB(0, _height * 0.04, 0, 0),

              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Number of cylinders used per month",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: _height * 0.03,
                    ),
                    Container(
                      width: _width * 0.8,
                      height: _height * 0.07,
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(10),
                        color: const Color(0xff281627),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Row(children: [
                          Text(
                            "0",
                            style: TextStyle(color: Colors.white),
                          ),
                          Expanded(
                            child: SliderTheme(
                              data: SliderThemeData(
                                //  activeTrackColor: Colors.red[700],
                                inactiveTrackColor: const Color(0xff281627),
                                trackShape: RoundedRectSliderTrackShape(),
                                trackHeight: 10.0,
                                thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 12.0),
                                thumbColor: const Color(0xffFEBB46),
                                overlayColor: Colors.black,
                                overlayShape: RoundSliderOverlayShape(
                                    overlayRadius: 28.0),
                                tickMarkShape: RoundSliderTickMarkShape(),
                                activeTickMarkColor: Colors.white,
                                inactiveTickMarkColor: Colors.white,
                                valueIndicatorShape:
                                    PaddleSliderValueIndicatorShape(),
                                valueIndicatorColor: Colors.redAccent,
                                valueIndicatorTextStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              child: Slider(
                                label: "$numCylinders",
                                value: numCylinders,
                                min: 0,
                                max: 10,
                                divisions: 10,
                                activeColor: const Color(0xffFEBB46),
                                onChanged: (double value) {
                                  setState(() {
                                    numCylinders = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          Text(
                            "10",
                            style: TextStyle(color: Colors.white),
                          ),
                        ]),
                      ),
                    ),
                    SizedBox(height: _height * 0.02),
                    new Divider(
                      color: Colors.grey,
                    ),
                    SizedBox(height: _height * 0.02),
                    Text("Number Of People In Your Family",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: _height * 0.03,
                    ),
                    Container(
                      width: _width * 0.8,
                      height: _height * 0.07,
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(10),
                        color: const Color(0xff281627),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Row(children: [
                          Text(
                            "0",
                            style: TextStyle(color: Colors.white),
                          ),
                          Expanded(
                            child: SliderTheme(
                              data: SliderThemeData(
                                //  activeTrackColor: Colors.red[700],
                                inactiveTrackColor: const Color(0xff281627),
                                trackShape: RoundedRectSliderTrackShape(),
                                trackHeight: 10.0,
                                thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 12.0),
                                thumbColor: const Color(0xffFEBB46),
                                overlayColor: Colors.black,
                                overlayShape: RoundSliderOverlayShape(
                                    overlayRadius: 28.0),
                                tickMarkShape: RoundSliderTickMarkShape(),
                                activeTickMarkColor: Colors.white,
                                inactiveTickMarkColor: Colors.white,
                                valueIndicatorShape:
                                    PaddleSliderValueIndicatorShape(),
                                valueIndicatorColor: Colors.redAccent,
                                valueIndicatorTextStyle: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              child: Slider(
                                label: "$familySize",
                                value: familySize,
                                min: 1,
                                max: 10,
                                divisions: 10,
                                activeColor: const Color(0xffFEBB46),
                                onChanged: (double value) {
                                  setState(() {
                                    familySize = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          Text(
                            "10",
                            style: TextStyle(color: Colors.white),
                          ),
                        ]),
                      ),
                    ),
                    SizedBox(height: _height * 0.02),
                    new Divider(
                      color: Colors.grey,
                    ),
                    SizedBox(height: _height * 0.02),
                    Padding(
                      padding: EdgeInsets.only(left: 40, right: 40),
                      child: RaisedButton(
                        onPressed: () {
                          calculateCarbon_4();
                        },
                        color: Color(0xffA663C6),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        child: Center(
                          child: Text(
                            "SUBMIT",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'dart:ui';

import 'package:carbon_emission/models/user.dart';
import 'package:carbon_emission/screens/Profile.dart';
import 'package:carbon_emission/screens/chooseNewActivity.dart';
import 'package:carbon_emission/widget/badge.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:carbon_emission/services/calculations.dart';

class DashBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
    double compareMonth = compareFromLastMonth(
        user.total_carbon_emission_this_month,
        user.total_carbon_emission_last_month);
    double ans1 = double.parse((compareMonth).toStringAsFixed(2));
    double compareDay = compareFromYesterday(
        user.total_carbon_emission_today, user.total_carbon_emission_yesterday);
    double ans2 = double.parse((compareDay).toStringAsFixed(2));
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    String userName = user.name;
    if (userName == null) {
      userName = "Test";
    }
    if (userName.length > 18) {
      userName = userName.substring(0, 18) + '...';
    }

    return Padding(
        padding: const EdgeInsets.only(
          top: 40,
          left: 35,
          right: 35,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "$userName",
                    style: TextStyle(color: Colors.white, fontSize: 27),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(Profile.routeName);
                    },
                    child: Icon(
                      Icons.account_circle_outlined,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Your carbon emission is going well\n ",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
              Row(children: user.batchesEarned.map((e) => Badge(e)).toList()),
              SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    showLabels: false,
                    showTicks: false,
                    startAngle: 180,
                    endAngle: 0,
                    radiusFactor: 0.8,
                    canScaleToFit: true,
                    axisLineStyle: AxisLineStyle(
                      thickness: 0.1,
                      color: Colors.white,
                      thicknessUnit: GaugeSizeUnit.factor,
                      cornerStyle: CornerStyle.startCurve,
                    ),
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        positionFactor: 0.1,
                        angle: 90,
                        widget: Column(
                          children: [
                            SizedBox(
                              height: 75,
                            ),
                            Text(
                              user.total_carbon_emission_this_month
                                      .toInt()
                                      .toString() +
                                  " Kg",
                              style: TextStyle(
                                  color: const Color(0xffFEBB46), fontSize: 30),
                            ),
                            Text("of CO2 has been emitted this",
                                style: TextStyle(
                                    color: const Color(0xffFEBB46),
                                    fontSize: 14)),
                            Text("month ",
                                style: TextStyle(
                                    color: const Color(0xffFEBB46),
                                    fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                    pointers: <GaugePointer>[
                      RangePointer(
                          color: const Color(0xffFEBB46),
                          value: 70,
                          width: 0.1,
                          sizeUnit: GaugeSizeUnit.factor,
                          cornerStyle: CornerStyle.bothCurve)
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        ans1.toString() + "%",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "CO2 this",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "month",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 35,
                  ),
                  Container(
                    height: 55,
                    width: 2,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 35,
                  ),
                  Column(
                    children: [
                      Text(
                        ans2.toString() + "%",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "CO2 from",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "yesterday",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "We have a single mission: to protect and",
                style: TextStyle(color: const Color(0xffFEBB46), fontSize: 14),
              ),
              Text(
                "hand on the planet to the next",
                style: TextStyle(color: const Color(0xffFEBB46), fontSize: 14),
              ),
              Text(
                "generation",
                style: TextStyle(color: const Color(0xffFEBB46), fontSize: 14),
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                textColor: Colors.white,
                color: const Color(0xffA663C6),
                child: Container(
                  width: width * 0.4,
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      Text(
                        " Add CO2 sources",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(chooseNewActivity.routeName);
                },
                shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
              ),
            ],
          ),
        ));
  }
}

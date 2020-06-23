import 'package:flutter/material.dart';
import 'package:finance_manager/widgets/SavingsGoalWidget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Color background = Color(0xFF086972);
  Color textColor = Color(0xFF01A9B4);
  Color accent = Color(0xFF87DFD6);
  Color addOns = Color(0xFFFBFD8A);

  List<SavingsGoalWidget> goals = [
    SavingsGoalWidget(
      tileColor: Colors.red,
      title: "Samochód",
      saved: 57,
      goal: 20000,
    ),
    SavingsGoalWidget(
      tileColor: Colors.orange,
      title: "Studia semestr",
      saved: 475.04,
      goal: 7000,
    ),
    SavingsGoalWidget(
      tileColor: Colors.green,
      title: "Hipoteka",
      saved: 195.93,
      goal: 500000,
    ),
    SavingsGoalWidget(
      tileColor: Colors.white,
      title: "iMac",
      saved: 200,
      goal: 7000,
    ),
    SavingsGoalWidget(
      tileColor: Colors.brown,
      title: "Emerytura",
      saved: 38,
      goal: 1000000,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: MediaQuery.of(context).size.width - 80,
                      width: MediaQuery.of(context).size.width - 80,
                      decoration: BoxDecoration(
                          border: Border.all(color: textColor),
                          shape: BoxShape.circle),
                      child: Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Wszystkie środki",
                            style: TextStyle(fontSize: 30, color: textColor),
                          ),
                          Text(
                            "1000,00 pln",
                            style: TextStyle(fontSize: 30, color: textColor),
                          )
                        ],
                      )),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () {},
                    child: Icon(
                      Icons.remove,
                      color: addOns,
                    ),
                    shape: CircleBorder(),
                    color: accent,
                  ),
                  FlatButton(
                    onPressed: () {},
                    child: Icon(
                      Icons.add,
                      color: addOns,
                    ),
                    shape: CircleBorder(),
                    color: accent,
                  ),
                ],
              ),
              Column(
                children: goals,
              ),
              FlatButton(
                onPressed: () {},
                child: Icon(
                  Icons.add,
                  color: addOns,
                ),
                shape: CircleBorder(),
                color: accent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

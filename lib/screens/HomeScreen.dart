import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Color background = Color(0xFF086972);
  Color textColor = Color(0xFF01A9B4);
  Color accent = Color(0xFF87DFD6);
  Color addOns = Color(0xFFFBFD8A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SingleChildScrollView(
        child: SafeArea(
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
              children: <Widget>[
                SavingsGoalWidget(textColor: textColor),
              ],
            ),
          ],
        )),
      ),
    );
  }
}

class SavingsGoalWidget extends StatelessWidget {
  const SavingsGoalWidget({
    Key key,
    @required this.textColor,
  }) : super(key: key);

  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.red),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Samochód",
                    style: TextStyle(color: Colors.red),
                  ),
                  Text(
                    "20 / 20000",
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: LinearProgressIndicator(
                backgroundColor: textColor,
                value: 0.1,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:finance_manager/widgets/SavingsGoalWidget.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Color background = Color(0xFF086972);
  Color textColor = Color(0xFF01A9B4);
  Color accent = Color(0xFF87DFD6);
  Color addOns = Color(0xFFFBFD8A);

  double amount;

  _displayAddSavingsDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Dodaj kwotę wolnych środków'),
            content: TextField(
              keyboardType: TextInputType.numberWithOptions(),
              onChanged: (input) {
                setState(() {
                  amount = double.parse(input);
                });
              },
              decoration: InputDecoration(hintText: "Podaj kwotę"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Zatwierdź'),
                onPressed: () {
                  freeMoney = freeMoney + amount;
                  loadData();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  _displayRemoveSavingsDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Usuń kwotę z wolnych środków'),
            content: TextField(
              keyboardType: TextInputType.numberWithOptions(),
              onChanged: (input) {
                setState(() {
                  amount = double.parse(input);
                });
              },
              decoration: InputDecoration(hintText: "Podaj kwotę"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Zatwierdź'),
                onPressed: () {
                  setState(() {
                    if (amount > freeMoney) {
                      freeMoney = 0;
                    } else {
                      freeMoney = freeMoney - amount;
                    }
                  });
                  loadData();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

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

  List<PieChartSectionData> _sections = List<PieChartSectionData>();
  double allSavings;
  double freeMoney = 100.00;

  void loadData() {
    setState(() {
      _sections = [];
      allSavings = 0;
      allSavings = allSavings + freeMoney;
      for (SavingsGoalWidget goal in goals) {
        allSavings = allSavings + goal.saved;
      }

      _sections.add(new PieChartSectionData(
          color: textColor,
          value: (freeMoney / allSavings) * 100,
          title: "Wolne",
          titleStyle: TextStyle(
              color: textColor.computeLuminance() > 0.5
                  ? Colors.black
                  : Colors.white),
          radius: 50));
      for (SavingsGoalWidget goal in goals) {
        _sections.add(
          new PieChartSectionData(
              color: goal.tileColor,
              value: (goal.saved / allSavings) * 100,
              title: goal.title,
              titleStyle: TextStyle(
                  color: goal.tileColor.computeLuminance() > 0.5
                      ? Colors.black
                      : Colors.white),
              radius: 50),
        );
      }
    });
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

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
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: PieChart(
                          PieChartData(
                              sections: _sections,
                              borderData: FlBorderData(show: false),
                              sectionsSpace: 0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                "${allSavings.toStringAsFixed(2)} zł",
                style: TextStyle(color: textColor, fontSize: 35),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () => _displayRemoveSavingsDialog(context),
                    child: Icon(
                      Icons.remove,
                      color: addOns,
                    ),
                    shape: CircleBorder(),
                    color: accent,
                  ),
                  FlatButton(
                    onPressed: () => _displayAddSavingsDialog(context),
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

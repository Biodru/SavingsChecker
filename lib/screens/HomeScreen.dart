import 'package:flutter/material.dart';
import 'package:finance_manager/widgets/SavingsGoalWidget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:finance_manager/supporting/DataBaseHandler.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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

  bool _loading = true;

  //Nowy obiekt
  Color tileColor = Color(0xFF086972);
  String title;
  String info;
  String history;
  double saved;
  double goal;
  void changeColor(Color color) => setState(() => tileColor = color);

  _displayAddNewDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Zmień co chcesz'),
            content: Column(
              children: <Widget>[
                Text("Tytuł"),
                TextField(
                  keyboardType: TextInputType.numberWithOptions(),
                  onChanged: (input) {
                    setState(() {
                      title = input;
                    });
                  },
                  decoration: InputDecoration(hintText: "Podaj nowy tytuł"),
                ),
                Text("Oszczędności"),
                TextField(
                  keyboardType: TextInputType.numberWithOptions(),
                  onChanged: (input) {
                    setState(() {
                      amount = double.parse(input);
                    });
                  },
                  decoration:
                      InputDecoration(hintText: "Podaj nowe oszczędności"),
                ),
                Text("Cel"),
                TextField(
                  keyboardType: TextInputType.numberWithOptions(),
                  onChanged: (input) {
                    setState(() {
                      goal = double.parse(input);
                    });
                  },
                  decoration: InputDecoration(hintText: "Podaj nowy tytuł"),
                ),
                FlatButton(
                    child: Text('Kolor'),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Wybierz kolor'),
                            content: SingleChildScrollView(
                              child: BlockPicker(
                                pickerColor: tileColor,
                                onColorChanged: changeColor,
                              ),
                            ),
                          );
                        },
                      );
                    })
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  child: new Text('Zatwierdź'),
                  onPressed: () {
                    if (title != null && title != "") {
                      title = title;
                    }
                    if (amount != null && amount != 0) {
                      saved = amount;
                    }
                    if (goal != null && goal != 0) {
                      goal = goal;
                    }
                    DataBaseHandler.instance.insert({
                      DataBaseHandler.title: title,
                      DataBaseHandler.tileColor: tileColor.value,
                      DataBaseHandler.saved: saved,
                      DataBaseHandler.goal: goal
                    });
                    loadData();
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

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

  List<SavingsGoalWidget> goals = [];

  List<PieChartSectionData> _sections = List<PieChartSectionData>();
  double allSavings;
  double freeMoney;

  void loadData() async {
    setState(() async {
      _sections = [];
      allSavings = 0;
      List<Map<String, dynamic>> queryRows =
          await DataBaseHandler.instance.queryAll();
      for (dynamic query in queryRows) {
        goals.add(SavingsGoalWidget(
            title: query[DataBaseHandler.title],
            tileColor: Color(query[DataBaseHandler.tileColor]),
            saved: query[DataBaseHandler.saved],
            goal: query[DataBaseHandler.goal],
            history: query[DataBaseHandler.history],
            info: query[DataBaseHandler.info]));
      }
      for (SavingsGoalWidget goalie in goals) {
        allSavings = allSavings + goalie.saved;
      }

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
      _loading = false;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });

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
              _loading
                  ? Text("Ładowanie")
                  : Row(
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
              _loading
                  ? Text("Ładowanie")
                  : Text(
                      "${allSavings.toStringAsFixed(2)} zł",
                      style: TextStyle(color: textColor, fontSize: 35),
                    ),
              _loading
                  ? Text("Ładowanie")
                  : Row(
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
              _loading
                  ? Text("Ładowanie")
                  : Column(
                      children: goals,
                    ),
              FlatButton(
                onPressed: () => _displayAddNewDialog(context),
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

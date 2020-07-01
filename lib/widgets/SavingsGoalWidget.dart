import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:finance_manager/supporting/DataBaseHandler.dart';
import 'package:finance_manager/screens/HomeScreen.dart';

class SavingsGoalWidget extends StatefulWidget {
  SavingsGoalWidget(
      {Key key,
      this.tileColor,
      this.title,
      this.saved,
      this.goal,
      this.history,
      this.info,
      this.id})
      : super(key: key);

  Color tileColor;
  String title;
  String info;
  String history;
  double saved;
  double goal;
  int id;

  @override
  _SavingsGoalWidgetState createState() => _SavingsGoalWidgetState();
}

class _SavingsGoalWidgetState extends State<SavingsGoalWidget> {
  bool clicked = false;
  double amount;
  String title;
  double goal;
  String info;
  bool updateTitle = false;
  void changeColor(Color color) =>
      setState(() => this.widget.tileColor = color);

  _displayAddSavingsDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Dodaj kwotę'),
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
                  addSavings(amount);
                  Navigator.of(context).pushReplacementNamed(HomeScreen.id);
                },
              )
            ],
          );
        });
  }

  _displayChangessDialog(BuildContext context) async {
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
                Text("Informacje"),
                TextField(
                  onChanged: (input) {
                    setState(() {
                      info = input;
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
                                pickerColor: this.widget.tileColor,
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
                  onPressed: () async {
                    if (title != null && title != "") {
                      this.widget.title = title;
                      await DataBaseHandler.instance.update(
                          {DataBaseHandler.title: this.widget.title},
                          this.widget.id);
                    }
                    if (info != null && info != "") {
                      this.widget.info = info;
                      await DataBaseHandler.instance.update(
                          {DataBaseHandler.info: this.widget.info},
                          this.widget.id);
                    }
                    if (amount != null && amount != 0) {
                      this.widget.saved = amount;
                      await DataBaseHandler.instance.update(
                          {DataBaseHandler.saved: this.widget.saved},
                          this.widget.id);
                    }
                    if (goal != null && goal != 0) {
                      await DataBaseHandler.instance.update(
                          {DataBaseHandler.goal: this.widget.goal},
                          this.widget.id);
                      this.widget.goal = goal;
                    }
                    await DataBaseHandler.instance.update({
                      DataBaseHandler.tileColor: this.widget.tileColor.value
                    }, this.widget.id);
                    this.widget.goal = goal;
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  _displayRemoveSavingsDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Usuń kwotę'),
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
                  Navigator.of(context).pushReplacementNamed(HomeScreen.id);
                },
              )
            ],
          );
        });
  }

  void setTileColor(Color newColor) {
    this.widget.tileColor = newColor;
  }

  void setSavings(double newSavings) {
    this.widget.saved = newSavings;
  }

  void addSavings(double addedAmount) async {
    this.widget.saved = this.widget.saved + addedAmount;
    this.widget.history = this.widget.history + 'Zasilenie: $addedAmount \n';
    await DataBaseHandler.instance.update({
      DataBaseHandler.saved: this.widget.saved,
      DataBaseHandler.history: this.widget.history,
    }, this.widget.id);
  }

  void removeSavings(double removedAmount) async {
    if (removedAmount > this.widget.saved) {
      this.widget.saved = 0;
    } else {
      this.widget.saved = this.widget.saved - removedAmount;
    }
    this.widget.history =
        this.widget.history + 'Obciążenie: -$removedAmount \n';
    await DataBaseHandler.instance.update({
      DataBaseHandler.saved: this.widget.saved,
      DataBaseHandler.history: this.widget.history
    }, this.widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            clicked = !clicked;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: this.widget.tileColor),
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
                      widget.title,
                      style: TextStyle(color: this.widget.tileColor),
                    ),
                    Text(
                      widget.saved == null || widget.goal == null
                          ? 'Ładowanie'
                          : "${widget.saved.toStringAsFixed(2)} / ${widget.goal.toStringAsFixed(2)}",
                      style: TextStyle(color: this.widget.tileColor),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: LinearProgressIndicator(
                  //TODO: Zmienić hardcoded color na motyw
                  backgroundColor: Color(0xFF01A9B4),
                  value: (widget.saved / widget.goal),
                  valueColor:
                      AlwaysStoppedAnimation<Color>(this.widget.tileColor),
                ),
              ),
              clicked
                  ? Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            FlatButton(
                              onPressed: () {
                                _displayRemoveSavingsDialog(context);
                              },
                              child: Icon(
                                Icons.remove,
                                color: this.widget.tileColor,
                              ),
                              shape: CircleBorder(),
                              color: Color(0xFF01A9B4),
                            ),
                            FlatButton(
                              onPressed: () async {
                                await _displayChangessDialog(context);
                              },
                              child: Icon(
                                Icons.menu,
                                color: this.widget.tileColor,
                              ),
                              shape: CircleBorder(),
                              color: Color(0xFF01A9B4),
                            ),
                            FlatButton(
                              onPressed: () =>
                                  _displayAddSavingsDialog(context),
                              child: Icon(
                                Icons.add,
                                color: this.widget.tileColor,
                              ),
                              shape: CircleBorder(),
                              color: Color(0xFF01A9B4),
                            ),
                          ],
                        ),
                        Text(
                          this.widget.info == null
                              ? 'Brak informacji'
                              : this.widget.info,
                          style: TextStyle(color: this.widget.tileColor),
                        ),
                        Text(
                          this.widget.history == null
                              ? 'Brak historii'
                              : this.widget.history,
                          style: TextStyle(color: this.widget.tileColor),
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

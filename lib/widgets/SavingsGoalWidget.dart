import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class SavingsGoalWidget extends StatefulWidget {
  SavingsGoalWidget(
      {Key key,
      this.tileColor,
      this.title,
      this.saved,
      this.goal,
      this.history,
      this.info})
      : super(key: key);

  Color tileColor;
  String title;
  String info;
  String history;
  double saved;
  double goal;

  @override
  _SavingsGoalWidgetState createState() => _SavingsGoalWidgetState();
}

class _SavingsGoalWidgetState extends State<SavingsGoalWidget> {
  bool clicked = false;
  double amount;
  String title;
  double goal;
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
                  Navigator.of(context).pop();
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
                  onPressed: () {
                    if (title != null && title != "") {
                      this.widget.title = title;
                    }
                    if (amount != null && amount != 0) {
                      this.widget.saved = amount;
                    }
                    if (goal != null && goal != 0) {
                      this.widget.goal = goal;
                    }
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
                  removeSavings(double.parse(input));
                });
              },
              decoration: InputDecoration(hintText: "Podaj kwotę"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Zatwierdź'),
                onPressed: () {
                  Navigator.of(context).pop();
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

  void addSavings(double addedAmount) {
    this.widget.saved = this.widget.saved + addedAmount;
  }

  void removeSavings(double removedAmount) {
    if (removedAmount > this.widget.saved) {
      this.widget.saved = 0;
    } else {
      this.widget.saved = this.widget.saved - removedAmount;
    }
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
                      "${widget.saved.toStringAsFixed(2)} / ${widget.goal.toStringAsFixed(2)}",
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
                  ? Row(
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
                          onPressed: () => _displayChangessDialog(context),
                          child: Icon(
                            Icons.menu,
                            color: this.widget.tileColor,
                          ),
                          shape: CircleBorder(),
                          color: Color(0xFF01A9B4),
                        ),
                        FlatButton(
                          onPressed: () => _displayAddSavingsDialog(context),
                          child: Icon(
                            Icons.add,
                            color: this.widget.tileColor,
                          ),
                          shape: CircleBorder(),
                          color: Color(0xFF01A9B4),
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

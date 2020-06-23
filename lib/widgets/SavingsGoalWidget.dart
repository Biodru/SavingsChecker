import 'package:flutter/material.dart';

class SavingsGoalWidget extends StatefulWidget {
  SavingsGoalWidget({
    Key key,
    this.tileColor,
    this.title,
    this.saved,
    this.goal,
  }) : super(key: key);

  Color tileColor;
  final String title;
  double saved;
  final double goal;

  @override
  _SavingsGoalWidgetState createState() => _SavingsGoalWidgetState();
}

class _SavingsGoalWidgetState extends State<SavingsGoalWidget> {
  bool clicked = false;

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
                  addSavings(double.parse(input));
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
                      "${widget.saved} / ${widget.goal}",
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

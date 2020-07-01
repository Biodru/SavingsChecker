import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Text('Wyślij mi maila ze wskazówkami'),
              FlatButton(
                onPressed: () {
                  _launchURL("mailto:piotr.brus998@gmail.com");
                },
                child: Text('Otwórz maila'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

import 'package:flutter/material.dart';

class SomethingWrongScreen extends StatefulWidget {
  SomethingWrongScreen({Key? key}) : super(key: key);

  @override
  _SomethingWrongScreenState createState() => _SomethingWrongScreenState();
}

class _SomethingWrongScreenState extends State<SomethingWrongScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                    "Please make sure you are connected to the internet!",
                    style: TextStyle(fontSize: 25),
                    textAlign: TextAlign.center)),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.15,
            left: MediaQuery.of(context).size.width * 0.2,
            right: MediaQuery.of(context).size.width * 0.2,
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 255, 192, 98)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50))),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => new AlertDialog(
                    title: new Text("Error"),
                    content:
                        new Text("The file you are looking for is not here..."),
                    actions: <Widget>[
                      TextButton(
                        child: Text('Close me!'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                );
              },
              child: Text(
                "Go back".toUpperCase(),
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}

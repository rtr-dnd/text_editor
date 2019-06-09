import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(body: MyStack()),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyStack extends StatefulWidget {
  @override
  _MyStackState createState() => _MyStackState();
}

class _MyStackState extends State<MyStack> {
  String _input = "";
  var txtc = new TextEditingController();

  void initState() {
    super.initState();
    _load();
  }

  void _onTyped(String text) {
    _input = text;
    print(_input);
    _save();
  }

  void _save() async {
    Firestore.instance
        .collection('input_data')
        .document('one')
        .setData({'content': _input});
    print('saved!');
  }

  void _load() async {
    setState(() {
      //_input = prefs.getString('input') ?? '';
      Firestore.instance
          .collection('input_data')
          .document('one')
          .get()
          .then((DocumentSnapshot _snapshot) {
        _input = _snapshot.data['content'];
        print(_input);
        txtc.text = _input;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return Scrollbar(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints:
                      BoxConstraints(minHeight: viewportConstraints.maxHeight),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 48, 16, 160),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          minLines: 20,
                          maxLines: null,
                          cursorColor: Color(0xff999999),
                          controller: txtc,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 0, color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 0, color: Colors.white),
                            ),
                            hintText: 'Type something down...',
                          ),
                          onChanged: (text) {
                            _onTyped(text);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        Positioned(
          top: 32,
          right: 0,
          child: IconButton(
            icon: Icon(Icons.more_vert),
            color: Colors.grey,
            onPressed: () {
              _save();
            },
          ),
        )
      ],
    );
  }
}

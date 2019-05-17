import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snacking A-Z',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Snacking A-Z'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static final myController = new TextEditingController();

  List<Widget> _widgetOptions = <Widget>[
    Column(
      children: <Widget>[
        Text(
        'SHOPPING LIST LEADERBOARD',
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
      ),
      ],
    ),
    Column(
      children: <Widget>[
        Text(
          'NOMINATIONS',
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
        new Padding(
            padding: EdgeInsets.only(top: 50.0)
        ),
        TextFormField(
          decoration: new InputDecoration(
            labelText: "Nominate a New Snack",
            fillColor: Colors.white,
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
            ),
          ),
          controller: myController,
        ),
        FloatingActionButton(
          // When the user presses the button, show an alert dialog with the
          // text the user has typed into our text field.
          onPressed: () {
            debugPrint(myController.text);
            myController.text = '';
          },
          tooltip: 'Add Nomination',
          child: Icon(Icons.add_comment),
        ),
      ],
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            _widgetOptions.elementAt(_selectedIndex),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            title: Text('Add Nomination'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

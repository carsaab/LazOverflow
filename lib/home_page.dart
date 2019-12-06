import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LAZ Overflow',
      color: Colors.black,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new HomePage(title: 'LAZ Overflow'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static final FocusNode _nominationsFocus = FocusNode();
  static final myController = new TextEditingController();
  static final db = Firestore.instance;

  List<Widget> _widgetOptions = <Widget>[
    Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('shoppingItem').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text('Loading...');
          }

          var voteTotalFromDocument = (document) {
            final upVotes = document['currentUpVotes'] ?? 0;
            final downVotes = document['currentDownVotes'] ?? 0;
            return upVotes - downVotes;
          };

          snapshot.data.documents.sort((documentA, documentB) =>
              voteTotalFromDocument(documentB) -
              voteTotalFromDocument(documentA));
          final documents = snapshot.data.documents;

          return ListView.builder(
              itemExtent: 80.00,
              itemCount: documents.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final document = documents[index];
                final upVotes = document['currentUpVotes'] ?? 0;
                final downVotes = document['currentDownVotes'] ?? 0;
                debugPrint(upVotes.toString());
                debugPrint(downVotes.toString());
                return Row(children: [
                  IconButton(
                    icon: Icon(Icons.thumb_up),
                    onPressed: () => {
                          document.reference.updateData({
                            'currentUpVotes': FieldValue.increment(1),
                            'historicalUpVotes': FieldValue.increment(1)
                          })
                        },
                  ),
                  IconButton(
                    icon: Icon(Icons.thumb_down),
                    onPressed: () => {
                          document.reference.updateData({
                            'currentDownVotes': FieldValue.increment(1),
                            'hisotricalDownVotes': FieldValue.increment(1)
                          })
                        },
                  ),
                  Text(voteTotalFromDocument(document).toString()),
                  Text(document['name'] ?? "no name provided"),
                ]);
              });
        },
      ),
    ),
    ListView(
      children: <Widget>[
        FractionallySizedBox(
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('requestItem').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Text('Loading...');
              }
              return ListView.builder(
                  itemExtent: 80.00,
                  itemCount: snapshot.data.documents.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final document = snapshot.data.documents[index];
                    final upVotes = document['nominationCount'] ?? 0;
                    debugPrint(upVotes.toString());
                    return Row(children: [
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () => {
                              document.reference.updateData(
                                  {'nominationCount': FieldValue.increment(1)})
                            },
                      ),
                      Text((upVotes).toString()),
                      Text(document['name'] ?? "no name provided"),
                    ]);
                  });
            },
          ),
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
          focusNode: _nominationsFocus,
        ),
        FloatingActionButton(
          onPressed: () {
            addNewNomination();
            myController.text = '';
            _nominationsFocus.unfocus();
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

  static void addNewNomination() {
    var requestItem = {
      "name": myController.text,
      "nominationCount": 0,
      "requestedAt": DateTime.now()
    };

    db.collection('requestItem').add(requestItem);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
              children: <Widget>[_widgetOptions.elementAt(_selectedIndex)])),
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

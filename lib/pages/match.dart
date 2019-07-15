
import 'package:flutter/material.dart';
import 'package:sportive_app/model/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sportive_app/model/match_making.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class OnGoingMatch extends StatefulWidget {
  OnGoingMatch({Key key}) : super(key: key);

  @override
  _OnGoingMatch createState() => _OnGoingMatch();
}

class _OnGoingMatch extends State<OnGoingMatch>{
int _selectedIndex = 1;
void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
  });
}
Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Estás seguro?'),
        content: new Text('Quieres salir del partido'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: (){
              FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
                MatchMakingAlgorithm().deleteUserFromMatch(user.uid,user.displayName);
                });
              Navigator.of(context).pop(true);
            },
            child: new Text('Yes'),
          ),
        ],
      ),
    ) ?? false;
  }

@override
Widget build(BuildContext context) {
var uid;
FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
  uid = user.uid;
});
List<Widget> _widgetOptions = <Widget>[new Text('Chat'),
new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('on_going_matches').where('usersOnMatch',isEqualTo: uid).getDocuments().asStream(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return new ListTile(
                  title:  new Text(document.data.toString())
                );
              }).toList(),
            );
        }
      },
    )];
  return new WillPopScope(
    onWillPop: _onWillPop,
    child: Scaffold(
    appBar: AppBar(
      title: const Text('Sportive',style: TextStyle(color: Colors.black54 ,fontStyle: FontStyle.italic, fontSize:32.0, letterSpacing: 1.5, fontWeight: FontWeight.bold )),
      centerTitle: true,
      leading: new Container()
    ),
    body: Center(
      child: _widgetOptions.elementAt(_selectedIndex),
    ),
    bottomNavigationBar: BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          title: Text('Chat'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_run),
          title: Text('Jugadores'),
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.amber[800],
      onTap: _onItemTapped,
      
    ),
       floatingActionButton: StreamBuilder(
          stream: FirebaseAuth.instance.currentUser().asStream(),
          builder:
              (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
            return FloatingActionButton(
              elevation: 10.0,
              onPressed: () { new AlertDialog(
                title: new Text('Estás seguro?'),
                content: new Text('Deseas salir de la aplicación'),
                actions: <Widget>[
                  new FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: new Text('No'),
                    ),
                  new FlatButton(
                    onPressed: (){
                      Navigator.of(context).pushNamed('login-page');
                      FBApi.signOut();
                      },
                    child: new Text('Yes'),
                    ),
                ],
                );
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(snapshot.data.photoUrl),
                radius: 30.0,
              ),
            );
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat
  ));
}}
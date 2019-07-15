
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sportive_app/model/api.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:sportive_app/model/match_making.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home>{
String _buttonText = '';
int _selectedIndex = 1;

void _setButtonText(String text){
  setState((){
  _buttonText = text;
  });
}

void _onItemTapped(int index) {
  setState(() {
    _selectedIndex = index;
  });
}

Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit the App'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('Yes'),
          ),
        ],
      ),
    ) ?? false;
  }

@override
Widget build(BuildContext context) {

List<Widget> _widgetOptions = <Widget>[new Text('Home'),
  Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
            ButtonTheme(
              minWidth: 200.0,
              height: 100.0,
              child: RaisedButton(
                highlightElevation: 2.0 ,
                elevation: 10.0,
                onPressed: (){
                    new Picker(
                      adapter: NumberPickerAdapter(data: [
                        NumberPickerColumn(begin: 6, end: 24),
                        NumberPickerColumn(begin: 0,end: 0),
                        ]),
                        delimiter: [
                          PickerDelimiter(child: Container(
                            width: 30.0,
                            alignment: Alignment.center,
                            child: Icon(Icons.more_vert),
                            ))
                            ],
                            hideHeader: true,
                            title: new Text("Selecciona la hora del partido"),
                            onConfirm: (Picker picker, List value) {
                              _setButtonText('Buscando...');
                              FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
                                  MatchMakingAlgorithm().searchForExistingMatch('Temuco',user.displayName,user.uid,picker.getSelectedValues()[0],context);
                                  });}
                              ).showDialog(context);
                  },
                child: Text(_buttonText = 'Buscar Partido', style: TextStyle(fontSize: 45,fontStyle: FontStyle.italic , color: Colors.black54)),
                shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50.0)),
                ),
            )
            ],
          ),
        ),
new Text('Historial')];
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
          icon: Icon(Icons.person),
          title: Text('Perfil'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_run),
          title: Text('Jugar'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          title: Text('Historial'),
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
  ),
  );



}
}
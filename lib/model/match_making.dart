import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MatchMakingAlgorithm{

searchForExistingMatch(String city,String name,String uid,int hour,BuildContext context)async{
Firestore.instance.collection('on_going_matches')
.where('userSlot',isGreaterThan: 0)
.where('matchTime',isEqualTo: hour)
.where('city',isEqualTo: city)
.getDocuments().then((QuerySnapshot data){
  if(data.documents.length > 0){
 // addUser(name, uid, data, context);
  }
  else
  createNewMatch(city, name, uid, hour, context);
});}

createNewMatch(String city,String name,String uid,int hour,BuildContext context)async{
var documentref = Firestore.instance.collection("on_going_matches").document();
Firestore.instance.runTransaction((transaction) async {
  await transaction.set(documentref, {
    'userSlot': 13,
    'matchTime': hour,
    'city': city,
    });
    addUserOnMatchCollection(documentref.documentID,uid,name);});
    Navigator.of(context).pushNamed('on-going-match');
}

addUserToExistingMatch(String name,String uid,QuerySnapshot data,BuildContext context)async{
    Navigator.of(context).pushNamed('on-going-match');
    Firestore.instance.collection("on_going_matches").document(data.documents[0].documentID).setData({
    'userSlot': data.documents[0]['userSlot'] - 1,
    'usersOnMatch': {uid:{'Name':name}},
    'usersName': {name:''}
    },merge: true);
}

deleteUserFromMatch(String uid,String name)async{
Firestore.instance.collection('on_going_matches')
.where('usersOnMatch.' + uid + '.Name', isEqualTo: name)
.getDocuments().then((QuerySnapshot data){
  if(data.documents.length > 0){
    if(data.documents[0]['userSlot'] == 13)
    Firestore.instance.collection("on_going_matches").document(data.documents[0].documentID).delete();
    else
    Firestore.instance.runTransaction((transaction) async {
      await transaction.update(Firestore.instance.collection("on_going_matches").document(data.documents[0].documentID), {
      'userSlot': data.documents[0]['userSlot'] + 1,
      'usersOnMatch.' + uid: FieldValue.delete(),
      'usersName.' + name: FieldValue.delete()
    });});
  }
  else
    print("User not found");
  });
    }

addUserOnMatchCollection(String documentID,String uid,String name)async{
var documentref = Firestore.instance.collection("on_going_matches").document(documentID).collection('usersOnMatch').document(uid);
Firestore.instance.runTransaction((transaction) async {
  await transaction.set(documentref, {
    'Name': name
    });});
  }

}
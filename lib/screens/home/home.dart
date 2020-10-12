import 'dart:convert';
import 'package:sikap/screens/dosen/dosen.dart';
import 'package:sikap/screens/konsultasi/konsultasi.dart';
import 'package:sikap/screens/mahasiswa/mahasiswa.dart';
import 'package:flutter/material.dart';
import 'package:sikap/screens/login/login.dart';
import 'package:sikap/network/rest_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sikap/screens/profil/profil.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String email;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var token;

  @override
  void initState() {
    _loadUserData();
    super.initState();
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));

    if (user != null) {
      setState(() {
        email = user['email'];
      });
    }
  }

  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("Dashboard"),
        backgroundColor: Colors.blueGrey,
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            new Container(
              color: Colors.blueGrey,
              child: UserAccountsDrawerHeader(
                accountName: new Text("SIKAP"),
                accountEmail: new Text("$email"),
                currentAccountPicture: new CircleAvatar(
                  backgroundColor: Colors.blueGrey,
                  backgroundImage: NetworkImage(
                      "https://upload.wikimedia.org/wikipedia/commons/5/55/Logo-unsoed-2017-warna.png"),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profil'),
              onTap: () {
                profil();
              },
            ),
            ListTile(
              leading: Icon(Icons.supervised_user_circle_rounded),
              title: Text('Dosen'),
              onTap: () {
                dosen();
              },
            ),
            ListTile(
              leading: Icon(Icons.supervised_user_circle_rounded),
              title: Text('Mahasiswa'),
              onTap: () {
                mahasiswa();
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Konsultasi'),
              onTap: () {
                konsultasi();
              },
            ),
            ListTile(
              title: Text('Keluar'),
              trailing: Icon(Icons.input),
              onTap: () {
                logout();
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text("Drawer"),
      ),
    );
  }

  void logout() async {
    var res = await Network().getData('/logout');
    var body = json.decode(res.body);
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    }
  }

  void dosen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Dosen()));
  }

  void mahasiswa() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Mahasiswa()));
  }

  void konsultasi() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Konsultasi()));
  }

  void profil() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Profil()));
  }
}

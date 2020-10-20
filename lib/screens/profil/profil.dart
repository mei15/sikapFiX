import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sikap/network/rest_api.dart';
import 'package:sikap/screens/dosen/dosen.dart';
import 'package:sikap/screens/home/home.dart';
import 'package:sikap/screens/konsultasi/konsultasi.dart';
import 'package:sikap/screens/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sikap/screens/mahasiswa/mahasiswa.dart';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  String email;
  String username;
  String first_name;
  String last_name;
  @override
  void initState() {
    _loadUserData();
    super.initState();
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));
    var data = jsonDecode(localStorage.getString('data'));

    if (user != null && data != null) {
      setState(() {
        email = user['email'];
        username = user['username'];
        first_name = data['first_name'];
        last_name = data['last_name'];
      });
    }
  }

  var token;
  var user;
  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    final String imgUrl =
        'https://upload.wikimedia.org/wikipedia/commons/5/55/Logo-unsoed-2017-warna.png';

    return new Stack(
      children: <Widget>[
        new Container(
          color: Colors.blueGrey,
        ),
        new Image.network(
          imgUrl,
          fit: BoxFit.fill,
        ),
        new BackdropFilter(
            filter: new ui.ImageFilter.blur(
              sigmaX: 6.0,
              sigmaY: 6.0,
            ),
            child: new Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
              ),
            )),
        new Scaffold(
            drawer: Drawer(
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
                children: <Widget>[
                  new Container(
                    color: Colors.blueGrey[50],
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
                    leading: Icon(Icons.home),
                    title: Text('Dashboard'),
                    onTap: () {
                      home();
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
            appBar: new AppBar(
              title: new Text("Profil"),
              centerTitle: false,
              elevation: 0.0,
              backgroundColor: Colors.transparent,
            ),
            backgroundColor: Colors.transparent,
            body: new Center(
              child: new Column(
                children: <Widget>[
                  new SizedBox(
                    height: _height / 12,
                  ),
                  new CircleAvatar(
                    radius: _width < _height ? _width / 4 : _height / 4,
                    backgroundImage: NetworkImage(imgUrl),
                  ),
                  new SizedBox(
                    height: _height / 25.0,
                  ),
                  new Text(
                    '$first_name  $last_name',
                    style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: _width / 15,
                        color: Colors.white),
                  ),
                  new Padding(
                    padding: new EdgeInsets.only(
                        top: _height / 30, left: _width / 8, right: _width / 8),
                    child: new Text(
                      '$username',
                      style: new TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: _width / 25,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  new Divider(
                    height: _height / 30,
                    color: Colors.white,
                  ),
                  new Center(
                      child: new Column(
                    children: <Widget>[
                      Text(
                        '$email',
                      ),
                    ],
                  )),
                  new Divider(height: _height / 30, color: Colors.white),
                  new Padding(
                    padding: new EdgeInsets.only(
                        left: _width / 8, right: _width / 8),
                    child: new FlatButton(
                      onPressed: () {},
                      child: new Container(
                          child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Icon(Icons.person),
                          new SizedBox(
                            width: _width / 30,
                          ),
                          new Text('created by H1D016021')
                        ],
                      )),
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget rowCell(int count, String type) => new Expanded(
          child: new Column(
        children: <Widget>[
          new Text(
            '$count',
            style: new TextStyle(color: Colors.white),
          ),
          new Text(type,
              style: new TextStyle(
                  color: Colors.white, fontWeight: FontWeight.normal))
        ],
      ));

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
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DosenScreen()));
  }

  void home() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  void mahasiswa() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MahasiswaScreen()));
  }

  void konsultasi() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => KonsultasiScreen()));
  }

  void profil() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Profil()));
  }
}

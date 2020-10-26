import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sikap/model/konsultasi.dart';
import 'package:sikap/network/rest_api.dart';
import 'package:sikap/screens/dosen/dosen.dart';
import 'package:sikap/screens/home/home.dart';
import 'package:sikap/screens/konsultasi/edit.dart';
import 'package:sikap/screens/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sikap/screens/mahasiswa/mahasiswa.dart';
import 'package:sikap/screens/konsultasi/add.dart';
import 'package:sikap/screens/profil/profil.dart';

class KonsulDosen extends StatefulWidget {
  @override
  _KonsulDosenState createState() => _KonsulDosenState();
}

class _KonsulDosenState extends State<KonsulDosen> {
  Network databaseHelper = new Network();
  String email;
  var datadariJSON;

  var token;
  String nim;

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
        nim = data['nim'];
        if (nim == null) {}
      });
    }
  }

  final String apiUrl = "https://sikapnew.tech/api/konsultasi";

  Future<List<dynamic>> _fecthDataKonsultasi() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token'))['token'];
    var result = await http.get(apiUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    return json.decode(result.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey[50],
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
        appBar: AppBar(
          title: new Text("Konsultasi"),
          backgroundColor: Colors.blueGrey,
        ),
        body: Card(
          child: FutureBuilder<List<dynamic>>(
            future: _fecthDataKonsultasi(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(
                            'Nama : ${snapshot.data[index]['mahasiswa']['first_name'] + " " + snapshot.data[index]['mahasiswa']['last_name']}'),
                        subtitle:
                            Text('Judul : ${snapshot.data[index]['judul']}'),
                      );
                    });
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ));
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
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DosenScreen()));
  }

  void mahasiswa() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MahasiswaScreen()));
  }

  void home() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  void konsultasi() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => KonsulDosen()));
  }

  void profil() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Profil()));
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sikap/network/rest_api.dart';
import 'package:sikap/screens/dosen/dosen.dart';
import 'package:sikap/screens/home/home.dart';
import 'package:sikap/screens/konsultasi/edit.dart';
import 'package:sikap/screens/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sikap/screens/mahasiswa/mahasiswa.dart';
import 'package:sikap/screens/konsultasi/add.dart';
import 'package:sikap/screens/profil/profil.dart';

class KonsultasiScreen extends StatefulWidget {
  @override
  _KonsultasiState createState() => _KonsultasiState();
}

class _KonsultasiState extends State<KonsultasiScreen> {
  Network databaseHelper = new Network();
  String email;
  var datadariJSON;

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
        floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.add),
          onPressed: () => Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) => new AddKonsultasi(),
          )),
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
                        onTap: () => edit(snapshot.data[index]['id']),
                        trailing: new FlatButton(
                            onPressed: () => delete(snapshot.data[index]['id']),
                            child: new Icon(Icons.delete_outline_outlined)),
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

  void delete(int id) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token'))['token'];

    final String apiUrl = "https://sikapnew.tech/api";
    String myUrl = "$apiUrl/konsultasi/$id";
    http.delete(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }).then((response) {
      print('Response body : ${response.body}');
    });
    Navigator.of(context).push(new MaterialPageRoute(
      builder: (BuildContext context) => new KonsultasiScreen(),
    ));
  }

  void edit(int id) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => EditKonsultasi()));
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
        context, MaterialPageRoute(builder: (context) => KonsultasiScreen()));
  }

  void profil() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Profil()));
  }
}

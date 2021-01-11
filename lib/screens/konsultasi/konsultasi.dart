import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sikap/network/rest_api.dart';
import 'package:sikap/screens/dosen/dosen.dart';
import 'package:sikap/screens/home/home.dart';
import 'package:sikap/screens/konsultasi/Detail.dart';
import 'package:sikap/screens/konsultasi/add2.dart';
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
  String email;
  var datadariJSON;

  String nim;
  String judul;

  @override
  void initState() {
    _loadUserData();

    super.initState();
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));
    var data = jsonDecode(localStorage.getString('data'));
    var konsul = jsonDecode(localStorage.getString('konsultasi'));

    if (user != null && data != null && konsul != null) {
      setState(() {
        email = user['email'];
        nim = data['nim'];
        judul = konsul['judul'];
      });
    }
  }

  var token;
  final String apiUrl = "https://sikapnew.tech/api/konsultasi";
  Future<List> getData() async {
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
        onPressed: () {
          konsul();
        },
      ),
      body: new FutureBuilder<List>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? new ItemList(
                  list: snapshot.data,
                )
              : new Center(
                  child: new CircularProgressIndicator(),
                );
        },
      ),
    );
  }

  void dosen() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => DosenScreen()));
  }

  void konsul() {
    if (judul == null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AddKonsul()));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AddKonsultasi()));
    }
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

  void delete(int id) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token'))['token'];

    final String apiUrl = "https://sikapnew.tech/api/konsultasi";
    String myUrl = "$apiUrl/delete/$id";
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
}

class ItemList extends StatelessWidget {
  final List list;
  ItemList({this.list});

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: list == null ? 0 : list.length,
      itemBuilder: (context, i) {
        return new Container(
          padding: const EdgeInsets.all(5.0),
          child: new GestureDetector(
            onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                builder: (BuildContext context) => new Detail(
                      list: list,
                      index: i,
                    ))),
            child: new Card(
              child: new ListTile(
                title: new Text("Judul : ${list[i]['judul']}"),
                leading: new Icon(Icons.widgets),
                subtitle:
                    new Text("Keterangan Revisi : ${list[i]['keterangan']}"),
              ),
            ),
          ),
        );
      },
    );
  }
}

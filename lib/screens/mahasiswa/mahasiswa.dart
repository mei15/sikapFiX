import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sikap/network/rest_api.dart';
import 'package:sikap/screens/dosen/dosen.dart';
import 'package:sikap/screens/home/home.dart';
import 'package:sikap/screens/konsultasi/konsuldosen.dart';
import 'package:sikap/screens/konsultasi/konsultasi.dart';
import 'package:sikap/screens/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sikap/screens/profil/profil.dart';

class MahasiswaScreen extends StatefulWidget {
  @override
  _MahasiswaState createState() => _MahasiswaState();
}

class _MahasiswaState extends State<MahasiswaScreen> {
  String email;
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

    if (user != null) {
      setState(() {
        email = user['email'];
        nim = data['nim'];
      });
    }
  }

  var token;
  final String apiUrl = "https://sikapnew.tech/api/mahasiswa";

  Future<List<dynamic>> _fecthDataMahasiswa() async {
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
                if (nim == null) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => KonsulDosen()));
                } else {
                  konsultasi();
                }
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
        title: new Text("Mahasiswa"),
        backgroundColor: Colors.blueGrey,
      ),
      body: Card(
        child: FutureBuilder<List<dynamic>>(
          future: _fecthDataMahasiswa(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                          'Nama : ${snapshot.data[index]['first_name'] + " " + snapshot.data[index]['last_name']}'),
                      subtitle: Text('NIM : ${snapshot.data[index]['nim']}'),
                    );
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
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

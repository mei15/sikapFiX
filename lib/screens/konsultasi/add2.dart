import 'package:flutter/material.dart';
import 'package:sikap/screens/konsultasi/konsuldosen.dart';
import 'package:sikap/screens/konsultasi/konsultasi.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddKonsul extends StatefulWidget {
  @override
  AddKonsulState createState() => AddKonsulState();
}

class AddKonsulState extends State<AddKonsul> {
  DateTime _dueDate = DateTime.now();
  DateTime dateNow = DateTime.now();
  String tanggal = '';

  String judul;
  String keterangan;
  String dosen_id;
  String mahasiswa_id;

  String email;
  String nim;
  String username;
  String first_name;
  String last_name;
  String fname;
  String lname;

  String select;

  var token;

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
        nim = data['nim'];
        if (nim == null) {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => KonsulDosen()));
        }
      });
    }
  }

  String _baseUrl = "https://sikapnew.tech/api/konsultasi/";
  String _valDosen;
  List<dynamic> _dataDosen = List();
  void getDosen() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token'))['token'];

    final response = await http.get(_baseUrl + "tambah", headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }); //untuk melakukan request ke webservice

    var listData = json.decode(response.body); //lalu kita decode hasil datanya
    setState(() {
      _dataDosen = listData; // dan kita set kedalam variable _dataDosen
    });
    print("Data Dosen : $listData");
  }

  String values;
  List<dynamic> data = List();
  void getKonsul() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token'))['token'];

    final response = await http.get(_baseUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }); //untuk melakukan request ke webservice

    var listData = json.decode(response.body); //lalu kita decode hasil datanya
    setState(() {
      data = listData; // dan kita set kedalam variable _dataDosen
    });
    print("Data Dosen : $listData");
  }

  Future<Null> _selectDueDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2018),
      lastDate: DateTime(2080),
    );

    if (picked != null) {
      setState(() {
        _dueDate = picked;
        tanggal = "${picked.year}-${picked.month}-${picked.day}";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // this.getSWData();
    getDosen();
    _loadUserData();
    getKonsul();
    tanggal = "${_dueDate.year}-${_dueDate.month}-${_dueDate.day}";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.blueGrey[50],
        appBar: AppBar(
          title: Text("Tambah Konsultasi"),
          backgroundColor: Colors.blueGrey,
        ),
        body: Center(
          child: new Column(
            children: <Widget>[
              new ListTile(
                  leading: const Icon(Icons.person),
                  title: new Text(
                    "Nama Mahasiswa : $first_name  $last_name",
                  ),
                  subtitle: new Text(
                    "NIM :$nim",
                  )),
              new ListTile(
                  leading: const Icon(Icons.person_add),
                  title: new DropdownButton(
                    hint: Text("Pilih Dosen"),
                    value: _valDosen,
                    items: _dataDosen.map((item) {
                      return DropdownMenuItem(
                        child: new Text(
                            item['first_name'] + " " + item['last_name']),
                        value: item['id'].toString(),
                      );
                    }).toList(),
                    onChanged: (String value) {
                      setState(() {
                        dosen_id = value;
                        _valDosen = value;
                      });
                    },
                  ),
                  subtitle: new Text(
                    "Kamu memilih Dosen $_valDosen",
                  )),
              new ListTile(
                leading: const Icon(Icons.bookmark_border),
                title: new TextField(
                  onChanged: (String str) {
                    setState(() {
                      judul = str;
                    });
                  },
                  decoration: new InputDecoration(
                    hintText: "Judul",
                  ),
                ),
              ),
              new ListTile(
                leading: const Icon(Icons.library_books_outlined),
                title: new TextField(
                  onChanged: (String str) {
                    setState(() {
                      keterangan = str;
                    });
                  },
                  decoration: new InputDecoration(
                    hintText: "Keterangan",
                  ),
                ),
              ),
              new ListTile(
                leading: const Icon(Icons.today),
                title: Text("Tanggal Konsultasi"),
                trailing: new InkWell(
                  onTap: () => _selectDueDate(context),
                  child: Text(
                    tanggal,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              new FlatButton(
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
                    child: Text(
                      "Tambah Konsultasi",
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  color: Colors.blueGrey,
                  disabledColor: Colors.grey,
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0)),
                  onPressed: () => addData()),
            ],
          ),
        ));
  }

  void addData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token'))['token'];
    final String apiUrl = "https://sikapnew.tech/api";
    String myUrl = "$apiUrl/konsultasi/simpan";
    http.post(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      "judul": "$judul",
      "tanggal": "$tanggal",
      "keterangan": "$keterangan",
      "dosen_id": "$dosen_id",
      nim: "$mahasiswa_id",
    }).then((response) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
      Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new KonsultasiScreen(),
      ));
    });
  }
}

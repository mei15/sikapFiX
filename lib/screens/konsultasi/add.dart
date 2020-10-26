import 'package:flutter/material.dart';
import 'package:sikap/network/rest_api.dart';
import 'package:sikap/screens/konsultasi/konsultasi.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:select_form_field/select_form_field.dart';

class AddKonsultasi extends StatefulWidget {
  @override
  AddKonsultasiState createState() => AddKonsultasiState();
}

class AddKonsultasiState extends State<AddKonsultasi> {
  DateTime _dueDate = DateTime.now();
  DateTime dateNow = DateTime.now();
  String tanggal = '';

  String judul = '';
  String keterangan = '';
  String dosen_id = '';
  String mahasiswa_id = '';

  String email;
  String nim;
  String username;
  String first_name;
  String last_name;

  String select;

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
              builder: (BuildContext context) => KonsultasiScreen()));
        }
      });
    }
  }

  // final String url = "https://sikapnew.tech/api/dosen";

  // List data = List(); //edited line

  // Future<String> getSWData() async {
  //   var res = await http
  //       .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
  //   var resBody = json.decode(res.body)['dosen'];

  //   setState(() {
  //     data = resBody;
  //   });

  //   print(resBody);

  //   return "Success";
  // }

  String _baseUrl = "https://sikapnew.tech/api/";
  String _valDosen;
  List<dynamic> _dataDosen = List();
  void getDosen() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token'))['token'];

    final response = await http.get(_baseUrl + "dosen", headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    });
    var listData = json.decode(response.body);
    setState(() {
      _dataDosen = listData;
    });
    print("data : $listData");
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
        tanggal = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // this.getSWData();
    getDosen();
    _loadUserData();
    tanggal = "${_dueDate.day}/${_dueDate.month}/${_dueDate.year}";
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
                    "$first_name  $last_name",
                  ),
                  subtitle: new Text(
                    "$nim",
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
              new ListTile(
                  leading: const Icon(Icons.person_add),
                  title: new DropdownButton(
                    hint: Text("Pilih Dosen"),
                    value: _valDosen,
                    items: _dataDosen.map((item) {
                      return DropdownMenuItem(
                        child:
                            Text(item['first_name'] + " " + item['last_name']),
                        value: item['id'].toString(),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _valDosen = value;
                      });
                    },
                  ),
                  subtitle: new Text(
                    "Kamu memilih Dosen $_valDosen",
                  )),
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

  var token;
  void addData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token'))['token'];
    final String apiUrl = "https://sikapnew.tech/api";
    String myUrl = "$apiUrl/konsultasi";
    http.post(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      "judul": "$judul",
      "tanggal": "$tanggal",
      "keterangan": "$keterangan",
      _valDosen: "$dosen_id",
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

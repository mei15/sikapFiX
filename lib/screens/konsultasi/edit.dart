import 'package:flutter/material.dart';
import 'package:sikap/network/rest_api.dart';
import 'package:sikap/screens/konsultasi/konsultasi.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:select_form_field/select_form_field.dart';

class EditKonsultasi extends StatefulWidget {
  @override
  EditKonsultasiState createState() => EditKonsultasiState();
}

class EditKonsultasiState extends State<EditKonsultasi> {
  DateTime _dueDate = DateTime.now();
  DateTime dateNow = DateTime.now();
  String tanggal = '';

  String judul = '';
  String keterangan = '';
  String dosen_id = '';
  String mahasiswa_id = '';

  String _mySelection;

  String email;
  String nim;
  String username;
  String first_name;
  String last_name;

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
      });
    }
  }

  final String url = "https://sikapnew.tech/api/dosen";

  List data = List(); //edited line

  Future<String> getSWData() async {
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body)['dosen'];

    setState(() {
      data = resBody;
    });

    print(resBody);

    return "Sucess";
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
    this.getSWData();
    _loadUserData();
    tanggal = "${_dueDate.day}/${_dueDate.month}/${_dueDate.year}";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.blueGrey[50],
        appBar: AppBar(
          title: Text("Ubah Konsultasi"),
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
                  decoration: new InputDecoration(
                    hintText: "Judul",
                  ),
                ),
              ),
              new ListTile(
                leading: const Icon(Icons.library_books_outlined),
                title: new TextField(
                  decoration: new InputDecoration(
                    hintText: "Keterangan",
                  ),
                ),
              ),
              new ListTile(
                leading: const Icon(Icons.today),
                onTap: () => _selectDueDate(context),
                title: const Text('Tanggal'),
              ),
              new ListTile(
                leading: const Icon(Icons.person_add),
                title: const Text('Dosen'),
                trailing: new DropdownButton(
                  items: data.map((item) {
                    return new DropdownMenuItem(
                      child: new Text(
                          item['first_name'] + " " + item['last_name']),
                      value: item['id'].toString(),
                    );
                  }).toList(),
                  onChanged: (newVal) {
                    setState(() {
                      _mySelection = newVal;
                    });
                  },
                  value: _mySelection,
                ),
              ),
              new FlatButton(
                  child: Padding(
                    padding:
                        EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
                    child: Text(
                      "Simpan Konsultasi",
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
                  onPressed: () {})
            ],
          ),
        ));
  }

  var token;
  void editData(int id) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = jsonDecode(localStorage.getString('token'))['token'];
    final String apiUrl = "https://sikapnew.tech/api";
    String myUrl = "$apiUrl/konsultasi/";

    http.post(myUrl, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    }, body: {
      "judul": "$judul",
      tanggal: "$tanggal",
      "keterangan": "$keterangan",
      _mySelection: "$dosen_id",
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

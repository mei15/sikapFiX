import 'package:flutter/material.dart';
import 'package:sikap/network/rest_api.dart';
import 'package:sikap/screens/konsultasi/konsultasi.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  final String apiUrl = "https://sikapnew.tech/api/dosen";

  Future<List<dynamic>> _fecthDataDosen(BuildContext context, int index) async {
    var result = await http.get(apiUrl);
    return json.decode(result.body)['dosen'](
      title: Text(
          'Nama : ${data[index]['first_name'] + " " + data[index]['last_name']}'),
      subtitle: Text('NIP : ${data[index]['nip']}'),
    );
  }

  final List<Map<String, dynamic>> data = [
    {
      'value': '$dosen_id',
      'label': _fetchDataDosen(),
      'icon': Icon(Icons.person),
    },
  ];

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
    tanggal = "${_dueDate.day}/${_dueDate.month}/${_dueDate.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Tambah Konsultasi"),
          backgroundColor: Colors.blueGrey,
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              TextField(
                onChanged: (String str) {
                  setState(() {
                    judul = str;
                  });
                },
                decoration: InputDecoration(
                    icon: Icon(Icons.widgets),
                    hintText: "Masukkan Judul Kerja Praktik",
                    border: InputBorder.none),
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.date_range),
                  Padding(padding: EdgeInsets.only(right: 16)),
                  Expanded(
                    child: Text(
                      "Tanggal",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => _selectDueDate(context),
                    child: Text(
                      tanggal,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              TextField(
                // maxLength: 3,
                maxLines: 3,
                onChanged: (String str) {
                  setState(() {
                    keterangan = str;
                  });
                },
                decoration: InputDecoration(
                    icon: Icon(Icons.note),
                    hintText: "Tambah Keterangan Revisi",
                    border: InputBorder.none),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                      color: Colors.blueGrey,
                      icon: Icon(Icons.check, size: 40),
                      onPressed: () {},
                    ),
                    IconButton(
                      color: Colors.blueGrey,
                      icon: Icon(Icons.close, size: 40),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

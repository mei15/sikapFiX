import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './edit.dart';
import 'package:http/http.dart' as http;
import './konsultasi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:date_format/date_format.dart';

class Detail extends StatefulWidget {
  List list;
  int index;
  Detail({this.index, this.list});
  @override
  _DetailState createState() => new _DetailState();
}

class _DetailState extends State<Detail> {
  var token;
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

  String tanggal;

  void convert() {
    final tanggal = DateTime.now();

    print(formatDate(tanggal, [dd, '-', mm, '-', yyyy]));
  }

  void confirm() {
    AlertDialog alertDialog = new AlertDialog(
      content: new Text(
          "Are You sure want to delete '${widget.list[widget.index]['judul']}'"),
      actions: <Widget>[
        new RaisedButton(
          child: new Text(
            "OK DELETE!",
            style: new TextStyle(color: Colors.black),
          ),
          color: Colors.red,
          onPressed: () {
            delete(widget.list[widget.index]['id']);
            Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new KonsultasiScreen(),
            ));
          },
        ),
        new RaisedButton(
          child: new Text("CANCEL", style: new TextStyle(color: Colors.black)),
          color: Colors.green,
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );

    showDialog(context: context, child: alertDialog);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("${widget.list[widget.index]['judul']}"),
          backgroundColor: Colors.blueGrey,
        ),
        body: new Container(
          height: 270.0,
          padding: const EdgeInsets.all(20.0),
          child: new Card(
            child: Center(
              child: new Column(
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                  ),
                  new Text(
                    "Mahasiswa : ${widget.list[widget.index]['mahasiswa']['first_name'] + " " + widget.list[widget.index]['mahasiswa']['last_name']}",
                    style: new TextStyle(fontSize: 18.0),
                  ),
                  new Text(
                    "Dosen : ${widget.list[widget.index]['dosen']['first_name'] + " " + widget.list[widget.index]['dosen']['last_name']}",
                    style: new TextStyle(fontSize: 18.0),
                  ),
                  new Text(
                    "Judul : ${widget.list[widget.index]['judul']}",
                    style: new TextStyle(fontSize: 20.0),
                  ),
                  new Text("Tanggal : ${widget.list[widget.index]['tanggal']}",
                      style: new TextStyle(fontSize: 18.0)),
                  new Text(
                    "Keterangan : ${widget.list[widget.index]['keterangan']}",
                    style: new TextStyle(fontSize: 18.0),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                  ),
                  new Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new RaisedButton(
                        child: new Text("EDIT"),
                        color: Colors.green,
                        onPressed: () =>
                            Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) => new EditData(
                            list: widget.list,
                            index: widget.index,
                          ),
                        )),
                      ),
                      new RaisedButton(
                        child: new Text("DELETE"),
                        color: Colors.red,
                        onPressed: () => confirm(),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

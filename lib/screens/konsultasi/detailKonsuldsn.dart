import 'package:flutter/material.dart';
import './edit.dart';
import 'package:http/http.dart' as http;
import './konsultasi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DetailKonsul extends StatefulWidget {
  List list;
  int index;
  DetailKonsul({this.index, this.list});
  @override
  _DetailKonsulState createState() => new _DetailKonsulState();
}

class _DetailKonsulState extends State<DetailKonsul> {
  var token;

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
                    "Dosen : ${widget.list[widget.index]['dosen']['first_name'] + " " + widget.list[widget.index]['dosen']['last_name']}",
                    style: new TextStyle(fontSize: 18.0),
                  ),
                  new Text(
                    "Dosen : ${widget.list[widget.index]['mahasiswa']['first_name'] + " " + widget.list[widget.index]['mahasiswa']['last_name']}",
                    style: new TextStyle(fontSize: 18.0),
                  ),
                  new Text(
                    "Judul : ${widget.list[widget.index]['judul']}",
                    style: new TextStyle(fontSize: 20.0),
                  ),
                  new Text(
                    "Tanggal : ${widget.list[widget.index]['tanggal']}",
                    style: new TextStyle(fontSize: 18.0),
                  ),
                  new Text(
                    "Keterangan : ${widget.list[widget.index]['keterangan']}",
                    style: new TextStyle(fontSize: 18.0),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

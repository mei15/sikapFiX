import 'dart:convert';
import 'package:sikap/screens/dosen/dosen.dart';
import 'dart:async';
import 'package:sikap/widgets/task_column.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:sikap/widgets/top_container.dart';
import 'package:sikap/theme/colors/light_colors.dart';
import 'package:sikap/screens/konsultasi/konsultasi.dart';
import 'package:sikap/screens/mahasiswa/mahasiswa.dart';
import 'package:flutter/material.dart';
import 'package:sikap/screens/login/login.dart';
import 'package:sikap/network/rest_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sikap/screens/profil/profil.dart';
import 'package:sikap/screens/konsultasi/konsuldosen.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String email;
  String first_name;
  String last_name;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
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

        first_name = data['first_name'];
        last_name = data['last_name'];
        nim = data['nim'];
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

  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Text subheading(String title) {
    return Text(
      title,
      style: TextStyle(
          color: LightColors.kDarkBlue,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    );
  }

  static CircleAvatar calendarIcon() {
    return CircleAvatar(
      radius: 25.0,
      backgroundColor: LightColors.kGreen,
      child: Icon(
        Icons.calendar_today,
        size: 20.0,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.blueGrey[50],
        appBar: AppBar(
          title: new Text("Dashboard"),
          backgroundColor: Colors.blueGrey,
        ),
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
        body: SafeArea(
            child: Column(children: <Widget>[
          TopContainer(
            height: 200,
            width: width,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 0, vertical: 0.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        CircularPercentIndicator(
                          radius: 90.0,
                          lineWidth: 5.0,
                          animation: true,
                          percent: 0.75,
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: LightColors.kBlue,
                          backgroundColor: Colors.blueGrey,
                          center: CircleAvatar(
                            backgroundColor: LightColors.kBlue,
                            radius: 35.0,
                            backgroundImage: AssetImage(
                              'assets/images/user.jpg',
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Text(
                                "$first_name " " $last_name",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 22.0,
                                  color: LightColors.kDarkBlue,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                '$email',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ]),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.transparent,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  child: Column(children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        subheading('SIKAP'),
                        TaskColumn(
                          icon: Icons.pages_outlined,
                          iconBackgroundColor: LightColors.kRed,
                          title: 'Selamat Datang di SIKAP!',
                          subtitle: "$first_name " " $last_name",
                        ),
                      ],
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ])));
  }

  void logout() async {
    var res = await Network().getData('/logout');
    var body = json.decode(res.body);
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      localStorage.remove('data');

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

  void konsultasi() async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => KonsultasiScreen()));
  }

  void profil() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Profil()));
  }
}

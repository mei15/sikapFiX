import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

List<Dosen> dosenFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Dosen>.from(data.map((item) => Dosen.fromJson(item)));
}

String dosenToJson(Dosen data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}

class Dosen {
// Properties
  int id;
  String first_name;
  String last_name;
  String nip;
  String prodi;

// Constructor
  Dosen({
    this.id,
    this.first_name,
    this.last_name,
    this.nip,
    this.prodi,
  });

  factory Dosen.fromJson(Map<String, dynamic> json) => Dosen(
        id: json["id"],
        first_name: json["first_name"],
        last_name: json["last_name"],
        nip: json["nip"],
        prodi: json["prodi"],
      );

// Map to json
  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": first_name,
        "last_name": last_name,
        "nip": nip,
        "prodi": prodi,
      };

// to string
  @override
  String toString() {
    return 'Dosen(id: $id, first_name: $first_name, last_name: $last_name, nip: $nip, prodi: $prodi)';
  }

  final String _baseUrl = "https://sikapnew.tech/api/konsultasi/";

  Future<List<Dosen>> fetchDosen(http.Client client) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await client
        .get(_baseUrl + '/tambah' + prefs.getInt("id").toString(), headers: {
      'Content-Type': 'application/json',
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> mapResponse = json.decode(response.body);
      final todos = mapResponse["result"].cast<Map<String, dynamic>>();
      final listOfTodos = await todos.map<Dosen>((json) {
        return Dosen.fromJson(json);
      }).toList();
      // print(listOfTodos);
      return listOfTodos.reversed.toList();
    } else {
      throw Exception("Failed to load Dosen from the server");
    }
  }

//add to the list
//   Future<Task> addTodo(http.Client client, Map<String, dynamic> params) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     params["user_id"] = prefs.getInt("id").toString();
//     final response = await client.post(BASE_URL + '/list/', body: params);
//     if (response.statusCode == 200) {
//       final responseBody = await json.decode(response.body);
//       return Task.fromJson(responseBody);
//     } else {
//       throw Exception('Failed to update a Task. Error: ${response.toString()}');
//     }
//   }

// //update list
//   Future<Task> updateATodo(
//       http.Client client, Map<String, dynamic> params) async {
//     final response =
//         await client.put('$BASE_URL/list/${params["id"]}', body: params);
//     if (response.statusCode == 200) {
//       final responseBody = await json.decode(response.body);
//       return Task.fromJson(responseBody);
//     } else {
//       throw Exception('Failed to update a Task. Error: ${response.toString()}');
//     }
//   }

// //Delete a Task
//   Future<Task> deleteATodo(http.Client client, int id) async {
//     final String url = '$BASE_URL/list/$id';
//     final response = await client.delete(url);
//     if (response.statusCode == 200) {
//       final responseBody = await json.decode(response.body);
//       return Task.fromJson(responseBody);
//     } else {
//       throw Exception('Failed to delete a Task');
//     }
//   }
}

import 'dart:convert';

List<Mahasiswa> mahasiswaFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Mahasiswa>.from(data.map((item) => Mahasiswa.fromJson(item)));
}

String mahasiswaToJson(Mahasiswa data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}

class Mahasiswa {
// Properties
  int id;
  String first_name;
  String last_name;
  String nim;
  String prodi;

// Constructor
  Mahasiswa({
    this.id,
    this.first_name,
    this.last_name,
    this.nim,
    this.prodi,
  });

  factory Mahasiswa.fromJson(Map<String, dynamic> json) => Mahasiswa(
        id: json["id"],
        first_name: json["first_name"],
        last_name: json["last_name"],
        nim: json["nim"],
        prodi: json["prodi"],
      );

// Map to json
  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": first_name,
        "last_name": last_name,
        "nim": nim,
        "prodi": prodi,
      };

// to string
  @override
  String toString() {
    return 'Mahasiswa(id: $id, first_name: $first_name, last_name: $last_name, nim: $nim, prodi: $prodi)';
  }
}

import 'dart:convert';

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
}

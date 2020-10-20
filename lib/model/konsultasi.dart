// To parse this JSON data, do
//
//     final konsultasi = konsultasiFromJson(jsonString);

import 'dart:convert';

List<Konsultasi> konsultasiFromJson(String str) =>
    List<Konsultasi>.from(json.decode(str).map((x) => Konsultasi.fromJson(x)));

String konsultasiToJson(List<Konsultasi> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Konsultasi {
  Konsultasi({
    this.id,
    this.judul,
    this.keterangan,
    this.tanggal,
    this.mahasiswaId,
    this.dosenId,
    this.createdAt,
    this.updatedAt,
    this.mahasiswa,
    this.dosen,
  });

  String id;
  String judul;
  String keterangan;
  DateTime tanggal;
  String mahasiswaId;
  String dosenId;
  dynamic createdAt;
  dynamic updatedAt;
  Mahasiswa mahasiswa;
  Dosen dosen;

  factory Konsultasi.fromJson(Map<String, dynamic> json) => Konsultasi(
        id: json["id"].toString(),
        judul: json["judul"],
        keterangan: json["keterangan"],
        tanggal: DateTime.parse(json["tanggal"]),
        mahasiswaId: json["mahasiswa_id"].toString(),
        dosenId: json["dosen_id"].toString(),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        mahasiswa: Mahasiswa.fromJson(json["mahasiswa"]),
        dosen: Dosen.fromJson(json["dosen"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "judul": judul,
        "keterangan": keterangan,
        "tanggal": tanggal.toIso8601String(),
        "mahasiswa_id": mahasiswaId,
        "dosen_id": dosenId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "mahasiswa": mahasiswa.toJson(),
        "dosen": dosen.toJson(),
      };
}

class Dosen {
  Dosen({
    this.id,
    this.prodi,
    this.nip,
    this.firstName,
    this.lastName,
    this.createdAt,
    this.updatedAt,
  });

  String id;
  String prodi;
  String nip;
  String firstName;
  String lastName;
  DateTime createdAt;
  DateTime updatedAt;

  factory Dosen.fromJson(Map<String, dynamic> json) => Dosen(
        id: json["id"].toString(),
        prodi: json["prodi"],
        nip: json["nip"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "prodi": prodi,
        "nip": nip,
        "first_name": firstName,
        "last_name": lastName,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Mahasiswa {
  Mahasiswa({
    this.id,
    this.prodi,
    this.firstName,
    this.lastName,
    this.createdAt,
    this.updatedAt,
    this.nim,
  });

  String id;
  String prodi;
  String firstName;
  String lastName;
  DateTime createdAt;
  dynamic updatedAt;
  String nim;

  factory Mahasiswa.fromJson(Map<String, dynamic> json) => Mahasiswa(
        id: json["id"].toString(),
        prodi: json["prodi"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        nim: json["nim"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "prodi": prodi,
        "first_name": firstName,
        "last_name": lastName,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "nim": nim,
      };
}

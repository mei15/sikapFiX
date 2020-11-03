class Konsultasi {
  int id;
  String judul;
  String keterangan;
  String tanggal;
  String mahasiswaId;
  String dosenId;
  Null createdAt;
  String updatedAt;
  Mahasiswa mahasiswa;
  Dosen dosen;

  Konsultasi(
      {this.id,
      this.judul,
      this.keterangan,
      this.tanggal,
      this.mahasiswaId,
      this.dosenId,
      this.createdAt,
      this.updatedAt,
      this.mahasiswa,
      this.dosen});

  Konsultasi.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    judul = json['judul'];
    keterangan = json['keterangan'];
    tanggal = json['tanggal'];
    mahasiswaId = json['mahasiswa_id'];
    dosenId = json['dosen_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    mahasiswa = json['mahasiswa'] != null
        ? new Mahasiswa.fromJson(json['mahasiswa'])
        : null;
    dosen = json['dosen'] != null ? new Dosen.fromJson(json['dosen']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['judul'] = this.judul;
    data['keterangan'] = this.keterangan;
    data['tanggal'] = this.tanggal;
    data['mahasiswa_id'] = this.mahasiswaId;
    data['dosen_id'] = this.dosenId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.mahasiswa != null) {
      data['mahasiswa'] = this.mahasiswa.toJson();
    }
    if (this.dosen != null) {
      data['dosen'] = this.dosen.toJson();
    }
    return data;
  }
}

class Mahasiswa {
  int id;
  String prodi;
  String nim;
  String firstName;
  String lastName;
  String createdAt;
  Null updatedAt;

  Mahasiswa(
      {this.id,
      this.prodi,
      this.nim,
      this.firstName,
      this.lastName,
      this.createdAt,
      this.updatedAt});

  Mahasiswa.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    prodi = json['prodi'];
    nim = json['nim'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['prodi'] = this.prodi;
    data['nim'] = this.nim;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Dosen {
  int id;
  String prodi;
  String nip;
  String firstName;
  String lastName;
  String createdAt;
  String updatedAt;

  Dosen(
      {this.id,
      this.prodi,
      this.nip,
      this.firstName,
      this.lastName,
      this.createdAt,
      this.updatedAt});

  Dosen.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    prodi = json['prodi'];
    nip = json['nip'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['prodi'] = this.prodi;
    data['nip'] = this.nip;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

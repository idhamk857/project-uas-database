import 'dart:convert';

class Profile {
  int id;
  String nama_buku;
  String jenis;
  String email;
  int jumlah;

  Profile({this.id = 0, this.nama_buku, this.jenis, this.email, this.jumlah});

  factory Profile.fromJson(Map<String, dynamic> map) {
    return Profile(
        id: map["id"], nama_buku: map["nama_buku"], jenis: map["jenis"], email: map["email"], jumlah: map["jumlah"]);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "nama_buku": nama_buku, "jenis": jenis, "email": email, "jumlah": jumlah};
  }

  @override
  String toString() {
    return 'Profile{id: $id, nama_buku: $nama_buku, jenis: $jenis, email: $email, jumlah: $jumlah}';
  }

}

List<Profile> profileFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Profile>.from(data.map((item) => Profile.fromJson(item)));
}

String profileToJson(Profile data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}

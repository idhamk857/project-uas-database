import 'package:duarrr/src/api/api_service.dart';
import 'package:duarrr/src/model/profile.dart';
import 'package:flutter/material.dart';


final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class FormAddScreen extends StatefulWidget {
  Profile profile;

  FormAddScreen({this.profile});

  @override
  _FormAddScreenState createState() => _FormAddScreenState();
}

class _FormAddScreenState extends State<FormAddScreen> {
  bool _isLoading = false;
  ApiService _apiService = ApiService();
  bool _isFieldNamaBukuValid;
  bool _isFieldJenisBukuValid;
  bool _isFieldEmailValid;
  bool _isFieldJumlahValid;
  TextEditingController _controllerNamaBuku = TextEditingController();
  TextEditingController _controllerJenisBuku = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerJumlah = TextEditingController();

  @override
  void initState() {
    if (widget.profile != null) {
      _isFieldNamaBukuValid = true;
      _controllerNamaBuku.text = widget.profile.nama_buku;
      _isFieldJenisBukuValid = true;
      _controllerJenisBuku.text = widget.profile.jenis;
      _isFieldEmailValid = true;
      _controllerEmail.text = widget.profile.email;
      _isFieldJumlahValid = true;
      _controllerJumlah.text = widget.profile.jumlah.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.profile == null ? "Form Add" : "Change Data",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildTextFieldNamaBuku(),
                _buildTextFieldJenisBuku(),
                _buildTextFieldEmail(),
                _buildTextFieldJumlah(),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: RaisedButton(
                    child: Text(
                      widget.profile == null
                          ? "Submit".toUpperCase()
                          : "Update Data".toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      if (_isFieldNamaBukuValid == null ||
                          _isFieldJenisBukuValid == null ||
                          _isFieldEmailValid == null ||
                          _isFieldJumlahValid == null ||
                          !_isFieldNamaBukuValid ||
                          !_isFieldJenisBukuValid ||
                          !_isFieldEmailValid ||
                          !_isFieldJumlahValid) {
                        _scaffoldState.currentState.showSnackBar(
                          SnackBar(
                            content: Text("Please fill all field"),
                          ),
                        );
                        return;
                      }
                      setState(() => _isLoading = true);
                      String nama_buku = _controllerNamaBuku.text.toString();
                      String jenis = _controllerJenisBuku.text.toString();
                      String email = _controllerEmail.text.toString();
                      int jumlah = int.parse(_controllerJumlah.text.toString());
                      Profile profile =
                          Profile(nama_buku: nama_buku, jenis: jenis, email: email, jumlah: jumlah);
                      if (widget.profile == null) {
                        _apiService.createProfile(profile).then((isSuccess) {
                          setState(() => _isLoading = false);
                          if (isSuccess) {
                            Navigator.pop(_scaffoldState.currentState.context);
                          } else {
                            _scaffoldState.currentState.showSnackBar(SnackBar(
                              content: Text("Submit data failed"),
                            ));
                          }
                        });
                      } else {
                        profile.id = widget.profile.id;
                        _apiService.updateProfile(profile).then((isSuccess) {
                          setState(() => _isLoading = false);
                          if (isSuccess) {
                            Navigator.pop(_scaffoldState.currentState.context);
                          } else {
                            _scaffoldState.currentState.showSnackBar(SnackBar(
                              content: Text("Update data failed"),
                            ));
                          }
                        });
                      }
                    },
                    color: Colors.blueGrey[600],
                  ),
                )
              ],
            ),
          ),
          _isLoading
              ? Stack(
                  children: <Widget>[
                    Opacity(
                      opacity: 0.3,
                      child: ModalBarrier(
                        dismissible: false,
                        color: Colors.grey,
                      ),
                    ),
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _buildTextFieldNamaBuku() {
    return TextField(
      controller: _controllerNamaBuku,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Full name",
        errorText: _isFieldNamaBukuValid == null || _isFieldNamaBukuValid
            ? null
            : "Full name is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldNamaBukuValid) {
          setState(() => _isFieldNamaBukuValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldJenisBuku() {
    return TextField(
      controller: _controllerJenisBuku,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: "Type",
        errorText: _isFieldJenisBukuValid == null || _isFieldJenisBukuValid
            ? null
            : "Type is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldJenisBukuValid) {
          setState(() => _isFieldJenisBukuValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldEmail() {
    return TextField(
      controller: _controllerEmail,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: "Email",
        errorText: _isFieldEmailValid == null || _isFieldEmailValid
            ? null
            : "Email is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldEmailValid) {
          setState(() => _isFieldEmailValid = isFieldValid);
        }
      },
    );
  }

  Widget _buildTextFieldJumlah() {
    return TextField(
      controller: _controllerJumlah,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Jumlah",
        errorText: _isFieldJumlahValid == null || _isFieldJumlahValid
            ? null
            : "Jumlah is required",
      ),
      onChanged: (value) {
        bool isFieldValid = value.trim().isNotEmpty;
        if (isFieldValid != _isFieldJumlahValid) {
          setState(() => _isFieldJumlahValid = isFieldValid);
        }
      },
    );
  }
}

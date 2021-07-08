import 'package:aplikasipariwisata/main.dart';
import 'package:flutter/material.dart';
import 'package:aplikasipariwisata/color/color.dart' as globals;
import 'package:http/http.dart' as http;

class SignUp extends StatelessWidget {
  TextEditingController _username = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _namalengkap = new TextEditingController();
  TextEditingController _gmail = new TextEditingController();
  final snackBar = SnackBar(content: Text('Perikas Kembali Isian Anda'));

  Future _sendData(BuildContext context) async {
    var response = await http.post(
        Uri.parse(
            "https://apipariwisata.adriel-creation.tech/registration.php"),
        body: {
          'username': _username.text,
          'password': _password.text,
          'namauser': _namalengkap.text,
          'gmail': _gmail.text,
        });
    var dataUser = response.body;
    if (dataUser == "Sukses") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => HomePage(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "DAFTAR",
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: globals.upperBackground,
            letterSpacing: 2,
            height: 1,
          ),
        ),
        SizedBox(
          height: 16,
        ),
        TextField(
          controller: _username,
          decoration: InputDecoration(
            hintText: 'Masukkan Username',
            hintStyle: TextStyle(
              fontSize: 16,
              color: globals.upperBackground,
              fontWeight: FontWeight.bold,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            fillColor: Colors.grey.withOpacity(0.1),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        TextField(
          controller: _password,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Masukkan Password',
            hintStyle: TextStyle(
              fontSize: 16,
              color: globals.upperBackground,
              fontWeight: FontWeight.bold,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            fillColor: Colors.grey.withOpacity(0.1),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        TextField(
          controller: _namalengkap,
          decoration: InputDecoration(
            hintText: 'Masukkan Nama Lengkap',
            hintStyle: TextStyle(
              fontSize: 16,
              color: globals.upperBackground,
              fontWeight: FontWeight.bold,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            fillColor: Colors.grey.withOpacity(0.1),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        TextField(
          controller: _gmail,
          decoration: InputDecoration(
            hintText: 'Masukkan E-Mail',
            hintStyle: TextStyle(
              fontSize: 16,
              color: globals.upperBackground,
              fontWeight: FontWeight.bold,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            filled: true,
            fillColor: Colors.grey.withOpacity(0.1),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          ),
        ),
        SizedBox(
          height: 24,
        ),
        MaterialButton(
          onPressed: () {
            _sendData(context);
          },
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: globals.upperBackground,
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
              boxShadow: [
                BoxShadow(
                  color: globals.upperBackground.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 4,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                "SIGN UP",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: globals.lowerBackground,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 24,
        ),
      ],
    );
  }
}

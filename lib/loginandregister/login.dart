import 'package:aplikasipariwisata/menu_utama/menuutama.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:aplikasipariwisata/color/color.dart' as globals;
import 'dart:convert';

class Login extends StatelessWidget {
  TextEditingController _usernameField = new TextEditingController();
  TextEditingController _passwordField = new TextEditingController();
  final snackBar = SnackBar(content: Text('Username atau Password salah'));

  Future _retrieveData(BuildContext context) async {
    var response = await http.post(
        Uri.parse("https://apipariwisata.adriel-creation.tech/login.php"),
        body: {
          'username': _usernameField.text,
          'password': _passwordField.text,
        });
    var dataUser = jsonDecode(response.body);
    if (dataUser['message'] == "Sukses") {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => MenuutamaWidget(
                    idUser: dataUser['0']['id_user'],
                    namaUser: dataUser['0']['nama_user'],
                  )));
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
          "SELAMAT DATANG",
          style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: globals.lowerBackground,
            letterSpacing: 2,
            height: 1,
          ),
        ),
        Text(
          "Silahkan login untuk melanjutkan",
          style: TextStyle(
            fontSize: 16,
            color: globals.lowerBackground,
            height: 1,
          ),
        ),
        SizedBox(
          height: 16,
        ),
        TextField(
          controller: _usernameField,
          decoration: InputDecoration(
            hintText: 'Username',
            hintStyle: TextStyle(
              fontSize: 16,
              color: globals.lowerBackground,
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
          controller: _passwordField,
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Password',
            hintStyle: TextStyle(
              fontSize: 16,
              color: globals.lowerBackground,
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
        InkWell(
          onTap: () {
            _retrieveData(context);
          },
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: globals.lowerBackground,
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
              boxShadow: [
                BoxShadow(
                  color: globals.lowerBackground.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 4,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                "LOGIN",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: globals.upperBackground),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          "LUPA PASSWORD?",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: globals.lowerBackground,
            height: 1,
          ),
        ),
      ],
    );
  }
}

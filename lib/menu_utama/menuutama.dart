import 'package:aplikasipariwisata/main.dart';
import 'package:aplikasipariwisata/menu_kategori.dart/menukategori.dart';
import 'package:flutter/material.dart';
import 'package:aplikasipariwisata/color/color.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class MenuutamaWidget extends StatefulWidget {
  String idUser;
  String namaUser;

  MenuutamaWidget({required this.idUser, required this.namaUser});

  @override
  _MenuutamaWidgetState createState() => _MenuutamaWidgetState();
}

class _MenuutamaWidgetState extends State<MenuutamaWidget> {
  StreamController<List> _streamController = StreamController();
  late Timer _timer;

  Future _ambilDataMenu() async {
    var response = await http.get(Uri.parse(
        "https://apipariwisata.adriel-creation.tech/showdatamenu.php"));
    var dataMenu = jsonDecode(response.body);

    _streamController.add(dataMenu);
  }

  @override
  void initState() {
    _ambilDataMenu();

    _timer = Timer.periodic(Duration(seconds: 5), (timer) => _ambilDataMenu());
    super.initState();
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: globals.lowerBackground,
      appBar: AppBar(
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 60.0,
            ),
            child: Text("Aplikasi Pariwisata"),
          ),
        ),
        backgroundColor: globals.upperBackground,
        elevation: 0,
        actions: [
          PopupMenuButton(
            icon: Icon(
                Icons.more_vert), //don't specify icon if you want 3 dot menu
            color: Colors.white,
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Row(
                  children: [
                    Icon(
                      Icons.info,
                      color: Colors.black,
                    ),
                    Text(
                      "  Tentang",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      color: Colors.black,
                    ),
                    Text(
                      "  Keluar",
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
            onSelected: (item) => {
              if (item == 0)
                {showAlertDialog(context)}
              else if (item == 1)
                {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => HomePage(),
                    ),
                  )
                }
            },
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: (MediaQuery.of(context).size.height) / 2.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50.0),
                  bottomRight: Radius.circular(50.0),
                ),
                color: globals.upperBackground,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 40.0,
                  left: 20.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Selamat Datang",
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Explore your journey here",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Positioned(
                top: 155.0,
                left: 7.0,
                child: Center(
                  child: Container(
                    width: 350.0,
                    height: 350.0,
                    child: StreamBuilder<List>(
                      stream: _streamController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return GridView.count(
                            crossAxisCount: 2,
                            children: snapshot.data!.map((data) {
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      (context),
                                      new MaterialPageRoute(
                                        builder: (context) =>
                                            new MenukategoriWidget(
                                          idUser: widget.idUser,
                                          idMenu: data['id_menu'],
                                          namaMenu: data['nama_menu'],
                                          namaUser: widget.namaUser,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    elevation: 4,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            "https://apipariwisata.adriel-creation.tech/upload/home/" +
                                                data['url_image'],
                                          ),
                                          fit: BoxFit.cover,
                                          colorFilter: new ColorFilter.mode(
                                              Colors.black.withOpacity(0.3),
                                              BlendMode.dstATop),
                                        ),
                                      ),
                                      child: ListTile(
                                        title: Center(
                                            child: Text(
                                          data['nama_menu'],
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        } else {
                          return LinearProgressIndicator();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = MaterialButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Tentang"),
      content: _widgetContainAbout(),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _widgetContainAbout() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            new Text(
              "Aplikasi Pengenalan Objek Pariwisata Pada Kabupaten Samosir Berbasis Mobile",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            new Text(
              "Tujuan rancangan aplikasi ini adalah sebagai solusi bagi calon wisatawan dan masyarakat untuk mempermudah mengenal lebih detail objek-objek wisata yang ada pada kabupaten Samosir.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 11,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            new Text(
              "Aplikasi ini terdiri atas 8 menu. Berikut adalah penjelasan mengenai menu-menu aplikasi ini :",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 11,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            //Text Divide
            new Text(
              "1.  Menu Login",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            new Text(
              "     " +
                  "Menu Login adalah halaman awal yang akan tampil pada saat aplikasi mulai dijalankan. Menu Login ini digunakan untuk mengamankan sistem dari user-user yang tidak bertanggung jawab sebelum masuk ke Menu Utama.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 11,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            //Text Divide
            new Text(
              "2.  Menu Daftar",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            new Text(
              "     " +
                  "Menu Daftar digunakan untuk melakukan registrasi pendaftaran bagi user-user yang belum mempunyai akun sebelumnya.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 11,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            //Text Divide
            new Text(
              "3.  Menu Utama",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            new Text(
              "     " +
                  "Menu Utama adalah halaman yang akan ditampilkan setelah user melakukan proses login. Pada bagian Menu Utama akan menampilkan Menu Pariwisata Alam, Menu Pariwisata Budaya, Kuliner, dan Pantai.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 11,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            //Text Divide
            new Text(
              "4.  Menu pariwisata Alam",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            new Text(
              "     " +
                  "Menu Pariwisata Alam adalah halaman menu yang khusus untuk  menampilkan objek-objek pariwisata yang berbasis alam.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 11,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            //Text Divide
            new Text(
              "5.  Menu Pariwisata Budaya",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            new Text(
              "     " +
                  "Menu Pariwisata Budaya adalah halaman menu yang khusus untuk menampilkan objek-objek pariwisata yang berbasis budaya.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 11,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            //Text Divide
            new Text(
              "6.  Menu Kuliner",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            new Text(
              "     " +
                  "Menu Kuliner adalah halaman menu yang khusus untuk menampilkan makanan-makanan khas Kabupaten Samosir.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 11,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            //Text Divide
            new Text(
              "7.  Menu Pantai",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            new Text(
              "     " +
                  "Menu Pantai adalah halaman menu yang khusus untuk menampilkan pantai-pantai yang ada pada Kabupaten Samosir.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 11,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            //Text Divide
            new Text(
              "8. Menu About",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            new Text(
              "     " +
                  "Menu About adalah menu yang berisi penjelasan-penjelasan menu yang terdapat di aplikasi pengenalan objek pariwisata pada Kabupaten Samosir.",
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontSize: 11,
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }
}

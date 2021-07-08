import 'package:aplikasipariwisata/show_data/showdata.dart';
import 'package:flutter/material.dart';
import 'package:aplikasipariwisata/color/color.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class MenukategoriWidget extends StatefulWidget {
  String idMenu;
  String idUser;
  String namaMenu;
  String namaUser;

  MenukategoriWidget(
      {required this.idMenu,
      required this.idUser,
      required this.namaMenu,
      required this.namaUser});

  @override
  _MenukategoriWidgetState createState() => _MenukategoriWidgetState();
}

class _MenukategoriWidgetState extends State<MenukategoriWidget> {
  StreamController<List> _streamController = StreamController();
  late Timer _timer;

  Future _ambilDataKategori() async {
    var response = await http.post(
        Uri.parse(
            "https://apipariwisata.adriel-creation.tech/showkategori.php"),
        body: {'idMenu': widget.idMenu});
    var dataKategori = jsonDecode(response.body);

    _streamController.add(dataKategori);
  }

  @override
  void initState() {
    _ambilDataKategori();

    _timer =
        Timer.periodic(Duration(seconds: 5), (timer) => _ambilDataKategori());
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
        title: Padding(
          padding: const EdgeInsets.only(right: 30.0),
          child: Center(
            child: Text(widget.namaMenu),
          ),
        ),
        backgroundColor: globals.lowerBackground,
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: new Container(
                decoration: BoxDecoration(
                  color: globals.lowerBackground,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 30.0,
                    left: 20.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Dashboard",
                        style: TextStyle(
                          fontSize: 35,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Explore more",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: new Container(
                width: MediaQuery.of(context).size.width,
                height: ((MediaQuery.of(context).size.height).toDouble() -
                    ((MediaQuery.of(context).size.height).toDouble() / 4.8)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0),
                  ),
                  color: globals.upperBackground,
                ),
                child: Padding(
                  padding: EdgeInsets.all(25.0),
                  child: StreamBuilder<List>(
                    stream: _streamController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return GridView.count(
                          childAspectRatio: 4 / 2,
                          crossAxisCount: 1,
                          children: snapshot.data!.map((data) {
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    (context),
                                    new MaterialPageRoute(
                                      builder: (context) => new ShowdataWidget(
                                        idUser: widget.idUser,
                                        namaUser: widget.namaUser,
                                        idKategori: data['id_kategori'],
                                        idMenu: data['id_menu'],
                                        namaKategori: data['nama_kategori'],
                                        urlImage: data['url_image'],
                                        namaLokasi: data['nama_lokasi'],
                                        deskripsi: data['deskripsi'],
                                        linkLokasi: data['link_lokasi'],
                                        namaMenu: data['nama_menu'],
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
                                        data['nama_kategori'],
                                        style: TextStyle(
                                          fontSize: 18.0,
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
          ],
        ),
      ),
    );
  }
}
